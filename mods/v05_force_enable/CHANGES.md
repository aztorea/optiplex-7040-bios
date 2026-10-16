# v05_force_enable — every constant-true guard flipped (max unlock), on W2b

## Summary
Most aggressive unlock. Same W2b base, and the IFR step flips **all 21**
constant-`True` condition guards in the Setup IFR:
- 19× `SuppressIf` (hide → show)
- 1× `GrayOutIf` (always-gray → selectable)
- 1× `DisableIf` (always-disabled → enabled)

`v04_hidden_opts` + the two always-gray/always-disable items. Offline sandbox
build only — never flashed.

## Artifact
- Image:    `mods\v05_force_enable\System_BIOS.bin`
- Size:     9437184 (0x900000) — unchanged
- SHA256:   `0FB733355040108E6CA6CCC408A4EA6EEE5A86021ECB4938E1B8295D7D52EE63`
- Baseline: `work\bios\System_BIOS.bin`
- Builder:  `work\scripts\build_wave5_force_enable.py`

## Change 1/2 — W2b base
`BootGuardDxe` worker RVA `0x1070` → `31 C0 C3` (dec `0x1E2494`); `ReBarDxe.ffs`
(2578 B) at dec `0x84B5E0`.

## Change 3 — flip all 21 constant-true guards
True=`0x46` → False=`0x47`, same length. Guard bytes = `<opcode> 82 46 02`:

| opcode | name | count | effect |
|---|---|---|---|
| `0A` | SuppressIf | 19 | reveals hidden menus + options (see `v04_hidden_opts\CHANGES.md`) |
| `19` | GrayOutIf | 1 | dec `0x125357` (body `0x32EDF`) → OneOf "TPM Owner Status" now selectable |
| `1E` | DisableIf | 1 | dec `0x13DA46` (body `0x4B5CE`) → Numeric qid `0x9F5` now enabled |

## Bytes changed (raw image)
- 2,430,174 bytes differ from baseline, all within `0x104748..0x358184`
  (recompression); stream is −6186 B and 0x00-padded to the original length.

## Verification performed
1. **Self-verify** (`build_wave5_force_enable.py`): liblzma round-trip (`eof`);
   `ReBarDxe` present; BG site `31 C0 C3`; asserts 0 guards of any kind remain
   `True`. `SuppressIf False=19`, `GrayOutIf False=1`, `DisableIf False=1`.
2. **L1** (`verify_image.py`): size OK; IBB `0x700000..0x900000` **UNCHANGED**;
   AMI range changed as expected. **RESULT: PASS**.
3. **L2** (re-extract + IFRExtractor): **`True { 46 02 }` guards = 0**;
   **`False { 47 02 }` = 21**. Re-extracted body SHA256 `79F52EA0…3161D2`.

## Reproduce
```
python_embeded\python.exe work\scripts\build_wave5_force_enable.py
python_embeded\python.exe work\scripts\verify_image.py mods\v05_force_enable\System_BIOS.bin
```

## Notes / risk
- Highest-risk variant: exposes and enables everything the firmware hides,
  including TPM Owner Status / Kill TPM / Vendor Keys and internal Numerics.
  Sandbox only; recover with CH341A.
- Same Boot Guard model + caveats as `v02b_rebar_bgbypass`.
