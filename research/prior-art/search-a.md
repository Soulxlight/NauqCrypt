---
search: A
wave: 2
verdict: NO-GO
gate_status: BLOCKED
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
prior_art_protocol_digest: 72bd201b652b5a6c406a919795077296c95abeec50a97fa8b4d654a7d42c2f16
searched_utc: 2026-08-06
scope: independent-primary-source-prior-art-search
---

# Wave 2 — Independent Primary-Source Prior-Art Search A

## Executive result

No architecture survives the frozen EC1 requirements and exclusions.

| Proposition tested | Finding | Confidence |
|---|---|---|
| 1. Equality-only leakage under deterministic nonce reuse is definitionally DAE/MRAE. | **Confirmed.** With `(domain, nonce, AAD, plaintext)` injectively encoded, EC1 asks for the deterministic random-injection ideal of DAE. Keeping the nonce as a distinguished IV gives the MRAE formulation. | Very high |
| 2. Candidates A, B, and C canonicalize to excluded families. | **Confirmed.** A is both a bidirectional feedback construction and encode-then-encipher over a wide state; B is SIV followed by indexed stream masking; C is redundancy encoding followed by a wide SPN/permutation. | Very high |
| 3. A known architecture or plausible loophole satisfies every frozen exclusion. | **Not found.** The closest primary-source families are SIV/synthetic-selector, pad/encode-then-encipher, tweakable-block-cipher/offset, online feedback, sponge/duplex, Farfalle/deck, or nonce/key/commitment wrappers. Each is expressly excluded, and the online alternatives leak prefixes rather than equality only. | High for the inspected corpus; not an exhaustive-world claim |

There is also a definition-level conflict. Read literally, EC1 requires DAE/MRAE security while the frozen exclusions forbid DAE. That makes the admissible set empty independently of implementation. If “DAE” in the exclusion was intended only as shorthand for familiar DAE *constructions*, the structural search still produces no survivor.

This is a **negative architecture result**, not an absolute novelty opinion and not a freedom-to-operate opinion. No provisional publication-novelty finding is available because there is no admissible candidate with a surviving essential invariant to test. Patent records below are search leads only.

## Frozen inputs and inspection method

The following local inputs were read after candidate C appeared and were not modified:

| Input | SHA-256 | Disposition |
|---|---|---|
| `REQUIREMENTS.md` | `a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828` | Frozen contract |
| `docs/PRIOR_ART_PROTOCOL.md` | `72bd201b652b5a6c406a919795077296c95abeec50a97fa8b4d654a7d42c2f16` | Search/canonicalization protocol |
| `research/architectures/A.md` | `1d6b5c73881130702c37b225737fed7be5b268dbb7d842dfddd01e087449a852` | Sealed, `NO-GO` |
| `research/architectures/B.md` | `b5f91c5c44ffeac180e11443f4a7db876676e66f8b975076579437455cd9a578` | Sealed, `NO-GO` |
| `research/architectures/C.md` | `54bbe8f7272507d7ba4597e67eecb2794750d387102eb372af3ad16dd01b53d7` | Sealed, `NO-GO` |

The search used the protocol's dependency-graph rule: names were ignored and each construction was reduced to (1) what first absorbs all of the public header and plaintext, (2) what value selects or initializes the second pass, (3) whether the transform is a permutation over the whole encoded record, and (4) where authentication redundancy is introduced and checked. Search-engine results were used only to route to primary sources. Evidence came from papers, specifications, standards, competition submissions, official project reports, and published patent records.

The evidence-bearing search ran on **2026-08-06 UTC**. “Current” in this report means checked on that date.

## Proposition 1 — the EC1 leakage target is DAE/MRAE

Let

```text
H = Encode(domain, nonce, AAD, all required lengths)
M = plaintext
```

where `Encode` is injective. EC1 requires deterministic encryption, fixed 256-bit expansion, authenticity, and ciphertexts that reveal no relation between distinct `(H,M)` inputs. Repeating the identical `(H,M)` necessarily repeats the ciphertext; no deterministic algorithm can avoid that equality leak.

Rogaway and Shrimpton define deterministic authenticated encryption with a vector-valued header and show its equivalence to a pseudorandom injection (PRI). Their MRAE ideal returns fresh random-looking outputs except when the complete `(header, IV, message)` triple repeats, and they show that DAE with the IV placed in the header directly realizes MRAE. See the full version of [Deterministic Authenticated-Encryption: A Provable-Security Treatment of the Key-Wrap Problem](https://eprint.iacr.org/2006/221) (especially §§3, 6, and 7; received 2006-06-30, last revision 2007-08-20).

The mapping to EC1 is exact under either interface view:

```text
DAE view:   header := (domain, nonce, AAD, lengths), message := plaintext
MRAE view:  header := (domain, AAD, lengths), IV := nonce, message := plaintext
```

[RFC 5297](https://www.rfc-editor.org/rfc/rfc5297.html) says SIV achieves DAE or nonce-based MRAE and states that nonce reuse retains authenticity while revealing only whether the same plaintext and associated data were protected under the same nonce and key. [RFC 8452](https://www.rfc-editor.org/rfc/rfc8452.html) describes the corresponding best-possible repeated-nonce loss as identical plaintexts producing identical ciphertexts. The current CFRG taxonomy, [RFC 9771](https://www.rfc-editor.org/rfc/rfc9771.html) (May 2025), names the formal notion MRAE, gives AES-GCM-SIV and Deoxys-II as examples, and identifies SIV as a generic nonce-misuse-resistant construction.

Therefore proposition 1 is not merely a resemblance claim. The frozen leakage contract is the DAE/PRI ideal expressed through a nonce-bearing API, hence MRAE.

## Proposition 2 — canonical forms of A, B, and C

### Candidate A

The sealed construction applies a keyed, header-dependent, bidirectional triangular-feedback permutation to an encoded record of the form `P || 0^256`, then splits the permuted result into the same-length ciphertext core and 256-bit tag.

Canonical graph:

```text
(domain, nonce, AAD, lengths) ---> tweak/header schedule -----+
                                                               v
plaintext ---> append 256 authentication-zero bits ---> wide keyed permutation ---> split(C,T)
                                                        ^
                                                        |
                                      forward/backward evolving feedback
```

This is excluded twice:

1. Appending known authentication redundancy, applying a whole-record permutation, and testing the redundancy after inverse permutation is encode/pad-then-encipher with a wide-block primitive.
2. Its claimed implementation mechanism is combined/evolving feedback in both directions.

AEZ supplies a direct primary-source neighbor: its specification says it appends a fixed authentication block and enciphers the result with an arbitrary-input-length block cipher tweaked by nonce and AD. See [AEZ v5](https://competitions.cr.yp.to/round3/aezv5.pdf), pp. 1–4.

### Candidate B

The sealed normal form is:

```text
S = F_K(domain || nonce || AAD || lengths || plaintext)
T = EncodeTag(S)
C_i = P_i xor G_K(S, public-header, i)
```

`S` is a synthetic message-dependent selector computed before encryption; it then selects the indexed masking stream. Renaming `S`, hiding it behind `T`, or fusing the calls does not change the dependency graph. This is SIV plus stream/counter encryption, both expressly excluded.

The primary-source comparators are exact rather than approximate: [RFC 5297](https://www.rfc-editor.org/rfc/rfc5297.html) computes S2V over associated data and plaintext and uses the result as the CTR initial value; [HS1-SIV v2 corrected](https://competitions.cr.yp.to/round2/hs1sivv2c.pdf) hashes `(A,M,N)` into a synthetic IV and uses a ChaCha-based pseudorandom stream for the ciphertext.

### Candidate C

The sealed construction encodes the plaintext with 256 bits of authentication redundancy, applies local keyed permutations separated by a global rank-one linear mixing layer over the entire variable-length record, then splits the output into ciphertext and tag.

Canonical graph:

```text
header ---> keyed parameters/tweak ----------------------------+
                                                               v
plaintext ---> injective redundancy code ---> wide SPN/permutation ---> split(C,T)
                                         local P / global L / local P
```

The rank-one matrix, local permutation choice, and number of layers are internal details of a variable-input-length wide permutation. Authentication comes from the encoded redundancy. The construction is therefore encode-then-encipher with a wide SPN/tweakable cipher, which is expressly excluded.

The closest structural primary source found was Cogliati and Lee, [Wide Tweakable Block Ciphers Based on Substitution-Permutation Networks](https://eprint.iacr.org/2018/488), which explicitly builds wide tweakable block ciphers from SPNs. The variable-input-length patent family discussed below is another close structural neighbor; neither creates an admissible escape from the wide-block exclusion.

## Publication corpus and exclusion decisions

### Foundational DAE/MRAE and CFRG/RFC corpus

| Primary source | Inspected proposition or construction | Decision under frozen EC1 |
|---|---|---|
| Rogaway–Shrimpton, [ePrint 2006/221](https://eprint.iacr.org/2006/221), full version of EUROCRYPT 2006 | DAE syntax, PRI equivalence, SIV, MRAE ideal, DAE-to-MRAE mapping | Establishes proposition 1. DAE and SIV are excluded. |
| [RFC 5297](https://www.rfc-editor.org/rfc/rfc5297.html), October 2008 | S2V over vector AD and plaintext, then AES-CTR; exact equality-only nonce-reuse statement | Direct SIV and stream/counter construction; excluded. |
| [RFC 8452](https://www.rfc-editor.org/rfc/rfc8452.html), April 2019 | Per-nonce key derivation, POLYVAL over AAD/plaintext, synthetic tag, AES-CTR; nonce-reuse loss and no-release rule | SIV, nonce-derived keys, and stream/counter-plus-auth; excluded. |
| [RFC 9771](https://www.rfc-editor.org/rfc/rfc9771.html), May 2025 | Current CFRG property taxonomy; MRAE, examples, SIV note, Q1 terminology | Confirms current terminology; does not supply a new construction. |
| [draft-irtf-cfrg-aead-limits-11](https://datatracker.ietf.org/doc/draft-irtf-cfrg-aead-limits/11/), revision 2025-12-04 | Current/archived CFRG usage-limit work; nonce-respecting operational limits | Context only; no admissible EC1 architecture. The Datatracker marked the draft expired/archived when checked. |

### CAESAR corpus

The official [CAESAR submissions index](https://competitions.cr.yp.to/caesar-submissions.html) and [CAESAR features taxonomy](https://competitions.cr.yp.to/features.html) were inspected first. The feature page defines the highest repeated-message-number target as full security except equality of repeated plaintexts; it separately identifies lower online targets that reveal common initial blocks.

The closest submissions were then inspected at specification level:

| Candidate/source | Canonical architecture or claimed leakage | Exclusion/failure |
|---|---|---|
| [Deoxys v1.41](https://competitions.cr.yp.to/round3/deoxysv141.pdf) | Deoxys-II is explicitly SCT-2, a Synthetic Counter-in-Tweak MRAE mode using a TBC. | Synthetic selector/counter-in-tweak and TBC/offset family; excluded. |
| [HS1-SIV v2 corrected](https://competitions.cr.yp.to/round2/hs1sivv2c.pdf) | Explicit Rogaway–Shrimpton SIV: hash `(A,M,N)` to an SIV, then use a ChaCha-based stream. | SIV and stream-plus-auth; excluded. |
| [AEZ v5](https://competitions.cr.yp.to/round3/aezv5.pdf) | Append authentication zeros, encode nonce/AD in tweak, encipher whole record with arbitrary-input-length block cipher. | Wide-block encode-then-encipher; excluded. |
| [COLM v1](https://competitions.cr.yp.to/round3/colmv1.pdf) | Encrypt–linear-mix–encrypt, online misuse resistance; its stated repeated-nonce security is only up to a common prefix. | Online/combined-feedback family and violates “no common prefixes.” |
| [NORX v3.0](https://competitions.cr.yp.to/round3/norxv30.pdf) | monkeyDuplex/parallel-duplex construction; only moderate reuse protection conditioned on unique header data. | Sponge/duplex excluded and does not meet full equality-only reuse leakage. |

This was not a line-by-line inspection of every CAESAR submission and every historical revision. It covered the official index/taxonomy and the primary specifications of the candidates closest to the required misuse target or to A/B/C's canonical structures.

### NIST Lightweight Cryptography corpus

The official [NIST finalist list](https://csrc.nist.gov/Projects/lightweight-cryptography/finalists), [NISTIR 8454](https://nvlpubs.nist.gov/nistpubs/ir/2023/NIST.IR.8454.pdf), and the [Romulus final specification](https://csrc.nist.gov/CSRC/media/Projects/lightweight-cryptography/documents/finalist-round/updated-spec-doc/romulus-spec-final.pdf) were inspected.

Romulus-M was the closest finalist. Its own specification says that it follows general SIV, processes the message twice using Romulus-N, and is based on the Skinny tweakable block cipher. NISTIR 8454 describes Romulus-M as MAC-then-Encrypt and records only **64-bit privacy and authenticity in the full nonce-misuse setting**, below EC1's 128-bit requirement. It is independently disqualified by the SIV/MtE/TBC exclusions.

NIST selected Ascon and published [SP 800-232](https://csrc.nist.gov/pubs/sp/800/232/final) in August 2025. That result does not produce an EC1 loophole: Ascon-AEAD128 is not the equality-only repeated-nonce design sought here, and its permutation/duplex lineage is independently excluded.

This search used NIST's finalist report as the broad official corpus map and inspected the closest MRAE finalist in full. It did not independently re-read all 57 initial submissions.

### IACR papers and modern near neighbors

| Primary source | Relevant result | Exclusion/failure |
|---|---|---|
| Khairallah, [Fast Parallelizable Misuse-Resistant AE](https://eprint.iacr.org/2024/550), SAC 2024 | Surveys SIV and encode-then-encipher as the two established DAE/MRAE blueprints; LLSIV, pLLSIV, and LLDFV remain TBC/SIV-family designs. | Confirms, rather than escapes, the excluded family split. |
| Campbell, [GLEVIAN and VIGORNIAN](https://eprint.iacr.org/2023/1379) | Strong nonce-misuse and no-unverified-plaintext goals; underlying PTE form appends redundancy and applies a wide tweakable permutation, with nonce-derived-key domain extension. | Wide-block pad/encode-then-encipher plus nonce-derived-key wrapper; excluded. |
| Hoang et al., [Online Authenticated-Encryption and its Nonce-Reuse Misuse-Resistance](https://eprint.iacr.org/2015/189), CRYPTO 2015 | Shows no online-AE definition can meaningfully retain the full nonce-reuse target; even the best online notion can suffer severe reuse leakage. | Rejects the main one-pass/online loophole. |
| Andreeva et al., [Nonce-Misuse Security of SAEF](https://eprint.iacr.org/2020/1524), SAC 2020 | Online sequential SAEF retains integrity but confidentiality degrades through repeated common message prefixes. | Violates equality-only leakage; sequential feedback family. |
| Hoang–Krovetz–Rogaway, [AEZ](https://eprint.iacr.org/2014/793) and [AEZ v5](https://competitions.cr.yp.to/round3/aezv5.pdf) | Robust AE by appending a fixed authentication block and enciphering the whole string. | Wide-block encode-then-encipher; excluded. |
| Daemen et al., [Xoodoo cookbook](https://eprint.iacr.org/2018/767) | Xoofff deck/Farfalle, SANE/SANSE, WBC/WBC-AE, and Xoodyak duplex cover multiple misuse and wide-block design routes. | Every listed route lands in an express exclusion: deck/Farfalle, WBC, or duplex. |
| Cogliati–Lee, [Wide Tweakable Block Ciphers Based on SPNs](https://eprint.iacr.org/2018/488), CRYPTO 2018 | Wide tweakable SPNs with multi-user bounds. | Close neighbor to C, but wide-block/TBC excluded. |
| Bhattacharjee–Bhaumik–Dhar, [Universal Context Commitment without Ciphertext Expansion](https://eprint.iacr.org/2024/1382) | PACT adds context commitment to legacy SIV, MtE, or EtE schemes without expansion and preserves misuse security. | Commitment transform/wrapper is expressly excluded; underlying families are excluded too. |

No “new name” in this corpus changed the canonical dependency graph. The low-latency and commitment papers optimize or wrap the same underlying families.

## Proposition 3 — explicit loophole audit

| Attempted escape | Why it cannot satisfy all frozen gates |
|---|---|
| Emit ciphertext online before seeing later plaintext | Later blocks cannot influence earlier ciphertext. Repeated nonce and common prefix therefore reveal more than full-tuple equality. The CAESAR taxonomy, COLM, OAE analysis, and SAEF result make this failure explicit. |
| First pass computes a short global message value; second pass encrypts under/indexed by it | The value is a synthetic selector/IV, whether exposed directly, encoded as the tag, or hidden behind a reversible map. This canonicalizes to SIV. |
| Append/check authentication redundancy and permute the complete record | This is pad/encode-then-encipher using a variable-input-length wide permutation. A and C, AEZ, GLEVIAN/VIGORNIAN, and wide-SPN work take this route. |
| Carry a secret state through blocks so the final tag authenticates the path | This is combined feedback/evolving state or sponge/duplex depending on the interface. Both are excluded; a single direction also retains prefix structure under reuse. |
| Obtain parallel global influence through a permutation-based PRF/deck | This is the Farfalle/deck branch, expressly excluded. |
| Derive a fresh key from the nonce or add key/context commitment | This is a nonce-derived-key, rekey, or commitment wrapper, expressly excluded. |
| Frame/chunk and authenticate subrecords | Framing is excluded and independently reveals record boundaries/equalities beyond the required whole-tuple equality. |
| Postulate a native arbitrary-length pseudorandom injection as the primitive | That simply assumes the DAE/PRI object EC1 asks to construct. Under the literal exclusion of DAE it is inadmissible; under the structural reading it supplies no implementable, non-excluded architecture. |
| Randomize encryption internally | The API is frozen deterministic and carries no permitted extra randomness or ciphertext expansion beyond the fixed tag. |

The two-pass allowance is therefore not the obstacle. The obstacle is that every known way to transport whole-message dependence into same-length ciphertext within two passes uses one of the excluded carriers: a synthetic selector, a wide permutation, evolving state, a deck, or a wrapper.

## Patent search — separate from publication novelty

### Databases and query route

The search checked published records routed through Google Patents and attempted indexed searches against USPTO Patent Public Search, WIPO PATENTSCOPE, and EPO Espacenet. Exact site-restricted queries are logged below. Native, complete claim-database export was **not achieved** for USPTO/WIPO/EPO; the official interfaces did not return a stable, reviewable result set through the available tooling. Consequently this section is not exhaustive and must not be used as a clearance opinion.

Relevant published families found:

| Record | Priority / assignee as displayed | Claim/architecture relevance | Search disposition |
|---|---|---|---|
| [US10862670B2](https://patents.google.com/patent/US10862670B2/en), “Automotive nonce-misuse-resistant authenticated encryption” | 2018-05-18; Infineon Technologies AG | Claims a hardware state machine with matching block-cipher devices; dependent claims cover nonce-misuse-resistant AEAD. Description explicitly implements CCM-SIV: CBC-based PRF/tag followed by CTR. | Relevant implementation claims, but structurally SIV/CTR and excluded. Displayed Google status “Active”; not independently verified. |
| [US11838424B2](https://patents.google.com/patent/US11838424B2/en) / [WO2022237440A1](https://patents.google.com/patent/WO2022237440A1/en), “Authenticated encryption apparatus with initialization-vector misuse resistance” | 2021-05-13; Huawei Technologies Co., Ltd. | Independent claim 1 produces a Poly1305 tag from MAC key, nonce, and message; encrypts the tag into a pseudorandom IV; then encrypts the message under that IV. | Direct SIV-family claim lead; excluded architecturally. Displayed US status “Active”; not independently verified. |
| [US20150349950A1](https://patents.google.com/patent/US20150349950A1/en) / US9571270B2 and continuation [US10009171B2](https://patents.google.com/patent/US10009171B2/en), “Construction and uses of variable-input-length tweakable ciphers” | 2013-11-29; Portland State University | Claims VIL tweakable ciphers, fixed-length TBC calls around a VILTC, hidden IV, and authenticated-encryption/full-disk uses. | Close wide-block/TBC structural lead for C; excluded. Family/legal status requires counsel verification. |
| [US7949129B2](https://patents.google.com/patent/US7949129B2/en), “Method and apparatus for facilitating efficient authenticated encryption” | 2001-07-30; inventor Phillip Rogaway | OCB-family same-length ciphertext core plus tag using offsets/checksum and a tweakable-block-cipher formulation. | Publication prior art and claim lead, but nonce-respecting and in the excluded offset/checksum family. |
| [US12107965B2](https://patents.google.com/patent/US12107965B2/en), “Data encryption and integrity verification” | PCT filing 2019-06-17; assignee/status require verification | Description hashes plaintext to an integrity value, derives an IV from integrity value and AD, then encrypts using that IV; expressly discusses AES-SIV. | Synthetic-IV/hash-then-encrypt lead; excluded. |

Observed classification routes included `H04L9/0618` (block ciphers), `H04L9/0631` (SPN), `H04L9/0637` (modes of operation), `H04L9/0861` (key derivation), `H04L9/3242` (keyed hashes/MACs), `H04L2209/125` (parallelization/pipelining), `H04L9/0625` (Feistel-type block ciphers), and `G06F12/1408` (cryptographic memory protection). These are routing aids, not a complete CPC landscape.

Google Patents itself warns that displayed legal status, expiration, priority, and assignee data are not legal conclusions. No claim construction, prosecution-history review, national-family verification, ownership verification, terminal-disclaimer review, or jurisdiction-by-jurisdiction expiration analysis was performed.

### Patent/FTO conclusion

The patent corpus reinforces the same structural split—SIV/tag-derived IV, wide/VIL tweakable cipher, or offset/checksum mode—but it does **not** establish freedom to operate. FTO is jurisdiction-, date-, claim-, implementation-, and ownership-specific. A patent professional would need to search the native databases and read live claims against a concrete implementation. Since no EC1-compliant implementation survives, that next-stage claim chart is presently undefined.

## Exact query log

All queries below were issued on 2026-08-06 UTC. Quotation marks are preserved. Search results were only routing aids; the evidence decisions above use linked primary sources.

### IACR / papers

```text
site:eprint.iacr.org deterministic authenticated encryption random injection Rogaway Shrimpton DAE 2006 PDF
site:eprint.iacr.org misuse resistant authenticated encryption definition nonce repetition equality leakage
site:eprint.iacr.org AEZ robust authenticated encryption wide block PDF
site:eprint.iacr.org "Online Authenticated-Encryption" nonce-reuse misuse-resistance prefix
site:eprint.iacr.org Deoxys-II nonce misuse resistant tweakable block cipher
site:eprint.iacr.org Romulus-M nonce misuse resistant SIV
site:eprint.iacr.org "two-pass" "nonce-misuse resistant" authenticated encryption
site:eprint.iacr.org bidirectional feedback authenticated encryption permutation tag
site:eprint.iacr.org rank-one global mixing authenticated encryption wide block
site:eprint.iacr.org "pseudorandom injection" authenticated encryption
site:eprint.iacr.org Farfalle SIV deck function nonce misuse authenticated encryption
site:eprint.iacr.org wide tweakable block cipher SPN authenticated encryption
site:eprint.iacr.org context commitment nonce misuse SIV encode then encipher
```

### CAESAR

```text
site:competitions.cr.yp.to/caesar-submissions.html Deoxys II specification
site:competitions.cr.yp.to/round3 deoxys v1.41 pdf
site:competitions.cr.yp.to/round3 COLM specification pdf nonce misuse
site:competitions.cr.yp.to HS1-SIV specification pdf
site:competitions.cr.yp.to/round3 NORX nonce misuse resistant appendix pdf
AEZ v5 specification CAESAR robust authenticated encryption PDF Hoang Krovetz Rogaway
site:competitions.cr.yp.to/round3 AEZ specification pdf
```

The official submissions index was additionally searched in-document for `Deoxys`, `COLM`, `AEZ`, `HS1-SIV`, and `NORX`; the features page was searched for `repeated message numbers`, `plaintext`, and `common initial blocks`.

### NIST LWC

```text
site:csrc.nist.gov lightweight cryptography finalists Romulus-M nonce misuse resistant
site:nvlpubs.nist.gov NISTIR 8454 Romulus-M misuse resistant 64-bit
site:csrc.nist.gov romulus specification final pdf SIV MRAE
site:csrc.nist.gov SP 800-232 Ascon final 2025
```

### CFRG / RFC

```text
site:rfc-editor.org/rfc RFC 5297 SIV deterministic authenticated encryption
site:rfc-editor.org/rfc RFC 8452 nonce reuse plaintext equality associated data
site:rfc-editor.org/rfc "misuse-resistant authenticated encryption"
site:datatracker.ietf.org/doc "nonce misuse resistant" AEAD CFRG
site:datatracker.ietf.org/doc "deterministic authenticated encryption" CFRG
site:datatracker.ietf.org/doc "SIV" "CFRG" AEAD
```

### Patents

```text
site:patentscope.wipo.int "synthetic initialization vector" encryption
site:worldwide.espacenet.com "synthetic initialization vector" authenticated encryption
site:ppubs.uspto.gov "deterministic authenticated encryption"
site:patents.google.com/patent "nonce misuse resistant" authenticated encryption
site:patents.google.com/patent/US10862670B2 nonce misuse resistant authenticated encryption
site:patents.google.com/patent/US11838424B2 initialization vector misuse resistance authenticated encryption
site:patents.google.com/patent/US10009171B2 variable-input-length tweakable ciphers
site:patents.google.com/patent "synthetic initialization vector" authenticated encryption
```

Direct record inspection then followed the family links, citations, claims, classifications, and related-publication tables for the five patent leads listed above.

## Reproducibility hashes for retrieved public artifacts

SHA-256 values below are over the exact byte streams retrieved on 2026-08-06 UTC.

| Artifact | SHA-256 |
|---|---|
| RFC 5297 text | `498a200ee427a67b27d643b3837ac04b1122755d2337b3cbe68de9c52e86a8cd` |
| RFC 8452 text | `ca48ec466b401ce5d68d6d1628127a1800adcc16f2573646aaa3d7df284d3c17` |
| RFC 9771 text | `dd872cf059d2ee20b0e42e18c19688e6ae33cedf8201ce489c8b05eefac57b27` |
| CAESAR submissions HTML | `2c1f3877634934cd6c648e4d7eac11a8f46a4eef1a2526e329077fe738ffc23d` |
| CAESAR features HTML | `fc596a22add625e5cd4fa4a72b045cdd96982b308ec01b0f567591ed6d63d31e` |
| HS1-SIV v2 corrected PDF | `ee1c8b286b52317f3bbf7d7fba4648060b0bb6bde2e703b49186abf31172fe1a` |
| COLM v1 PDF | `c220296294994471bbad200807475e11918850b2de3ab6efa1697125dccb6834` |
| AEZ v5 PDF | `f4bcb38a88b023b0a9d8367c1283173f4449d80484d5c467ce140c8bb7628c1f` |
| Deoxys v1.41 PDF | `7eb93c21f3516924d0bc4d15fa8a35b408d6ea727d63cd6da942917a92f8c54f` |
| NORX v3.0 PDF | `64fcf26821accd2680141ad80c0b46787e48fbd7cc40cea7ae843eecb87096ef` |
| Romulus final specification PDF | `358113f30554ca19bfdb37e02e2f7459934b6bee0620c7e8707fb3efa699954f` |
| NISTIR 8454 PDF | `0f89ee7b08f4670042a3f558fb911230af1f24fc0932fe3604cf2150a00db5eb` |

The IACR ePrint metadata and document bodies were inspected through the browser retrieval path. Independent command-line PDF retrieval returned HTTP 403 from Cloudflare, so no PDF-byte hashes are claimed for those entries. The failed retrievals were not recorded as empty-file hashes.

## Scope limits and confidence calibration

This is a broad, primary-source, architecture-focused search, but it is not a mathematically exhaustive search of all possible constructions or a complete archive audit. Specifically:

- Every historical revision, cited paper, dissertation, and failed candidate in CAESAR/NIST was not read line by line.
- The search did not produce a complete machine-exported IACR bibliography or all-language dissertation corpus.
- WIPO, EPO, and USPTO native full-text/claim result sets were not successfully exported; search-engine indexing can miss records and families.
- No patent legal opinion or live-status verification was performed.
- No independent proof, cryptanalysis, performance implementation, or benchmark was attempted for A/B/C; the result is architectural canonicalization against frozen exclusions.

Confidence is nevertheless **very high** on propositions 1 and 2 because they follow directly from definitions and explicit dependency graphs. Confidence is **high** that no admissible architecture exists in the inspected corpus because every close primary source lands in a named exclusion and the remaining causal carriers were audited explicitly. Confidence is only **moderate** on complete-publication and patent recall, so this report makes no absolute novelty or FTO claim.

## Final gate decision

**NO-GO / BLOCKED.** Keep the frozen requirements and exclusions unchanged. Do not advance A, B, or C, and do not make a provisional novelty claim. Under the literal requirements, EC1 is internally empty because it simultaneously requires and excludes DAE/MRAE. Under the narrower structural reading, the independent primary-source search still found no candidate or loophole that survives canonicalization.
