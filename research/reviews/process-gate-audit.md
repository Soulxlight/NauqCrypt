---
review: process-gate-audit
verdict: BLOCKED_NO_WINNER
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
authored_utc: 2026-08-06
provenance: independent-internal-process-audit
---

# Independent Process and Architecture-Gate Audit

## Audit verdict

**EC1 must stop at the architecture gate as `BLOCKED_NO_WINNER`.** This is a
tournament result, not a universal impossibility theorem.

The preregistered chain is explicit:

- Wave 1 consists of three blinded hypotheses
  (`docs/RESEARCH_PROTOCOL.md:3-8`).
- Excluded-family matches are hard rejections, and only survivors enter the
  primitive tournament (`docs/ARCHITECTURE_GATE.md:17-30` and
  `evidence/gates.toml:25-30`).
- Zero survivors requires a no-go report without weakening or renaming a
  requirement (`docs/RESEARCH_PROTOCOL.md:23-27`).
- EC1 is blocked rather than relaxed to force a winner
  (`REQUIREMENTS.md:82-83`).

The three direct failures are adequately identifiable:

| Submission | Direct failed clause | Evidence |
| --- | --- | --- |
| A | Combined/evolving feedback and wide-block encode-then-encipher (`REQUIREMENTS.md:55-57`) | `research/architectures/A.md:322-335` |
| B | Stream-plus-authenticator and synthetic-tag/SIV (`REQUIREMENTS.md:50-53`) | `research/architectures/B.md:194-200` |
| C | Wide-block encode-then-encipher (`REQUIREMENTS.md:57`) | `research/architectures/C.md:376-398` |

The formal review independently confirms those graph factorizations at
`research/reviews/architecture-gate-formal.md:187-227`. The current A, B, and C
SHA-256 values exactly match the sealed values in
`research/architectures/WAVE-1.md:38-44`.

The gate consequence is narrow but mandatory: no submission may enter the
primitive tournament. The unresolved architecture-only impossibility question
does not authorize advancing an ineligible submission and does not negate the
zero-survivor rule.

## Mandatory actions before final no-go publication

1. **Scope the conclusion correctly.** Publish: "No submitted EC1 architecture
   survived; the current tournament has no winner." Do not publish "no possible
   architecture exists" under the architecture-only reading. That claim remains
   unresolved (`research/reviews/architecture-gate-formal.md:229-250` and
   `:273-289`). The exhaustion claims in `research/architectures/A.md:352-362`,
   `research/architectures/B.md:14-37`, `:203-223`, and `:307-319`, and
   `research/architectures/C.md:436-438` must be presented as conditional or
   heuristic taxonomy arguments, not as a proved universal theorem.

2. **Correct the image-versus-acceptance-set statement.** Correctness proves
   that encryption is injective and that its image/codebook has density exactly
   `2^-256`. It does not by itself prove that the entire decryption acceptance
   set equals that image; decryption could accept additional strings that
   encryption never emits. The theorem classification in
   `research/reviews/architecture-gate-formal.md:45-63` must use "encryption
   image" unless an additional canonical-rejection condition is established.

3. **Seal the now-complete Wave 2 report set.** The two independent prior-art
   reports now exist at `research/prior-art/search-a.md` and
   `research/prior-art/search-b.md`. Together with the taxonomy and adversarial
   canonicalization in `research/reviews/architecture-gate-formal.md`, their
   existence discharges the previously provisional report-set condition in
   `research/architectures/WAVE-1.md:46-47`, subject to all three Wave 2
   artifacts being sealed, committed, and referenced by digest. Until that
   sealing is recorded, publication must remain explicitly provisional.

4. **Commit and identify all negative evidence.** Useful negative reports must
   be committed (`docs/RESEARCH_PROTOCOL.md:13-14`). Every final evidence record
   must carry the EC1 identity, requirements digest, provenance or independence
   status, artifact hash, and sealing metadata consistent with
   `docs/RESEARCH_PROTOCOL.md:16-21`. Preserve `evidence/gates.toml:1-3` as the
   preregistration record; record the outcome in a separate sealed artifact
   rather than overwriting the preregistration.

5. **Publish an exact failure map.** The final outcome artifact must map A, B,
   and C to the frozen failed clauses and the sealed report hashes, as required
   by `docs/RESEARCH_PROTOCOL.md:23-27`. It must state that the hard rejection is
   excluded-family canonicalization, not an unproved security reduction or a
   claim of exhaustive-world prior-art coverage.

6. **State both frozen ambiguities.** Ordinary unrestricted IND-CCA conflicts
   with deterministic equality leakage unless an equality-aware game is
   specified (`research/reviews/architecture-gate-formal.md:67-79`). The DAE
   exclusion also has unresolved extensional and architectural readings
   (`research/reviews/architecture-gate-formal.md:81-103`). These are limitations
   of EC1, not licenses for a post-result reinterpretation. Any clarification or
   rerun requires a new candidate identifier
   (`research/reviews/architecture-gate-formal.md:291-298` and
   `REQUIREMENTS.md:3-6`).

## Optional strengthening

- Obtain unaffiliated expert review. The present work establishes internal
  process separation, not unaffiliated independence
  (`research/architectures/WAVE-1.md:16` and
  `docs/RESEARCH_PROTOCOL.md:13-14`).
- Pursue a formal impossibility theorem or a broader architecture search.
  Neither is required to stop the current zero-survivor EC1 tournament.
- Start a new candidate only after defining an equality-aware confidentiality
  game, graph-equivalence rule, and formal pass/quarantine machine model.

## Final process ruling

Subject to sealing the existing Wave 2 and formal-review artifacts, EC1 should
publish a no-go whose exact claim is **blocked at the architecture gate, no
winner**. It must not publish a universal architecture-only impossibility claim.
