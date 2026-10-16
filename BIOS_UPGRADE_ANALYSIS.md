# Dell OptiPlex 7040 — BIOS Upgrade / Unlock / Compatibility Analysis

> Working dir: `C:\Users\Ghost\Desktop\bestproject`
> Generated: 2026-10-15
> **SCOPE: ANALYSIS + SANDBOX BUILD ONLY. NOTHING IS FLASHED. NO NVRAM/HARDWARE IS WRITTEN.**
> Flashing will only ever happen on an explicit instruction.

Source image analyzed: `work\bios\System_BIOS.bin`
(9,437,184 bytes / `0x900000`, SHA256 `505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E`)

---

## 1. Platform summary

| Item | Value |
|---|---|
| System | Dell OptiPlex 7040 (MT/SFF/MFF, board `0Y7WYT`) |
| Firmware base | AMI Aptio V (Dell OEM), UEFI image base `0xFF700000`, size `0x900000` |
| Chipset | Intel Q170 (100-series / SPT-H) |
| CPU support | **Intel Skylake only** — microcode contains a single record `CPUID 0x506E3` rev `0xF0` (2021-11-12). No Kaby Lake (`0x906E9`). |
| Installed CPU | i7-6700 (4C/8T) — top non-K SKU for this board |
| ME/CSME | 11.8.92.4222, Corporate H (vPro), Production, Stock update image |
| Boot Guard | Enabled (KM `0x879100`, BPM `0x878080`, ACM `0x870000`, ACM SVN 2) |
| Firmware modules | 8 volumes, 581 FFS files, 288 DXE drivers, 135 SMM modules, 81 PEI modules |

---

## 2. Integrity guards inside the image (verified, not guessed)

These matter because they determine *what a future modified image must also update* in order to remain valid.

### 2.1 Boot Guard IBB (initial boot block)
The BPM lists 4 IBB segments; their concatenated SHA256 was recomputed and **matches the stored BPM hash exactly**:

```
IBB segments (phys): FFE00000+0x170000, FFF78000+0x80, FFF79080+0x80, FFF7A100+0x85F00
Computed SHA256     : F41A1C2439602D17C6737325B06B47963CD15103EDC9EFDBFB730488FEEA3420
BPM stored IBB SHA256: F41A1C2439602D17C6737325B06B47963CD15103EDC9EFDBFB730488FEEA3420  ✅ MATCH
```

In BIOS-file terms the IBB = file offsets **`0x700000 .. 0x900000`** (the top 2 MiB: PEI core, SEC core, boot block, FIT, ACM, KM, BPM). The DXE/Setup volume is **not** part of the IBB.

### 2.2 AMI v2 protected range
The "AMI v2 protected ranges hash" was recomputed and **matches**:

```
Range: FF7E0000h + 382C00h  ==>  BIOS file offset 0x0E0000, size 0x382C00
Stored  SHA256: 6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098
Computed SHA256: 6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098  ✅ MATCH
```

This range (`0x0E0000 .. 0x462C00`) contains the **entire main DXE volume** — i.e. Setup, AMITSE, and essentially every module we would want to edit.

### 2.3 What this means for any future build

| Region | Guard | A modified build must... |
|---|---|---|
| Top 2 MiB (SEC/PEI/boot block) | Boot Guard IBB (fuse profile unknown — Verified vs Measured) | Cannot be changed at all if fuses are burned in Verified (FVE) mode. Determined at runtime by MSR `0x13A`, not inferable from the file. |
| DXE/Setup volume `0x0E0000..0x462C00` | AMI v2 protected-range hash | Recompute + patch the stored protected-range hash alongside the module edit, or the AMI/Dell validation will reject/mismatch. |

**Conclusion:** the file is fully editable *offline*. Whether a produced image boots depends on (a) the Boot Guard fuse profile and (b) recomputing the AMI v2 protected-range hash. Both are runtime/rebuild concerns — not blockers for the analysis/build stage.

---

## 3. Setup menu map — visible vs hidden

The image contains the complete AMI reference menu tree. Dell surfaces only a subset.

**Dell-visible top level** (`Main` form `0x2711`): General, System Information, System Configuration, Video, Security, Secure Boot, SGX, Performance, Power Management, POST Behavior, Virtualization Support, Wireless, Maintenance, System Logs, *Advanced configurations*, *Debug*, SupportAssist.

**Hidden but present** (referenced by `Advanced` `0x2712` / `Chipset` `0x2713` / `Main`, suppressed in the Dell UI):

| Form | Title | Options |
|---|---|---|
| `0x274C` | CPU Configuration | 77 (ratio limits, power limits PL1–PL4, C-states, CFG lock, SGX, debug) |
| `0x2772` | Memory Configuration | 52 (frequency, Max TOLUD, ECC, remap, training) |
| `0x2771` | PEG Port Configuration | 81 (dGPU / PEG) |
| `0x2768` | Graphics Configuration | 22 (Aperture Size, DVMT, Primary Display) |
| `0x2785` | PCH-IO Configuration | 45 |
| `0x2786` | PCI Express Configuration | 41 + root ports 1–20 (39 each) |
| `0x27D0` | CSM Configuration | 9 (CSM Support, boot filter, per-class UEFI/Legacy) |
| `0x2723` | Intel ICC | 24 (clocking) |
| `0x8008` | Virtualization Support | VT-x / VT-d / TXT |
| `0x274D`/`0x274E` | Power Limit 3/4 Settings | turbo power tuning |
| `0x274F` | CPU Thermal Configuration | thermal/power |
| `0x800C` | Debug | 58 |

Machine-readable inventories produced:

- `work\bios\setup_options.csv` — **2,993 questions** (2,382 in the `Setup` varstore `EC87D643-…`, all with `VarOffset`). Columns: form, type, prompt, question_id, varstore_id, var_offset, size, default.
- `work\bios\setup_options_report.txt` — full human-readable per-form listing + keyword index (`Above 4G`, `CFG`, `PCIe`, `Memory`, `C-state`, …).
- Parsers: `work\scripts\parse_ifr.py`, `summarize_ifr.py`, `dump_forms.py`.

---

## 4. Highest-value hidden settings (Setup varstore id `0x1`, size `0x1340`)

| Setting | VarOffset | Default | Relevance |
|---|---|---|---|
| Above 4GB MMIO BIOS assignment | `0x355` | Disabled | **Prerequisite for Resizable BAR** |
| CFG lock (MSR 0xE2[15]) | `0xAF` | Enabled (locked) | Unlock for tuning / non-Windows OSes |
| BIOS Lock (PCH BLE) | `0x461` | Disabled | Gates FPT-style flashing (irrelevant unless flashing) |
| Intel Virtualization Technology (VT-x) | `0x136` | Enabled | Virtualisation |
| Intel(R) Speed Shift Technology | `0x7E` | Enabled | HW P-states (already on) |
| Turbo Mode | `0x82` | Enabled | Turbo |
| Hyper-Threading | `0x79` | Enabled | |
| Active Processor Cores | `0x7A` | All | |
| Long Term / Short Term Power Limit | `0x87`/`0x89`,`0x83`/`0x8A` | Enabled/Enabled | Sustained turbo headroom |
| 1–4 Core Ratio Limit Override | `0x140`–`0x143` | — | (non-K CPU → effect limited) |
| Overclocking lock | `0x144` | Enabled | Gate for ratio/PLL overrides |
| Memory Frequency | `0x37E` | Auto | |
| Max TOLUD | `0x37D` | Dynamic | Above-4G / large-BAR interaction |
| Memory Remap | `0x408` | Enabled | |
| ECC Support | `0x37C` | Enabled | |
| Aperture Size | `0x2B9` | 256 MB | iGPU aperture |
| DVMT Pre-Allocated | `0x350` | 32 M | iGPU memory |
| CSM Support | `0xCA2` | Enabled | Must be **Disabled** for a clean ReBAR/UEFI setup |
| Boot option filter | `0xCA6` | UEFI and Legacy | |
| Primary Display | `0x373` | Auto | iGPU vs dGPU |
| Skip Scanning of External Gfx Card | `0x40F` | Disabled | dGPU enumeration |
| DMI Link ASPM Control | `0x897` | Disabled | power/latency |

> Note: `VT-d` appears as a read-only `Text` field ("VT-d") in this tree; the `VT for Direct I/O` toggle is under the Dell *Virtualization Support* page (`0x8008`).

---

## 5. Upgrade / compatibility opportunities (ranked)

### 5.1 Resizable BAR for the RTX 3060 — highest system-potential win (requires an image mod)
Skylake has no native ReBAR. To get it you need all three:
1. **Above 4GB MMIO** enabled (`0x355`) and **CSM disabled**.
2. **ReBarUEFI** (`xCuri0/ReBarUEFI`): insert `ReBarDxe.efi` into the DXE volume.
3. **UEFIPatch** of the PCI bus driver to lift the fixed 256 MB BAR limit.

Everything above is a **file-level build** we can assemble in the sandbox. It is the single biggest "unlock" available to this machine (GPU-visible VRAM window).

### 5.2 Hidden BIOS menu unlock (requires an image mod)
Most of the AMI tree (§3) is suppressed in Dell's UI. Exposing it requires editing the Setup/AMITSE visibility logic (e.g. AMITSE form-suppression patch / AMIBCP-style default edit). This is what makes CPU/memory/PCIe/PEG tuning reachable. Note: this lands squarely inside the AMI v2 protected range (§2.2), so a future flash build must recompute that hash.

### 5.3 CPU — already maxed for the platform (no mod)
- Microcode is the final Skylake revision `0xF0`; nothing newer exists to add.
- **No Kaby Lake**: the image ships only `0x506E3`. 7th-gen CPUs would not boot without adding Kaby ucode + RC support — not a realistic/valuable mod here.
- i7-6700 is the practical top CPU (Q170 does not overclock; non-K SKUs only).

### 5.4 Memory — capacity, not speed
- Board supports 4 DIMMs; **64 GB max** (current 32 GB = 4×8 GB DDR4-2133).
- Dell has no XMP; `Memory Frequency` (`0x37E`) is Auto. Speed ceiling is effectively DDR4-2133 on Skylake.

### 5.5 Features already present (no work needed)
NVMe/M.2 PCIe boot, TPM 2.0, Secure Boot, VT-x, Speed Shift, Turbo, SGX, AMT/vPro, USB3, SATA RST.

### 5.6 Possible ME refresh (low priority)
CSME `11.8.92.4222` is a 2022 update image; the 11.8 branch saw later point releases. Only relevant to future builds; separate ME region, out of the current editing scope.

---

## 6. What a future sandbox "build" would consist of (still NOT flashed)

1. Work from `work\bios\System_BIOS.bin.dump\`.
2. Insert `ReBarDxe.efi` into the `5C60F367-…` DXE volume (UEFITool NE `A75`).
3. Apply `UEFIPatch` (PciBus BAR-limit patch) to the volume.
4. Optionally patch Setup/AMITSE suppression logic to reveal hidden menus.
5. Recompute + update the **AMI v2 protected-range hash** (§2.2) for the changed `0x0E0000..0x462C00` range.
6. Repack to a candidate `System_BIOS.modded.bin` in the sandbox (hash it, keep the original untouched).
7. (Later, only on explicit go-ahead) plan a recovery-first flash with a full SPI backup.

---

## 7. Artifacts produced this session

| Artifact | Purpose |
|---|---|
| `work\bios\setup_options.csv` | All 2,993 Setup questions with offsets/defaults |
| `work\bios\setup_options_report.txt` | Per-form readable listing + keyword index |
| `work\scripts\parse_ifr.py` | IFR → CSV parser (handles multi-line Help) |
| `work\scripts\summarize_ifr.py` | Form/keyword summary generator |
| `work\scripts\dump_forms.py` | Dump selected forms in full |
| `work\scripts\scan_patterns.py` | Raw byte-pattern capability probes |
| `work\scripts\parse_ucode.py` | Microcode blob parser (CPU support) |
| `work\scripts\verify_ranges.py` | Verifies IBB + AMI-v2 protected-range hashes |

---

## 8. Open decisions (need your steer)

1. **Target(s) to pursue in the sandbox** — ReBAR (§5.1), hidden-menu unlock (§5.2), both, or pure documentation?
2. **Boot Guard fuse profile** — should we plan a read-only runtime check (MSR `0x13A`) so we know whether a future flashed image could ever boot? (No change to hardware.)
3. **Nothing will be flashed** until you explicitly say so.
