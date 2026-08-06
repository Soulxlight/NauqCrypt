---
candidate: B
verdict: NO-GO
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
authored_utc: 2026-08-06
---

# Architecture Designer B — Experimental Candidate 1

## 1. Verdict

**NO-GO.**

The frozen contract has an empty admissible design space under the stated exclusions.

For

\[
H=\operatorname{frame}(D,N,A),\qquad
E_K(H,M)=(C,T),
\]

the construction is deterministic, remains secure when \(N\) repeats arbitrarily, and leaks only equality of \((H,M)\). Treating the nonce as part of the public header gives the identity transformation

\[
E^{\mathrm{DAE}}_K(H,M)
:=E_K(D,N,A,M).
\]

This is deterministic authenticated encryption under the standard definition. Therefore every scheme satisfying the contract is already a DAE at its interface, regardless of its internal primitives. Excluding “DAE” consequently excludes the requested object itself.

Even if “DAE” was intended to exclude only known DAE constructions, the two-pass, \(O(n)\), small-state requirements force either:

1. a fixed-size transcript-dependent state controlling the second pass, which is a synthetic seed/SIV construction; or
2. message-sized distributed state, which is a wide-block, combined-feedback, or evolving-state construction.

No third causal path remains.

## 2. Formal Contract and Leakage

Let

\[
H =
\mathtt{"NC1"}\parallel
\operatorname{u8}(|D|)\parallel D\parallel
N\parallel
\operatorname{u64}(|A|)\parallel A\parallel
\operatorname{u64}(|M|),
\]

where:

- \(1\le |D|\le255\);
- \(|N|=24\) bytes;
- \(A\) is arbitrary public AAD;
- \(M\) is the plaintext.

Encryption must satisfy

\[
E_K(H,M)=(C,T),\quad |C|=|M|,\quad |T|=32.
\]

For a query sequence \(\tau_i=(D_i,N_i,A_i,M_i)\), the maximum permitted leakage is

\[
L(\tau_1,\ldots,\tau_q)=
\left(
(H_i,|M_i|)_{i=1}^{q},
R
\right),
\]

where

\[
R_{ij}=1
\iff
(D_i,N_i,A_i,M_i)
=
(D_j,N_j,A_j,M_j).
\]

Thus repeated public headers may reveal plaintext equality only when the entire plaintext is equal. Common prefixes, repeated blocks, block positions, or suffix relations must remain hidden.

## 3. Unavoidable Normal Form

The following is not an admissible proposal. It is the minimal normal form reached when the requirements are implemented with bounded state.

Let:

- \(F_{K_a}:\{0,1\}^*\rightarrow\{0,1\}^{256}\) be a prefix-free variable-input PRF;
- \(G_{K_e}(S,H,i,\ell)\) be a variable-output PRF;
- \(K_a,K_e\) be domain-separated derivations of the 256-bit master key.

### Encryption

\[
S=F_{K_a}(H\parallel M)
\]

and, for chunk \(i\),

\[
Z_i=G_{K_e}(S,H,i,|M_i|),
\qquad
C_i=M_i\oplus Z_i,
\qquad
T=S.
\]

```text
Encrypt(K, D, N, A, M):
    reject unless 1 <= len(D) <= 255
    reject unless len(N) == 24
    H <- frame(D, N, A, len(M))

    # Pass 1
    S <- F_Ka(H || M)

    # Pass 2
    for each chunk M_i at index i:
        Z_i <- G_Ke(S, H, i, len(M_i))
        C_i <- M_i XOR Z_i

    return C, S
```

### Decryption

```text
Decrypt(K, D, N, A, C, T):
    H <- frame(D, N, A, len(C))

    # Pass 1: authenticate without release
    initialize incremental F_Ka with H
    for each chunk C_i at index i:
        Z_i <- G_Ke(T, H, i, len(C_i))
        M_i_candidate <- C_i XOR Z_i
        absorb M_i_candidate into F_Ka
        erase M_i_candidate

    S_check <- finalize F_Ka
    ok <- constant_time_equal(S_check, T)
    if not ok:
        return failure

    # Pass 2: plaintext may now be released
    for each chunk C_i at index i:
        M_i <- C_i XOR G_Ke(T, H, i, len(C_i))
        release M_i

    return success
```

### Correctness

For valid ciphertext,

\[
M_i' =
C_i\oplus G_{K_e}(T,H,i)
=
M_i\oplus G_{K_e}(S,H,i)\oplus G_{K_e}(S,H,i)
=
M_i.
\]

Consequently,

\[
F_{K_a}(H\parallel M')=S=T,
\]

so verification succeeds before the second decryption pass releases plaintext.

## 4. Causal Dependency Graph

```text
D, N, A, length ───────────────┐
                               v
all plaintext chunks ───────> F_Ka ─────> S ─────> tag T
                                           |
                                           +────> G_Ke(S,H,0) ──> mask 0 ──┐
                                           +────> G_Ke(S,H,1) ──> mask 1 ──┤
                                           +────> ...                       |
                                                                            v
plaintext chunk i ───────────────────────────────────────────────────────> XOR ─> C_i
```

Decryption reverses the chunk XOR using \(T\), recomputes \(S\) over the recovered transcript, compares \(S\) with \(T\), and gates all plaintext release on that comparison.

The causal graph establishes the disqualification:

- \(S\) is a synthetic transcript seed and synthetic IV.
- \(F\) is the authentication pass.
- \(G\) is an indexed stream generator.
- The construction is SIV/DAE and stream-plus-MAC generic composition.

Renaming \(S\) as a “root,” “binding state,” “schedule,” or a vector of several values does not change that classification.

## 5. Causal Exhaustion Argument

Assume the first pass has at most \(w\le16384\) bits of private state and cannot retain the message in private storage. At the pass boundary, every influence from the complete transcript that survives privately is contained in

\[
S=f_K(H,M),\qquad |S|\le w.
\]

During the second pass, consider the first ciphertext region emitted in whatever traversal order is chosen. Plaintext regions not yet revisited can affect that output only through:

1. \(S\); or
2. data previously written into the ciphertext/output buffer.

If the dependency travels through \(S\), the second pass is controlled by a synthetic transcript state. Multiple summaries remain one aggregate synthetic seed.

If the dependency travels through the output buffer, the buffer is message-sized distributed state being transformed across passes. That is a wide-block or evolving/combined-feedback construction.

If neither path exists, some ciphertext relation remains independent of a changed, causally disconnected plaintext region. Under repeated \((D,N,A)\), an adversary can compare two chosen messages differing only in that region and detect a stable block, prefix, suffix, or differential relation. This exceeds the permitted leakage.

Absorbing the transcript into one fixed permutation state instead gives a sponge/duplex or deck construction. Using only the nonce gives a nonce-derived wrapper and immediately fails nonce reuse. Embedding validity into a message-wide permutation returns to wide-block AE.

## 6. Primitive Assumptions and Rejected Reduction

The unavoidable normal form could be analyzed from non-tautological assumptions:

- \(F\) is a 256-bit multi-user PRF on unambiguously framed strings.
- \(G\) is a multi-user variable-output PRF with domain separation over \((S,H,i)\).
- The master-key derivation is a multi-user PRF and preserves the \(2^{256}\) exhaustive-search cost.
- Implementations of both primitives are constant-time.

With \(Q\) distinct encryption transcripts and \(V\) verification attempts, a plausible hybrid bound is

\[
\operatorname{Adv}
\lesssim
\operatorname{Adv}^{\mathrm{mu}}_F+
\operatorname{Adv}^{\mathrm{mu}}_G+
\operatorname{Adv}^{\mathrm{mu}}_{\mathrm{KDF}}+
\frac{Q(Q-1)}{2^{257}}+
\frac{V}{2^{256}}.
\]

Replacing \(F\) by a random function makes \(S\) independent for distinct transcripts except on a 256-bit collision. Replacing \(G\) then makes each distinct transcript use an independent mask family. Identical transcripts repeat exactly. Authentication reduces to predicting the recomputed 256-bit \(F\) value.

For \(Q\ll2^{64}\), the generic collision term remains below approximately \(2^{-129}\). Exhaustive master-key search remains \(2^{256}\). A separate robust key-commitment proof would still be required; assuming “a committing AE primitive” would merely assume the requested result and is therefore tautological.

This reduction is plausible only for the rejected SIV construction. It does not establish an admissible candidate.

## 7. Toy Instantiation

A reduced toy can demonstrate the dependency structure:

\[
f_k(X)=\operatorname{Trunc}_{16}(\operatorname{HMAC\!-\!SHA256}(k,X)),
\]

\[
g_k(S,H,i)=
\operatorname{Trunc}_{8}
(\operatorname{HMAC\!-\!SHA256}(k,\mathtt{"g"}\parallel S\parallel H\parallel i)).
\]

Then

\[
S=f_{k_a}(H\parallel M),\quad
C_i=M_i\oplus g_{k_e}(S,H,i),\quad
T=S.
\]

Changing a suffix normally changes \(S\), which changes masks even over an unchanged prefix. Decryption using \(T\) recovers the message and recomputes \(S\). The 16-bit toy suffers transcript-state collisions after roughly \(2^8\) queries, illustrating why the real form needs a 256-bit state.

Again, the toy is explicitly SIV plus indexed stream generation and is disqualified.

## 8. Constant-Time and State Feasibility of the Rejected Form

The normal form is implementable in constant time on x86-64, ARM64, and WASM using fixed-round ARX or bitsliced primitives:

- \(O(n)\) encryption and decryption;
- a few hundred bytes of private state;
- no secret-dependent table access;
- fixed-size counters with checked overflow;
- constant-time tag comparison;
- no caller-visible plaintext before verification;
- a second decryption pass after acceptance.

These implementation properties do not alter its architectural classification.

## 9. Self-Attacks

1. **Definitional attack:** Arbitrary nonce repetition turns the public nonce into ordinary associated data. The requested interface is DAE by identity reduction.

2. **Taxonomy attack:** The only bounded-state construction with complete first-pass influence on second-pass output uses a synthetic transcript state.

3. **Output-scratch attack:** Avoiding a synthetic state by storing distributed influence in the output creates a wide-block or evolving-state mode.

4. **Commitment gap:** Ordinary confidentiality and unforgeability do not automatically prove robust key commitment. Adding a separate key fingerprint or commitment field would be a forbidden commitment wrapper.

5. **Birthday attack:** A 256-bit transcript state inherently gives a generic \(2^{128}\) collision scale. It cannot honestly claim substantially more than 128-bit collision security.

6. **Dictionary leakage:** Determinism necessarily permits equality testing for guessed complete transcripts. This is exactly the allowed leakage but cannot be reduced further.

7. **Release-gate attack:** Writing candidate plaintext into caller-observable storage before tag comparison violates the release requirement. Genuine bounded-state decryption therefore needs discard-and-repeat processing or an externally isolated buffer.

## 10. Final Conclusion

No architecture can meet the frozen contract while also not reducing to DAE. Under the narrower interpretation that only conventional DAE constructions are excluded, the two-pass and bounded-state constraints still force either a synthetic-seed construction or a message-wide distributed transform, both explicitly forbidden.

An admissible candidate requires relaxing at least one condition:

- permit SIV/DAE or another transcript-derived synthetic state;
- permit a dedicated wide-block transform;
- permit randomness or nonce uniqueness;
- weaken the nonce-reuse leakage target; or
- remove the \(O(n)\), two-pass, or bounded-state restriction.

Presenting any concrete construction without one of those relaxations would only disguise an excluded family.
