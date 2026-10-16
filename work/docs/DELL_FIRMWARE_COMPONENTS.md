# Dell Firmware Components — Deep Analysis

Source: `work\OptiPlex_7040_1_24_0.exe_extracted\Firmware\` (6 components extracted from
`OptiPlex_7040_1.24.0.exe`). Analysis-only; nothing is flashed.

---

## 1. System BIOS with BIOS Guard v1.24.0.bin

| | |
|---|---|
| Size | 9,437,184 B (`0x900000`) |
| SHA256 | `505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E` |
| Type | Full SPI BIOS region (not a full flash image — descriptor/ME/GbE are separate) |

This is the mod target. See `FIRMWARE_CATALOG.md` for the volume map and
`BIOS_UPGRADE_ANALYSIS.md` for the guard layout. "BIOS Guard" in the filename is
Dell's marketing label for the Boot Guard / BIOS Guard protected update path.

## 2. Gigabit Ethernet v0.8.bin — Intel I219 NVM

| | |
|---|---|
| Size | 8,192 B |
| Header | `FF FF FF FF FF FF 01 08 FF FF 84 00 8E 00 00 80` |
| Device/Vendor (LE @0x20) | `0x15B7` / `0x1028` (Dell subsystem) |

This is the **I219-LM GbE NVM/region** (flash descriptor region 3 shadow). It carries
the MAC-address area, PHY tuning and LAN config defaults. It is **not** part of the
BIOS region file — it lives in its own SPI descriptor region and is flashed separately.

**Opportunities**
- Custom MAC address / Dell "LAN config" strings (region is normally write-protected by
  the GbE region lock and the descriptor).
- Vendor/device IDs and subsystem can be read here — useful for OS NIC quirk work.
- Not a realistic modification target without SPI programmer + descriptor unlock.

## 3. Intel Management Engine (VPro) Update v11.8.92.4222.bin

| | |
|---|---|
| Size | 7,348,224 B (`0x702000`) |
| Version | CSME 11.8.92.4222, Corporate H, Production |
| Fit | Present (FIT table + ME config) |

Corporate/vPro SKU — **AMT remote management is enabled in silicon**, gated by NVRAM.

**Opportunities** (see UpgradeList §J)
- ME firmware is updatable to later 11.8.x if Dell ships it (OEM-signed only; can't be
  hand-built for this board safely).
- AMT/vPro provisioning (KVM, remote power) — feature-rich on this SKU; enable via
  MEBx (`Ctrl-P`) or Setup AMT form `0x272B` if the board exposes it.
- **Security posture:** ME is a persistent, out-of-band agent. `me_cleaner`-style
  trimming is *not* advisable on a Corporate H image (AMT/network stack needed) and is
  blocked by Boot Guard on the BIOS side anyway. Treat ME as unmodifiable.

## 4. System Map v1.0.1.bin — **140-byte measurement manifest**

| | |
|---|---|
| File size | 112 B |
| Magic | `49 57 41 50` = ASCII **"IWAP"** (little-endian "PAWI" — Dell internal) |
| Version fields | `31 2E 32 34` = **"1.24"** (BIOS version) |

Annotated layout:

```
off  bytes                                      meaning
0x00 49 57 41 50                                "IWAP" magic
0x04 70 00 00 00                                = 0x70 (112) length
0x08 01 B0 00 01 B9 06 00 00                    flags / model number 0x06B9
0x10 31 2E 32 34 03 02 20 00 02 00 00 00        "1.24" + version struct
...
0x30 3A 5C 91 FE EA AA 9F A2 92 E5 8C F8 C1 F5 B3 C4
     00 69 7B 34 5C 17 D3 0C FC E5 52 1F 6E C4 3E 92  <- SHA256 A (32 B)
0x50 05 4B E3 01 69 1C 07 92 41 C0 A6 23 F9 8C 37 03
     50 FB 48 C9 71 AD E9 02 2A 7D 6D E6 B7 BC BF CC  <- SHA256 B (32 B)
```

- **SHA256 A = the PCR0 `FV_DXE_PCR0_SHA256`** from the PCR0 XML
  (`3A5C91FE…1F6EC43E92`). Confirms the System Map is the runtime side of the same
  measured-boot manifest that the XML describes.
- **SHA256 B = `054BE301…BFCC`** — a second measured component (not the AMI v2 range
  hash `6C8E1C15…` nor the IBB hash `F41A1C24…`). Likely a *post-boot* DXE volume
  digest used by Dell's measured-boot/Integrity flow.
- Significance: Dell **internally measures a DXE volume at boot**. This is the strongest
  single piece of evidence that the platform runs in **Measured (or Verified+Measured)**
  Boot Guard profile and that any DXE-volume edit is *detected* (and may be refused).

**Opportunity / caution:** this is the reason a naive BIOS-region edit is high-risk —
the change is visible to the measurement chain even if it boots. See UpgradeList §Q.

## 5. PCR0 XML v0.0.0.1.xml — Dell measured-boot manifest

| | |
|---|---|
| Model | `OptiPlex 7040`, ModelNumber `0x06B9`, VersionBuild `1.24.0` |
| RIM | v17 |
| `FV_DXE_PCR0_SHA256` (b64) | `OlyR/uqqn6KS5Yz4wfWzxABpezRcF9MM/OVSH27EPpI=` = `3A5C91FE…1F6EC43E92` |
| SHA1 | `5B84933C9453F80E2AB3F8C0160B3B3C9DF25379` |

Declares a component (`ComponentID`) whose digest is extended into **PCR0** at boot by
Dell's measured-boot code (the "Boot Guard Debug Measured S-CRTM" path seen in PEI
vol 7). This is Dell's implementation of **DTPM/Intel Boot Guard measured boot for
auditing**, independent of Windows' own measured boot into PCRs 4–7.

**Implication:** PCR0 will change if the measured DXE volume changes. On a Verified-fused
board, a mismatch can block boot; on a Measured-fused board it only records a mismatch.
Determining which requires runtime MSR `0x13A` read (not available from the file).

## 6. Model Information v1.0.0.0.txt

85-byte plaintext descriptor of the model (name/ID/build). Cosmetic/reference only.

---

## Freeform files (48 total across the BIOS region)

Freeform FFS files are raw OEM blobs without a standard type. Notable volumes:
- **vol 3** `E34AEDB0-BB97-49BC-B139-1E419B3560E2`: 1 Freeform `F6405581-…`.
- **vol 4** `FD44D4FE-239B-4C57-B96D-E47E066A50A3`: **12 Freeform** = **NVRAM external
  defaults** (the "default store" that feeds `Setup` varstore defaults at first boot).

These are the highest-value NVRAM target: the true baked-in defaults (as opposed to the
IFR `default` opcodes) live here. Parsing them yields the factory default for every
`EC87D643` question (see `work\docs\NVRAM_DEFAULTS.md`, pending).

---

## Summary of new findings (this pass)

| # | Finding |
|---|---|
| F-1 | System Map is a **measured-boot manifest**, not just metadata: it embeds the exact PCR0 SHA256. |
| F-2 | A **second measured DXE digest** (`054BE301…BFCC`) exists in the System Map. |
| F-3 | Dell performs **internally measured DXE-volume boot** (PEI vol 7 S-CRTM path) — any DXE edit is measurable. |
| F-4 | GbE is a standalone **Intel I219 NVM region** (8 KB), not part of the BIOS file. |
| F-5 | ME is **Corporate H / vPro** — AMT is present in silicon, gated by NVRAM/MEBx. |
| F-6 | Model number `0x06B9`, version string "1.24" repeat across System Map / PCR0 XML / Model Info. |
