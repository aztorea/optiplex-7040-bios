# optiplex-7040-bios

UEFI firmware research and modified-image builds for the **Dell OptiPlex 7040**
(AMI Aptos/Aptio-class firmware, version **1.24.0**), plus OS/hardware tuning notes.

This is a personal research repository. Everything here is **analysis and
sandbox-built images** unless explicitly stated. Nothing in this repo has been
flashed to real hardware by the author.

## Target hardware

| Item | Value |
|---|---|
| Machine | Dell OptiPlex 7040 |
| Chipset | Intel Q170 (Skylake / SPT-H) |
| CPU | Intel Core i7-6700 (Skylake, `0x506E3`, non-K) |
| ME/CSME | 11.8.92.4222 (FW 11.8.92.4189), Corporate H |
| Firmware | Dell BIOS 1.24.0 |
| GPU | NVIDIA RTX 3060 12 GB |

## Boot Guard status (important)

The firmware fuses are **provisioned in `Verified + Measured`** Boot Guard mode:

- All policy rows **Enabled**, mode **Verified + Measured**
- OEM Public Key Hash `A53EF0C178D288B02E61FD71FC31874E89F041FE9332BA2A787A97F7146FB06C`
- FPF HW Source: Original FPF HW Fuse Bank

Because of this, any modified **in-firmware-volume** image must be built on the
**W2b base** (Boot Guard bypass) or it will not boot.

## Warning — read before using anything here

- **Flashing modified firmware can permanently brick the machine.** A failed or
  invalid image can leave the system unable to POST.
- **Boot Guard bypass**: this repo documents how the `BootGuardDxe` enforcement
  path can be neutralized. This is included **for research and recovery only**,
  with this warning. It defeats a platform security feature. Use only on a
  machine you own, ideally a spare, with a hardware programmer backup on hand.
- **Always** take a full SPI flash backup with a **CH341A-style programmer**
  before flashing anything. Dell's own flasher (`OptiPlex_7040_1.24.0.exe`)
  rejects modified images because of its RSA signature.
- The original Dell installer and the pristine BIOS dump are kept **unmodified**
  for reference and verification.

## Repository layout

| Path | Contents |
|---|---|
| `*.md` | Living research docs (catalogue, plan, analysis, baseline) |
| `work\bios\` | Pristine BIOS baseline and extracted firmware analysis |
| `work\mods\` | Sandbox-built modified images + per-build `CHANGES.md` |
| `work\scripts\` | Python builders and verification tools |
| `tools\` | Third-party utilities used for analysis |
| `python_embeded\` | *Excluded from git* (large, reinstallable) |
| `tools\qemu\` | *Excluded from git* (large third-party binaries) |

## Build/verify tooling

- `python_embeded\python.exe` (Python 3.11) for `work\scripts\*.py`
- UEFIExtract / UEFITool NE / IFRExtractor / MEAnalyzer / BIOSUtilities (`tools\`)
- `work\scripts\verify_image.py` for offline (L1/L2) image verification

## License

MIT — see [LICENSE](LICENSE). Upstream components remain under their own
licenses; see the respective `tools\` directories.
