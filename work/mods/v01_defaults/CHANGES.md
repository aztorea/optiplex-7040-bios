# v01_defaults — change record

## Summary
Modified Dell OptiPlex 7040 BIOS region (1.24.0) to bake new **defaults**:
- **Above 4G MMIO/Decode**: Disabled → **Enabled** (`Setup` offset `0x355`: `0x00` → `0x01`)
- **CSM**: Enabled → **Disabled** (`Setup` offset `0xCA2`: `0x01` → `0x00`)

## Files
| file | sha256 |
|---|---|
| `work\mods\original\System_BIOS.bin` (pristine) | `505d5f1971ba11f577a10fd16cb1bc52248be5c678e40e5049024ac367b5968e` |
| `work\mods\v01_defaults\System_BIOS.bin` (patched) | `187be662567c7123a27c74685f80ffaa75c7de62b975fd74c53c1e1bb7f25925` |

## Exact edits (file offsets, 9,437,184 B image)
| file offset | meaning | old | new |
|---|---|---|---|
| `0x0003DD` | `StdDefaults\Setup` data `+0x355` → Above 4G | `0x00` | `0x01` |
| `0x000D2A` | `StdDefaults\Setup` data `+0xCA2` → CSM | `0x01` | `0x00` |

Only these two bytes differ from the original.

## Location / why it's safe
- The target is the `Setup` variable inside the nested NVAR store of the **`StdDefaults`** variable that lives in the **vol0 NVAR store**:
  - vol0 FFS RAW file `CEF5B9A3-…` at file `0x48`, data at `0x60`.
  - Top-level NVAR entry `StdDefaults` @ `0x60`, size `0x1572` (5490), data @ `0x77` (5467 B).
  - Nested store inside it @ `0x77`; `Setup` entry @ `0x77`, size `0x1351` (4945), **data @ `0x88`** (4928 B = `0x1340`).
- **vol0 = file `0x000000..0x040000`**, which is **outside both integrity guards**:
  - AMI v2 protected range `0x0E0000..0x462C00` — untouched (verified).
  - Boot Guard IBB `0x700000..0x900000` — untouched (verified).
- **No checksums to recompute:**
  - Containing FFS file has `IntegrityCheck.File = 0xAA` (no file checksum) and `Attributes = 0x00`.
  - The FV header checksum covers only the FV header, not file bodies.
  - NVAR entry metadata bytes (`FF FF FF 83 NN`, `NN`=per-variable index) are constant/identifiers, not data checksums.

## Verification performed
`work\scripts\patch_v01_defaults.py` asserts:
- source sha == baseline
- sha256(`0x0E0000..0x462C00`) == stored AMI v2 value `6c8e1c15…` **before and after** the edit
- IBB region `0x700000..0x900000` byte-identical before/after
- exactly 2 bytes differ from original

## Known caveats / notes
- This edits the **baked defaults** (`StdDefaults`). Live NVRAM is seeded from these on NVRAM reset / first boot / "Load Setup Defaults". A one-time CMOS/NVRAM reset (or load-defaults) may be required for the change to take effect after flashing.
- A **second identical copy** of this Setup varstore exists at file `0x86C098` (inside the Boot Guard IBB — the boot block's recovery default). It is **Boot Guard protected and left unmodified**; it only matters during recovery.
- This is a **BIOS region only** edit — descriptor / ME / GbE regions are untouched.
- **Not flashed.** Sandbox artifact only.

## Scripts
- `work\scripts\parse_nvar.py` — list vol0 top-level NVAR entries
- `work\scripts\parse_nvar_nested.py` — parse nested store inside `StdDefaults`
- `work\scripts\patch_v01_defaults.py` — apply + verify the edit
