# Security Policy

## Current status

NauqCrypt has no usable encryption release. EC1 closed with no winner at the
architecture gate. Architecture documents and toy models are research artifacts
and may be completely broken.

## Intended EC1 use

If EC1 eventually passes its internal gates, use remains opt-in and restricted
to replaceable, non-sensitive data where compromise would not be catastrophic.
Do not use it for passwords, authentication tokens, private keys, financial or
medical data, irreplaceable backups, regulated data, or production secrets.

## Reporting

Report suspected cryptographic, implementation, proof, or specification flaws
through a GitHub security advisory after the public repository exists. Before
then, contact the repository owner privately. Reports should identify the
candidate/specification digest, affected claim, attack model, complexity, and a
reproducer when possible.

No bounty or embargo duration is promised by this repository. A confirmed
security fix always creates a new candidate identifier and resets affected
evidence.
