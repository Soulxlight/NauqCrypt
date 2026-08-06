# NauqCrypt

NauqCrypt is a public research project attempting to produce an experimental,
clean-sheet authenticated-encryption candidate for replaceable, non-sensitive
data.

There is no released cipher yet. Nothing in this repository is approved for
protecting credentials, financial or medical records, irreplaceable data,
production secrets, or data exposed to capable targeted attackers.

The first milestone is **Experimental Candidate 1 (EC1)**. A design can receive
that label only after one unchanged specification passes the preregistered
novelty, proof, cryptanalysis, implementation, side-channel, portability, and
performance gates. Internal qualification is not evidence of independent
security review.

## Fixed EC1 profile

- 256-bit uniformly random keys.
- 192-bit nonces.
- 256-bit tags with no truncation.
- Mandatory 1--255 byte public application domain.
- Two-pass, deterministic authenticated encryption.
- Nonce-misuse privacy limited to whole-transcript equality leakage.
- Safe message envelopes and 64 KiB verified random-access file chunks.
- Portable, constant-time Rust and independently authored C99 implementations.
- Primary targets: x86-64, ARM64, and WebAssembly.

The frozen requirements are in [REQUIREMENTS.md](REQUIREMENTS.md). Research is
tracked in [docs/STATUS.md](docs/STATUS.md), and all advancement gates are
machine-readable in [evidence/gates.toml](evidence/gates.toml).

## Status

Architecture gate under independent review. The first blinded wave produced no
admissible design. No encryption API or file format is available for use.

## Licensing

Source code is offered under either the MIT License or Apache License 2.0.
Specifications, research documents, test vectors, and generated evidence are
dedicated under CC0 1.0 unless a file says otherwise. See [PATENTS.md](PATENTS.md)
for the patent non-assert and limitations.
