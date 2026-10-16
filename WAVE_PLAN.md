# WAVE_PLAN.md — firmware upgrade waves, builds, and safe testing

> Owner: opencode. Working dir: `C:\Users\Ghost\Desktop\bestproject`.
> Interpreter: **`python_embeded\python.exe` only.** Tooling: `tools\`.
> Guardrail (AGENTS.md): **never flash/write firmware/SPI/ME/NVRAM/CMOS** unless the
> user's message contains the exact phrase **"I fully authorize you"**. Everything here
> is offline analysis + sandbox image building until that phrase appears.

---

## 1. Objective

Produce a set of **verified, improved System BIOS images** (and OS/HW tuning), each
described in `CHANGES.md`, each passed through an automated safety test before any
(opt-in) flashing.

Pristine baselines (never edited):
- `work\bios\System_BIOS.bin` — SHA256 `505D5F19…B5968E`, 9,437,184 B (`0x900000`).
- `OptiPlex_7040_1.24.0.exe` — SHA256 `C1B7E6E5…709F4A`.

---

## 2. Safe test strategy (layered — what we CAN do without hardware)

The vendor image cannot be fully booted in QEMU, so testing is layered. Only L1+L2 are
hard gates; L3/L4 are evidence.

| Layer | What | How | Gate? |
|---|---|---|---|
| **L1 Structural** | image size/layout, guard ranges untouched, FV/FFS checksums valid, exact diff vs baseline | `work\scripts\verify_image.py <img>` | **YES** |
| **L2 Semantic** | NVRAM: resolve Setup values for edited offsets; IFR: resolve menu/form visibility after unlock | verifier + `work\scripts\ifr_menu.py` | **YES** |
| **L3 Module emulation** | run the actual changed EFI binaries under OVMF (QEMU) to prove they load/execute | `work\qemu\run-ovmf.ps1 -Code …` + `startup.nsh` (`load`) | evidence |
| **L4 Full-image emulation** | boot the whole image in QEMU | see §2.1 | diagnostic |
| **Flash/recovery** | opt-in only | FPT read-only probe → CH341A backup | gated |

### 2.1 Full-image emulation finding (2026-07-… / record: 2026-10-15)

- QEMU 11.1.0 caps system firmware at **8 MB**; `-maxfirmwaresize` is **not** in this build.
  Workaround: trim the low 1 MB (`dell_bios8.fd`) — absolute addresses above `0xFF800000`
  are preserved, so the reset vector still maps correctly.
- With the trimmed image, QEMU **runs** the vendor image (no size error, process stays alive)
  but **no serial output** (Dell defaults to no COM1 console).
- Monitor probe: **EIP=`0xFFFFF556`** (reset-vector 4 KB page), 32-bit PM, **CR0.PG=0**,
  **EAX=`0x5AA55AD0`** (AMI POST marker), EDI=`0xFEF00004` → hangs **very early in SEC/PEI**
  on a chipset/ME handshake QEMU does not emulate (no Boot Guard ACM, no CSH/ME, ICH9≠Q170).
- VGA screendump = QEMU's own placeholder text **"Guest has not initialized the display (yet)."**
  (decoded via `VisionPipeline\describe.py`). Confirms the guest never set a display mode.
- **Conclusion:** Boot Guard is *not* enforced in QEMU (so a modded image *would* run), but the
  platform bring-up can't proceed → L4 cannot gate a build. It remains a useful smoke test that
  the image is well-formed enough to reach SEC.

### 2.2 Vision assist (for screenshots/UI evidence)

`VisionPipeline\describe.py <png> "<instr>"` on the **embedded** Python — proven. Use it to read
BIOS screenshots, menu captures, and emulated UI. (See `VisionPipeline\USE_ME_OPENCODE.md`.)

---

## 3. Waves

| Wave | Name | Touches | Guard impact | Build | Test |
|---|---|---|---|---|---|
| W0 | Recon | — | none | done | — |
| W1 | Safe defaults (Above 4G on, CSM off) | vol0 NVAR (`Setup` var) | outside both guards | **DONE** | L1 ✓ |
| W2 | ReBAR (RESIZABLE_BAR) | vol5 nested FV (`5C60F367…`) + NVAR | **inside AMI v2 range** | own FV/FFS editor | L1+L3 |
| W3 | Hidden menu unlock | vol5 `Setup` IFR (SuppressIf) | **inside AMI v2 range** | **DONE** | L1 ✓ L2 ✓ |
| W4 | Microcode / ME / option-ROM refresh | vol5 FVs, ME region | mixed | per-component | L1 |
| W5 | OS / hardware tuning (no firmware) | Windows, drivers, NVMe | none | scripts | system tests |

### W1 — Safe defaults (DONE)
- `work\mods\v01_defaults\System_BIOS.bin`, SHA256 `187be662…f25925`; exactly **2 bytes** differ:
  `0x0003DD` Above 4G MMIO `00→01`, `0x000D2A` CSM `01→00`. AMI v2 range hash & IBB unchanged.
- `work\mods\v01_defaults\CHANGES.md` written.

### W2b — ReBAR + BootGuardDxe bypass (DONE, offline)
- `work\mods\v02b_rebar_bgbypass\System_BIOS.bin` (SHA256 `BA464B00…E359D5D`): W2 plus a
  3-byte patch of the `BootGuardDxe` worker (RVA `0x1070` = dec `0x1E2494`, `40 53 48` →
  `31 C0 C3`) so the stale AMI hash cannot halt. IBB untouched → Intel ACM chain intact; works
  whether or not fuses are burned. L1 **PASS**. See its `CHANGES.md`.

### W2 — ReBAR
- **Goal:** enable Resizable BAR for the RTX 3060 (full 12 GB BAR) + Above 4G decoding.
- **Pieces:** (a) insert `tools\ReBARUEFI_0.3\ReBarDxe.ffs`
  (GUID `A8EE1777-A4F5-4345-9DA4-13742084D31E`, DXE driver, checksum attr) into DXE FV
  `5C60F367-A505-419A-859E-2A4FF6CA6FE5`; (b) set default `Above 4G` in NVAR; (c) ReBarState
  value in NVRAM (or `ReBarState.exe` at runtime).
- **Build:** UEFIReplace cannot insert → build `work\scripts\fvfs.py` (headless FV/FFS
  insert/remove, section recompress). Reuses the OVMF ReBarDxe PE32 already validated (L3).
- **Test:** L1 (FFS present, checksums, guard diff), L3 (extract the rebuilt PE32, `load` in OVMF).

### W3 — Hidden menus
- **Mechanism (found by RE):** the Setup driver `899407D7-99FE-43D8-9A21-79EC328CAC21` embeds its
  IFR (FormPackage at body `0x29CC4`, len `0x229B5`). Whole top-level menus are hidden behind
  `SuppressIf` wrapping a *constant* `True`; guard bytes `0A 82 46 02` immediately before the `Ref`.
  Opcodes: `SUPPRESS_IF`=0x0A, `TRUE`=0x46, `FALSE`=0x47. AMIBCP is invalid on Skylake+; the
  ReBARUEFI recipe → flip the constant.
- **Patch:** flip `0x46`→`0x47` (same length) on the menu `Ref`s, revealed menus:
  Advanced `0x2712`, Chipset `0x2713`, Security `0x2714`, Dell "Advanced configurations" `0x80A0`,
  ASPM `0x2816`.
- **Build (DONE):** `work\scripts\build_wave3_hidden.py` (W2b base + 5 IFR flips) →
  `work\mods\v03_hidden\System_BIOS.bin` (SHA256 `4615B333…B38E60`). L1 **PASS**; **L2** via
  `work\scripts\extract_setup_body.py` + IFRExtractor 1.6.1 re-extract shows all 5 menus now
  `SuppressIf → False` (`True=15 / False=5`; patched body SHA256 `e0b39cb1…5efa32`). See its
  `CHANGES.md`.
- **Hidden-options variant (DONE):** `work\scripts\build_wave4_hidden_opts.py` flips **all 19**
  `SuppressIf True` guards (5 menus + 14 options: Boot List, TPM Owner Status, Kill TPM, Vendor
  Keys, ASPM, ALS, …) → `work\mods\v04_hidden_opts\System_BIOS.bin` (SHA256 `CE616B15…3AEC93`),
  L1 **PASS**, L2 confirms `SuppressIf` guards now `True=0 / False=19` (only a `GrayOutIf` and a
  `DisableIf` retain a constant `True`).
- **Force-enable variant (DONE):** `work\scripts\build_wave5_force_enable.py` flips **all 21**
  constant-true guards (19 SuppressIf + 1 GrayOutIf + 1 DisableIf) →
  `work\mods\v05_force_enable\System_BIOS.bin` (SHA256 `0FB73335…52EE63`), L1 **PASS**, L2
  `True=0 / False=21`.

### W3b — Access-level unlock
- Flip `AMITSESetup` / access-granularity so hidden questions expose to USER (if needed).

### W4 — Component refresh
- Microcode already final (`0x506E3` rev `0xF0`). Evaluate ME 11.8.92 CSME update, GbE, option ROMs.
  Each component verified independently.

### W5 — OS/HW tuning
- NVMe/PCIe, power, GPU, memory tuning; no firmware change. ReBAR user-space half (GPU driver).

---

## 4. Guard model (must be re-checked every build — L1)

- **Boot Guard IBB:** file `0x700000..0x900000`. Gate = **bytes identical to pristine**.
  (`F41A1C24…` at `0x8780F4` is the BPM value, not a region hash.)
- **AMI v2 protected range:** file `0x0E0000..0x462C00`; expected `sha256` ==
  `6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098`, stored at file
  `0x7B93F4` (inside the IBB). **Confirmed runtime-enforced** (2026-10-15): `BootGuardPei`
  `B41956E1…` recomputes the SHA-256, `BootGuardDxe` `1DB43EC9…` prints "Boot Guard verified
  failed / System will shutdown" and halts; both gate on **MSR `0x13A` bit 32**. Full detail in
  `FIRMWARE_CATALOG.md §4.1`. **FPF now confirmed read-only (2026-10-15): Boot Guard is
  provisioned in Verified + Measured mode** (`MEInfoWin64 -verbose`, fuses burned; OEM key hash
  `A53EF0C1…B06C`; see `work\bios\bootguard_fpf.txt`). ⇒ **W2/W3 in-FV edits would brick on the
  stock image; the `BootGuardDxe` bypass (W2b, §4.1) is required** for every in-FV variant.
- **Editable, outside both guards:** `0x000000–0x0E0000` and `0x462C00–0x700000`.

### 4.1 If enforcement is active — neutralization strategy (feasible)

- The Intel **ACM only verifies the IBB (vol7)** with the OEM key. The DXE region is guarded by
  **AMI *software*** (the FV hash + `BootGuardDxe`). `BootGuardPei` merely *sets a flag*; the only
  component that halts is **`BootGuardDxe`** — a DXE driver inside vol5, i.e. **not in the IBB**.
- ⇒ Patch `BootGuardDxe` to skip its output path (e.g., `xor eax,eax; ret` at worker `0x1070`
  entry, before it registers the notify) so the check becomes inert while the IBB/ACM chain still
  verifies (we never touch vol7/FIT/ACM/BPM). This is the standard "Boot Guard doesn't cover DXE"
  bypass; **no OEM re-signing needed**. With it neutralized, in-FV W2/W3 edits are viable even on
  a *provisioned* platform.
- Corroboration: no SMM verifier `EE89F590` (`VerifyFwBootGuard`) exists in this image to re-check.
- Risk: unverified on hardware → build as its own variant, gate with L1, recover with CH341A.
- **W2 fallback — checked, BLOCKED by the `0x360` overlap:** vol5's free space starts at file
  `0x4628A0` (all-`0xFF` through `0x680000`), but the AMI v2 range ends at `0x462C00`, so the
  first `0x360` bytes of free space are *inside* the protected range, and a new FFS file must be
  placed at the **start** of free space (the FV walk stops at the first `0xFF` header). ⇒ inserting
  into vol5 free space still changes hashed bytes. No dispatched FV has free space inside the safe
  regions (`0x0–0xE0000`, `0x462C00–0x700000`): vol6 (`AFDD39F1`) is packed (largest gap 3,408 B),
  vol1–4 are NVRAM/PEI data. **⇒ on a provisioned (Verified) platform there is no in-image
  insertion point for a DXE driver; ReBAR would not be achievable from firmware.**

---

## 5. Tooling to build (headless, embedded Python)

1. **`work\scripts\verify_image.py`** — L1 gate: size, sha256, diff vs baseline, guard-byte
   checks, AMI-v2 stored-hash check, FV walk + FFS checksum spot-check, and optional expected-diff spec.
2. **`work\scripts\fv_edit.py`** — headless FV/FFS editor: insert/replace/remove files & sections,
   handle compressed sections (LZMA) with size fixups. (Needed for W2; replaces GUI UEFITool.)
3. **`work\scripts\ifr_menu.py`** — L2 gate: parse Setup IFR, list form refs + suppression state,
   and assert unlock targets.
4. **`work\scripts\nvar_resolve.py`** — parse vol0 NVAR store, resolve Setup var field values by offset.
5. **`work\scripts\check_bootguard.py`** — **(DONE)** read-only FPF probe: runs
   `tools\MEInfo_v11r46\MEInfoWin64.exe -verbose`, decodes the Boot Guard policy table, and picks
   the route; raw → `work\bios\meinfo_verbose.txt`, summary → `work\bios\bootguard_fpf.txt`
   (`--parse <file>` re-decodes a saved dump).

---

## 6. Flashing / recovery (OPT-IN; requires the exact authorization phrase)

1. Read-only probe: `fpt -d` (does the descriptor allow host BIOS-region access?).
2. Full SPI backup (software) + CH341A hardware dump (insurance).
3. Prefer BIOS-region-only edits (self-recoverable with a programmer).
4. Dell EXE flasher rejects modded images (RSA) → use FPT (`fptw64 -bios -f mod.bin`) or programmer.

---

## 7. Status

- W0 done. W1 built+verified. QEMU harness works; full-image boot characterized as SEC-hang.
- v01/v02 build pipeline + L1 done; W2 image built (`work\mods\v02_rebar\`).
- **W2b built + L1 PASS** (`work\mods\v02b_rebar_bgbypass\`): W2 + `BootGuardDxe` neutralization
  (§4.1) → boots regardless of FPF state. Awaiting hardware validation; recover with CH341A.
- Guard enforcement reverse-engineered: AMI v2 hash is **runtime-enforced** (BootGuardPei +
  BootGuardDxe, MSR `0x13A` bit 32); FIT parsed (ACM/KMSM/BPM in vol7, no IBB entry).
- **FPF check DONE (2026-10-15).** `work\scripts\check_bootguard.py` runs `MEInfoWin64.exe
  -verbose` (Intel CSME System Tools v11 r46, fetched from the `CE1CECL/IntelCSTools` mirror into
  `tools\MEInfo_v11r46\`) and decodes the fuse state: **Boot Guard provisioned, Verified +
  Measured** (all policy rows Enabled; KM ID `0xF`; Enforcement `0x3`; OEM key hash
  `A53EF0C1…B06C`). Raw: `work\bios\meinfo_verbose.txt`; summary: `work\bios\bootguard_fpf.txt`.
  ⇒ route is settled: **use the W2b base** (BootGuardDxe bypass) for all in-FV variants.
- **W3 built + L1 PASS + L2 PASS** (`work\mods\v03_hidden\`): W2b + hidden-menu unlock (5 menus);
  re-extracted IFR confirms the guards now read `False`. Awaiting hardware validation.
- **W3-variant v04 built + L1/L2 PASS** (`work\mods\v04_hidden_opts\`): maximal unlock — all 19
  `SuppressIf` guards flipped (menus + options).
- **v05 built + L1/L2 PASS** (`work\mods\v05_force_enable\`): force-enable — all 21 constant-true
  guards (SuppressIf + GrayOutIf + DisableIf) flipped.
- Next: (a) FPF check. If **not** provisioned (or Measured-only) → in-FV W2/W3 boot as-is (the
  check is inactive). If **provisioned (Verified)** → the §4.1 `BootGuardDxe` bypass in W2b/W3 image
  handles it. (b) Optional: "hidden options" variant (the 15 option-level suppressions).
