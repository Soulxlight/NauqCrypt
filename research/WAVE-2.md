# Architecture Review Wave 2 Seal

- Candidate: EC1
- Sealed: 2026-08-06 UTC
- Frozen requirement digest: `a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828`
- Result: `BLOCKED_NO_WINNER`
- Provenance: isolated internal research and review agents
- Unaffiliated cryptographic review: none

Wave 2 used two different prior-art strategies plus an adversarial formal
classifier. A fourth internal process audit checked that the result follows the
preregistered stop rule and that the final claim is not broader than the
evidence.

| Artifact | Method | SHA-256 | Result |
| --- | --- | --- | --- |
| `prior-art/search-a.md` | primary-source terminology, citation, construction, and patent-lead search | `b563f62c8bf1e3e00a5928689fef6e16a2a69d82b4a5636a9589ef133f7bdc81` | no admissible survivor |
| `prior-art/search-b.md` | canonical dependency-graph search; machine screen of 99 NIST LWC PDFs and all 132 PDFs linked by the CAESAR index, with manual review of hits | `8ccaa6725d82bae11443d631a3b8654def39349f07d76f741dbb4b663400b06e` | no admissible survivor |
| `reviews/architecture-gate-formal.md` | theorem/definition/heuristic separation and anonymous graph factorization | `2cfe6b10f074396ee5eae5a10c017060bbcc2bc15834982df49eebb1f60d3c69` | all three submissions directly excluded |
| `reviews/process-gate-audit.md` | independent internal audit of preregistration and stop conditions | `017e03a8878d5451ffbb1961dcf743759ea2bac01e871766167c9465f961c0c9` | EC1 must stop with no winner |

The two search reports explicitly record their corpus and patent-portal limits.
Neither report is a legal freedom-to-operate opinion or an exhaustive-world
novelty proof. Positive architecture equivalents were located for all three
submissions, so a negative claim that no prior art exists is neither needed nor
made.

The formal result is deliberately narrow: no submitted EC1 architecture
survived. Universal impossibility is true only under an extensional reading of
the frozen DAE exclusion; it is unresolved under an architecture-only reading.
That unresolved question does not permit an excluded submission to advance.

