# Architecture Gate Protocol

## Submission package

Each blinded architecture must provide equations and pseudocode, a causal
dependency graph, decryption and correctness arguments, exact leakage,
primitive assumptions, proof plan, toy instantiation, constant-time analysis,
and self-attacks. A submission may return NO-GO.

## Canonicalization

Before comparison, remove names, notation, constants, word sizes, endianness,
key/nonce/tag lengths, primitive choices, ordinary KDF key splitting, and wire
formatting. Compare primitive-call ordering, data-dependency edges, feedback,
pass boundaries, state lifetimes, and output timing.

## Hard rejection

Reject a design that:

1. Canonicalizes to an excluded family in REQUIREMENTS.md.
2. Requires a tautological assumption equivalent to "the complete scheme is a
   secure AEAD."
3. Has circular or ambiguous decryption, multiple valid decodings, biased tags,
   or leakage beyond the frozen function.
4. Cannot be implemented with fixed-time portable integer/Boolean operations.
5. Cannot support the fixed external limits and advantage bound.
6. Needs more than two full passes or more than 2 KiB working state.

Only candidates passing every hard gate may enter the primitive tournament.

