# EC1 Threat Model

## Adversary capabilities

The adversary may choose nonces, domains, AAD, plaintexts, and ciphertexts;
repeat nonces; adapt queries from earlier outputs; observe ciphertext length,
accept/fail results, and timing; attack many keys/users; replay, reorder,
duplicate, truncate, or transplant file records; and inspect all source,
specifications, constants, models, and evidence.

The adversary does not obtain endpoint memory, uniformly generated keys, or
plaintext before successful authentication. Q1 attackers may use local quantum
computation but interact with encryption/decryption through classical queries.

## Required leakage

Length is public. With nonce reuse, equality of the complete transcript may be
public. No additional common-prefix, common-block, or partial-message equality
leakage is permitted.

## Non-goals

Bare AEAD does not prevent replay, hide lengths or traffic patterns, provide
identity or forward secrecy, make password-derived keys safe, or recover from
endpoint/key compromise. The file profile detects a malformed or incomplete
object when its relevant verification operation runs; it does not prevent an
attacker from replaying an older complete valid file.

