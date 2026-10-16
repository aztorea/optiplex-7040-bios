# OptiPlex 7040 / BIOS 1.24.0 — Firmware Structure & Module Catalog

> Deep documentation of the raw BIOS image `work\bios\System_BIOS.bin` (9 MiB, base `0xFF700000`).
> Companion files: `work\docs\modules_catalog.md` (readable tables) and
> `work\docs\modules_catalog.csv` (machine-readable, one row per FFS file).
>
> **SAFETY:** analysis only. Nothing flashed, no NVRAM/hardware written.

---

## 1. Firmware volume map

Top-level FFSv2 volumes (offsets are **file** offsets; logical base = `0xFF700000 + offset`):

| Idx | File offset | Size | Volume GUID | Contents |
|-----|-------------|------|-------------|----------|
| 0 | `0x000000` | `0x040000` | `8C8CE578-8A3D-4F1C-9935-896185C32DD3` | **NVAR store** — 1 Raw file (`CEF5B9A3-…`). Holds live variables: `Setup`, `AMITSESetup`, `SecureBootSetup`, `UsbSupport`, `NetworkStackVar`, `DellVar01`, `PCI_COMMON`, `IccAdvancedSetupDataVar`, `PlatformLang`, `Timeout`, `StdDefaults`. |
| 1 | `0x040000` | `0x040000` | `8C8CE578-…` | Free space (spare variable/fault-tolerant store) |
| 2 | `0x080000` | `0x010000` | `8C8CE578-…` | Free space |
| 3 | `0x090000` | `0x040000` | `E34AEDB0-BB97-49BC-B139-1E419B3560E2` | 1 Freeform file (`F6405581-…`) + raw |
| 4 | `0x0D0000` | `0x010000` | `FD44D4FE-239B-4C57-B96D-E47E066A50A3` | **NVRAM external defaults** — 12 Freeform files (Dell/AMI HII default store) |
| 5 | `0x0E0000` | `0x5A0000` | `4F1C52D3-D824-4D2A-A2F0-EC40C23C5916` | **Main BIOS volume** — 461 files: 288 DXE, 135 SMM, DXE core, SMM core, 4 Applications, plus nested driver volumes ⤵ |
| 5a | *(nested in 5)* | `0x84C000` | `5C60F367-A505-419A-859E-2A4FF6CA6FE5` | **DXE driver FV** — insertion target for `ReBarDxe.efi` |
| 5b | *(nested in 5)* | `0x34F000` | `BDB6C5ED-6BF3-4909-837C-353F6DCBB6A2` | Secondary DXE driver FV |
| 6 | `0x680000` | `0x080000` | `AFDD39F1-19D7-4501-A730-CE5A27E1154B` | 4 files: Raw `2D27C618-…` (182,232 B) + Raw `B52282EE-…` (408 B) + 2 padding |
| 7 | `0x700000` | `0x200000` | `61C0F511-A691-4F54-974F-B9A42172CE53` | **PEI / boot-block volume = Boot Guard IBB** — 102 files: 81 PEI modules, PEI core, SEC core, FIT, PEI apriori |

The main BIOS volume (5) begins at file offset `0x0E0000` — the same base as the **AMI v2 protected range**
(`0x0E0000 + 0x382C00`). The IBB (top 2 MiB) is volume 7. Both match the verified guard hashes
(see `work\logs\hashes.txt` / `verify_ranges.py`).

---

## 2. Module counts (581 FFS files)

| Type | Count |
|------|-------|
| DXE driver | 288 |
| SMM module | 135 |
| PEI module | 81 |
| Freeform | 48 |
| Raw | 12 |
| Pad | 7 |
| Application | 4 |
| Volume image (nested FV) | 2 |
| DXE core / SMM core / PEI core / SEC core | 1 each |

PE32 image sections: 505. Version sections: 424. DXE dependency: 248. MM dependency: 135. PEI dependency: 81.

---

## 3. Notable identified modules

Names are best-effort, inferred from embedded strings. Full list in `modules_catalog.md`.

**Boot / core (vol 7 — inside IBB):**
- `34989D8E`, `961C19BE`, `9B3F28D5`, `E9312938` — **"Boot Guard Debug Measured S-CRTM"** strings
  (Measured-boot code paths present in PEI). 🔎 *Suggests measured path; fuse mode still only confirmable at runtime (MSR 0x13A).*
- `D6A2CB7F-…` — DXE Core · `52C05B14-…` — PEI Core

**Security / TPM (vol 5):**
- `39045756-…` TPM Driver · `4C8BDF60-…` TPM2 · `50F6096D-…` TPM PER-BIOS flags
- `196CA3D8-…` / `E5B24906-…` / PEI `0D8039FF`, `0FE9DA53` — TPM presence / `InternalDisallowTpmFlag`
- `4551F2F5-…`, `A062CF1F-…`, `E4ECD0B2-…`, `F80697E9-…`, SMM `BC327DBD-…` — Secure Boot
- `1DB43EC9-…` — Boot Guard verification driver
- `60740CF3-…` — Secure System Agent security

**Chipset / platform (vol 5):**
- `00B46EC9-…` Intel 9-Series (PCH) · `BB65942B-…` Intel PCH SATA controller · `2F2295B6-…` AMI PCIe AHCI
- `502B04F3-…` AMI PCI Bus Driver · `634E8DB5-…` AMI NVMe Bus Driver · `32C1C9F8-…` Native SATA

**Networking (vol 5):** `025BBFC7` MNP · `1A7E4468` TCP · `26841BDE` IP4 CONFIG · `529D3F93` ARP · `21891A9E` NetworkStackVar

**Graphics:** `43E7ABDD` AMI Graphic Console · `DB941521`/`55BB5A4B` Intel HD Graphics · `DE23ACEE` IntelGraphicsMem · `29CF55F8` gBIOS INT10

**Management Engine / AMT:** `773CB08B` SetupAmtFeatures · ME setup drivers in vol 5

**Dell OEM:** `194EE52B` DellMonotonicCounter (DXE) · `7122810D` DellMonotonicCounter (SMM) · `8B529353` DellEdiagsEnabled · `7D15608C` Dell Configuration Information · `D7DCC862` Dell Wireless · `21B0CB55` Service Tag

**Storage / boot services:** `1FA1F39E` Partition Driver (MBR/GPT/El Torito) · `42857F0A` Capsule Update · `3FE89372` Boot Manager

---

## 4. Guard-relevant observations

- **Volume 7 = IBB (SHA256 `F41A1C24…`)** — entirely covered by Boot Guard; not editable without re-signing the ACM/BPM chain (needs fuses; OEM key).
- **Volume 5 = inside the AMI v2 protected range (SHA256 `6C8E1C15…`)** — any edit here (Setup, AMITSE, ReBar insertion) requires recomputing the stored protected-range hash. This is the *modifiable-but-hash-tracked* region.
- The strings in §3 confirm the guards are actively implemented (verification driver + S-CRTM measured paths present), consistent with the earlier recomputed-hash matches.

### 4.1 Runtime enforcement (reverse-engineered 2026-10-15)

The AMI v2 hash is **enforced at boot**, not merely checked at update time:

- **`BootGuardPei` `B41956E1-7CA2-42DB-9562-168389F0F066`** (vol7) recomputes SHA-256 over
  `[0xFF7E0000, +0x382C00)` and compares to the stored digest. Match → sets the verified bit
  (`or byte [eax+0x18], 1` @ `FFE1BFFB`); mismatch → clears it (`and byte [eax+0x18], 0x10` @
  `FFE1C00A`) and returns `EFI_UNSUPPORTED`. Gate = **MSR `0x13A` bit 32**.
- **`BootGuardDxe` `1DB43EC9-DF5F-4CF5-AAF0-0E85DB4E149A`** (inside DXE FV `5C60F367…`) is the
  enforcer: a protocol-notify handler prints **"Boot Guard verified failed" / "System will
  shutdown" / "Press any key"** and halts. Gate = **MSR `0x13A` bit 32**.
- **MSR `0x13A`** (community-documented decode, `rdmsr 0x13a`): `0x0` = not provisioned ·
  `0x10000000` = **Verified** (bit 28) · `0x20000000` = Measured (bit 29) · `0x30000000` = both.
  (The RE "bit 32" gate above refers to the MSR read inside `BootGuardPei`/`BootGuardDxe`.)
  ⇒ outcome depends on **FPF fuse state**, not the image.
- **FPF confirmed read-only (2026-10-15).** `MEInfoWin64.exe -verbose` (Intel CSME System Tools
  v11 r46, run via `work\scripts\check_bootguard.py`) reports the burned fuses: **Force Boot Guard
  ACM, Protect BIOS Environment, CPU Debugging, BSP Initialization, Measured Boot, Verified Boot
  = Enabled** (FPF column == ME column; "FPF and ME Config Status: Match"); **Key Manifest ID
  `0xF`**, **Enforcement Policy `0x3`**, **OEM Public Key Hash `A53EF0C178D288B02E61FD71FC31874E
  89F041FE9332BA2A787A97F7146FB06C`**; FPF HW Source = "Original FPF HW Fuse Bank". ⇒ **Boot Guard
  is provisioned in Verified + Measured mode** — the `BootGuardDxe` neutralization (§4.1) is
  **required**; the plain `v02_rebar` (W2 with no bypass) would halt. Raw dump:
  `work\bios\meinfo_verbose.txt`; summary: `work\bios\bootguard_fpf.txt`.
- FIT (`0x680100`): **no type-`0x07` (IBB) entry**; `0x0B` Key-Manifest @ `0xFFF79100`, `0x0C`
  Boot-Policy-Manifest @ `0xFFF78080`, ACM @ `0xFFF70000` (all vol7).
- Real-world: same-gen Dell (3040) shows this exact halt message after a damaged DXE flash.

⇒ **Boot Guard *is* provisioned (Verified) on this platform (confirmed 2026-10-15), so W2/W3
in-FV edits brick** unless `BootGuardDxe` is neutralized. Independently, there is no safe in-image
insertion point for a DXE driver: vol5's free space begins `0x360` B *inside* the range
(`0x4628A0` vs `0x462C00`) and must be written at its start, so it is not usable (see
`WAVE_PLAN.md §4`).

**Neutralization implemented (offline, 2026-10-15).** Because the halting actor is a *DXE driver*
(`BootGuardDxe`) and the only hardware verifier covers the IBB (vol7), patching its worker
(RVA `0x1070` → `xor eax,eax; ret`) makes the stale AMI hash inert while the Intel ACM/KMSM/BPM
chain still verifies. Built as `work\mods\v02b_rebar_bgbypass\` (W2 + bypass) and
`work\mods\v03_hidden\` (W2b + hidden-menu unlock); both keep the IBB byte-identical, L1 PASS.
The hidden-menu unlock flips the Setup IFR `SuppressIf` constant (`0x46` True → `0x47` False) for
the menu `Ref`s: Advanced `0x2712`, Chipset `0x2713`, Security `0x2714`, Dell "Advanced
configurations" `0x80A0`, ASPM `0x2816`. Re-extracted IFR now reads True=15 / False=5 (see
`work\mods\v03_hidden\CHANGES.md`). Not yet hardware-validated.

---

## 5. Dell measured-boot & component findings (inventor pass)

Full write-up: `work\docs\DELL_FIRMWARE_COMPONENTS.md`. New evidence this pass:

- **System Map v1.0.1.bin** (112 B, `IWAP` magic) is a **measured-boot manifest** — it
  embeds the exact PCR0 `FV_DXE_PCR0_SHA256` (`3A5C91FE…1F6EC43E92`) at offset `0x30`,
  plus a **second DXE digest** (`054BE301…BFCC`) at `0x50`.
- **PCR0 XML** confirms the same digest and a `ComponentID` (`OptiPlex 7040`,
  `ModelNumber 0x06B9`, `VersionBuild 1.24.0`, RIM v17).
- ⇒ Dell runs an **internally measured DXE-volume boot** (the "Boot Guard Debug Measured
  S-CRTM" path in §3). **Any DXE-volume edit is measurable/detectable.** The AMI v2
  stored hash (§4) is a *second, independent* guard.
- **Gigabit Ethernet v0.8.bin** = standalone **Intel I219 NVM region** (8 KB, dev
  `0x15B7` / sub `0x1028`), separate from the BIOS file.
- **ME = CSME 11.8.92.4222 Corporate H (vPro)** — AMT present in silicon.
- **Volume 4** (`FD44D4FE…`) 12 Freeform = **NVRAM external default store** (baked-in
  defaults for the `Setup` varstore).

| Component | Size | Most-significant fact |
|---|---|---|
| System BIOS w/ BIOS Guard | 9,437,184 | mod target; carries both guard ranges |
| GbE (I219 NVM) | 8,192 | separate region; dev `0x15B7`/sub `0x1028` |
| ME (VPro) update | 7,348,224 | CSME 11.8 Corporate H |
| System Map | 112 | measured-boot manifest (PCR0 hash embedded) |
| PCR0 XML | 2,396 | Dell DTPM/measured-boot declaration |
| Model Information | 85 | plaintext model descriptor |

---

## 6. How this was produced

- `work\scripts\catalog_modules.py` — walks the UEFIExtract dump, parses each `info.txt`, extracts PE32 strings.
- `work\scripts\build_catalog.py` — names modules (known-GUID table + string heuristic), attributes volumes, emits
  `work\docs\modules_catalog.csv` + `work\docs\modules_catalog.md`.
- Raw identification dump: `work\docs\module_names.txt`, `work\docs\module_strings_dump.txt`.

---

### Changelog
- 2026-10-15 — created (volume map, module counts, notable modules, guard observations).
- 2026-10-15 — inventor pass: added §5 Dell measured-boot & component findings (System Map
  manifest, PCR0, I219 GbE, CSME vPro, Freeform defaults); see
  `work\docs\DELL_FIRMWARE_COMPONENTS.md` and `OPPORTUNITIES.md`.
- 2026-10-15 — added §4.1 runtime-enforcement reverse-engineering (BootGuardPei `B41956E1` +
  BootGuardDxe `1DB43EC9`, MSR `0x13A` gate, FIT manifest locations) and the vol5 free-space
  safe-region finding.
- 2026-10-15 — Wave 2b/3 builds: §4.1 neutralization implemented (`BootGuardDxe` worker RVA `0x1070`
  → `xor eax,eax; ret`) and hidden-menu unlock (Setup IFR `SuppressIf` `0x46`→`0x47`); artifacts
  `work\mods\v02b_rebar_bgbypass\` and `work\mods\v03_hidden\` (builders in `work\scripts\`).
- 2026-10-15 — `v04_hidden_opts`: maximal unlock (all 19 `SuppressIf` guards: 5 menus + 14 options;
  L2 `True=0/False=19`), `work\mods\v04_hidden_opts\` + `build_wave4_hidden_opts.py`.
- 2026-10-15 — `v05_force_enable`: all 21 constant-true guards flipped (19 SuppressIf + 1 GrayOutIf +
  1 DisableIf; L2 `True=0/False=21`), `work\mods\v05_force_enable\` + `build_wave5_force_enable.py`.
- 2026-10-15 — **FPF check (read-only).** Added `work\scripts\check_bootguard.py`; obtained Intel
  `MEInfoWin64.exe` v11 r46 from the `CE1CECL/IntelCSTools` GitHub mirror into
  `tools\MEInfo_v11r46\` (4 files; `MEInfoWin64.exe` SHA256 `E37035BF…74660F0`). Confirms Boot
  Guard **provisioned, Verified + Measured** (KM ID `0xF`, Enforcement `0x3`, OEM key hash
  `A53EF0C1…B06C`); raw `work\bios\meinfo_verbose.txt`, summary `work\bios\bootguard_fpf.txt`.
  ⇒ W2b base required for all in-FV variants.
