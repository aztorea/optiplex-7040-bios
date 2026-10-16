# UpgradeList — Dell OptiPlex 7040 (BIOS 1.24.0)

> **LIVING DOCUMENT.** Everything that can be upgraded / unlocked / tuned / enabled /
> improved / made compatible — at firmware, NVRAM, OS and physical-hardware level.
> Working dir: `C:\Users\Ghost\Desktop\bestproject`
> Source image: `work\bios\System_BIOS.bin` (SHA256 `505D5F19…B5968E`)
>
> **SAFETY:** ANALYSIS + SANDBOX BUILD ONLY. Nothing is flashed. No NVRAM/hardware is written.
> Flashing only ever on explicit instruction.
>
> Legend — **Method:** `IMG` = firmware image edit, `NVRAM` = hidden-setting change, `HW` = physical,
> `OS` = software/OS, `ME` = management-engine region. **Risk:** 🟢 low / 🟡 medium / 🔴 high.

---

## 0. Platform snapshot

| | |
|---|---|
| Firmware | AMI Aptio V (Dell OEM), UEFI image base `0xFF700000`, `0x900000` (9 MiB) |
| Chipset | Intel Q170 (SPT-H, 100-series) |
| CPU | i7-6700 (4C/8T), CPUID `0x506E3` — **Skylake only** (single ucode rev `0xF0`) |
| ME/CSME | 11.8.92.4222, Corporate H (vPro), Production |
| Guards | Boot Guard **provisioned, Verified+Measured** (fuses burned, 2026-10-15) — IBB = top 2 MiB + AMI v2 protected range (`0x0E0000+0x382C00`) |
| Modules | 8 volumes · 581 FFS files · 288 DXE · 135 SMM · 81 PEI · 505 PE32 |

---

## A. Hidden BIOS settings — unlockable (image mod) / settable (NVRAM)

Full machine-readable dump: `work\bios\setup_options.csv` (2,993 questions) and
`work\bios\setup_options_report.txt`. Varstore `Setup` GUID `EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9`, id `0x1`, size `0x1340`.

| # | Item | Offset | Default | Potential | Method | Risk |
|---|---|---|---|---|---|---|
| A1 | Above 4GB MMIO BIOS assignment | `0x355` | Disabled | Enable → prerequisite for Resizable BAR | IMG/NVRAM | 🟡 |
| A2 | CFG lock (MSR 0xE2[15]) | `0xAF` | Enabled | Disable → OS/tuning access | IMG/NVRAM | 🟡 |
| A3 | BIOS Lock (PCH BLE) | `0x461` | Disabled | (only matters for flashing) | IMG/NVRAM | 🟢 |
| A4 | CSM Support | `0xCA2` | Enabled | Disable → clean UEFI, needed for ReBAR | IMG/NVRAM | 🟡 |
| A5 | Intel Virtualization Technology (VT-x) | `0x136` | Enabled | (already on) | IMG/NVRAM | 🟢 |
| A6 | VT for Direct I/O (VT-d) | (page `0x8008`) | — | Enable → device DMA passthrough | IMG/NVRAM | 🟡 |
| A7 | Intel Speed Shift | `0x7E` | Enabled | (already on) | IMG/NVRAM | 🟢 |
| A8 | Turbo Mode | `0x82` | Enabled | (already on) | IMG/NVRAM | 🟢 |
| A9 | Hyper-Threading | `0x79` | Enabled | (already on) | IMG/NVRAM | 🟢 |
| A10 | Active Processor Cores | `0x7A` | All | limit cores | IMG/NVRAM | 🟢 |
| A11 | Enhanced C-states | `0x81` | Enabled | power/perf | IMG/NVRAM | 🟢 |
| A12 | Package C State limit | `0xB7` | AUTO | power/perf | IMG/NVRAM | 🟢 |
| A13 | Hardware Prefetcher | `0x13C` | Enabled | tuning | IMG/NVRAM | 🟢 |
| A14 | Adjacent Cache Line Prefetch | `0x13D` | Enabled | tuning | IMG/NVRAM | 🟢 |
| A15 | CPU AES | `0x137` | Enabled | (already on) | IMG/NVRAM | 🟢 |
| A16 | SGX (Software Guard Extensions) | `0x14A` | Disabled | Enable → SGX enclaves | IMG/NVRAM | 🟡 |
| A17 | Memory Frequency | `0x37E` | Auto | force speed | IMG/NVRAM | 🟡 |
| A18 | Max TOLUD | `0x37D` | Dynamic | large-BAR interaction | IMG/NVRAM | 🟡 |
| A19 | Aperture Size | `0x2B9` | 256 MB | iGPU aperture | IMG/NVRAM | 🟢 |
| A20 | DVMT Pre-Allocated | `0x350` | 32 M | iGPU memory | IMG/NVRAM | 🟢 |
| A21 | Primary Display | `0x373` | Auto | iGPU vs dGPU | IMG/NVRAM | 🟢 |
| A22 | DMI Link ASPM Control | `0x897` | Disabled | power/latency | IMG/NVRAM | 🟢 |
| A23 | PCIe ASPM (per root port) | forms `0x2788`–`0x279B` | — | power tuning | IMG/NVRAM | 🟢 |
| A24 | Serial Port Console Redirection | form `0x2735` | — | headless console | IMG/NVRAM | 🟢 |

> Note: NVRAM setability depends on whether Dell leaves the `Setup` varstore writable
> (`EFI_SECURITY_VIOLATION 0x1a` if protected). See doc §"Boot Guard".

---

## B. Performance / thermal / power tuning

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| B1 | Long/Short Term Power Limit (PL1/PL2) | `0x87`,`0x83`,`0x89`,`0x8A` | raise sustained turbo headroom | IMG | 🟡 |
| B2 | Platform PL1/PL2 Enable + Power/Window | `0x9D`–`0xA4` | platform power tuning | IMG | 🟡 |
| B3 | Power Limit 3 / 4 Settings | forms `0x274D`/`0x274E` | extra turbo power | IMG | 🟡 |
| B4 | CPU Thermal Configuration | form `0x274F` | thermal/power | IMG | 🟡 |
| B5 | Boot performance mode | `0x7F` | Max Non-Turbo default → tune | IMG | 🟢 |
| B6 | 1–4 Core Ratio Limit Override | `0x140`–`0x143` | (non-K CPU → limited) | IMG | 🟡 |
| B7 | Overclocking lock | `0x144` | gate for ratio/PLL overrides | IMG | 🔴 |
| B8 | CPU Flex Ratio Override/Settings | `0x78`,`0x77` | base-clock tuning | IMG | 🔴 |
| B9 | Configurable TDP | `0xB0`–`0xB2` | cTDP control | IMG | 🟡 |
| B10 | Intel ICC clocking | form `0x2723` | clocking profiles | IMG | 🔴 |
| B11 | Fan Control Override | page `0x8006` | fan curve | IMG | 🟢 |
| B12 | Pch Thermal Throttling Control | form `0x27BB` | throttle tuning | IMG | 🟡 |
| B13 | Platform Thermal Configuration | form `0x27BD` | thermal policy | IMG | 🟡 |

---

## C. Memory

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| C1 | Capacity | HW | 4 DIMMs → **max 64 GB** (now 32 GB 4×8) | HW | 🟢 |
| C2 | Speed | `0x37E` / HW | DDR4-2133 (Skylake ceiling; Dell has no XMP) | HW/IMG | 🟢 |
| C3 | ECC Support | `0x37C` | toggle (needs ECC DIMMs + chipset support) | IMG | 🟡 |
| C4 | Memory Remap | `0x408` | Enabled (large memory) | IMG | 🟢 |
| C5 | Memory training algorithms | form `0x2779` | stability/tuning | IMG | 🟡 |
| C6 | Row Hammer / RH Prevention | `0x40A`,`0x40B`,`0x40C` | security/stability | IMG | 🟡 |
| C7 | Channel A/B DIMM Control, Force Single Rank | `0x406`,`0x407`,`0x390` | compatibility | IMG | 🟡 |

---

## D. Graphics / GPU — **Resizable BAR (biggest win)**

| # | Item | Detail | Potential | Method | Risk |
|---|---|---|---|---|---|
| D1 | Resizable BAR | Needs Above4G (`0x355`) + CSM off (`0xCA2`) + ReBarUEFI `ReBarDxe.efi` inserted into DXE vol `5C60F367-…` + UEFIPatch PciBus BAR-limit | RTX 3060 full 12 GB BAR window, +5–10% typical | IMG | 🟡 |
| D2 | iGPU aperture / DVMT | `0x2B9`,`0x350` | iGPU tuning | IMG | 🟢 |
| D3 | Primary Display / Primary PEG / Primary PCIE | `0x373`,`0x444`,`0x445` | display routing | IMG | 🟢 |
| D4 | Skip Scanning of External Gfx Card | `0x40F` | dGPU enumeration | IMG | 🟢 |
| D5 | IGFX VBIOS / Gop | form `0x2768`/`0x2769` | iGPU GOP | IMG | 🟡 |

---

## E. PCIe

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| E1 | PCI Express root ports 1–20 (ASPM, speed, CLKREQ, LTR) | forms `0x2788`–`0x279B` | device tuning | IMG | 🟢 |
| E2 | PCIe Speed / Gen3 presets/RxCTLE | `0x620`+, forms `0x2773`–`0x2782` | link tuning | IMG | 🟡 |
| E3 | PCIe Spread Spectrum Clocking | `0xF9A` | EMI/link | IMG | 🟢 |
| E4 | Above 4G decoding | `0x355` | large BAR / MMIO | IMG | 🟡 |
| E5 | Peer Memory Write Enable | `0x4FF` | P2P | IMG | 🟡 |
| E6 | PCIe bifurcation | (root-port forms) | split lanes | IMG | 🟡 |

---

## F. Storage

| # | Item | Detail | Method | Risk |
|---|---|---|---|---|
| F1 | NVMe / M.2 PCIe SSD boot | already supported (`0xED5`) | OS/IMG | 🟢 |
| F2 | SATA operation (AHCI/RAID) | `0x48B`+ / page `0x8002` | IMG | 🟡 |
| F3 | RST PCIe Storage Remapping | `0x502`–`0x504` | IMG | 🟡 |
| F4 | UEFI drive password / HDD protection | page `0x8004` | IMG | 🟡 |
| F5 | OPAL / self-encrypting drive | — | HW | 🟢 |

---

## G. Virtualization & security

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| G1 | VT-x / VT-d / TXT | `0x136` / page `0x8008` | virtualization, passthrough | IMG/NVRAM | 🟡 |
| G2 | SGX (enclave memory) | `0x14A`,`0x14C` | SGX workloads | IMG | 🟡 |
| G3 | TPM 1.2 / 2.0 toggles | pages `0x8809`/`0x8821` | (already configured) | IMG | 🟢 |
| G4 | Secure Boot | enabled-capable | IMG/OS | 🟢 |
| G5 | SMM Security Mitigation | page `0x8004` | hardening (usually ON) | IMG | 🟢 |
| G6 | CPU XD (NX) | page `0x8004` | DEP | IMG | 🟢 |
| G7 | BIOS Guard technology page | form `0x2712` ref | hardening | IMG | 🔴 |
| G8 | Computrace/Absolute | page `0x8004` | deactivate persistence | IMG | 🟢 |
| G9 | Admin/System password lockouts | page `0x8004` | management | IMG | 🟡 |

---

## H. I/O & devices

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| H1 | USB front/rear/side enables | `0xE56`,`0xE61`,`0xE6C` | enable/disable ports | IMG | 🟢 |
| H2 | USB PowerShare / USB Wake | pages `0x8002`/`0x8006` | charging/wake | IMG | 🟢 |
| H3 | Serial ports / console redirection | forms `0x2735`,`0x2736`,`0x2738` | headless | IMG | 🟢 |
| H4 | HD Audio / DSP | forms `0x279E`,`0x279F`,`0x27A0` | audio features | IMG | 🟢 |
| H5 | Integrated NIC / AMT network | pages `0x890D`,`0x272B` | networking | IMG | 🟢 |
| H6 | Wireless device enable | page `0x8D01` | Wi-Fi/BT | IMG | 🟢 |
| H7 | SIO / Serial IO (I2C, SPI, UART) | forms `0x27A1`–`0x27AA` | embedded I/O | IMG | 🟢 |
| H8 | Keyboard illumination / backlight | page `0x8002` | (laptop-only) | IMG | 🟢 |

---

## I. Boot & compatibility

| # | Item | Where | Potential | Method | Risk |
|---|---|---|---|---|---|
| I1 | CSM / legacy boot | `0xCA2`,`0xCA6`–`0xCAA` | legacy OS / clean UEFI | IMG | 🟡 |
| I2 | Fast Boot, Quiet Boot | `0x50`,`0x1` | boot speed | IMG | 🟢 |
| I3 | UEFI Boot Path Security | page `0x8000` | boot security | IMG | 🟢 |
| I4 | USB/PS2/Network/VGA support flags | `0x1`–`0x7` | boot devices | IMG | 🟢 |
| I5 | Launch EFI Shell | page `0x2716` | recovery/tools | IMG | 🟢 |

---

## J. Management Engine / vPro / AMT

| # | Item | Detail | Method | Risk |
|---|---|---|---|---|
| J1 | CSME version | 11.8.92.4222 → later 11.8.x point release | ME | 🟡 |
| J2 | AMT / vPro configuration | form `0x272B`, page `0x272D` | remote mgmt features | IMG/ME | 🟡 |
| J3 | ME firmware update config | form `0x272E` | update policy | ME | 🟡 |
| J4 | USB Provisioning of AMT | `0x35` | provisioning | IMG | 🟢 |
| J5 | Network Stack | form `0x27CE` | PXE/UEFI net boot | IMG | 🟢 |

---

## K. Firmware-level mods (image edits — sandbox only)

| # | Item | Detail | Risk |
|---|---|---|---|
| K1 | Unlock hidden AMI menus (Setup/AMITSE) | reveal CPU/Mem/PCIe/PEG/CSM/Debug tree | 🔴 |
| K2 | Insert ReBarUEFI driver | `ReBarDxe.efi` into `5C60F367-…` | 🟡 |
| K3 | UEFIPatch PciBus | lift 256 MB BAR limit | 🟡 |
| K4 | Recompute AMI v2 protected-range hash | required after any `0x0E0000..0x462C00` edit | 🟡 |
| K5 | Change setup defaults | e.g. Above4G/CSM off by default | 🟡 |
| K6 | Custom boot logo / splash | replace logo module | 🟢 |
| K7 | Add CPU microcode | (not useful — already latest Skylake; no Kaby) | — |
| K8 | Disable Boot Guard references / guards | 🔴 brick if fuses burned | 🔴 |

---

## L. System identity / branding (image edits)

| # | Item | Detail | Risk |
|---|---|---|---|
| L1 | Service Tag | stored plaintext ~`78002A` (per public Dell guides) | 🟡 |
| L2 | Asset Tag / Ownership Tag | page `0x8001` fields | 🟡 |
| L3 | Model strings | "OptiPlex 7040", "Dell Inc." | 🟢 |
| L4 | DMI/SMBIOS strings | manufacturer/product/serial | 🟡 |

---

## M. Physical hardware upgrades (maximize potential)

| # | Item | Detail | Risk |
|---|---|---|---|
| M1 | RAM | 4× 16 GB DDR4-2133 → 64 GB | 🟢 |
| M2 | NVMe SSD | larger/faster M.2 NVMe | 🟢 |
| M3 | GPU | RTX 3060 present (needs PSU/space check for bigger) | 🟢 |
| M4 | CPU | i7-6700 is top-usable (no Kaby; Q170 no OC) | 🟢 |
| M5 | Add-in NIC / PCIe cards | via root ports | 🟢 |
| M6 | Cooling | better airflow for sustained turbo | 🟢 |

---

## N. Microcode / CPU support

| # | Item | Finding | Method |
|---|---|---|---|
| N1 | Current microcode | `0x506E3` rev `0xF0` (2021-11-12) — final Skylake rev | — |
| N2 | Kaby Lake support | **Absent** (no `0x906E9`) — not realistically addable | img (🔴) |
| N3 | Mismatched-CPU guard | form `0x274C` "Mismatch CPU" text | IMG |

---

## O. Update / maintenance posture

| # | Item | Detail | Method |
|---|---|---|---|
| O1 | UEFI capsule updates | page `0x8004` "UEFI Capsule Firmware Updates" | IMG |
| O2 | Signed Firmware Update | shown ENABLED in System Information | — |
| O3 | Config lock for flashing | BIOS Lock `0x461` | IMG/NVRAM |

---

## P. Firmware structure / module catalog (reference)

Full deep documentation: `FIRMWARE_CATALOG.md`. Machine-readable tables:
`work\docs\modules_catalog.csv` (581 FFS files) and `work\docs\modules_catalog.md`.

| # | Item | Detail |
|---|---|---|
| P1 | Volume map | 8 top-level FFSv2 volumes; vol 0 = NVAR store, vol 4 = NVRAM defaults, vol 5 = main BIOS (`0x0E0000`, 461 files), vol 7 = Boot Guard IBB (PEI, top 2 MiB) |
| P2 | Nested driver FVs | `5C60F367-…` (main DXE, ReBAR insertion target) and `BDB6C5ED-…` |
| P3 | Module inventory | 288 DXE · 135 SMM · 81 PEI · 48 Freeform · 505 PE32 · 424 Version |
| P4 | Identified modules | TPM/Secure Boot, PCH/SATA/AHCI/NVMe, network stack (MNP/TCP/IP4/ARP), Intel HD Graphics, ME/AMT, Dell OEM (monotonic counter, eDiags, config info, wireless, service tag) |
| P5 | Boot Guard evidence | "Boot Guard Debug Measured S-CRTM" strings in PEI vol 7 — measured-boot paths present (fuse mode still runtime-only) |

---

## Q. Measured boot / Dell components (new this pass)

Full analysis: `work\docs\DELL_FIRMWARE_COMPONENTS.md`.

| # | Item | Detail | Method |
|---|---|---|---|
| Q1 | **System Map = measured-boot manifest** | `IWAP` magic; embeds the exact PCR0 `FV_DXE_PCR0_SHA256` (`3A5C91FE…3E92`) + a second DXE digest (`054BE301…BFCC`) | IMG |
| Q2 | **Dell measured DXE volume** | PEI vol 7 "Boot Guard Debug Measured S-CRTM" path measures a DXE volume at boot → **any DXE edit is detected** | IMG |
| Q3 | PCR0 manifest XML | `ModelName=OptiPlex 7040`, `ModelNumber=0x06B9`, `VersionBuild=1.24.0`, RIM v17 | IMG |
| Q4 | Intel I219 GbE NVM | standalone 8 KB region (dev `0x15B7` / sub `0x1028`), separate from BIOS file — custom MAC only with SPI programmer | HW/SPI |
| Q5 | ME = Corporate H vPro | AMT present in silicon, gated by NVRAM/MEBx | IMG/ME |
| Q6 | Freeform default store | vol 4 (`FD44D4FE…`) 12 Freeform = NVRAM external defaults; **`Setup` default body = 4,928 B (=`0x1340`)** and matches stock IFR defaults — see `work\docs\NVRAM_DEFAULTS.md` | IMG |

> **Risk consequence:** because Q1/Q2 exist, *any* edit to the measured DXE volume (ReBAR
> driver insert, Setup patch, hidden-menu unlock) is visible to the measurement chain.
> Whether it blocks boot depends on the runtime fuse profile (MSR `0x13A`), which is not
> knowable from the file. Treat every image mod as sandbox-only until H-11 (SPI programmer
> + full backup) is in place.

---

## R. Transformation playbooks (what to make the machine)

Full "inventor's compendium": `OPPORTUNITIES.md`.

| # | Playbook | Key upgrades |
|---|---|---|
| R1 | VR / gaming powerhouse | D1 (ReBAR) + B1–B3/B11 (power/fan) + E1/E2 |
| R2 | Proxmox / VFIO gaming VM | A6/G1 (VT-d) + T1 synergy + J2 (vPro AMT) |
| R3 | Plex / media server (Quick Sync iGPU) | A4, A20, A21; HW HDDs |
| R4 | Local LLM / AI box | RTX 3060 12 GB + C1/M1 (64 GB); no firmware blocker |
| R5 | pfSense/OPNsense router | H-4 NIC + A6 VT-d + A24 console redir |
| R6 | NAS / storage server | F2/F3 + M2 HDDs + C1 RAM |
| R7 | Hackintosh (OpenCore) | A2 CFG-off + A1 Above4G + SMBIOS spoof |
| R8 | Firmware-analysis lab | this project + H-11 SPI programmer |

---

## S. Built sandbox images (offline, L1/L2-verified — NEVER flashed)

Each is under `mods\<variant>\System_BIOS.bin` with its own `CHANGES.md`; baseline
`work\bios\System_BIOS.bin`. All keep the Boot Guard IBB (`0x700000..0x900000`) byte-identical.

| Variant | Contents | SHA256 | Tests |
|---|---|---|---|
| `v01_defaults` | Above 4G on, CSM off (2 bytes, vol0 NVAR) | `187BE662…F25925` | L1 ✓ |
| `v02_rebar` | W1 + ReBarDxe insert | `F696E8D2…280696` | L1 ✓ |
| `v02b_rebar_bgbypass` | W2 + `BootGuardDxe` neutralization (RVA `0x1070`→`31 C0 C3`) | `BA464B00…E359D5D` | L1 ✓ |
| `v03_hidden` | W2b + unlock 5 hidden menus | `4615B333…B38E60` | L1 ✓ L2 ✓ |
| `v04_hidden_opts` | W2b + unlock all 19 `SuppressIf` guards | `CE616B15…3AEC93` | L1 ✓ L2 ✓ |
| `v05_force_enable` | W2b + flip all 21 constant-true guards | `0FB73335…52EE63` | L1 ✓ L2 ✓ |

**Hidden-menu unlock (K1, done):** the Setup driver `899407D7-…` IFR hides menus/options behind
`SuppressIf` / `GrayOutIf` / `DisableIf` wrapping a constant `True`; flip the operand `0x46`→`0x47`
(same length). Opcodes: SUPPRESS_IF=`0x0A`, GRAY_OUT_IF=`0x19`, DISABLE_IF=`0x1E`, TRUE=`0x46`,
FALSE=`0x47`. Builders: `work\scripts\build_wave{3,4,5}_*.py`. See `WAVE_PLAN.md §3`.

> This means in-FV variants must use the **W2b base** (`v02b`+); the plain `v02_rebar` (no
> `BootGuardDxe` bypass) would halt. None of these is hardware-validated yet — recover with an
> SPI programmer. FPF check: `work\scripts\check_bootguard.py` → `work\bios\bootguard_fpf.txt`.

---

### Changelog
- 2026-10-15 — created; seeded from `BIOS_UPGRADE_ANALYSIS.md` + IFR inventory.
- 2026-10-15 — added §P firmware catalog; built `work\docs\modules_catalog.{csv,md}` + `FIRMWARE_CATALOG.md` (581 FFS files, volume map, module identification).
- 2026-10-15 — inventor pass: added §Q (measured-boot/System Map, I219 GbE, ME vPro, Freeform defaults), §R (transformation playbooks); created `OPPORTUNITIES.md`, `work\docs\DELL_FIRMWARE_COMPONENTS.md`, `work\docs\NVRAM_DEFAULTS.md` (+ `nvram_defaults.csv`).
- 2026-10-15 — build pass: added §S built-image matrix; K1 hidden-menu unlock implemented (W2b base + `SuppressIf` flip) → `v03_hidden`, `v04_hidden_opts`, `v05_force_enable`; W2b `BootGuardDxe` neutralization. See `WAVE_PLAN.md` / `FIRMWARE_CATALOG.md §4.1`.
- 2026-10-15 — FPF check: read-only `MEInfoWin64 -verbose` (CSME Tools v11 r46 from the `CE1CECL/IntelCSTools` mirror) confirms Boot Guard **provisioned, Verified+Measured** (OEM key `A53EF0C1…B06C`); added `work\scripts\check_bootguard.py`. ⇒ W2b route required.
