# Research Governance

## Roles

- The project lead owns scope, gate enforcement, releases, and withdrawal.
- Blinded design workstreams propose architectures without seeing competing
  submissions.
- Attack and classification workstreams receive frozen, anonymized candidates.
- Rust and C implementation workstreams receive only the frozen specification;
  the C implementation is not translated from Rust.
- Internal reproduction workstreams may not count as independent public
  cryptanalysis.

## Decision order

Advancement is lexicographic: correctness; exact security/leakage contract;
originality; non-tautological proof interface; cryptanalytic margin;
constant-time portability; performance. A later strength cannot compensate for
failure of an earlier gate.

If multiple candidates survive, select the one with, in order: the least novel
assumption, simplest specification, largest attack margin, smallest state/code,
then highest speed.

## Change control

- Editorial changes preserve evidence only when every normative digest and
  vector remains byte-for-byte identical.
- Any ambiguity resolution is normative and resets affected evidence.
- Any round, state, constant, domain, padding, encoding, tag, nonce, limit,
  error, or wire-format change creates a new candidate identifier.
- A security fix is always normative.
- Compiler, linker, target, dependency, or SIMD changes reset binary leakage,
  sanitizer, and performance evidence for that environment.
- Gates and thresholds may not be weakened after results exist.

