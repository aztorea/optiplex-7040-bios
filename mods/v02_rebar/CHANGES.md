# v02_rebar — Wave 2: insert ReBarDxe (Resizable BAR) DXE driver

## Summary
Adds the ReBARUEFI `ReBarDxe` DXE driver to the main compressed DXE
firmware volume so the platform can expose resizable PCIe BARs (with
Above 4G decoding, which Wave 1 enables). Offline sandbox build only —
**never flashed**.

## Artifact
- Image:            `mods\v02_rebar\System_BIOS.bin`
- Size:             9437184 (0x900000) — unchanged
- SHA256:           `F696E8D23FD914C845580A1F4D178566218CC624CF9AF50D1F4866E195280696`
- Baseline:         `work\bios\System_BIOS.bin` (sha256 `505D5F19…B5968E`)
- Injected file:    `tools\ReBARUEFI_0.3\ReBarDxe.ffs` (2578 bytes,
                    GUID `A8EE1777-A4F5-4345-9DA4-13742084D31E`, type 0x07
                    DXE_DRIVER, attrs 0x40)

## Container chain touched (physical offsets in the raw image)
| object | raw offset | note |
|---|---|---|
| FFS file `9E21FD93-9C72-4C15-8C4B-E77F1DB2D792` | 0x104550 | size 0x253C35 (unchanged) |
| GUID section `EE4E5898-3914-4259-9D6E-DC7BD79403CF` (LZMA) | 0x104568 | size 0x253C1D (unchanged) |
| 4-byte AMI prefix `18 00 01 00` | 0x10457C | preserved |
| LZMA_ALONE stream payload | 0x104580 .. 0x358184 | **recompressed** |

Inside the decompressed 0x84C010 payload, the nested FV
`5C60F367-A505-419A-859E-2A4FF6CA6FE5` (len 0x84C000) lives at offset 0x10;
its trailing free space was at FV offset **0x84B5D0** (0xA30 = 2608 bytes,
8-aligned, all 0xFF — matches UEFITool). `ReBarDxe.ffs` was written at the
start of that free space (dec offset 0x84B5E0); the remaining 30 bytes stay
0xFF.

## Bytes changed
- 2,430,470 bytes differ from baseline, **all within `0x104748..0x358184`**
  (the FVMAIN LZMA compressed payload). Every other region is byte-identical.
- No container size changed: file, section, parent FV and all following
  vol5 files are byte-identical; the recompressed stream is 6,455 bytes
  smaller and padded back to the original section length with 0x00.

## LZMA format notes (important)
- Vendor stream = standard LZMA_ALONE with a **known** uncompressed size
  (0x84C010) and **no** end-marker. Prefixed by AMI's constant 4-byte
  `18 00 01 00`.
- EDK2 `LzmaDecompress.c` (`GetDecodedSizeOfBuf`) requires a known size in
  bytes 5..12 (an "unknown" 0xFFFF… header returns RETURN_UNSUPPORTED).
- liblzma (Python `lzma`) always emits a marker + unknown-size header, so
  the stream is recompressed and the header size field is patched to the
  true length. The EDK2 SDK decoder (`LZMA_FINISH_END`) tolerates the
  trailing marker and returns before any padding; the extra 0x00 padding
  after the marker is therefore never read.

## Verification performed
1. **In-script self-verify** (`work\scripts\build_wave2_rebar.py`):
   - re-extracts the rebuilt section, restores the unknown-size header,
     decompresses with a streaming LZMA decoder, confirms `eof` (marker
     reached) and that the output equals the intended decompressed image;
   - confirms the ReBarDxe GUID is present at dec offset 0x84B5E0;
   - confirms every changed decompressed byte lies within the FV free
     space region [0x84B5E0, 0x84B5E0+0xA30);
   - confirms section/file size fields are unchanged.
2. **L1 structural verifier** (`work\scripts\verify_image.py`):
   - size OK; IBB guard `0x700000..0x900000` UNCHANGED (0 bytes);
   - AMI guard `0xE0000..0x462C00` CHANGED as expected;
   - raw diff confined to 0x104748..0x358184 (inside the section payload);
   - RESULT: PASS.

## Open risk (NOT yet resolved)
This is the **first edit inside the AMI v2 protected range**
(`0xE0000..0x462C00`). The stored AMI hash at `0x7B93F4` is now stale:

```
stored in image      : 6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098
recomputed in image  : 685BAEE8291A9A62C803E52C1D6A94764738372557D79276AFB7CE59B2750463
```

Whether AMI/Boot Guard enforces this hash at boot is **not yet
characterized**. Until it is, this image must not be flashed. Boot-Guard
IBB is untouched, so the Boot Guard measured path is unaffected; the
concern is AMI's own firmware-volume hash/verification path.

## Reproduce
```
python_embeded\python.exe work\scripts\build_wave2_rebar.py
python_embeded\python.exe work\scripts\verify_image.py mods\v02_rebar\System_BIOS.bin
```
