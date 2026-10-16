# v04_hidden_opts — hidden *options* unlocked (all SuppressIf guards), on W2b

## Summary
Maximal-unlock sibling of `v03_hidden`. Same three change classes, but the IFR
step flips **every** constant-`True` `SuppressIf` guard in the Setup IFR — the 5
menu refs **and** the 14 option-level guards. Offline sandbox build only — never
flashed.

## Artifact
- Image:     `work\mods\v04_hidden_opts\System_BIOS.bin`
- Size:      9437184 (0x900000) — unchanged
- SHA256:    `CE616B15BD78C8BFBD40ACD22BF917696EBEEBB8E44E85C12C118E37903AEC93`
- Baseline:  `work\bios\System_BIOS.bin` (sha256 `505D5F19…B5968E`)
- Builder:   `work\scripts\build_wave4_hidden_opts.py`

## Change 1 — BootGuardDxe neutralization (W2b)
3 bytes at dec `0x1E2494` `40 53 48` → `31 C0 C3`. (See `v02b_…\CHANGES.md`.)

## Change 2 — ReBarDxe insert (W2b)
`tools\ReBARUEFI_0.3\ReBarDxe.ffs` (2578 B) at dec `0x84B5E0`.

## Change 3 — Unlock all 19 `SuppressIf True` guards
Setup driver `899407D7-…` IFR: guard bytes `0A 82 46 02` (SuppressIf + True).
Flip the `0x46`→`0x47` (True→False). Same length. Body base = `0xF2468` (FV),
so `body = dec − 0xF2478`.

| # | guard @ body | dec | wraps (next opcode) |
|---|---|---|---|
| 1 | 0x2A43C | 0x11C8B4 | Ref → Advanced `0x2712` |
| 2 | 0x2A451 | 0x11C8C9 | Ref → Chipset `0x2713` |
| 3 | 0x2A466 | 0x11C8DE | Ref → Security `0x2714` |
| 4 | 0x2A5DC | 0x11CA54 | Ref → "Advanced configurations" `0x80A0` |
| 5 | 0x2B5E8 | 0x11DA60 | Ref → ASPM `0x2816` |
| 6 | 0x2CE9C | 0x11F314 | OneOf "Boot List" |
| 7 | 0x2F129 | 0x1215A1 | GrayOutIf (nested) |
| 8 | 0x2F322 | 0x12179A | GrayOutIf (nested) |
| 9 | 0x2F373 | 0x1217EB | OneOf "TPM Owner Status" |
| 10 | 0x2F3C1 | 0x121839 | CheckBox "Kill TPM" |
| 11 | 0x2F8E0 | 0x121D58 | CheckBox (qid 0xF7) |
| 12 | 0x300C7 | 0x12253F | CheckBox (qid 0x104) |
| 13 | 0x33270 | 0x1256E8 | Numeric (qid 0x18C) |
| 14 | 0x337A7 | 0x125C1F | SuppressIf (nested) |
| 15 | 0x37EBF | 0x12A337 | GrayOutIf (nested) |
| 10b | 0x38051 | 0x12A4C9 | GrayOutIf (nested) |
| 17 | 0x3880C | 0x12AC84 | SuppressIf (nested) |
| 18 | 0x39056 | 0x12B4CE | OneOf "ALS Support" |
| 19 | 0x4B012 | 0x13D48A | OneOf "Vendor Keys" |

`unlock_all()` asserts the guard byte is `0x46` before flipping; the build reports
**19** flips.

## Bytes changed (raw image)
- 2,430,162 bytes differ from baseline, all within `0x104748..0x358184`.
- Recompressed stream is smaller (−6182 B), 0x00-padded back; no size change.

## Verification performed
1. **In-script self-verify**: liblzma round-trip (`eof` asserted); `ReBarDxe`
   present; BG site = `31 C0 C3`; **0** `0a 82 46 02` remain, **19** `0a 82 47 02`.
2. **L1** (`verify_image.py`): size OK; IBB `0x700000..0x900000` **UNCHANGED**;
   AMI range changed as expected. **RESULT: PASS**.
3. **L2** — re-extract Setup body (`work\scripts\extract_setup_body.py`) +
   IFRExtractor 1.6.1 `verbose`: all 19 `SuppressIf` guards now show
   `False { 47 02 }`. The only remaining `True { 46 02 }` expressions (2) are a
   `GrayOutIf` and a `DisableIf` (always-gray/always-disable), **not** `SuppressIf`
   — left untouched. Re-extracted body SHA256 `F0E3C8BA…1BB418`.

## Reproduce
```
python_embeded\python.exe work\scripts\build_wave4_hidden_opts.py
python_embeded\python.exe work\scripts\verify_image.py work\mods\v04_hidden_opts\System_BIOS.bin
```

## Notes / risk
- Reveals normally-hidden/option-locked settings (TPM Owner Status, Kill TPM,
  Vendor Keys, Boot List, ASPM, ALS, etc.). Sandbox image only; recover with CH341A.
- Same Boot Guard model + caveats as `v02b_rebar_bgbypass`.
