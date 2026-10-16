# BIOS Deconstruction — Session Log

> Chronological account of everything performed on 2026-10-15.
> Working dir: `C:\Users\Ghost\Desktop\bestproject`
> Goal: deconstruct `OptiPlex_7040_1.24.0.exe` into an editable format
> (raw System BIOS `.bin` + unpacked UEFI module tree). No reflashing.
> Original EXE never modified.

---

## Phase 4 — 7-Zip availability (was the blocker)

| Step | Command | Result |
|---|---|---|
| Install attempt | `winget install --id 7zip.7zip -e --accept-source-agreements --accept-package-agreements` | Existing package found (26.04 upgrade offered); UAC prompt cancelled → `0x800704c7`. |
| Locate existing | `Test-Path "C:\Program Files\7-Zip\7z.exe"` | FOUND — `7-Zip 26.01 (x64)` |
| Use it | `$env:PATH = "C:\Program Files\7-Zip;$env:PATH"` | 7z resolvable for subsequent runs. |

**Outcome:** blocked step resolved without a new install.

---

## Phase 5 — PFS unwrap (BIOSUtilities)

Run (workdir `tools\BIOSUtilities`):

```powershell
$env:PATH = "C:\Program Files\7-Zip;$env:PATH"
python_embeded\python.exe main.py work\OptiPlex_7040_1_24_0.exe -o work -e
```

Console: `Dell PFS Update Extractor v25.07.01 ... Extracting Dell PFS 1 > OptiPlex_7040_1_24_0 > Firmware`
(raw output: `work\logs\pfs_extract_output.txt`)

Output dir `work\OptiPlex_7040_1_24_0.exe_extracted\Firmware\`:

| # | Component | Size |
|---|---|---|
| 1 | System BIOS with BIOS Guard v1.24.0.bin | 9,437,184 |
| 2 | Gigabit Ethernet v0.8.bin | 8,192 |
| 3 | Intel Management Engine (VPro) Update v11.8.92.4222.bin | 7,348,224 |
| 4 | System Map v1.0.1.bin | 112 |
| 5 | PCR0 XML v0.0.0.1.xml | 2,396 |
| 6 | Model Information v1.0.0.0.txt | 85 |

Model info: `Dell Inc. / OptiPlex 7040 / 1.24.0 / Model=6b9`.

Main BIOS region copied to `work\bios\System_BIOS.bin` (9,437,184 bytes,
SHA256 `505D5F19...B5968E`).

---

## Phase 6 — Component identification

### 6a. ME Analyzer (CSME)

Initial attempts failed:
- `MEA.py -h` → `Dependency "crccheck" is missing!`
- Installed `crccheck` → next error `Dependency "pltable" is missing!`
- Installed `pltable colorama` → OK.
- MEA is interactive; fed a blank line via stdin and used `-exit`:
  `"" | python MEA.py "<...ME...bin>" -exit`
  (the trailing `EOFError: ... Press enter to exit` traceback is harmless).

Result (raw: `work\logs\me_analyzer_output.txt`):

| Field | Value |
|---|---|
| Family | CSE ME |
| Version | 11.8.92.4222 |
| Release | Production |
| Type | Stock |
| SKU | Corporate H |
| Chipset | KBP/BSF/GCF-H A, SPT-H D |
| TCB SVN | 3 |
| VCN | 331 |
| Production Ready | Yes |
| Date | 2022-02-07 |
| File System State | Unconfigured |
| Size | 0x702000 |

### 6b. UEFI fingerprint

From `System_BIOS.bin.dump\info.txt` and the UEFITool report:
Dell / AMI Aptio V, UEFI image base `0xFF700000`, size `0x900000` (9 MiB),
8 firmware volumes, 581 FFS files, 505 PE32 sections.

---

## Phase 7 — UEFI unpack

```powershell
tools\UEFIExtract\UEFIExtract.exe work\bios\System_BIOS.bin all
```

This emits the FIT table + Boot Guard parsing to the console
(raw: `work\logs\uefiextract_fit_bootguard.txt`) and writes:

- `work\bios\System_BIOS.bin.dump\` — full module tree (6,973 files)
- `work\bios\System_BIOS.bin.report.txt` — human-readable tree
- `work\bios\System_BIOS.bin.guids.csv` — GUID → name map

Key findings: microcode CPUID `0x506E3` rev `0xF0` (2021-11-12);
Intel Boot Guard enabled (ACM 2015-06-24; KM @ 0x879100; BPM @ 0x878080);
AMI v2 protected ranges hash present (range FF7E0000h+382C00h).

### 7a. Setup IFR extraction (IFRExtractor)

Diagnostic path (important discovery: IFRExtractor RS writes the result to a
**file next to the input**, and only prints a header to stdout):

1. `ifrextractor "<Setup PE32 body.bin>" all` → stdout only 74 bytes; no match.
2. `ifrextractor "<nested volume body.bin>" list` → found form/string packages,
   but the module boundary was wrong for extraction.
3. Located the Setup module by offset: `info.txt` shows Setup at volume offset
   `0xF2450`, size `0xB6276`; the form package (volume offset `0x11C12C`) falls
   inside it.
4. `ifrextractor list "<...\70 899407D7-...\body.bin>"` →
   `form pkg #0 @ 0x29CC4 len 0x229B5 (3886 strings)`,
   `string pkg #0 @ 0x4C679 len 0x665CB (en-US, 5481 strings)`.
5. Ran `ifrextractor "<...\70 899407D7-...\body.bin>"` → wrote
   `body.bin.0.0.en-US.uefi.ifr.txt` **next to the input**.
6. Copied it to `work\bios\setup_ifr.txt` (1,251,181 bytes, 21,313 lines).
7. Deleted all intermediate `*.ifr.txt` files scattered inside the dump tree.

Setup form set: `7B59104A-C00D-4158-87FF-F04D6396A915` (Title "Setup");
persistent var store `EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9` size `0x1340`.

---

## Phase 8 — Reporting

- Wrote `work\EXTRACTION_REPORT.md` (full technical write-up).
- Updated `TASK_PLAN.md` (progress tracker + command log) to COMPLETE.
- This session also produced the `work\logs\` evidence bundle.

---

## Post-run verification

- Original `OptiPlex_7040_1.24.0.exe` re-hashed after all work:
  SHA256 `C1B7E6E5EDCA9FE4939F083C7745F7726E7B343FCAEF36EFB4A316F656709F4A` (unchanged),
  MD5 `3E7B777FAA5AE066ED536EDE9FA73F94` (unchanged).

---

## Evidence bundle in `work\logs\`

| File | What it is |
|---|---|
| `environment.txt` | Tool versions, git commits, interpreter info |
| `hashes.txt` | SHA256/MD5 of EXE + all PFS sections + key BIOS artifacts |
| `dump_manifest.txt` | SHA256 + size + rel-path for every file in the UEFI dump (6,973) |
| `pfs_extract_output.txt` | Raw BIOSUtilities console output |
| `me_analyzer_output.txt` | Raw ME Analyzer table |
| `uefiextract_fit_bootguard.txt` | Raw FIT / Boot Guard parsing output |
| `session_log.md` | This file |
