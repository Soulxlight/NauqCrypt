---
candidate: A
verdict: NO-GO
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
authored_utc: 2026-08-06
---

# Architecture Designer A Report — NO-GO

## 1. Decision

**NO-GO.**

The clean-sheet hypothesis below has the required two-pass/global-dependency shape, but it is exactly a bidirectional combined-feedback permutation applied to plaintext plus 256 redundancy bits. It therefore reduces to two explicitly excluded families:

1. combined/evolving-state feedback; and  
2. wide-block encode-then-encipher.

Removing either interpretation leaves only an assumed variable-length pseudorandom injection, which would make the primitive assumption tautological.

## 2. Formal target

Let

\[
\tau=\operatorname{enc}(
  \text{"NC1"}, |D|,D,N,|A|,A,|P|
)
\]

where:

- \(1\le |D|\le255\) bytes;
- \(N\in\{0,1\}^{192}\);
- \(A\) is AAD;
- \(P\in\{0,1\}^{8n}\).

For fixed \(K,\tau,n\), correctness requires an injective map

\[
\mathcal E_{K,\tau,n}:\{0,1\}^{8n}
\longrightarrow
\{0,1\}^{8n+256}.
\]

The ideal misuse-resistant object is therefore a length-indexed keyed pseudorandom injection, with an efficient inverse-membership test.

## 3. Rejected hypothesis: Boundary-Coupled Bidirectional Injection

### 3.1 Definitions

Hash the public context:

\[
h=H(\tau).
\]

Use two domain-separated keyed functions

\[
f_K(h,L,i,W):\{0,1\}^{256}\rightarrow\{0,1\}^{8},
\]

\[
g_K(h,L,i,W):\{0,1\}^{256}\rightarrow\{0,1\}^{8},
\]

and keyed 32-byte boundary strings \(B_F(K,h,L)\) and \(B_B(K,h,L)\).

Let

\[
X=P\parallel 0^{256}
\]

be a byte array of length \(L=n+32\).

Set the virtual left boundary

\[
U_{-32},\ldots,U_{-1}=B_F(K,h,L).
\]

The forward sweep is

\[
U_i=X_i\oplus
 f_K(h,L,i,U_{i-32}\parallel\cdots\parallel U_{i-1}),
\quad 0\le i<L.
\]

Set the virtual right boundary

\[
Y_L,\ldots,Y_{L+31}=B_B(K,h,L).
\]

The backward sweep is

\[
Y_i=U_i\oplus
 g_K(h,L,i,Y_{i+1}\parallel\cdots\parallel Y_{i+32}),
\quad i=L-1,\ldots,0.
\]

Output

\[
C=Y_0\ldots Y_{n-1},
\qquad
T=Y_n\ldots Y_{n+31}.
\]

Thus \(|C|=|P|\) and \(|T|=256\) bits.

### 3.2 Encryption pseudocode

```text
encrypt(K, D, N, A, P):
    require 1 <= len(D) <= 255
    require len(N) == 24

    h = H(canonical_encode("NC1", D, N, A, len(P)))
    buf = P || zero_bytes(32)

    left = B_F(K, h, len(buf))
    for i = 0 .. len(buf)-1:
        u = buf[i] XOR f_K(h, len(buf), i, last_32(left))
        buf[i] = u
        shift_in(left, u)

    right = B_B(K, h, len(buf))
    for i = len(buf)-1 .. 0:
        y = buf[i] XOR g_K(h, len(buf), i, next_32(right))
        buf[i] = y
        shift_in_reverse(right, y)

    return buf[0:len(P)], buf[len(P):len(P)+32]
```

## 4. Causal dependency graph

```text
D, N, A, plaintext length
          |
          v
       public h
       /      \
      v        v
 left boundary right boundary
      |             |
      v             |
P || 0^256          |
      |             |
      v             |
forward recurrence U[0] -> U[1] -> ... -> U[L-1]
      |                                      |
      +------------------+-------------------+
                         v
backward recurrence Y[0] <- Y[1] <- ... <- Y[L-1]
                         |
               +---------+---------+
               v                   v
            ciphertext             tag
```

A change in \(X_j\) has a forward path to every \(U_i\) for \(i\ge j\). The backward recurrence gives it a path to every earlier \(Y_i\). Consequently, every output byte has a causal path from every plaintext byte. This is only a dependency statement, not a security proof.

## 5. Decryption

Given \(Y=C\parallel T\):

\[
U_i=Y_i\oplus
 g_K(h,L,i,Y_{i+1}\parallel\cdots\parallel Y_{i+32})
\]

is computed right-to-left using the same right boundary.

Then

\[
X_i=U_i\oplus
 f_K(h,L,i,U_{i-32}\parallel\cdots\parallel U_{i-1})
\]

is computed left-to-right using the same left boundary.

Accept only if

\[
X_n\parallel\cdots\parallel X_{n+31}=0^{256}.
\]

The redundancy comparison must be constant-time. The candidate plaintext must remain in an API-owned quarantine buffer until that comparison succeeds; on failure it is zeroized and never returned.

## 6. Correctness

Each sweep is triangular and bijective.

For the forward sweep,

\[
X_i=
U_i\oplus
f_K(h,L,i,U_{i-32}\parallel\cdots\parallel U_{i-1}).
\]

For the backward sweep,

\[
U_i=
Y_i\oplus
g_K(h,L,i,Y_{i+1}\parallel\cdots\parallel Y_{i+32}).
\]

Applying these inverses in reverse sweep order reconstructs \(X=P\parallel0^{256}\) exactly. The final zero test establishes membership in the encoded plaintext subset.

## 7. Intended leakage function

For encryption queries

\[
q_i=(D_i,N_i,A_i,P_i),
\]

the intended leakage is

\[
\mathcal L(q_1,\ldots,q_s)=
\left(
  (D_i,N_i,A_i,|P_i|)_{i=1}^{s},
  \sim
\right),
\]

where

\[
i\sim j
\iff
(D_i,N_i,A_i,P_i)=(D_j,N_j,A_j,P_j).
\]

The decryption interface additionally leaks one validity bit per query, as every AEAD interface necessarily does.

“Never common blocks” must mean no computationally detectable correlation beyond the random-injection baseline. A literal prohibition on coincident ciphertext blocks is impossible because independently random finite blocks sometimes coincide.

## 8. Primitive assumptions

The non-tautological assumptions available for this hypothesis are:

- collision resistance of a canonical 256-bit public-context hash, such as SHA-512/256;
- PRF security of independently domain-separated 256-bit-key fixed-input functions \(f\), \(g\), \(B_F\), and \(B_B\);
- full 256-bit classical key-search resistance of those PRFs.

A portable candidate for the fixed-input PRFs would be a keyed BLAKE2s-based function, with fixed-size encoded inputs and label-based key separation.

These assumptions are insufficient by themselves. One still needs a theorem that the composition of the two triangular recurrences is a strong variable-length pseudorandom permutation. Assuming that property directly would amount to assuming the desired AE security.

## 9. Plausible but incomplete reduction strategy

A potential proof attempt would proceed as follows:

1. Reject any pair of public transcripts colliding under \(H\).
2. Replace \(f,g,B_F,B_B\) with independent random functions through PRF hybrids.
3. Define a bad event when two distinct oracle executions reach the same 256-bit hidden recurrence window at the same direction, tweak, length, and index.
4. Bound hidden-window collisions by approximately

   \[
   \frac{\Sigma(\Sigma-1)}{2^{257}},
   \]

   where \(\Sigma\) is the aggregate number of recurrence windows.
5. Conditioned on no bad event, attempt an H-coefficient argument that unseen outputs are distributed as unused points of a random permutation.
6. Treat acceptance as membership in a subset of density \(2^{-256}\).

The unresolved step is step 5. Two random triangular sweeps are not known here to imply a strong pseudorandom permutation. Local-window differential, rectangle, slide-across-length, or adaptive inverse-membership distinguishers may survive even without an exact hidden-state collision.

If the missing lemma held, a tentative multi-user bound would have the form

\[
\operatorname{Adv}
\lesssim
\operatorname{Adv}^{\mathrm{PRF}}_{f,g,B}
+
\operatorname{Adv}^{\mathrm{CR}}_H
+
\frac{\Sigma^2}{2^{257}}
+
\frac{V}{2^{256}},
\]

with \(V\) verification attempts. Under an aggregate \(\Sigma\le2^{64}\), the state-collision term is below \(2^{-128}\). This is a conditional target, not a proved bound.

For independent keys, an already generated codeword is accepted under another random key with probability \(2^{-256}\). Searching for any cross-key collision has a generic \(2^{128}\) birthday scale, so the 256-bit tag can provide only a 128-bit generic commitment margin.

## 10. Toy instantiation

Use 4-bit symbols instead of bytes:

- feedback window: two symbols, or 8 bits;
- redundancy/tag: two symbols, or 8 bits;
- \(f_i,g_i:\{0,1\}^{8}\rightarrow\{0,1\}^{4}\) are keyed random tables;
- encode \(m\) plaintext symbols as \(X=M\parallel(0,0)\);
- apply the same forward and backward equations.

Both sweeps can be exhaustively verified as permutations. The accepted set has size \(16^m\) inside a state space of size \(16^{m+2}\), so its density is \(2^{-8}\). This toy validates invertibility and redundancy density only; it supplies no evidence of pseudorandomness.

## 11. Constant-time and resource feasibility

- Two in-place sweeps over \(n+32\) bytes.
- \(O(n+|A|)\) work.
- Two 32-byte recurrence rings, public-context hash state, and fixed PRF state fit well below 2 KiB.
- No secret-indexed tables are needed in a production instantiation.
- Fixed rotations, additions, Boolean operations, and fixed loops are portable to x86-64, ARM64, and WASM.
- The byte-granular form is inefficient because it invokes a PRF per byte, but its asymptotic and memory bounds are compliant.
- Decryption can avoid pre-verification release only if the output buffer remains inaccessible to the caller until the function returns success.

## 12. Self-attacks and disqualifiers

### 12.1 Exact reduction to wide-block encode-then-encipher

The construction is

\[
(C,T)=\Pi_{K,\tau,n}(P\parallel0^{256}),
\]

where \(\Pi\) is the permutation formed by the two triangular sweeps. This is precisely wide-block encode-then-encipher.

### 12.2 Exact reduction to combined feedback

The forward sweep evolves a 256-bit window from left to right. The backward sweep evolves another 256-bit window from right to left. Both output and future processing depend on these carried states. This is bidirectional combined feedback and evolving-state AE.

### 12.3 Birthday ceiling

A 256-bit recurrence window reaches its generic collision scale at \(2^{128}\) work. A collision can cause two different prefixes to enter the same forward state; with a common continuation, the remaining forward state then merges. That risks exposing equal ciphertext regions after the backward sweep. The construction has no security margin beyond the requested 128-bit boundary.

### 12.4 Unproved two-sweep pseudorandomness

PRF security of the local functions does not prove that two triangular layers form an SPRP. Adding more alternating sweeps might remove structural distinguishers, but would exceed the two-pass contract and remain within the excluded feedback/wide-block families.

### 12.5 Public-context compression

Hashing arbitrary domain and AAD into 256 bits introduces a \(2^{128}\)-work collision boundary. A collision lets different public transcripts share the same mode context. A wider public hash could add margin but would not cure the architectural exclusions.

### 12.6 Quarantine semantics

For arbitrary-length plaintext and less than 2 KiB private state, plaintext must be materialized in an external buffer before the final redundancy byte is checked. “No release” is therefore an API ownership guarantee, not a claim that plaintext bytes do not exist before verification.

## 13. Exhaustion argument

For an \(O(n)\), two-pass, \(O(1)\)-state deterministic transform to make every output depend on every plaintext byte, it must use one of three causal mechanisms:

1. compute a compact message summary on pass one and use it while emitting ciphertext on pass two — synthetic seed, SIV, or MAC-driven wrapper;
2. mutate the external buffer into a reversible global state and finish it on pass two — wide-block encode-then-encipher, offset/TBC, or combined feedback;
3. carry authentication/encryption state sequentially while producing or revising output — evolving-state AE, feedback, sponge/duplex, or deck/Farfalle.

Without a compact summary, mutable full buffer, or sequential carried state, distant plaintext regions cannot influence every ciphertext region in \(O(n)\).

Introducing a “native keyed pseudorandom injection with decoder” avoids the mode taxonomy only syntactically. Assuming that primitive is secure assumes deterministic misuse-resistant AE itself and violates the non-tautological-assumption requirement.

## 14. Final conclusion

No admissible architecture hypothesis was found. The nearest clean two-pass construction satisfies correctness, length, resource, verification-order, and ideal leakage goals, but is unambiguously an excluded bidirectional feedback wide-block encoding. Accepting it under another name would disguise an excluded family.
