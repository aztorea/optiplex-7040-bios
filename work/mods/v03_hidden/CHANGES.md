# v03_hidden — Wave 3: hidden Setup menus unlocked (on top of W2b)

## Summary
Three changes, all inside the nested DXE FV `5C60F367-…` (compressed into FFS
file `9E21FD93-…`):
1. **Neutralize** `BootGuardDxe` (W2b) — worker RVA `0x1070` → `xor eax,eax; ret`.
2. **Insert** `ReBarDxe` (W2b) into FV free space.
3. **Unlock** the hidden Setup menus by flipping the `SuppressIf` constant-guard
   expression from `True` (`0x46`) to `False` (`0x47`).

Offline sandbox build only — **never flashed**.

## Artifact
- Image:     `work\mods\v03_hidden\System_BIOS.bin`
- Size:      9437184 (0x900000) — unchanged
- SHA256:    `4615B33378B36ED51D8AE14068982A518FDF2409D2ACA2C50C3DE9A806B38E60`
- Baseline:  `work\bios\System_BIOS.bin` (sha256 `505D5F19…B5968E`)

## Change 1 — BootGuardDxe neutralization (W2b)
Identical to `v02b_rebar_bgbypass`: 3 bytes at dec `0x1E2494`
`40 53 48` → `31 C0 C3`. See that variant's `CHANGES.md`.

## Change 2 — ReBarDxe insert (W2b)
Identical to `v02b_rebar_bgbypass`: `tools\ReBARUEFI_0.3\ReBarDxe.ffs`
(2578 B) written at dec `0x84B5E0` (FV free space, was 0xA30 → 30 B free left).

## Change 3 — Hidden menu unlock (decompressed FV)
The Setup driver `899407D7-99FE-43D8-9A21-79EC328CAC21` (FFS FV offset
`0xF2450`, body FV offset `0xF2468`, body size `0xB625E`=746078 B) embeds its IFR
(FormPackage at body `0x29CC4`, len `0x229B5`). Whole menus are hidden behind
`SuppressIf` wrapping a constant `True` expression. UEFI opcodes: `SUPPRESS_IF`
=`0x0A`, `TRUE`=`0x46`, `FALSE`=`0x47`; the guard bytes are `0A 82 46 02`
immediately before the `Ref`. Flipping the `0x46`→`0x47` (True→False) makes the
suppression never fire, revealing the referenced menu. Same length.

| menu (Ref FormId) | title | guard @ body | byte flipped @ body | dec |
|---|---|---|---|---|
| `0x2712` | Advanced | `0x2A43C` | `0x2A43E` | 0x11C8B6 |
| `0x2713` | Chipset | `0x2A451` | `0x2A453` | 0x11C8CB |
| `0x2714` | Security | `0x2A466` | `0x2A468` | 0x11C8E0 |
| `0x80A0` | Advanced configurations (Dell) | `0x2A5DC` | `0x2A5DE` | `0x11CA56` |
| `0x2816` | ASPM | `0x2B5E8` | `0x2B5EA` | `0x11DA62` |

(`dec = body + 0xF2478`.) All five flips are `0x46 → 0x47`.

The image has **19** `0A 82 46 02` guards total; the other 14 wrap individual
questions/options (`ONE_OF`, `CHECKBOX`, `NUMERIC`, `GRAY_OUT_IF`, nested
`SUPPRESS_IF`) and are left untouched here — see the maximal `v04_hidden_opts`
variant which flips all 19.

## Bytes changed (raw image)
- 2,430,200 bytes differ from baseline, all within `0x104748..0x358184`
  (FVMAIN LZMA payload; dominated by recompression output).
- Recompressed stream is **smaller** (−6332 B) and 0x00-padded back to the
  original section length; no container size changed.

## Verification performed
1. **In-script self-verify** (`work\scripts\build_wave3_hidden.py`): re-extracts
   the rebuilt section, streams it through liblzma (asserts `eof`), then confirms
   (a) `ReBarDxe` GUID present, (b) BG site reads `31 C0 C3`, (c) all 5 menu
   guards read `0x47`. **OK**.
2. **L1 structural verifier** (`work\scripts\verify_image.py`): size OK; IBB guard
   `0x700000..0x900000` **UNCHANGED**; AMI guard `0xE0000..0x462C00` changed as
   expected. **RESULT: PASS** (exit 0).
3. **L2 semantic verifier** — re-extract the patched Setup body
   (`work\scripts\extract_setup_body.py`) and re-run IFRExtractor 1.6.1
   (`verbose`). Result: the constant-guard expressions now number **True=15 /
   False=5**; each of the five target menus reads
   `SuppressIf { 0A 82 }` → `False { 47 02 }` → `Ref … FormId: <target>`, i.e.
   **visible**. Patched body SHA256 `e0b39cb1…5efa32`.

## Reproduce
```
python_embeded\python.exe work\scripts\build_wave3_hidden.py
python_embeded\python.exe work\scripts\verify_image.py work\mods\v03_hidden\System_BIOS.bin
```

## Open risk (NOT hardware-verified)
- Same Boot Guard enforcement model caveats as `v02b_rebar_bgbypass` (software
  guard, no SMM re-check, recover with CH341A).
- Unlocking "Advanced"/"Chipset"/"Security" exposes AMI reference forms; a form
  referencing an uninitialised varstore could misbehave in the Setup UI. Left as
  the aggressive Dell `0x80A0` / `0x2816` too for completeness.
