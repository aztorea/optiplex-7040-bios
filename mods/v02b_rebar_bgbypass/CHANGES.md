# v02b_rebar_bgbypass — Wave 2b: ReBarDxe insert + `BootGuardDxe` neutralization

## Summary
Two changes, both inside the main compressed DXE volume (file `9E21FD93`):
1. **Insert** the ReBARUEFI `ReBarDxe` DXE driver (same as `v02_rebar`).
2. **Neutralize** the AMI DXE-integrity enforcer `BootGuardDxe`
   (`1DB43EC9-DF5F-4CF5-AAF0-0E85DB4E149A`) by replacing the entry of its worker
   (RVA `0x1070`) with `xor eax,eax; ret`, so the stale AMI FV hash no longer
   arms its "Boot Guard verified failed / System will shutdown" path.

Offline sandbox build only — **never flashed**. Rationale: `WAVE_PLAN.md` §4.1.
The Intel ACM only hardware-verifies the **IBB (vol7)**, which is left byte-identical;
`BootGuardPei` only sets a flag and the only halting actor is this DXE driver.

## Artifact
- Image:            `mods\v02b_rebar_bgbypass\System_BIOS.bin`
- Size:             9437184 (0x900000) — unchanged
- SHA256:           `BA464B00EAFEE31D141CFD810E0857CC0963C6A98B290083EBDCA34E9E359D5D`
- Baseline:         `work\bios\System_BIOS.bin` (sha256 `505D5F19…B5968E`)
- Injected file:    `tools\ReBARUEFI_0.3\ReBarDxe.ffs` (2578 bytes, GUID
                    `A8EE1777-A4F5-4345-9DA4-13742084D31E`, type 07, attrs 0x40)

## Container chain touched (physical offsets)
| object | raw offset | note |
|---|---|---|
| FFS file `9E21FD93-9C72-4C15-8C4B-E77F1DB2D792` | 0x104550 | size 0x253C35 (unchanged) |
| GUID section `EE4E5898-3914-4259-9D6E-DC7BD79403CF` (LZMA) | 0x104568 | size 0x253C1D (unchanged) |
| 4-byte AMI prefix `18 00 01 00` | 0x10457C | preserved |
| LZMA_ALONE stream payload | 0x104580 .. 0x358184 | **recompressed** |

Inside the decompressed 0x84C010 payload, the nested FV
`5C60F367-A505-419A-859E-2A4FF6CA6FE5` (len 0x84C000) is at offset 0x10.

## Change 1 — BootGuardDxe neutralization (decompressed FV)
- Module `1DB43EC9-…` FFS file at dec `0x1E1FF0` (type 07, size 0xE42); PE32
  section at dec `0x1E2020`; PE32 image at dec `0x1E2024`; `.text` RVA `0x1000`
  → `0x1400` (raw 0x400).
- Worker at **RVA `0x1070`** = dec **`0x1E2494`**. Original code (`push rbx;
  sub rsp,0x40; …`) builds the config GUIDs, reads MSR `0x13A` (bit 32), locates
  the AMI config table, then creates an `EVT_NOTIFY_SIGNAL` event with
  NotifyFunction RVA `0x11C4` and `RegisterProtocolNotify`s it — that notify is
  what prints the failure text and halts.
- **Patched 3 bytes** at dec `0x1E2494`:

  | | bytes | meaning |
  |---|---|---|
  | before | `40 53 48` | `push rbx` ; `sub rsp,0x40…` |
  | after  | `31 C0 C3` | `xor eax,eax` ; `ret` |

  The worker now returns `0` (EFI_SUCCESS) immediately and never registers the
  shutdown notify. The module entry (`0x1000`), which caches the table pointers
  and calls `0x1280`/`0x1070`, is left intact; the return stack stays balanced.

## Change 2 — ReBarDxe insert (decompressed FV)
- Written at the start of FV free space, dec offset **`0x84B5E0`** (= FV offset
  0x84B5D0 + 0x10); free space was 0xA30 (2608) bytes, all 0xFF; the remaining
  30 bytes stay 0xFF (identical to `v02_rebar`).

## Bytes changed (raw image)
- 2,430,342 bytes differ from baseline, **all within `0x104748..0x358184`** (the
  FVMAIN LZMA payload; byte diffs are dominated by recompression output).
- No container size changed; file/section/parent and all following vol5 files are
  byte-identical; the recompressed stream is smaller and 0x00-padded back to the
  original section length.

## Verification performed
1. **In-script self-verify** (`work\scripts\build_wave2b_bg_bypass.py`): re-extracts
   the rebuilt section, restores the unknown-size header, streams it through liblzma
   (asserts `eof`), then confirms (a) the ReBarDxe GUID is present and (b) the patch
   site at dec `0x1E2494` reads `31 C0 C3`.
2. **L1 structural verifier** (`work\scripts\verify_image.py`): size OK; IBB guard
   `0x700000..0x900000` **UNCHANGED**; AMI guard `0xE0000..0x462C00` changed as
   expected; diff confined to the section payload; **RESULT: PASS** (exit 0).

## Hash-policy note
The stored AMI v2 hash at `0x7B93F4` is now stale (`53AED210…D0FDFC` vs stored
`6C8E1C15…3098`) — this is *intended*: the neutralized `BootGuardDxe` no longer
consumes it. The IBB (vol7), FIT, ACM, BPM and Key Manifest are all byte-identical,
so the Intel Boot Guard hardware chain still verifies. If Boot Guard is **not**
provisioned, `BootGuardDxe` was already a no-op (MSR `0x13A` bit 32 clear), so this
patch is inert and equally safe.

## Open risk (NOT yet hardware-verified)
- Assumes `BootGuardDxe` is the *sole* consumer of BootGuardPei's flag and that no
  SMM verifier exists (the Black Hat component `VerifyFwBootGuard EE89F590` is
  **absent** from this image). Not validated on silicon → recover with CH341A.
- The patch itself is inside the AMI range; if some other path re-hashes it, the
  image would not boot. Kept as its own variant + L1 gate for that reason.

## Reproduce
```
python_embeded\python.exe work\scripts\build_wave2b_bg_bypass.py
python_embeded\python.exe work\scripts\verify_image.py mods\v02b_rebar_bgbypass\System_BIOS.bin
```
