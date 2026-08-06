# Research Execution Protocol

## Waves

1. Three blinded architecture hypotheses.
2. Two independent prior-art searches plus one abstract classifier.
3. Three primitive-family instantiations for every surviving architecture.
4. Independent cryptanalysis/modeling workstreams with anonymized candidates.
5. Frozen specification, Rust implementation, clean-room C implementation, and
   formal verification in separate workstreams.
6. Independent internal reproduction and public release.

All useful reports, including negative results, are committed. Agent diversity
does not count as unaffiliated expert review.

## Evidence identity

Before candidate freeze, artifacts carry a requirements digest and candidate
label. After freeze, every normative and evidentiary artifact carries the same
`spec_digest`. Commands, tool versions, seeds, timeouts, raw output hashes, and
environment identities accompany each result.

## No-go behavior

If no design survives a gate, write a no-go report identifying the exact failed
requirements and evidence. Do not reinterpret, rename, or weaken a requirement
to advance a design.

