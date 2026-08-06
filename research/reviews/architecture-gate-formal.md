---
review: architecture-gate-formal
verdict: BLOCKED_NO_WINNER
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
authored_utc: 2026-08-06
provenance: internal_review_wave_2
sealed_utc: 2026-08-06T00:37:01Z
---

# Formal and adversarial architecture gate

## 1. Gate result

All three submitted hypotheses are disqualified by direct factorization into families expressly excluded by the frozen originality contract. No submitted construction is eligible.

The stronger shared claim that *no possible architecture can satisfy the frozen contract* is not unconditional. It has two different readings:

1. If “DAE” is excluded extensionally, meaning the deterministic authenticated-encryption abstraction itself is forbidden, the contract is inconsistent by definition.
2. If “DAE” is excluded architecturally, meaning known DAE modes and routine compositions are forbidden but a new architecture providing DAE-like security is sought, the submissions do not establish an impossibility theorem. Their bounded-state causal argument is useful, but it depends on a computation model and an architecture-equivalence relation that the frozen requirements do not define.

Accordingly, the formal gate result is **blocked, no winner**. There is a definition-level inconsistency under one natural reading and an unresolved architecture search under the other.

## 2. Deterministic interface

Let

\[
h=\operatorname{frame}(D,N,A,\ell)
\]

contain the public domain, 192-bit nonce, AAD, and plaintext length. For a fixed key, header, and byte length, encryption is a deterministic map

\[
E_{K,h,\ell}:\{0,1\}^{8\ell}
\longrightarrow
\{0,1\}^{8\ell+256}.
\]

Write its output as \(Y=C\parallel T\), with \(|C|=\ell\) bytes and \(|T|=256\) bits. Decryption is a partial map

\[
D_{K,h,\ell}:\{0,1\}^{8\ell+256}
\longrightarrow
\{0,1\}^{8\ell}\cup\{\bot\}.
\]

Correctness requires

\[
D_{K,h,\ell}(E_{K,h,\ell}(M))=M
\]

for every permitted input. Therefore:

- \(E_{K,h,\ell}\) is injective;
- the encryption image, or codebook, is

  \[
  \mathcal C_{K,h,\ell}=\operatorname{Im}(E_{K,h,\ell});
  \]

- \(|\mathcal C_{K,h,\ell}|=2^{8\ell}\) inside a universe of size \(2^{8\ell+256}\); and
- the exact density of encryption codewords is \(2^{-256}\).

Define the full decryption acceptance set as

\[
\mathcal A_{K,h,\ell}
=
\{Y:D_{K,h,\ell}(Y)\ne\bot\}.
\]

Correctness proves only

\[
\mathcal C_{K,h,\ell}\subseteq\mathcal A_{K,h,\ell}.
\]

It does not require equality: decryption may accept strings that encryption never emits. Injectivity and the codebook density are theorems following from determinism, lengths, and correctness. The size and density of \(\mathcal A_{K,h,\ell}\) are not fixed by correctness. INT-CTXT must make fresh accepting strings computationally infeasible to produce, including any useful points in \(\mathcal A_{K,h,\ell}\setminus\mathcal C_{K,h,\ell}\).

The natural ideal object for the stated leakage is a separately sampled random injection for each public \((h,\ell)\). It returns the previous output for an identical complete transcript and a fresh unused output for every new plaintext. Its ideal decoder normally accepts exactly the sampled image. Public headers and lengths remain visible. This is a security definition or idealization, not a consequence of correctness for a real implementation.

## 3. Nonce-respecting and repeated-header IND-CCA

RFC 9771's conventional IND-CCA default is nonce-respecting. Under that reading, requirement 2 and the nonce-misuse requirement are coherent: requirement 2 covers the conventional security case in which encryption nonces obey the game's uniqueness discipline, while requirement 3 specifies the additional leakage permitted after nonce repetition.

An unrestricted or repeated-header IND-CPA/IND-CCA game without an equality-aware restriction is incompatible with deterministic encryption. An adversary can:

1. query \(E_{K,h,\ell}(M_0)\) and retain \(Y_0\);
2. request a challenge for \((M_0,M_1)\) under the same public header; and
3. decide that the challenge encrypted \(M_0\) exactly when its output equals \(Y_0\).

Injectivity makes this test perfect for \(M_0\ne M_1\). This is not an attack beyond the stated leakage; it is precisely complete-transcript equality testing.

The ambiguity is therefore not whether the RFC 9771 nonce-respecting default can coexist with requirement 3; it can. The unresolved point is the exact combined game for repeated nonces or repeated public headers: it must forbid trivial challenge replay, or explicitly provide complete-transcript equality to the ideal-world simulator, while still defining CCA decryption access. The frozen document does not publish that combined game, so a concrete misuse-confidentiality bound cannot yet be a formal theorem.

The same precision is needed for multi-user accounting and the named CMT-1 commitment game.

## 4. Is DAE excluded nominally or architecturally?

If DAE means “deterministic authenticated encryption with equality leakage,” define

\[
E^{\mathrm{DAE}}_K(h,M)
:=E_K(D,N,A,M).
\]

Because nonce uniqueness is not assumed, the nonce is simply another public header field. The transformation above is the identity at the cryptographic interface. Under this meaning, every object satisfying the required security contract is a DAE. Excluding DAE then excludes the target by definition.

This is a definition-level result, not a cryptanalytic result.

There is, however, another plausible reading. In the originality list, “DAE” appears beside SIV, synthetic selectors, sponges, feedback modes, and other architecture families. “Instance or routine composition” also sounds architectural rather than extensional. On that reading, the intended question could be whether a new internal graph realizes the DAE ideal without being architecture-equivalent to known DAE modes. The identity reduction does not answer that question.

The frozen requirements do not define:

- the canonical representation of an architecture;
- when two graphs are architecture-equivalent;
- whether an interface-level security class is itself disqualifying; or
- whether an efficient reduction is required before a construction is called an instance of an excluded family.

Without those definitions, the global inconsistency claim is conditional rather than absolute.

## 5. Wide-block extension lemma and its limit

There is a second extensional argument. For any injection

\[
E:X\rightarrow Y,
\qquad |X|=2^{8\ell},\quad |Y|=2^{8\ell+256},
\]

let

\[
\operatorname{Code}(M)=M\parallel0^{256}.
\]

The subsets \(\operatorname{Code}(X)\) and \(E(X)\) have equal cardinality. The bijection

\[
\operatorname{Code}(M)\mapsto E(M)
\]

can therefore be extended set-theoretically to some permutation \(\Pi:Y\to Y\). Hence

\[
E=\Pi\circ\operatorname{Code}
\]

on the encoded subset.

The existence of such a permutation is a theorem. It does **not** establish that:

- \(\Pi\) has an efficient algorithm;
- \(\Pi^{-1}\) is efficient on invalid encodings;
- the candidate actually evaluates \(\Pi\); or
- the candidate’s causal graph is a wide-block cipher.

Therefore every deterministic AE injection is extensionally encode-then-permute, but it is not necessarily architecture-equivalent to an efficient wide-block encode-then-encipher construction. Treating the set-theoretic extension as an architectural canonicalization again makes the requirements inconsistent by definition; requiring an efficient graph-level factorization does not.

## 6. Internal randomness and mutable state

Internal coins do not evade the fixed-interface result. Suppose an implementation computes

\[
\mathcal A(K,h,M;r).
\]

If encryption is deterministic, then for all admissible coins \(r,r'\),

\[
\mathcal A(K,h,M;r)=\mathcal A(K,h,M;r').
\]

The coins may change execution details, but they cannot change the extensional map. They can be fixed arbitrarily for functional analysis.

If random coins change \((C,T)\), encryption is probabilistic. If a persistent mutable state changes the result on the next equal transcript, the interface is stateful rather than the fixed \((K,D,N,A)\) map required here. Encoding the random value or state into the 256-bit tag likewise produces randomized or stateful AE. Memoizing a random injection would realize the ideal leakage behavior, but requires unbounded persistent state and is not the frozen deterministic core.

Thus randomness supplies no compliant counterexample.

## 7. What the two-pass causal cut actually proves

Consider the more restrictive machine model in which:

- input is immutable;
- each pass is a sequential scan;
- private state at the pass boundary has at most \(s\) bits; and
- output is append-only and cannot serve as scratch.

Let \(S\) be the complete state after pass one. During pass two, if an output coordinate is emitted before some input coordinate is revisited, every causal path from that unread input to the emitted output must cross \(S\). This is an ordinary graph-cut theorem.

It supports an important necessary condition. If a \(b\)-bit observable ciphertext projection stays exactly unchanged whenever a causally disconnected plaintext region changes, an adversary obtains a collision with probability one where a random-injection baseline gives approximately \(2^{-b}\). Equality-only leakage therefore rules out stable local output components. Merely drawing a causal path is not sufficient for pseudorandomness, but an absent path can establish a distinguisher.

The frozen engineering contract is broader than the model above:

- caller-owned input, output, and quarantine are excluded from the 2 KiB state limit;
- it does not expressly make output append-only;
- it does not define whether quarantine may hold intermediate per-block state; and
- “two complete passes” does not formalize random access or processing of quarantined intermediates.

With mutable external storage, cross-cut influence may travel through \(O(n)\) distributed data rather than the 2 KiB private state. Classifying every such graph as wide-block, feedback, or evolving-state AE is plausible taxonomy, but it is not a consequence of the graph-cut theorem alone.

There is also a concrete correction to the claim that every compact transcript summary is necessarily a *public selector*. A secret sum can be broadcast into local second-layer permutations and recovered only from the joint output. It is then neither the tag nor a public mask selector. Such a graph can still be disqualified as an explicit wide-block permutation, but it refutes the narrower implication “compact summary implies SIV.”

## 8. Anonymous canonicalization of the submissions

### Canonical form I

\[
S=F_K(h,M),\qquad
T=S,qquad
C_i=M_i\oplus G_K(S,h,i).
\]

This is a message-derived public selector driving indexed masks, with a separate transcript authenticator. It is directly a synthetic-tag/SIV construction and stream-plus-authenticator composition. Its disqualification is syntactic and does not rely on the global impossibility claim.

### Canonical form II

\[
X=M\parallel0^{256},qquad
Y=\Pi_{K,h,\ell}(X),qquad
(C,T)=\operatorname{split}(Y),
\]

where \(\Pi\) is explicitly implemented by one forward and one backward triangular recurrence. This is an efficiently realized wide-block encode-then-encipher transform. Its carried windows also make it a bidirectional feedback/evolving-state construction. Both factorizations are explicit.

### Canonical form III

\[
X=E^0_K(Q_K(h)\parallel M),
\qquad
Y=L(X),
\qquad
(T,C)=E^1_K(Y),
\]

where \(L\) is an invertible rank-one global mixing layer and \(E^0,E^1\) are products of local keyed permutations. Thus

\[
(T,C)=W_{K,h,\ell}(Q_K(h)\parallel M)
\]

for an explicitly evaluated variable-width permutation \(W=E^1\circ L\circ E^0\). This is keyed redundancy encoding followed by wide-block enciphering. The internal global sum is not itself a public selector, but the full graph is still directly excluded.

These canonicalizations do not depend on the reports’ titles or provenance. Each submitted graph is in an excluded class even under the narrower architecture-only interpretation.

## 9. Attempted counterexamples and remaining graph class

No concrete counterexample meeting every security and engineering requirement was found.

The only logical class not eliminated by the graph-cut argument under an architecture-only interpretation is a native, non-surjective keyed injection circuit

\[
J_{K,h,\ell}:\{0,1\}^{8\ell}
\rightarrow\{0,1\}^{8\ell+256}
\]

with efficient decoding on its encryption image and a keyed acceptance predicate, but without:

- an efficiently exposed whole-domain permutation on padded inputs;
- a message-derived public selector;
- absorb/squeeze state;
- carried feedback or offset state; or
- separable encryption and authentication components.

Its full acceptance set need not equal its encryption image; INT-CTXT would have to make every fresh accepting string infeasible to produce, including any additional accepting region. Such a circuit is extensionally the desired DAE object. Assuming directly that \(J\) is a pseudorandom injection with INT-CTXT-secure acceptance would be tautological. What remains unresolved is whether those properties can be reduced to lower-level, independently meaningful primitive assumptions while retaining two-pass \(O(n)\) operation, less than 2 KiB private state, constant-time software, and the stated performance bound.

This unresolved class is not evidence that a construction exists. It is evidence that the submitted exhaustion argument is not a formal impossibility theorem under an architecture-only interpretation.

The following proposed escapes do not work:

- fresh per-message randomness violates determinism;
- synchronized state changes the interface and adds replay/state semantics expressly outside scope;
- storing a random injection table violates bounded steady-state processing;
- a native variable-length permutation over \(M\parallel R\) is wide-block encode-then-encipher;
- a transcript digest used to select local encryption is synthetic-seed/SIV; and
- separate validity redundancy plus ordinary encryption is generic composition or encode-then-encipher.

## 10. Security-bound corrections

A generic collision at \(2^{128}\) work is a security ceiling, not automatically a violation of a 128-bit target. The profile allows fewer than \(2^{30}\) invocations and less than \(2^{60}\) total plaintext bytes. For a 256-bit state, a birthday term based on at most \(2^{60}\) processed byte positions is approximately

\[
\frac{2^{120}}{2^{256}}=2^{-136},
\]

and a term based on 256-bit blocks is smaller. A claimed \(2^{128}\)-query structural collision is far outside the invocation profile. It may show lack of margin, but it does not alone falsify the frozen concrete bound.

Conversely, none of the reports supplies a complete reduction for confidentiality, INT-CTXT, multi-user behavior, or CMT-1 commitment. The proposed random-function and random-permutation hybrids are proof plans. The missing coupling lemmas, precise games, primitive instantiations, and performance measurements prevent any construction from passing the security or engineering gate even if its architectural exclusion were waived.

## 11. Classification of conclusions

| Statement | Status |
| --- | --- |
| Correct deterministic encryption has an image/codebook of density \(2^{-256}\); correctness only implies that this image is contained in the decryption acceptance set. | Theorem. |
| Unrestricted repeated-header IND-CPA/IND-CCA without equality-aware restrictions is impossible for the deterministic interface. | Theorem under that unrestricted game. |
| RFC 9771's conventional nonce-respecting IND-CCA reading is coherent with a separate nonce-misuse requirement. | Definition/game interpretation. |
| Equality-only deterministic privacy is naturally modeled by a random injection. | Definition/idealization. |
| The target is a DAE when DAE denotes the deterministic AE security abstraction. | Definition-level equivalence. |
| Every such injection has some encode-then-permute extension. | Set-theoretic theorem. |
| Every such extension is an efficient wide-block architecture. | Not proved and generally does not follow. |
| Internal randomness can change a compliant deterministic output. | False. |
| A small-state sequential pass boundary is a causal cut. | Theorem under the stated streaming model. |
| Every mutable-buffer two-pass graph belongs to one of the listed excluded families. | Heuristic taxonomy; no formal equivalence relation is supplied. |
| Every compact secret summary is a public synthetic selector. | False; the global-sum graph is a counterexample, although it is excluded for another reason. |
| The three submitted constructions are excluded. | Established by direct graph factorization. |
| No possible architecture satisfies the contract under an architecture-only reading. | Unresolved. |
| No possible architecture satisfies the contract under an extensional DAE exclusion. | True by definition. |

## 12. Required ruling

Before another architecture tournament, the contract must choose one interpretation:

1. **Extensional exclusion.** DAE or any random-injection-equivalent deterministic AE is forbidden. EC1 is then blocked by definition and should not solicit another construction.
2. **Architectural exclusion.** The DAE ideal is the target, while enumerated implementation graphs are forbidden. This requires a formal canonicalization/equivalence rule, a computation model for passes and external quarantine, and an equality-aware confidentiality game.

Because the requirements are frozen and state that post-result changes invalidate the tournament, resolving this ambiguity would require a new candidate identifier rather than silently reinterpreting the current contract.
