# v06_all_in_one — change record

## Summary
**The single combined image: everything from every wave in one file.**
Superset of `v01`..`v05`. Offline sandbox build only — **never flashed**.

| Source wave | Feature combined in |
|---|---|
| W1 | Above 4G MMIO = **Enabled**, CSM = **Disabled** (baked defaults) |
| W2 | `ReBarDxe.ffs` inserted (Resizable BAR driver) |
| W2b | `BootGuardDxe` worker neutralized (needed to boot any modified image) |
| W5 | **all 21** constant-true Setup IFR guards flipped (19 SuppressIf + 1 GrayOutIf + 1 DisableIf) |

## Artifact
- Image:   `mods\v06_all_in_one\System_BIOS.bin`
- Size:    9437184 (0x900000) — unchanged
- SHA256:  `a0699eaee736e6fb79b39c0b1d36cdd4d79a8511086dcf5fc0e813edfe19d067`
- Baseline: `work\bios\System_BIOS.bin` (sha256 `505D5F19…B5968E`)

## Exact edits vs pristine
| location | change |
|---|---|
| file `0x0003DD` (vol0 `StdDefaults\Setup` +0x355) | Above 4G `0x00` → `0x01` |
| file `0x000D2A` (vol0 `StdDefaults\Setup` +0xCA2) | CSM `0x01` → `0x00` |
| file `0x104580..0x358184` (LZMA payload of file `9E21FD93`) | recompressed; contains: `BootGuardDxe` worker RVA `0x1070` → `xor eax,eax; ret`; `ReBarDxe` inserted at dec `0x84B5E0`; 21 IFR guard `True`→`False` |

Guard regions: Boot Guard **IBB `0x700000..0x900000` byte-identical**; AMI v2 range
`0x0E0000..0x462C00` edited (expected) — its stored hash is **not** updated, which is
handled by the Boot Guard bypass (same as v02b…v05).

## Verification — three independent layers, all PASS
1. **Builder self-check** (`work\scripts\build_v06_all_in_one.py`): ReBarDxe present;
   `BootGuardDxe` = `31 C0 C3`; flips = SuppressIf 19 / GrayOutIf 1 / DisableIf 1;
   NVAR bytes set; IBB unchanged; **decompressed FV byte-identical to `v05_force_enable`**;
   **raw diff vs `v05` = exactly `{0x3DD, 0xD2A}`**; diff vs pristine confined to NVAR + the
   compressed container.
2. **L1** `work\scripts\verify_image.py`: `RESULT: PASS` (size OK, IBB UNCHANGED,
   `0x3DD=01`, `0xD2A=00`).
3. **L2** `extract_setup_body.py` + `IFRExtractor 1.6.1`: pristine IFR has 21 `True`
   operands / 0 `False`; combined has **0 `True` / 21 `False`**; the IFR diff is **only**
   those 21 lines (+ the header hash). Nothing else in Setup changed.

## Notes / caveats
- This is the **most aggressive** image (force-enable variant): it also enables the two
  items that were always greyed/disabled (incl. TPM-related controls). Sandbox only.
- Like every image here it needs a real flash to be validated; recover with a CH341A
  programmer + full 16 MB backup. See `mods\FLASHING.md`.
