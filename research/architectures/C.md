---
candidate: C
verdict: NO-GO
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
authored_utc: 2026-08-06
---

# Architecture Designer C Report

## Decision

**NO-GO.**

The clean-sheet hypothesis below is functionally coherent and plausibly reaches a 128-bit birthday bound under idealized primitives. However, it has the exact normal form of **wide-block encode-then-encipher**, which the frozen contract excludes. More fundamentally, deterministic AEAD with equality-only leakage is itself a DAE abstraction. Relabeling either property would only disguise an excluded family.

## 1. Hypothesis: Global-Constraint SPN

The construction treats the 256-bit tag as the exposed portion of a secret redundancy coordinate. A global algebraic layer couples that coordinate to every plaintext block.

It uses no counter stream, evolving feedback state, duplex state, or nonce-derived keystream.

### Transcript framing

Reject domains outside 1–255 bytes. Define the prefix-free public header

\[
H=\mathtt{NC1}\parallel |D|_8\parallel D\parallel N_{192}
  \parallel |A|_{128}\parallel A\parallel |P|_{128}.
\]

Let

\[
Q=F_{K_H}(H)\in\{0,1\}^{256},
\]

where \(F\) is a domain-separated 256-bit-output PRF.

Parse plaintext as

\[
P=P_1\parallel\cdots\parallel P_m\parallel R,
\]

where each \(P_i\in\{0,1\}^{256}\) and the tail \(R\) has \(0\le r<256\) bits. For byte-oriented APIs, \(r\) is a multiple of eight.

### Primitive families

For the public shape \((m,r)\), use independent tweak domains for:

\[
A^0_i,A^1_i:\{0,1\}^{256}\rightarrow\{0,1\}^{256},
\]

and

\[
B^0_r,B^1_r:\{0,1\}^{256+r}\rightarrow\{0,1\}^{256+r}.
\]

All are keyed permutations. Superscripts identify the two substitution layers; indices and message shape are included in their tweaks.

Arithmetic below is in \(\mathbb F=\mathrm{GF}(2^{256})\), with addition represented by XOR.

Choose a fixed \(\alpha\in\mathbb F\setminus\{0,1\}\). Let \(n=m+1\) and define

\[
\lambda_i=
\begin{cases}
1 & n\text{ even, for every }i,\\
\alpha & n\text{ odd and }i=0,\\
1 & n\text{ odd and }i>0.
\end{cases}
\]

Then

\[
\delta=1+\sum_{i=0}^{m}\lambda_i
=
\begin{cases}
1 & n\text{ even},\\
1+\alpha & n\text{ odd},
\end{cases}
\]

so \(\delta\ne0\).

## 2. Encryption

### Equations

First substitution layer:

\[
(x_0,\rho)=B^0_r(Q\parallel R),
\]

where \(x_0\) is the first 256 bits, and

\[
x_i=A^0_i(P_i),\qquad 1\le i\le m.
\]

Compute the global spine sum

\[
S=\bigoplus_{i=0}^{m}x_i.
\]

Apply the rank-one global mixing layer:

\[
y_i=x_i+\lambda_iS,\qquad 0\le i\le m.
\]

Second substitution layer:

\[
(T,C_R)=B^1_r(y_0\parallel\rho),
\]

with \(T\) the first 256 bits and \(C_R\) the remaining \(r\) bits, and

\[
C_i=A^1_i(y_i),\qquad 1\le i\le m.
\]

Return

\[
C=C_1\parallel\cdots\parallel C_m\parallel C_R
\]

and the 256-bit tag \(T\). Thus \(|C|=|P|\).

### Two-pass pseudocode

```text
seal(K, D, N, A, P):
    validate 1 <= len(D) <= 255
    H <- frame(D, N, A, bitlen(P))
    Q <- HeaderPRF(KH, H)
    parse P as P[1..m] || R

    # Pass 1
    S <- 0
    for i = 1..m:
        x <- A0(K, shape, i, P[i])
        S <- S xor x

    (x0, rho) <- B0(K, shape, Q || R)
    S <- S xor x0

    (T, Ctail) <- B1(K, shape, (x0 xor lambda[0]*S) || rho)

    # Pass 2
    rewind P
    for i = 1..m:
        x <- A0(K, shape, i, P[i])
        C[i] <- A1(K, shape, i, x xor lambda[i]*S)

    return C[1..m] || Ctail, T
```

## 3. Causal dependency graph

```text
D, N, A, plaintext length
        |
        v
        H ---> HeaderPRF ---> Q -----------+
                                            |
plaintext tail R --------------------------> B0 ---> x0, rho
                                                      |
P1 ---> A0_1 ---> x1 -------------------------------+
P2 ---> A0_2 ---> x2 -------------------------------+--> S = XOR(all x)
 ...                                                  |
Pm ---> A0_m ---> xm -------------------------------+

For every i:
    xi, S ---> yi = xi XOR lambda_i*S

y0, rho ---> B1 ---> tag T and ciphertext tail
yi -------> A1_i ---> ciphertext block Ci
```

Except for ideal-primitive collision events, any header, tail, or full-block change changes \(S\), which reaches every second-layer input.

## 4. Decryption and verification

```text
open(K, D, N, A, C, T):
    validate domain and lengths
    H <- frame(D, N, A, bitlen(C))
    Q <- HeaderPRF(KH, H)
    parse C as C[1..m] || Ctail

    # Pass 1: recover global state and authenticate
    (y0, rho) <- inverse_B1(K, shape, T || Ctail)
    Y <- y0

    for i = 1..m:
        yi <- inverse_A1(K, shape, i, C[i])
        Y <- Y xor yi

    S <- inverse(delta) * Y
    x0 <- y0 xor lambda[0]*S
    (Qcandidate, R) <- inverse_B0(K, shape, x0 || rho)

    if constant_time_equal(Qcandidate, Q) == false:
        return FAIL

    # Pass 2: plaintext release is now permitted
    rewind C
    for i = 1..m:
        yi <- inverse_A1(K, shape, i, C[i])
        xi <- yi xor lambda[i]*S
        P[i] <- inverse_A0(K, shape, i, xi)

    return P[1..m] || R
```

The tail is recovered during pass one but remains buffered until verification succeeds. No plaintext need be released speculatively.

## 5. Correctness

Because

\[
\begin{aligned}
\bigoplus_i y_i
 &=\bigoplus_i(x_i+\lambda_iS)\\
 &=S+\left(\sum_i\lambda_i\right)S\\
 &=\delta S,
\end{aligned}
\]

decryption obtains the encryption value of \(S\) by multiplying by \(\delta^{-1}\).

It then recovers every

\[
x_i=y_i+\lambda_iS.
\]

All local layers are permutations, so their inverses recover \(Q\), \(R\), and every \(P_i\). A genuine ciphertext therefore reproduces \(Q=F_{K_H}(H)\) and is accepted.

## 6. Intended leakage function

For encryption queries

\[
\tau_j=(D_j,N_j,A_j,P_j),
\]

the intended leakage is

\[
\mathcal L(\tau_1,\ldots,\tau_q)=
\left(
(D_j,N_j,A_j,|P_j|)_{j=1}^{q},
\sim
\right),
\]

where

\[
i\sim j\iff
\operatorname{frame}(D_i,N_i,A_i,P_i)
=
\operatorname{frame}(D_j,N_j,A_j,P_j).
\]

A simulator would maintain a table keyed by the complete framed transcript and assign each new entry a random output of \(|P|+256\) bits, sampled without replacement within each public length. Repeated complete transcripts return the prior value.

Consequently, nonce reuse intentionally exposes only duplicate complete transcripts. Ciphertext-prefix or block equality for nonduplicates occurs only with the probability expected from random strings, plus the construction’s bad-event probability.

## 7. Non-tautological primitive assumptions

The candidate would require:

1. A 256-bit-output multi-user PRF for header framing.
2. Multi-user strong tweakable PRPs on 256-bit strings.
3. Strong tweakable permutations on widths 256 through 511 bits for \(B_r\).
4. A domain-separated subkey derivation PRF retaining the full 256-bit master-key search space.
5. Independence, up to standard tweakable-primitive advantage, between phase, position, width, and header-PRF domains.

None of these assumptions directly assumes AE security for the complete construction.

A plausible implementation would use a full-entropy 256-bit master key, a fixed-width 256-bit Feistel permutation for \(A\), and balanced or unbalanced Feistel networks for \(B_r\). Every Feistel half is at least 128 bits. The round functions would be fixed-output PRFs rather than data-indexed tables.

## 8. Plausible reduction strategy

This is a proof plan, not a completed reduction.

1. Replace the KDF, header PRF, and local tweakable permutations with independent ideal objects.
2. Lazily sample first-layer outputs.
3. Mark `Bad` when:
   - distinct headers obtain the same \(Q\);
   - two distinct query transcripts create the same global \(S\);
   - a second-layer coordinate input repeats unexpectedly;
   - a forgery produces a previously constrained internal tuple.
4. Conditioned on no bad event, couple each new complete transcript to a fresh random injective output.
5. For a fresh verification attempt, the recovered 256-bit redundancy coordinate is uniform relative to \(Q\), giving success probability \(2^{-256}\).
6. For a wrong independent key, the same argument gives approximately \(2^{-256}\) acceptance per key trial, establishing key commitment in the ideal model.

A target multi-user expression would have the form

\[
\operatorname{Adv}
\lesssim
\operatorname{Adv}^{\mathrm{mu}}_F+
\operatorname{Adv}^{\mathrm{mu}}_{\mathrm{TPRP}}+
\frac{c\sum_u \sigma_u^2}{2^{256}}+
\frac{\sum_u v_u}{2^{256}}+
\frac{U(U-1)}{2^{257}},
\]

where \(\sigma_u\) counts processed coordinates and \(v_u\) counts fresh verification attempts.

The quadratic term limits the construction to a 128-bit birthday security level. Exhaustive recovery of a uniformly generated master key remains a \(2^{256}\)-scale classical search, assuming no shortcut in the instantiated primitives.

## 9. Toy instantiation

Use \(\mathrm{GF}(2^8)\) with polynomial

\[
x^8+x^4+x^3+x+1
\]

and \(\alpha=02_{16}\). Replace 256-bit cells and the tag by eight-bit cells. Independent keyed eight-bit S-boxes can serve as the toy local permutations.

For an algebra-only test, take the local permutations as identity, use

\[
Q=\mathtt{A6},\quad P_1=\mathtt{12},\quad P_2=\mathtt{34}.
\]

There are three spine coordinates, so

\[
\lambda_0=02,\quad\lambda_1=\lambda_2=01.
\]

Then

\[
S=\mathtt{A6}\oplus\mathtt{12}\oplus\mathtt{34}
 =\mathtt{80}.
\]

Since \(02\cdot80=1B\),

\[
y_0=\mathtt{BD},\quad
y_1=\mathtt{92},\quad
y_2=\mathtt{B4}.
\]

Their XOR is \(\mathtt{9B}=03\cdot80\), and \(\delta=1+\alpha=03\). Multiplying by \(03^{-1}\) recovers \(S=\mathtt{80}\), after which the original three inputs are recovered. Identity permutations are only an inversion test, not a security instantiation.

## 10. Constant-time and resource feasibility

- Processing is \(O(|A|+|P|)\).
- Encryption and decryption each make exactly two plaintext/ciphertext passes.
- State consists of key schedules, several 256-bit accumulators, one at-most-511-bit core coordinate, and public framing counters; it can fit below 2 KiB.
- Message-shape branches depend only on public lengths.
- Field multiplication can use fixed-schedule CLMUL on x86-64, PMULL on ARM64, and fixed-iteration carryless arithmetic in WASM.
- Feistel round functions can use hardware AES where available and a bitsliced or fixed-instruction implementation in WASM.
- Tag comparison is constant-time.

## 11. Self-attacks and disqualification

### 11.1 Exact prohibited factorization

Define

\[
\operatorname{Code}_K(H,P)=Q_K(H)\parallel P.
\]

Let

\[
W_{K,|P|}=E^1\circ M\circ E^0
\]

be the permutation formed by the first local layer, global linear layer, and second local layer, including the tail coordinate. Then the complete construction is exactly

\[
(T,C)=\operatorname{split}\left(
W_{K,|P|}\bigl(\operatorname{Code}_K(H,P)\bigr)
\right).
\]

That is a keyed redundancy encoding followed by wide-block enciphering. The global-constraint terminology does not change the family.

### 11.2 Definition-level DAE conflict

For each public header \(H\), deterministic correctness makes

\[
P\mapsto(C,T)
\]

an injection. Equality-only leakage asks that this injection resemble a random injection. Authentication asks that its image be a sparse keyed valid-code set. This is precisely a deterministic authenticated-encryption abstraction.

More generally, any injection from \(\ell\) bits to \(\ell+256\) bits can be extended to a permutation over \(\ell+256\) bits after encoding the input with 256 redundancy bits. Thus, if “must not reduce to DAE or wide-block encode-then-encipher” is interpreted extensionally, the frozen requirements are mutually inconsistent.

### 11.3 Detectable global-sum collisions

Hold one plaintext block fixed while varying other blocks under a reused header. For the fixed block,

\[
C_i=A^1_i(x_i+\lambda_iS).
\]

Because \(A^1_i\) is a permutation, equality of that ciphertext block reveals equality of \(S\). A birthday search therefore finds two different transcripts with equal \(S\) in approximately \(2^{128}\) queries. Those transcripts can expose unchanged ciphertext coordinates, reaching the security boundary exactly rather than leaving a comfortable concrete margin.

### 11.4 Algebraic forgery target

A ciphertext modification that induces internal differences satisfying

\[
\bigoplus_i\Delta y_i=0
\]

and leaves \(y_0\) unchanged preserves both \(S\) and the redundancy check. Ideal independent second-layer permutations make arranging this appear to cost roughly \(2^{256}\) per direct attempt, or birthday-scale work when internal collisions are harvested. A real related-tweak weakness could lower that cost substantially.

### 11.5 Primitive and proof burden

There is no standard single primitive covering every required 256–511-bit tweakable permutation width. A Feistel realization adds substantial assumptions and leaves the proposed two-layer wide-SPN reduction unproven. Treating the complete transform itself as a strong wide-block PRP would make the assumption tautological.

### 11.6 Exhaustion of the two-pass alternatives

With bounded state, suffix information can affect early ciphertext only through information retained after pass one. If that retained value controls otherwise local second-pass transforms, it is a synthetic seed or deck-like construction. If the second pass performs a reversible global transform, it is wide-block enciphering. If state evolves while emitting blocks, it is evolving-state or feedback AE. If authentication is kept separate, it is generic composition.

## 12. Final conclusion

**NO-GO.** Global-Constraint SPN is a coherent functional design hypothesis, but it is directly and demonstrably an excluded wide-block encode-then-encipher DAE. Its 256-bit global sum also exposes a birthday-bound structural collision test. I do not find a non-disguised architecture satisfying the frozen contract and exclusions simultaneously.
