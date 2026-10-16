# BIOS Deconstruction — Task Plan & Progress

> Working directory: `C:\Users\Ghost\Desktop\bestproject`
> Last updated: 2026-10-15 (ALL PHASES COMPLETE)
> Owner goal: deconstruct `OptiPlex_7040_1.24.0.exe` into an **editable format**
> (raw System BIOS `.bin` **+** fully unpacked UEFI module tree) for offline analysis/editing.
> **No reflashing** in scope (can be added later).

---

## 0. Key facts

| Item | Value |
|---|---|
| Source file | `C:\Users\Ghost\Desktop\bestproject\OptiPlex_7040_1.24.0.exe` |
| Size | 12,980,352 bytes |
| SHA256 | `C1B7E6E5EDCA9FE4939F083C7745F7726E7B343FCAEF36EFB4A316F656709F4A` |
| MD5 | `3E7B777FAA5AE066ED536EDE9FA73F94` |
| Format | **PE32 (i386) Dell PFS BIOS executable** (wrapper = Dell flasher; payload = PFS container) |
| PFS magics | `PFS.HDR.` at `0x2FA43`, `0x2FA5C`, `0x72FEC` |
| Target machine | Dell OptiPlex 7040 (current BIOS 1.24.0 = latest) |
| Embedded Python | `C:\Users\Ghost\Desktop\bestproject\python_embeded\python.exe` (v3.11.9) |

**What "editable format" means here (two layers):**
1. **PFS layer** → pull the System BIOS region `.bin` out of the `.exe`.
2. **UEFI layer** → unpack that `.bin` into individual firmware volumes / modules (PE32 drivers, Setup/NVRAM, etc.).

---

## 1. Directory layout

```
bestproject\
├─ OptiPlex_7040_1.24.0.exe        # original (NEVER modified)
├─ python_embeded\python.exe        # our Python (3.11.9)
├─ TASK_PLAN.md                     # THIS FILE
├─ SYSTEM_BASELINE.md               # live-machine hardware/OS/security baseline
├─ collect_system_baseline.ps1      # re-runnable baseline collector (read-only)
├─ collect_system_baseline_admin.ps1# elevated collector (TPM/BitLocker/Defender)
├─ work\                            # our extraction sandbox
│  ├─ OptiPlex_7040_1_24_0.exe      # dot-stripped copy (hash verified = original)
│  ├─ ..._extracted\Firmware\       # PFS sections (Phase 5 output)
│  ├─ EXTRACTION_REPORT.md          # final report (Phase 8)
│  ├─ logs\                         # evidence bundle (raw outputs, hashes, manifest)
│  │  ├─ session_log.md             # chronological account of all work
│  │  ├─ environment.txt            # tool versions + git commits
│  │  ├─ hashes.txt                 # SHA256/MD5 of artifacts
│  │  ├─ dump_manifest.txt          # per-file hash manifest of the UEFI dump
│  │  ├─ pfs_extract_output.txt     # raw BIOSUtilities output
│  │  ├─ me_analyzer_output.txt     # raw ME Analyzer output
│  │  ├─ uefiextract_fit_bootguard.txt
│  │  ├─ system_baseline_raw.txt        # raw live-system inventory (non-elevated)
│  │  ├─ system_baseline_admin.txt      # elevated: TPM/BitLocker/Defender/boot
│  │  ├─ system_installed_programs.txt  # 323 installed programs
│  │  └─ system_python_packages.txt     # embedded Python pip freeze
│  └─ bios\                         # raw .bin + unpacked tree (Phases 6-7)
│     ├─ System_BIOS.bin            # raw 9 MiB BIOS region
│     ├─ System_BIOS.bin.dump\      # unpacked UEFI module tree
│     ├─ System_BIOS.bin.report.txt
│     ├─ System_BIOS.bin.guids.csv
│     └─ setup_ifr.txt              # human-readable Setup IFR
└─ tools\
   ├─ BIOSUtilities\                # platomav/BIOSUtilities (dell_pfs_extract etc.)
   ├─ MEAnalyzer\                   # platomav/MEAnalyzer
   ├─ UEFITool\UEFITool.exe         # LongSoft UEFITool NE A75 (GUI/report)
   ├─ UEFIExtract\UEFIExtract.exe   # LongSoft UEFIExtract NE A75 (bulk unpack)
   └─ IFRExtractor\ifrextractor.exe # LongSoft IFRExtractor-RS v1.6.1
```

---

## 2. Progress tracker

| # | Task | Status |
|---|---|---|
| 0 | Prep: copy EXE to `work\`, verify hashes, create dirs | **DONE** |
| 1 | Install BIOSUtilities + MEAnalyzer (git clone) | **DONE** |
| 2 | Install UEFITool / UEFIExtract / IFRExtractor binaries | **DONE** |
| 3 | Install Python deps (pefile, dissect.util) into embedded Python | **DONE** |
| 4 | **Install 7-Zip (`7z`) onto PATH** | **DONE** |
| 5 | Unwrap PFS: run BIOSUtilities on the `.exe` | **DONE** |
| 6 | Identify components (sections, ME Analyzer, fingerprint UEFI) | **DONE** |
| 7 | Unpack UEFI BIOS `.bin` (UEFIExtract tree + UEFITool report + IFRExtract) | **DONE** |
| 8 | Write final `EXTRACTION_REPORT.md` | **DONE** |

---

## 3. RESUME HERE (restart point)

### Status: COMPLETE

The 7-Zip blocker was resolved (7-Zip 26.01 already installed at
`C:\Program Files\7-Zip\7z.exe`; prepended to `PATH` for the BIOSUtilities run).

All phases ran successfully:

- **PFS unwrap (Phase 5):** `work\OptiPlex_7040_1_24_0.exe_extracted\Firmware\` — 6 sections.
- **Components (Phase 6):** CSME 11.8.92.4222 (Corporate H), GbE v0.8; Dell/AMI Aptio V Skylake, 9 MiB BIOS region.
- **UEFI unpack (Phase 7):** `work\bios\System_BIOS.bin.dump\` (8 volumes, 581 files, 505 PE32),
  `System_BIOS.bin.report.txt`, `setup_ifr.txt` (21,313 lines).
- **Report (Phase 8):** `work\EXTRACTION_REPORT.md`.

> Extra Python deps needed by ME Analyzer (`crccheck`, `pltable`) and the IFRExtractor
> behavior (writes output to a file next to the input) are documented in the report.

---

## 4. Remaining phases (detail)

### Phase 5 — Unwrap PFS (from the EXE)
- Run the command in Step B.
- Expected output folder: `work\OptiPlex_7040_1_24_0.exe_extracted\`
  containing sections such as:
  - `… System BIOS v1.24.0.bin` (the main BIOS region — likely BIOS Guard/PFAT wrapped)
  - ME / CSME 11 firmware, GbE, EC, and a Utility section (PFS/BIN/7z).
- Move/copy the System BIOS `.bin` to `work\bios\System_BIOS.bin`.

### Phase 6 — Identify components
- List all extracted sections (name, size, type).
- Run ME Analyzer on the CSME part: `tools\MEAnalyzer\MEA.py` (check its README for exact cmd).
- Fingerprint the UEFI BIOS (vendor/base, e.g. Dell/AMI Aptio V, Skylake) and record BIOS region size.

### Phase 7 — Unpack UEFI into editable modules
```powershell
# Bulk unpack the BIOS region into volumes/modules
& "C:\Users\Ghost\Desktop\bestproject\tools\UEFIExtract\UEFIExtract.exe" `
  "C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"

# Human-readable UEFI tree/report via UEFITool NE (GUI; or its report output)
& "C:\Users\Ghost\Desktop\bestproject\tools\UEFITool\UEFITool.exe"
```
- Output tree → `work\bios\System_BIOS.bin.dump\` (contains `.ffs`, `.pe32`, `.te`, sections, etc.).
- Locate the **Setup** module → dump its IFR → convert with `ifrextractor.exe`:
  ```powershell
  & "C:\Users\Ghost\Desktop\bestproject\tools\IFRExtractor\ifrextractor.exe" `
    "<path to setup PE32/section>" > "C:\Users\Ghost\Desktop\bestproject\work\bios\setup_ifr.txt"
  ```
  (IFRExtractor can also take a whole BIOS file and extract all IFR/HII.)

### Phase 8 — Final report
- Write `work\EXTRACTION_REPORT.md` (or `EXTRACTION_REPORT.md` in root): tool versions,
  hashes, component list, BIOS region details, and editing entry points (Setup/IFR, key modules).

---

## 5. Risks / notes
- **Signatures:** Dell PFS/BIOS images are RSA-signed. Editing is fine for analysis, but a
  **modified image will fail the official flasher's signature check**. Reflashing a mod would
  require an SPI dump + hardware programmer / Intel FPT — out of scope unless requested.
- **Antivirus:** BIOS tools are commonly false-flagged. May need a Defender exclusion for
  `bestproject\tools` (will ask before touching Defender).
- **Original file is never modified.** All writes stay under `bestproject\`.
- **Python:** embedded 3.11.9 used (`tools\BIOSUtilities` requires 3.10–3.13). Do NOT rely on
  the system Python 3.10 for BIOSUtilities.

---

## 6. Command log (what actually ran)

```text
# Prep
New-Item tools, work ; Copy-Item exe -> work\OptiPlex_7040_1_24_0.exe   (hash verified)

# Tools
git clone https://github.com/platomav/BIOSUtilities.git   tools\BIOSUtilities
git clone https://github.com/platomav/MEAnalyzer.git      tools\MEAnalyzer
# UEFITool NE A75 + UEFIExtract NE A75 (win64) extracted to tools\
# IFRExtractor-RS v1.6.1 (windows) extracted to tools\IFRExtractor\

# Python deps (embedded)
python_embeded\python.exe -m pip install pefile==2023.2.7 dissect.util==3.20   # OK

# PFS unwrap (SUCCESS after 7-Zip on PATH)
$env:PATH = "C:\Program Files\7-Zip;$env:PATH"
python_embeded\python.exe main.py work\OptiPlex_7040_1_24_0.exe -o work -e
   -> work\OptiPlex_7040_1_24_0.exe_extracted\Firmware\ (6 sections)

# ME Analyzer deps + run
python_embeded\python.exe -m pip install crccheck pltable colorama
"" | python_embeded\python.exe tools\MEAnalyzer\MEA.py "<...ME...v11.8.92.4222.bin>" -exit

# UEFI unpack + report
tools\UEFIExtract\UEFIExtract.exe work\bios\System_BIOS.bin all
   -> work\bios\System_BIOS.bin.dump\ + .report.txt + .guids.csv

# Setup IFR (IFRExtractor writes a file next to the input)
tools\IFRExtractor\ifrextractor.exe "<...\70 899407D7-...\body.bin>"
   -> copied to work\bios\setup_ifr.txt
```

**Status:** complete. See `work\EXTRACTION_REPORT.md` for the full write-up.

---

## 7. Upgrade-analysis phase (post-extraction)

After extraction, work shifted to cataloguing everything that can be upgraded / unlocked /
tuned. New artifacts (all analysis-only, nothing flashed):

| Artifact | Purpose |
|---|---|
| `UpgradeList.md` | Master living list (§A–§R) |
| `BIOS_UPGRADE_ANALYSIS.md` | Platform, guards, menu maps, offsets |
| `FIRMWARE_CATALOG.md` | Volume map + module catalog summary |
| `OPPORTUNITIES.md` | Inventor's compendium (transformations, inventions, HW, OS) |
| `SYSTEM_BASELINE.md` | Live hardware/OS/security baseline |
| `work\docs\modules_catalog.{csv,md}` | 581 FFS files catalogued |
| `work\docs\DELL_FIRMWARE_COMPONENTS.md` | System Map/PCR0/I219/ME/Freeform findings |
| `work\docs\NVRAM_DEFAULTS.md` (+`nvram_defaults.csv`) | Baked Setup defaults (4,928 B store) |
| `work\docs\setup_options.csv` | 2,993 Setup questions (hidden options) |

**Latest pass (2026-10-15):** inventor-mindset deep re-analysis — measured-boot manifest
discovered in System Map (embeds PCR0 SHA256); I219 GbE NVM identified; ME = Corporate H
vPro; Setup default store located and decoded; `OPPORTUNITIES.md` authored. All folded into
`UpgradeList.md` §Q/§R and `FIRMWARE_CATALOG.md` §5.

**Next:** run `find_pcr0.py` refinements (optional), and — only on explicit instruction —
sandbox-build ReBAR / hidden-menu images (never flash without SPI backup).
