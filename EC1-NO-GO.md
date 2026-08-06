---
candidate: EC1
outcome: BLOCKED_NO_WINNER
gate: architecture
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
decided_utc: 2026-08-06
spec_digest: null
cipher_released: false
---

# NauqCrypt EC1 Architecture-Gate No-Go

## Decision

**NauqCrypt Experimental Candidate 1 is blocked with no winner. No cipher was
frozen, implemented, or released.**

All three preregistered, blinded architecture hypotheses canonicalized to
families explicitly forbidden by the frozen originality contract. The hard
architecture gate therefore has zero survivors. Under the preregistered stop
rule, no design may enter the primitive tournament and the requirements may
not be renamed, reinterpreted, or weakened to force one through.

This is a tournament result: **no submitted EC1 architecture survived**. It is
not a theorem that no possible future architecture can exist.

## Frozen decision chain

1. `REQUIREMENTS.md` fixed the external/security contract, engineering limits,
   and architecture exclusions before the design reports were opened.
2. Three isolated internal design agents received the same contract and could
   return a complete hypothesis or `NO-GO`.
3. Every report supplied a concrete construction attempt, then self-audited it
   against the canonicalization rules.
4. Two differently routed prior-art searches and one adversarial formal review
   independently classified the sealed graphs.
5. A separate internal process audit checked the preregistered stop condition,
   corrected an image-versus-acceptance-set overclaim, and limited this report
   to what the evidence establishes.

Internal agent separation is not unaffiliated cryptanalysis. No external
cryptographer has endorsed this result or any NauqCrypt design.

## Submission failure map

| Submission | Canonical form | Frozen hard rejection | Sealed report SHA-256 |
| --- | --- | --- | --- |
| A | plaintext plus 256 redundancy bits under forward/backward triangular recurrences | combined/evolving feedback and wide-block encode-then-encipher | `1d6b5c73881130702c37b225737fed7be5b268dbb7d842dfddd01e087449a852` |
| B | transcript PRF produces a public tag/selector that drives indexed masking | SIV/synthetic tag, stream-plus-authenticator | `b5f91c5c44ffeac180e11443f4a7db876676e66f8b975076579437455cd9a578` |
| C | keyed redundancy, local permutations, global linear mixing, local permutations | wide-block encode-then-encipher; structurally Encrypt-Mix-Encrypt | `54bbe8f7272507d7ba4597e67eecb2794750d387102eb372af3ad16dd01b53d7` |

The direct factorizations are sufficient to reject the submissions. They do
not depend on the incomplete proof plans, primitive choices, or performance.

## Formal findings and their limits

For a fixed key, framed public header, and message length, deterministic
encryption is a map

\[
E:\{0,1\}^{8\ell}\rightarrow\{0,1\}^{8\ell+256}.
\]

Correct decryption makes `E` injective. Its encryption image contains exactly
`2^(8l)` strings in a universe of `2^(8l+256)`, so encryption codewords have
exact density `2^-256`. Correctness alone does **not** prove that decryption
rejects every string outside that image; INT-CTXT must make any fresh accepting
string computationally infeasible to produce.

The target's deterministic, complete-transcript-equality leakage is naturally
the random-injection ideal used for deterministic authenticated encryption
(DAE), or MRAE when the nonce remains a distinguished public input. Rogaway and
Shrimpton formalized the DAE/PRI equivalence and the DAE-to-MRAE mapping in
[ePrint 2006/221](https://eprint.iacr.org/2006/221). [RFC 8452](https://www.rfc-editor.org/rfc/rfc8452.html)
likewise describes equality as the minimum repeated-nonce leakage of a
deterministic scheme, and [RFC 9771](https://www.rfc-editor.org/rfc/rfc9771.html)
uses MRAE as the current CFRG term.

That creates an ambiguity in the frozen originality list:

- If excluding “DAE” means excluding the security abstraction extensionally,
  the requested object is excluded by definition.
- If it means excluding only known DAE implementation architectures, universal
  impossibility is unresolved because EC1 did not define a complete graph
  equivalence relation or pass/quarantine machine model.

The no-go does not choose a post-result interpretation. All three actual graphs
are forbidden under either reading, so the tournament still has no winner.

The conventional IND-CCA requirement is coherent when read with RFC 9771's
nonce-respecting default. A future proof would still need a bit-exact combined
game for repeated nonces that supplies or excludes trivial transcript-equality
tests, plus exact multi-user and CMT-1 games. EC1 never reached proof freeze.

## Prior-art result

The two searches located architecture equivalents for every submission:

- SIV/DAE and the pseudorandom-injection ideal for B and the external target;
- CMC-style bidirectional feedback and AEZ-style encode-then-encipher for A;
- EME/ELmE-style local–global–local wide enciphering and AEZ/PTE for C; and
- Deoxys-II, Romulus-M, HS1-SIV, GLEVIAN/VIGORNIAN, and related modern MRAE
  work in the same excluded SIV, tweakable-cipher, or wide-block families.

Search B converted and machine-screened 99 PDFs from the official 56-directory
NIST LWC Round-1 archive and all 132 PDFs linked by the saved CAESAR submissions
index, then manually inspected structural hits. Search A independently followed
terminology, citations, competition specifications, RFCs, papers, and published
patent leads. The detailed query ledgers, hashes, and coverage limitations are
published in `research/prior-art/`.

Patent portal coverage was incomplete and no freedom-to-operate claim is made.
Published PCT applications may remain unavailable until roughly 18 months from
priority under [PCT Article 21](https://www.wipo.int/en/web/pct-system/texts/articles/a21).
Because no architecture survived, EC1 makes no novelty statement at all.

## Why implementation stops here

The gates are lexicographic. Architecture eligibility precedes the primitive
tournament, specification freeze, proof, vectors, Rust, clean-room C99, message
and file profiles, fuzzing, side-channel work, conformance, and benchmarks.
Implementing an excluded graph would spend validation effort on a design that
cannot ship and could create a misleading appearance of security.

Accordingly:

- primitive tournament started: **no**;
- primitive or round count selected: **no**;
- `spec_digest` issued: **no**;
- encryption API or file format implemented: **no**;
- test vectors or security proof issued: **no**;
- experimental-use qualification granted: **no**.

The repository contains research process, tooling, negative designs, query
ledgers, and this no-go—not usable cryptographic software.

## Evidence and reproduction

The machine-readable decision is `evidence/architecture-gate.toml`. Verify the
frozen foundation and sealed gate artifacts from the repository root:

```sh
./scripts/verify-foundation.sh
./scripts/verify-architecture-gate.sh
```

The public CI workflow runs the same checks. Report and corpus hashes identify
the exact evidence reviewed; they do not turn internal review into independent
cryptanalysis.

## What a future candidate would require

Any attempt to resolve the DAE wording, define an equality-aware misuse game,
formalize graph equivalence, or change the pass/quarantine computation model is
normative. Under the frozen change-control rule it must use a new candidate
identifier and rerun the blinded architecture and review process from the
beginning. EC1 itself remains closed and unchanged.

