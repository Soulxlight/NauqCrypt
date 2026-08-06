# Blinded Architecture Wave 1

- Started: 2026-08-05 EDT
- Sealed: 2026-08-06 UTC
- Frozen requirement digest: `a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828`
- Designers: three isolated internal research agents
- Cross-viewing before submission: prohibited
- Outcome: zero admissible submissions

Each designer received the same frozen external contract and exclusion list.
They were required either to submit a complete, self-audited architecture or to
return `NO-GO`; names, constants, primitive choices, state widths, key splitting,
and serialization were not accepted as architectural distinctions. Reports were
revealed to the other workstreams only after sealing.

This process supplies internal diversity, not independent public cryptanalysis.

## Frozen assignment

Produce one deterministic, two-pass AEAD hypothesis satisfying all of the
following simultaneously:

- exactly 256-bit key, 192-bit nonce, and 256-bit tag;
- ciphertext length equal to plaintext length;
- repeated nonces reveal at most equality of the complete domain, nonce, AAD,
  and plaintext transcript;
- a non-tautological reduction target and at least a 128-bit concrete profile;
- portable constant-time implementation with at most 2 KiB working state; and
- no reduction, after canonicalization, to generic composition,
  counter/stream-plus-MAC, SIV/DAE, sponge/duplex, offset/tweakable-cipher modes,
  combined feedback, evolving-state AE, Farfalle/deck constructions, or
  wide-block encode-then-encipher.

Every non-NO-GO report had to include equations, a dependency graph,
encryption/decryption algorithms, correctness, proof interface, exact nonce
reuse leakage, resource feasibility, a toy instance, and self-attacks.

## Sealed reports

| Candidate | SHA-256 | Self-classification | Verdict |
|---|---|---|---|
| A | `1d6b5c73881130702c37b225737fed7be5b268dbb7d842dfddd01e087449a852` | bidirectional combined feedback and wide-block enciphering | NO-GO |
| B | `b5f91c5c44ffeac180e11443f4a7db876676e66f8b975076579437455cd9a578` | deterministic AE/PRI or synthetic transcript state | NO-GO |
| C | `54bbe8f7272507d7ba4597e67eecb2794750d387102eb372af3ad16dd01b53d7` | wide-block encode-then-encipher DAE | NO-GO |

The provisional condition was discharged by the sealed reports in
`research/WAVE-2.md`. The final gate result is `BLOCKED_NO_WINNER`.

