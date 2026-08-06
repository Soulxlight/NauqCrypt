---
search: B
result: NO-ADMISSIBLE-SURVIVOR
gate_effect: BLOCKED
requirements_digest: a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828
searched_utc: 2026-08-06
---

# Search B — Canonical Dependency-Graph Prior-Art Report

## 1. Decision

**No known construction class located in this search escapes the frozen
originality exclusions while also meeting the EC1 functional and security
contract. Search B therefore does not support a provisional architecture
pass.**

This is not a finding of exhaustive novelty. It is a false-negative-oriented
search of the sources and query forms recorded below. The strongest result is
negative and structural:

1. equality-only leakage under arbitrary nonce repetition is the established
   MRAE/DAE interface;
2. the two-pass realizations found reduce to a transcript-derived public
   selector, a feedback/evolving-state mode, or a variable-input-length
   enciphering of plaintext plus redundancy; and
3. those are precisely frozen excluded families.

The permitted positive statement from `REQUIREMENTS.md` is not applicable to
the three sealed candidates: architecture-equivalent prior art *was* located.
No essential invariant survived canonicalization to support a new formal claim
or measured advantage, as required by `docs/PRIOR_ART_PROTOCOL.md`.

This report is a technical prior-art screen, not a legal opinion, patentability
search, claim construction, or freedom-to-operate analysis.

## 2. Frozen inputs and integrity

Search B read the frozen requirements, the prior-art protocol, and all three
sealed architecture reports before searching. None was edited.

| Artifact | SHA-256 |
| --- | --- |
| `REQUIREMENTS.md` | `a4a1f6e9f2f0d8d621146847bba0bcc6d942a323e43df517a2e220912b9bd828` |
| `docs/PRIOR_ART_PROTOCOL.md` | `72bd201b652b5a6c406a919795077296c95abeec50a97fa8b4d654a7d42c2f16` |
| `research/architectures/A.md` | `1d6b5c73881130702c37b225737fed7be5b268dbb7d842dfddd01e087449a852` |
| `research/architectures/B.md` | `b5f91c5c44ffeac180e11443f4a7db876676e66f8b975076579437455cd9a578` |
| `research/architectures/C.md` | `54bbe8f7272507d7ba4597e67eecb2794750d387102eb372af3ad16dd01b53d7` |

The controlling target was not weakened: deterministic two-pass AEAD; 256-bit
key; 192-bit nonce; 256-bit untruncated tag; ciphertext exactly plaintext
length; public domain and AAD; equality-only leakage for repeated nonces; at
least 128-bit concrete confidentiality, authenticity, multi-user, and CMT-1
security; 256-bit classical key-search target; constant-time normative
software; and at most 2 KiB working state excluding caller-owned
input/output/quarantine.

## 3. Search-B method

This search deliberately differed from a name- or citation-led Search A. It
first erased candidate vocabulary and reduced the sealed reports to causal
graphs. It then searched for pass order, state lifetime, data dependency,
output timing, and verification relation. Candidate names were used only after
a graph hit was identified, to inspect its primary specification and citation
neighborhood.

### 3.1 Canonical graphs searched

**Graph A — boundary-coupled bidirectional feedback**

```text
frame(D,N,A,len) -> boundary state
P || redundancy -> forward recurrence -> backward recurrence -> C || tag
```

Search abstractions: forward/backward passes, bidirectional diffusion,
combined feedback, rekeying feedback, whole-message dependency, and
redundancy checked after inversion.

**Graph B — transcript seed / synthetic selector**

```text
frame(D,N,A,len) || P -> fixed transcript value S
S -> second-pass masks/stream/selector -> C
S or f(S,C) -> tag
```

Search abstractions: synthetic IV/tag/seed, protected IV, SIV-like MAC/hash
then encryption, transcript-derived counter origin, and a first-pass global
value controlling a second pass.

**Graph C — global mixing between local permutations**

```text
P || redundancy -> local keyed maps -> global linear mixing
                 -> local keyed maps -> C || tag
```

Search abstractions: encrypt-mix-encrypt, local/global/local networks,
wide-domain enciphering, redundancy encryption, pad/encode then encipher, and
variable-input-length permutations.

### 3.2 Decision rule

A hit was treated as a possible escape only if its canonical dependency graph
could simultaneously provide:

- the exact deterministic, length-preserving-plus-256-bit-tag interface;
- equality-only leakage for arbitrary reuse of the complete public header;
- no more than two complete data passes and 2 KiB non-caller state;
- the frozen concrete and key-commitment targets; and
- no reduction to any excluded architecture or wrapper.

Parameter changes, renaming a tag as an IV, hiding a selector in another
output field, or assuming a variable-length pseudorandom injection were not
counted as architectural escapes.

## 4. Corpus accounting

### 4.1 NIST Lightweight Cryptography

Primary index: [NIST Round 1 Candidates](https://csrc.nist.gov/projects/lightweight-cryptography/round-1-candidates).
Primary archive: [all Round 1 submission files](https://csrc.nist.gov/CSRC/media/Projects/Lightweight-Cryptography/documents/round-1/submissions/all-lwc-submission-files.zip).

- The NIST page records 57 submissions received and 56 accepted Round 1
  candidates. The archive contained 56 candidate directories.
- Archive SHA-256:
  `71c58dfadcdd6fefc9be31e2bd4d2096663f1f2ae76ab4d45150a79291f2e5ed`.
- Ninety-nine PDF specification/coversheet artifacts were converted to text.
  All 56 candidate directories were machine-searched using the dependency
  expressions in Section 9. High-risk hits were manually inspected in their
  full specifications. This does **not** mean every one of the 99 PDFs received
  a page-by-page human review.
- Candidate directories covered:
  ACE, ASCON, Bleep64, CiliPadi, CLÆ, CLX, COMET, DryGASCON, Elephant,
  ESTATE, FlexAEAD, ForkAE, Fountain, GAGE/INGAGE, GIFT-COFB, Gimli,
  Grain-128AEAD, HER(N)/HERON, HYENA, ISAP, KNOT, LAEM, Lilliput-AE,
  Limdolen, LOTUS/LOCUS, mixFeed, ORANGE, Oribatida, PHOTON-Beetle,
  Pyjamask, Qameleon, Quartet, REMUS, Romulus, SAEAES, SATURNIN,
  Shamash/Shamashash, SIMPLE, SIV-Rijndael256, SIV-TEM-PHOTON, SKINNY,
  SNEIK, SPARKLE, SPIX, SpoC, Spook, Subterranean, SUNDAE-GIFT, Sycon,
  TGIF, TinyJAMBU, Triad, TRIFLE, WAGE, Xoodyak, and Yarará/Coral.

The decisive full-MRAE hits were ESTATE, SUNDAE-GIFT,
SIV-Rijndael256, SIV-TEM-PHOTON, Lilliput-II, Romulus-M, REMUS-M,
TGIF-M, and TRIFLE. They identify themselves as SIV, SCT, deterministic
AE, or tweakable-block-cipher constructions. Spook targets misuse
*resilience*, not equality-only full MRAE. TinyJAMBU and CLX retain limited
security but do not hide unequal messages under repeated nonces. Remaining
hits were nonce-respecting, sponge/duplex, feedback, offset/TBC, or otherwise
outside the frozen contract.

### 4.2 CAESAR

Primary index: [CAESAR submissions and revisions](https://competitions.cr.yp.to/caesar-submissions.html).

- The saved index HTML had SHA-256
  `2c1f3877634934cd6c648e4d7eac11a8f46a4eef1a2526e329077fe738ffc23d`.
- All 132 PDF links enumerated from that saved page were downloaded and
  converted to text. All 132 were machine-searched; full-document human
  inspection was limited to structural hits and their relevant revisions.
- This accounts for PDF artifacts linked by the public index, not every source
  file, mailing-list item, withdrawal note, security analysis, or unlinked
  historical artifact that may ever have existed.

The closest hits were:

- [AEZ v5](https://competitions.cr.yp.to/round3/aezv5.pdf): explicitly obtains
  robust AE from enciphering by generic encode-then-encipher of message plus
  redundancy.
- [Deoxys v1.41](https://competitions.cr.yp.to/round3/deoxysv141.pdf): full
  MRAE through Synthetic Counter in Tweak and a tweakable block cipher.
- [HS1-SIV](https://competitions.cr.yp.to/round2/hs1sivv2c.pdf): explicit
  synthetic-IV construction.
- [AES-COPA](https://competitions.cr.yp.to/round2/aescopav2.pdf),
  [ELmD](https://competitions.cr.yp.to/round2/elmdv21.pdf), and
  [COLM](https://competitions.cr.yp.to/round3/colmv1.pdf):
  Encrypt–Linear-Mix–Encrypt relatives. Their online security exposes a
  common-prefix relation under nonce reuse, so they fail equality-only leakage
  even before applying the frozen EME/offset exclusions.
- [POET](https://competitions.cr.yp.to/round2/poetv20.pdf): online privacy and
  full integrity, but longest-common-prefix leakage.
- AES-CMCC, Joltik, KIASU, and McOE-family material canonicalized to
  combined feedback, checksum/offset, or tweakable-codebook modes.
- TriviA-ck's claimed misuse condition requires distinct `(nonce,AAD)` pairs;
  it is not the frozen same-header/different-plaintext MRAE game.

### 4.3 IACR, ToSC, FSE, CHES/TCHES, and related primary literature

The following primary documents were inspected because they matched a graph,
not merely a candidate name:

| Source | Canonical finding | Frozen result |
| --- | --- | --- |
| [ELmE](https://eprint.iacr.org/2013/767.pdf) | Encrypt–Linear-mix–Encrypt, two local encryption layers around a linear mixer | Graph C; only online/common-prefix privacy under reuse; EME family excluded |
| [AEZ / Robust AE](https://eprint.iacr.org/2014/793.pdf) | two-pass robust AE by encode-then-encipher | Graph C; wide-block/encode-then-encipher excluded |
| [Synthetic Counter in Tweak](https://eprint.iacr.org/2015/1049.pdf) | SIV-like authentication value used in a counter-like TBC layer | Graph B; SIV and TBC excluded |
| [RIV](https://iacr.org/archive/fse2016/97830021/97830021.pdf) | robust two-pass AE in the established robust/SIV design neighborhood | no independent escape from Graph B |
| [FEMALE](https://eprint.iacr.org/2018/484.pdf) | rekeying ciphertext-feedback pre-encryption, then one-time encryption and authentication | Graph A; feedback/rekeying excluded; output is `(V,c,T)`, adding a second public expansion field |
| [Xoodoo/Farfalle cookbook](https://eprint.iacr.org/2018/767.pdf) | Xoofff-WBC-AE and Farfalle/deck variants | Graph C; Farfalle/deck and wide-block excluded |
| [TES from public permutations](https://eprint.iacr.org/2021/128.pdf) | tweakable enciphering schemes; surveys CMC, EME, FMix, AEZ, XCB, HCTR, HCH | Graph C; wide-block/TES excluded |
| [Masked Iterate-Fork-Iterate](https://eprint.iacr.org/2022/1534.pdf) | SAFE/ZAFE deterministic AE from TPRF/TBC components | DAE/TBC/expanding-PRF family excluded |
| [Encrypting Farfalle nonce and redundancy](https://eprint.iacr.org/2022/1711.pdf) | redundancy-encrypting Farfalle/wide-block construction | Graph C; Farfalle/deck/wide-block excluded |
| [GLEVIAN and VIGORNIAN](https://eprint.iacr.org/2023/1379.pdf) | MRAE; first derives `I` from `(A,M)`, uses `I` for CTR, and authenticates `(A,C,I)`; proof stack explicitly uses PTE1 over PIV wide-block enciphering and nonce-derived keys | Graphs B/C; SIV-like selector, CTR+authenticator, wide-block PTE, and nonce-derived-key wrapper are all excluded |
| [Mystrium](https://eprint.iacr.org/2024/1474) | deck-function wide-block encryption | Graph C; deck/wide-block excluded |
| [XCB analysis](https://eprint.iacr.org/2024/1527.pdf) | XCB/HCTR/HCH wide-block neighborhood and structural attacks | Graph C; wide-block excluded and no positive EC1 invariant |
| [ChaCha20-Poly1305-PSIV notice](https://www.iacr.org/news/item/24995) | explicit NSIV/PSIV misuse-resistant and key-committing transform | Graph B and wrapper; synthetic-selector and commitment-wrapper exclusions |

The CHES/FSE terminology search was especially useful for avoiding a false
negative: FEMALE is not named SIV and is designed for physical leakage, yet its
own specification names a rekeying ciphertext-feedback stage and transmits
`(V,c,T)`. It is therefore neither an architectural escape nor an exact EC1
wire match.

The newer GLEVIAN/VIGORNIAN designs were also treated as high-risk potential
escapes because they provide strong MRAE, two passes, length-preserving
ciphertext, and a separate tag. Their primary paper resolves the ambiguity:
Sections 3–4 explicitly build the DAE layer using Pad-then-Encrypt PTE1,
Protected IV, a wide-tweak wide-block cipher, CTR, and nonce-based key
derivation. That is a direct intersection of several frozen exclusions.

### 4.4 RFC and CFRG material

- [RFC 5297](https://www.rfc-editor.org/rfc/rfc5297.html) defines SIV as DAE
  and misuse-resistant nonce-based AE, with S2V followed by CTR.
- [RFC 8452](https://www.rfc-editor.org/rfc/rfc8452.html) states that repeated
  nonces reveal only whether messages are equal and that encryption is
  necessarily two-pass; its concrete mechanism is POLYVAL-derived synthetic
  IV followed by CTR.
- [RFC 9771](https://www.rfc-editor.org/rfc/rfc9771.html) records the current
  AEAD-property taxonomy, including MRAE examples and CMT-1 commitment as a
  distinct property/transform concern.
- The [CFRG document index](https://datatracker.ietf.org/rg/cfrg/documents/)
  and exact queries in Section 9 produced SIV, GCM-SIV, PSIV/NSIV, and generic
  commitment material, but no fourth dependency class.

### 4.5 Dissertations

The dissertation pass was used to catch older vocabulary, taxonomy, and
construction families that submission specifications may not name uniformly.

- Damian Vizár, [*Provably Secure Authenticated Encryption*](https://infoscience.epfl.ch/record/256677/files/EPFL_TH8681.pdf):
  formalizes MRAE as the random-injection/equality-only target; explains that
  every ciphertext bit must depend on every plaintext bit, ruling out online
  full MRAE; and identifies AEZ and Deoxys-II as the full-MRAE CAESAR examples
  in its final-round accounting.
- Robert Seth Terashima, [*Tweakable Ciphers: Constructions and Applications*](https://pdxscholar.library.pdx.edu/open_access_etds/2484/):
  robust AE through tweakable/wide-domain ciphers, mapping to Graph C.
- [*Misusing Authenticated Encryption Schemes*](https://www.db-thueringen.de/servlets/MCRFileNodeServlet/dbt_derivate_00043056/dissertation_pdfa.pdf):
  nonce/decryption misuse and online-construction taxonomy; online variants
  relax equality-only privacy.
- [*Regarding Assumptions Made of Authenticated Encryption*](https://escholarship.org/uc/item/30p5t984):
  commitment and anonymity properties; the relevant constructions are
  transforms around an AE core, not a new equality-only two-pass core.
- [KAIST ZLR thesis record](https://library.kaist.ac.kr/search/detail/view.do?bibCtrlNo=1032998&flag=dissertation):
  online nonce-misuse resilience/TBC direction; weaker leakage and excluded
  TBC architecture.

## 5. Near-neighbor matrix by essential invariant

| Essential invariant | Closest prior blueprints | Why it does not survive |
| --- | --- | --- |
| Every output block depends on the entire unequal transcript within two passes | FEMALE; POET; McOE; AES-CMCC; bidirectional/combined-feedback constructions | full dependence comes from evolving/rekeying feedback or extra passes/fields; frozen combined-feedback and rekeying exclusions apply |
| Fixed-size value from pass 1 globally controls pass 2 | RFC 5297 SIV; AES-GCM-SIV; HS1-SIV; ESTATE; SUNDAE-GIFT; SIV-Rijndael256; SIV-TEM-PHOTON; SCT/Deoxys; PSIV | exactly a synthetic tag/seed/public selector or TBC variant, both excluded |
| Local keyed maps + global algebraic mixing + local keyed maps | EME/ELmE; COPA/COLM; CMC/FMix; AEZ; XCB/HCTR/HCH | either online common-prefix leakage or a wide-block/TES/encode-then-encipher construction |
| Encrypt plaintext plus checkable redundancy and expose only 256 redundancy bits | AEZ; PTE1/PIV; Simpira robust-AE discussion; Farfalle-WBC; GLEVIAN/VIGORNIAN | canonical encode-then-encipher/wide-block construction, explicitly excluded |
| Strong misuse resistance plus key commitment | RFC 9771 taxonomy; PSIV/NSIV; generic committing-AE transforms | commitment is supplied by a wrapper/transform or a synthetic selector; commitment and framing wrappers are excluded |
| Online or constant-state escape from the above | COLM/COPA/ELmD/POET, Spook, ZLR, misuse-resilient modes | these relax privacy to common-prefix/block leakage or protect only fresh-nonce challenges; fail EC1 requirement 3 |
| New primitive name avoids mode equivalence | ButterKnife/SAFE/ZAFE, Mystrium, deck/TES/RPRP constructions | canonical proof assumes an expanding PRF, TBC, or VIL permutation and then instantiates DAE/wide-block machinery; no new AEAD dependency graph |

**Surviving invariant: none.** The interface itself is the DAE/MRAE random
injection target. With bounded passes and state, every located implementation
route uses a frozen excluded mechanism. Treating the random injection as a new
primitive would assume the security goal rather than construct it.

## 6. Patent screen

### 6.1 Public interfaces attempted

The following public portals were attempted on 2026-08-06:

- [USPTO Patent Public Search](https://ppubs.uspto.gov/pubwebapp/): the public
  page loaded only its JavaScript shell in the available text client.
- [USPTO Patent Center application 17/319732](https://patentcenter.uspto.gov/applications/17319732):
  the application route was reachable but exposed no searchable record text in
  the available client.
- [EPO Espacenet](https://worldwide.espacenet.com/): HTTP 403 from the research
  environment.
- [WIPO PATENTSCOPE](https://patentscope.wipo.int/search/en/search.jsf): HTTP
  403 from the research environment.

The dedicated browser was already controlled by another task, and no in-app
browser surface was attached. The search was therefore **not** completed as a
native fielded search inside those three portals. Exact phrase searches were
run through public web indexing, and an indexed family was traced to its
publication identifiers and official-record links. This is a documented
coverage limitation, not an exhaustive-patent claim.

### 6.2 Located family

The synthetic-selector query located:

- US 2022/0376922 A1, later US 11,838,424 B2;
- PCT publication WO 2022/237440 A1;
- title: *Authenticated encryption apparatus with initialization-vector
  misuse resistance and method therefor*; and
- secondary family locator: [US20220376922A1](https://patents.google.com/patent/US20220376922A1/en)
  and [WO2022237440A1](https://patents.google.com/patent/WO2022237440A1/en).

The claims and description generate a Poly1305 tag from nonce/message/AAD,
encrypt it into a pseudorandom IV, then use that IV for message encryption
(including AES-CTR embodiments). Canonically this is Graph B: MAC/PRF-derived
SIV followed by stream/counter encryption. It is directly excluded and does
not supply an escape. The indexed CPC neighborhood includes `H04L9/32`,
`H04L9/3242`, `H04L9/0637`, and related block-cipher/stream-cipher classes.
No complete CPC classification sweep or forward/backward patent-citation
review was possible through the blocked portals.

No indexed publication specifically matching the bidirectional-feedback or
local/global/local query strings was located. Given the interface limitations,
that observation has **low confidence** and must not be restated as “no such
patent exists.”

### 6.3 Publication-lag caveat

Patent applications are commonly unavailable to public searching until
publication, often about 18 months after the earliest priority date, subject to
jurisdictional rules, non-publication requests, national-security restrictions,
translations, continuations/divisionals, and family timing. Synonyms,
machine-translated claims, assignee changes, and classification drift also
create false negatives. A later professional search must repeat the queries by
claims, family, inventors/assignees, citations, and CPC/IPC classes in each
native portal.

## 7. Frozen-constraint escape audit

| Possible escape | Assessment |
| --- | --- |
| Use a 256-bit tag instead of the common 128-bit tags | changes concrete bounds and wire size, not the dependency graph; no architectural escape |
| Use a 256-bit key or 192-bit nonce | parameterization only; most found modes can be widened or re-keyed without becoming original |
| Fold SIV/selector into the 256-bit tag | still a message-derived public selector; name/location is immaterial |
| Use a secret, non-transmitted transcript seed | decryption must recover it from ciphertext, forcing a reversible whole-message network or a second transmitted field; returns to Graph A/C or violates the wire contract |
| Use an online mode to meet 2 KiB state | online encryption reveals at least common-prefix timing/content relations for unequal same-header messages; fails equality-only leakage |
| Store the whole message in caller memory | may satisfy the state accounting, but does not change SIV/wide-block/feedback canonicalization |
| Add a CMT-1 transform | frozen contract excludes commitment/rekeying/framing wrappers; known transforms do not create a new MRAE core |
| Define a variable-length pseudorandom injection primitive | tautologically assumes the ideal DAE object; known realizations are VIL/wide-block enciphering |
| Randomize or keep hidden cross-message state | violates deterministic output or changes the frozen nonce/API semantics |

## 8. Confidence and limits

| Area | Confidence | Basis / limit |
| --- | --- | --- |
| Canonical equivalence of sealed A/B/C | High | all three reports self-identify the same excluded normal forms; multiple independent primary sources use the same proof/dependency taxonomy |
| NIST LWC accepted-candidate false-negative risk | High for the 56 accepted Round 1 directories | official archive, 99 PDFs converted, all specs machine-searched, manual review of structural hits; not every page manually read |
| CAESAR false-negative risk | Medium-high for the 132 PDFs linked by the saved public index | every linked PDF converted and searched; unlinked/withdrawn/supporting artifacts and all citation chains not exhausted |
| IACR/ToSC/FSE/CHES literature | Medium-high for named graph families | primary papers and dissertations inspected; search-engine robots and inconsistent indexing prevent a complete proceedings census |
| CFRG/RFC | High for published RFC taxonomy, medium for drafts | official RFCs and document index searched; expired/unindexed drafts may be missed |
| Patents | Low | native USPTO/EPO/WIPO fielded interfaces were unavailable; one family was located through indexing; CPC/citation/family sweep incomplete; publication lag applies |
| Absolute novelty / freedom to operate | None claimed | outside this protocol and unsupported by the evidence |

Corpus-specific limitations:

- IACR ePrint, IACR archive, and ToSC search endpoints intermittently returned
  robots exclusions. Direct primary PDFs or author/institutional copies were
  used when reachable; otherwise the result was not counted as full-document
  review.
- PDF text extraction can miss diagrams, vector text, ligatures, and scanned
  pages. High-risk hits were checked against surrounding sections and figures,
  but no OCR-completeness claim is made.
- NIST's archive covers the 56 accepted Round 1 candidates, not the unaccepted
  57th submission or every IP/security-comment artifact.
- Dissertation repository indexing is uneven; the named records are a
  targeted sample, not a global thesis census.
- Backward and forward citations were followed selectively around high-risk
  graph hits, not exhaustively for every corpus item.

## 9. Exact query ledger

All searches below were run on **2026-08-06 UTC**. Quoted strings are exact.
`site:` queries used public web indexing; a result was not treated as primary
evidence until its specification, paper, RFC, dissertation record, or patent
publication was inspected.

### 9.1 Corpus-location queries

1. `site:competitions.cr.yp.to/caesar-submissions.html CAESAR submissions authenticated encryption`
2. `site:csrc.nist.gov projects lightweight-cryptography round 1 candidates submissions`
3. `site:eprint.iacr.org deterministic authenticated encryption misuse resistant two pass`
4. `site:rfc-editor.org authenticated encryption synthetic IV deterministic nonce misuse resistant`

### 9.2 Dependency-graph queries

5. `site:eprint.iacr.org authenticated encryption "forward" "backward" pass ciphertext tag`
6. `site:eprint.iacr.org authenticated encryption "linear mixing" "two layers" encryption`
7. `site:eprint.iacr.org authenticated encryption redundancy "wide block" enciphering`
8. `site:eprint.iacr.org authenticated encryption "first pass" "second pass" plaintext`

### 9.3 ToSC/FSE and older-construction queries

9. `site:tosc.iacr.org deterministic authenticated encryption SUNDAE`
10. `site:tosc.iacr.org authenticated encryption "linear mixing" nonce misuse`
11. `site:iacr.org/archive/fse2009 deterministic authenticated encryption HBS`
12. `site:iacr.org/archive/fse2005 "Two-Pass Authenticated Encryption Faster Than Generic Composition"`
13. `SUNDAE Small universal deterministic authenticated encryption ToSC 2018 3`
14. `SCT nonce misuse resistant authenticated encryption tweakable block cipher paper`
15. `HBS single-key deterministic authenticated encryption PDF Iwata Yasuda`
16. `BTM single-key inverse-cipher-free deterministic authenticated encryption PDF`

### 9.4 Dissertation queries

17. `dissertation authenticated encryption nonce misuse online cipher PDF thesis`
18. `site:repository.ubn.ru.nl thesis wide block cipher authenticated encryption`
19. `site:escholarship.org dissertation deterministic authenticated encryption wide block`
20. `site:etheses.bham.ac.uk authenticated encryption thesis misuse resistant`

### 9.5 CFRG/RFC queries

21. `site:datatracker.ietf.org/doc CFRG authenticated encryption nonce misuse SIV`
22. `site:datatracker.ietf.org/doc "deterministic authenticated encryption"`
23. `site:rfc-editor.org "nonce misuse" authenticated encryption`
24. `site:rfc-editor.org "key commitment" AEAD`

### 9.6 CHES/FSE false-negative queries

25. `site:iacr.org/archive/ches authenticated encryption "nonce misuse" "two pass"`
26. `site:eprint.iacr.org CHES authenticated encryption deterministic two-pass`
27. `site:iacr.org/archive/fse authenticated encryption forward backward two-pass nonce misuse`
28. `site:tosc.iacr.org authenticated encryption "wide block" deterministic`

These queries exposed FEMALE, GLEVIAN/VIGORNIAN, SAFE/ZAFE, and other
non-SIV-named graph neighbors. The official-domain search endpoints reported
robots restrictions for some requests, so the ledger records discovery but not
an exhaustive indexed result count.

### 9.7 Patent-index queries

29. `patent "authenticated encryption" "synthetic IV"`
30. `patent "authenticated encryption" "forward pass" "backward pass"`
31. `patent "authenticated encryption" "encrypt-mix-encrypt" OR "linear mixing"`
32. `patent "wide block" encryption redundancy "encode then encipher"`
33. `US20220376922 USPTO publication authenticated encryption apparatus initialization vector misuse resistance`
34. `WO authenticated encryption apparatus initialization vector misuse resistance Kalach Abbassi Wu`
35. `EP authenticated encryption apparatus initialization vector misuse resistance Kalach`
36. `site:patentscope.wipo.int "authenticated encryption" "synthetic IV"`

The official portal URLs in Section 6 were also opened directly. Because
native fielded searching was blocked, no exact-result-count or exhaustive
claims search is reported.

### 9.8 Local full-text expressions

The downloaded CAESAR and NIST PDF text was searched case-insensitively with
the following expression family (line breaks added here only for readability):

```text
nonce.{0,40}(misuse|reuse)
misuse.{0,40}nonce
synthetic.{0,20}(iv|initialization|vector)
deterministic authenticated
two[- ]pass
encrypt.{0,10}(mix|linear).{0,10}encrypt
wide[- ]block
wide[- ]domain
combined feedback
bidirectional
backward.{0,30}forward
forward.{0,30}backward
full[- ]message
encode-then-encipher
enciphering mode
```

The expression was a triage mechanism, not the decision mechanism. Manual
canonicalization of the hit's algorithm and security claim determined each
row above.

## 10. Bottom line

Search B found more neighbors, not an escape hatch. In particular, newer
designs that at first appear closest to EC1—FEMALE and
GLEVIAN/VIGORNIAN—resolve respectively to excluded rekeying feedback with an
extra output field, and explicit PTE/PIV wide-block plus nonce-derived-key
machinery. The CAESAR and NIST full-MRAE candidates resolve to SIV/SCT/TBC or
wide-block designs. EME-like online modes sacrifice the required equality-only
leakage.

Accordingly, the frozen architecture gate remains **blocked**. The gates must
not be weakened to force a winner.
