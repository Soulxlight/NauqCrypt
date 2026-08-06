# Frozen EC1 Requirements

Status: preregistered before architecture submissions are opened.

Changes to this document after architecture results exist invalidate the
current tournament. A replacement must receive a new candidate identifier.

## External parameters

| Property | EC1 value |
| --- | --- |
| Key | 32 bytes, uniformly random |
| Nonce | 24 bytes |
| Tag | 32 bytes, never truncated |
| Domain | public byte string, 1--255 bytes |
| AAD | public byte string, 0--`2^32-1` bytes |
| Raw plaintext | 0--`2^32-1` bytes |
| Ciphertext | exactly the plaintext length |
| File chunk | exactly 65,536 bytes except the final chunk |
| Maximum file | `2^48` bytes |

Only one parameter set, round count, and wire algorithm identifier may ship.

## Required security contract

1. Correctness for every permitted input.
2. IND-CCA confidentiality and INT-CTXT authenticity under the published
   profile limits.
3. Deterministic nonce-misuse-resistant authenticated encryption: repeated
   nonces may reveal equality only when the complete `(domain, nonce, AAD,
   plaintext)` transcript is equal. Common prefixes and blocks of unequal
   transcripts may not be exposed.
4. At least 128 bits of concrete confidentiality, forgery, multi-user, and
   CMT-1 key-commitment security under fewer than `2^30` invocations, less than
   `2^60` total plaintext bytes, and fewer than `2^48` failed verifications per
   key.
5. A 256-bit classical key-search target and 128-bit Q1 quantum key-search
   target. Q2 superposition-oracle security is not claimed.
6. All public transcript fields use injective encodings and disjoint domains.
7. Authentication failure has one public result. No provisional plaintext is
   written to caller-visible output.
8. Secret values do not affect branches, memory addresses, loop counts, or use
   of variable-time instructions in normative software.

## Required originality contract

The primitive and AEAD architecture must be independently designed. After
canonicalization, the AEAD may not be an instance or routine composition of:

- Encrypt-and-MAC, MAC-then-Encrypt, Encrypt-then-MAC, or counter/stream plus
  an authenticator.
- SIV, DAE, synthetic-tag/seed, or other message-derived public selector modes.
- Sponge, duplex, MonkeyDuplex, Cyclist, or keyed absorb/squeeze modes.
- Offset, tweakable-block-cipher, codebook, or checksum-finalization modes.
- Combined-feedback or dedicated evolving-state authenticated encryption.
- Farfalle/deck/parallel-PRF modes.
- Wide-block or encode-then-encipher constructions.
- Nonce-derived-key, commitment, rekeying, or framing wrappers around a known
  core architecture.

The permitted claim is only: "No architecture-equivalent prior art was located
as of DATE under the published corpus, queries, abstractions, and review
protocol." Absolute novelty and legal freedom to operate are not claimed.

## Engineering contract

- At most two complete passes over plaintext/ciphertext and `O(n)` work.
- At most 2 KiB working state, excluding caller-owned input/output/quarantine.
- No heap allocation in steady-state core processing.
- Primary portable targets are x86-64, ARM64, and WebAssembly.
- Rust is the primary safe implementation; C99 is independently authored from
  the frozen prose specification.
- Median performance at every required benchmark point is no worse than 2x
  the pinned AES-256-GCM-SIV baseline; p95 is no worse than 2.5x.

## Explicit exclusions

EC1 does not define password hashing, a KDF, key exchange, forward secrecy,
identity authentication, replay protection, traffic/length hiding, endpoint
compromise recovery, or physical power/EM/fault resistance.

If no design satisfies every requirement, EC1 is blocked. Requirements are not
relaxed to force a winner.

