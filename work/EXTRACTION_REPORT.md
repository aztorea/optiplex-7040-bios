# Dell OptiPlex 7040 BIOS 1.24.0 — Deconstruction Report

> Generated: 2026-10-15
> Goal: deconstruct `OptiPlex_7040_1.24.0.exe` into an editable format (raw System BIOS `.bin` + unpacked UEFI module tree) for offline analysis/editing.
> Original file was **never modified**. No reflashing performed.

---

## 1. Source & integrity

| Item | Value |
|---|---|
| Source file | `OptiPlex_7040_1.24.0.exe` |
| Size | 12,980,352 bytes |
| Format | PE32 (i386) Dell PFS BIOS update executable |
| **SHA256** | `C1B7E6E5EDCA9FE4939F083C7745F7726E7B343FCAEF36EFB4A316F656709F4A` |
| **MD5** | `3E7B777FAA5AE066ED536EDE9FA73F94` |

Hash of the original EXE was re-verified **after** all work and is unchanged.

---

## 2. Tool versions used

| Tool | Version | Source |
|---|---|---|
| BIOSUtilities (`dell_pfs_extract` via `main.py`) | Dell PFS Update Extractor v25.07.01 | platomav/BIOSUtilities |
| ME Analyzer (`MEA.py`) | v1.312.0 r378 | platomav/MEAnalyzer |
| UEFIExtract NE | A75 | LongSoft |
| UEFITool NE | A75 | LongSoft |
| IFRExtractor RS | v1.6.1 | LongSoft |
| 7-Zip | 26.01 (x64) | `C:\Program Files\7-Zip\7z.exe` |
| Python (embedded) | 3.11.9 | `python_embeded\python.exe` |

Python packages installed into the embedded interpreter: `pefile`, `dissect.util`, `crccheck` 1.3.1, `pltable` 1.1.0, `colorama` 0.4.6.

---

## 3. Layer 1 — PFS unwrap (from the EXE)

Command (workdir `tools\BIOSUtilities`, 7-Zip on `PATH`):

```powershell
python_embeded\python.exe main.py work\OptiPlex_7040_1_24_0.exe -o work -e
```

Output folder: `work\OptiPlex_7040_1_24_0.exe_extracted\Firmware\`

| # | Component | Size (bytes) | SHA256 |
|---|---|---|---|
| 1 | **System BIOS with BIOS Guard v1.24.0.bin** | 9,437,184 | `505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E` |
| 2 | Gigabit Ethernet v0.8.bin | 8,192 | `774F205C6DC665DDE1D885F54E8A14A83096E62CADD94402AF14D95CBA111C69` |
| 3 | Intel Management Engine (VPro) Update v11.8.92.4222.bin | 7,348,224 | `3714971E3B83CE679D63A8B394202759937E3514A1B2F89C538E44907406EED1` |
| 4 | System Map v1.0.1.bin | 112 | `2EAEBB5F957FA394D368A48D077D16FE01C9369E023062782B43C5E8C3682A46` |
| 5 | PCR0 XML v0.0.0.1.xml | 2,396 | — |
| 6 | Model Information v1.0.0.0.txt | 85 | — |

Model info (section 6): `VendorName=Dell Inc.`, `SystemName=OptiPlex 7040`, `Version=1.24.0`, `Model=6b9`.

The main BIOS region was copied to `work\bios\System_BIOS.bin`:

| Item | Value |
|---|---|
| Path | `work\bios\System_BIOS.bin` |
| Size | 9,437,184 bytes (0x900000) |
| SHA256 | `505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E` |
| MD5 | `DB725CFC8B3D8AF3456795CB49968A3D` |

---

## 4. Component identification

### 4.1 Intel Management Engine (CSME)

ME Analyzer on section 3:

| Field | Value |
|---|---|
| Family | CSE ME |
| Version | 11.8.92.4222 |
| Release | Production |
| Type | Stock (update image) |
| SKU | Corporate H (vPro) |
| Chipset | KBP/BSF/GCF-H A, SPT-H D (100-series) |
| TCB SVN | 3 |
| Version Control Number | 331 |
| Production Ready | Yes |
| Date | 2022-02-07 |
| File System State | Unconfigured |
| Size | 0x702000 |

### 4.2 UEFI System BIOS fingerprint

| Field | Value |
|---|---|
| Vendor / base | Dell Inc. / AMI Aptio V |
| Platform | Intel Skylake (Dell OptiPlex 7040, Q170 / SPT-H PCH) |
| Image type | UEFI image, base address `0xFF700000`, size 0x900000 (9 MiB) |
| Firmware volumes | 8 |
| FFS files | 581 |
| PE32 image sections | 505 |
| DXE drivers / DXE core | 288 / 1 |
| PEI modules / PEI core | 81 / 1 |
| NVAR entries | 33 (incl. `Setup`, `StdDefaults`, `AMITSESetup`) |

**Boot Guard** is enabled (Intel). FIT table findings:

| Finding | Detail |
|---|---|
| Microcode | CPUID `0x506E3` (Skylake), revision `0xF0`, date 2021-11-12 |
| Startup ACM | SVN 2, date 2015-06-24 |
| Key Manifest (KM) | base `0x879100`, KM SVN 0, KM ID 0xF (KeyId 1, RSA-2048) |
| Boot Policy Manifest (BPM) | base `0x878080`, BPSVN 0, ACM SVN 2 |
| IBB segments | `FFE00000h+0x170000`, `FFF78000h+0x80`, `FFF79080h+0x80`, `FFF7A100h+0x85F00` |
| AMI v2 protected ranges | hash file present; protected range `FF7E0000h + 0x382C00h` |

### 4.3 Firmware volume map (top-level)

| Vol # | Volume GUID | Offset | Size |
|---|---|---|---|
| 0 | `8C8CE578-8A3D-4F1C-9935-896185C32DD3` | 0x000000 | 0x040000 |
| 1 | `8C8CE578-8A3D-4F1C-9935-896185C32DD3` | 0x040000 | 0x040000 |
| 2 | `8C8CE578-8A3D-4F1C-9935-896185C32DD3` | 0x080000 | 0x010000 |
| 3 | `E34AEDB0-BB97-49BC-B139-1E419B3560E2` | 0x090000 | 0x040000 |
| 4 | `FD44D4FE-239B-4C57-B96D-E47E066A50A3` | 0x0D0000 | 0x010000 |
| 5 | `4F1C52D3-D824-4D2A-A2F0-EC40C23C5916` | 0x0E0000 | 0x5A0000 |
| 6 | `AFDD39F1-19D7-4501-A730-CE5A27E1154B` | 0x680000 | 0x080000 |
| 7 | `61C0F511-A691-4F54-974F-B9A42172CE53` | 0x700000 | 0x200000 |

- Volume 0 holds the NVRAM store (`CEF5B9A3-...`) with the `Setup` default variable set.
- Volume 5 (5.6 MiB) is the main DXE volume; it contains two compressed nested FFS volumes:
  - `5C60F367-A505-419A-859E-2A4FF6CA6FE5` — the primary DXE driver volume (Setup, AMITSE, etc.).
  - `BDB6C5ED-6BF3-4909-837C-353F6DCBB6A2`.
- Volume 7 contains `PEI core` (`52C05B14-0B98-496C-BC3B-04B50211D680`) and the `Volume Top File` / `SEC core` (`1BA0062E-C779-4582-8566-336AE8F78F09`).

---

## 5. Layer 2 — UEFI module tree

Bulk unpack:

```powershell
tools\UEFIExtract\UEFIExtract.exe work\bios\System_BIOS.bin all
```

Outputs:

| Artifact | Path |
|---|---|
| Module tree (~6,973 files) | `work\bios\System_BIOS.bin.dump\` |
| Human-readable tree/report | `work\bios\System_BIOS.bin.report.txt` |
| GUID name mapping | `work\bios\System_BIOS.bin.guids.csv` |

### 5.1 Key modules for editing

| Module | GUID | Role |
|---|---|---|
| **Setup** | `899407D7-99FE-43D8-9A21-79EC328CAC21` | BIOS Setup driver; owns the Setup HII form set |
| AMITSE | `B1DA0ADF-4F77-4070-A88E-BFFE1C60529A` | AMI Setup Engine (hidden/advanced forms) |
| AMITSESetupData | `FE612B72-203C-47B1-8560-A66D946EB371` | AMITSE data/defaults |
| AMI v2 protected ranges hash | `CBC91F44-A4BC-4A5B-8696-703451D0B053` | Boot Guard IBB hash reference |
| NVRAM external defaults | `77D3DC50-D42B-4916-AC80-8F469035D150`, `9221315B-30BB-46B5-813E-1B1BF4712BD3` | Default variable sets |
| DXE core | `D6A2CB7F-6A18-4E2F-B43B-9920A733700A` | DXE dispatcher |
| PEI core | `52C05B14-0B98-496C-BC3B-04B50211D680` | PEI dispatcher |
| SEC core / Volume Top File | `1BA0062E-C779-4582-8566-336AE8F78F09` | Reset vector |

Setup module location inside the tree:

```
work\bios\System_BIOS.bin.dump\
  5 4F1C52D3-D824-4D2A-A2F0-EC40C23C5916\
    2 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\
      0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\
        1 Volume image section\
          0 5C60F367-A505-419A-859E-2A4FF6CA6FE5\
            70 899407D7-99FE-43D8-9A21-79EC328CAC21\   <- Setup module
```

### 5.2 Setup IFR (human-readable BIOS options)

The Setup HII form/string packages live inside the Setup module `body.bin`
(form pkg #0: 0x229B5 bytes, 3886 used strings; string pkg #0: en-US, 5481 strings).

Extract:

```powershell
tools\IFRExtractor\ifrextractor.exe "<...\70 899407D7-...\body.bin>"
```

> Note: IFRExtractor **writes its output to a file next to the input**
> (`<input>.0.0.en-US.uefi.ifr.txt`), not to stdout.

Result copied to:

| Artifact | Path | Size |
|---|---|---|
| Setup IFR dump | `work\bios\setup_ifr.txt` | 1,251,181 bytes (21,313 lines) |

Header of the dump:

```
Program version: 1.6.1, Extraction mode: UEFI, SHA256: 2197134d...
FormSet Guid: 7B59104A-C00D-4158-87FF-F04D6396A915, Title: "Setup", Help: "Setup"
  VarStore ... EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9, VarStoreId: 0x1, Size: 0x1340, Name: "Setup"
  Form FormId: 0x2710, Title: "Setup"
```

The persistent Setup variable store (`Setup`, GUID `EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9`, size 0x1340 = 4,928 bytes) is the NVRAM image of BIOS settings.

---

## 6. Editing entry points (analysis-oriented)

1. **BIOS option definitions / defaults** — `work\bios\setup_ifr.txt` (form IDs, varstore offsets, option values).
2. **NVRAM Setup defaults** — NVAR `Setup` entry (`EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9`, 0x1351 bytes) in volumes 0 and 4.
3. **Individual UEFI modules** — PE32 drivers (`.ffs`/`.pe32`) under `System_BIOS.bin.dump\` can be edited and re-inserted with UEFITool.
4. **Microcode** — via the FIT table region (CPUID 0x506E3).
5. **Nested DXE volume** — the decompressed volume image body (`...\1 Volume image section\body.bin`) can be recompressed and patched back.

---

## 7. Risks / caveats

- **Signatures:** The PFS container and BIOS image are RSA-signed; Boot Guard is enabled. Any modification will fail the official flasher's signature check. Reflashing a modified image would require an SPI dump plus a hardware programmer or Intel FPT (out of scope).
- **Boot Guard:** With Boot Guard active, arbitrary modification of the IBB (initial boot block) will not boot on real hardware; analysis-only edits are safe.
- The original `OptiPlex_7040_1.24.0.exe` was never modified (hash re-verified).

---

## 8. Artifact index

```
work\
├─ OptiPlex_7040_1_24_0.exe                     # dot-stripped copy (hash = original)
├─ OptiPlex_7040_1_24_0.exe_extracted\Firmware\ # PFS sections (6 components)
├─ EXTRACTION_REPORT.md                          # this file
├─ logs\                                         # evidence bundle
│  ├─ session_log.md                             # chronological account of all work
│  ├─ environment.txt                            # tool versions + git commits
│  ├─ hashes.txt                                 # SHA256/MD5 of all artifacts
│  ├─ dump_manifest.txt                          # per-file hash manifest (6,973 files)
│  ├─ pfs_extract_output.txt                     # raw BIOSUtilities console output
│  ├─ me_analyzer_output.txt                     # raw ME Analyzer output
│  └─ uefiextract_fit_bootguard.txt              # raw FIT / Boot Guard output
└─ bios\
   ├─ System_BIOS.bin                            # raw 9 MiB BIOS region
   ├─ System_BIOS.bin.dump\                      # unpacked UEFI module tree (~6,973 files)
   ├─ System_BIOS.bin.report.txt                 # UEFITool tree report
   ├─ System_BIOS.bin.guids.csv                  # GUID → name mapping
   └─ setup_ifr.txt                              # human-readable Setup IFR
```

### 8.1 Reproducibility / audit trail

- `work\logs\session_log.md` — every command and result, in order, including the
  diagnostic dead-ends (IFRExtractor output-file behavior, MEA dependencies).
- `work\logs\hashes.txt` — integrity of every produced artifact.
- `work\logs\dump_manifest.txt` — SHA256 + size for all 6,973 files in the UEFI dump,
  so the unpacked tree can be verified or reconstructed bit-exactly.
- `work\logs\environment.txt` — exact tool versions and git commits used.
