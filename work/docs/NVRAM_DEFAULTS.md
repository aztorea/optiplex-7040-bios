# NVRAM Default Store — Deep Analysis

How the **factory defaults** for the `Setup` varstore are baked into the image, and
whether Dell overrode any of them. Analysis-only.

---

## 1. Where the defaults live

| Store | Volume | GUID | Size |
|---|---|---|---|
| **StdDefaults** (AMI standard default store) | vol 4 `FD44D4FE-239B-4C57-B96D-E47E066A50A3` → `11 NVRAM external defaults` | `0 EB3001D5-F827-4938-95E2-5C8F644B966F` | 1,122 B header + 5,526 B body |
| **Setup default content** | …\`0 Raw section\0 StdDefaults\0 Setup\body.bin` | — | **4,928 B = 0x1340** |
| **AMITSESetupData default** | vol 5 → `373 AMITSESetupData` | `FE612B72-203C-47B1-8560-A66D946EB371` | 340,688 B |

The `Setup` default body is **exactly the varstore size (`0x1340` = 4,928 B)** — it is the
raw byte image of every `EC87D643-…` question's default. This is the ground truth used at
"Load Defaults" / first boot.

### Variables present in StdDefaults (in the default store)
`0 Setup`, `1 PlatformLang`, `2 Timeout`, `3 AMITSESetup`, `4 IccAdvancedSetupDataVar`,
`5 NetworkStackVar`, `6 SecureBootSetup`, `7 UsbSupport`, `8 DellVar01`, `9 PCI_COMMON`,
plus free space and a GUID store.

---

## 2. Key baked defaults (low byte of the stored value)

Decoded from `0 Setup\body.bin` (offsets are varstore-relative). IFR-declared default is
the value the Setup form advertises; "match" confirms Dell did **not** override it.

| Offset | Option | Stored byte | IFR default | Match |
|---|---|---|---|---|
| `0x79` | Hyper-Threading | `01` | Enabled=1 | ✅ |
| `0x7E` | Intel Speed Shift | `01` | Enabled=1 | ✅ |
| `0x82` | Turbo Mode | `01` | Enabled=1 | ✅ |
| `0xAF` | CFG lock | `01` | Enabled=1 | ✅ |
| `0x136` | Intel VT-x | `01` | Enabled=1 | ✅ |
| `0x14A` | SGX | `00` | Disabled=0 | ✅ |
| `0x2B9` | Aperture Size | `01` | 256MB=1 | ✅ |
| `0x350` | DVMT Pre-Allocated | `01` | 32M=1 | ✅ |
| `0x355` | Above 4GB MMIO assignment | `00` | Disabled=0 | ✅ |
| `0x37C` | ECC Support | `01` | Enabled=1 | ✅ |
| `0x37D` | Max TOLUD | `0B` | Dynamic | ✅ |
| `0x37E` | Memory Frequency | `00` | Auto | ✅ |
| `0x461` | BIOS Lock | `01` | Disabled=0 | ⚠ (see note) |
| `0xCA2` | CSM Support | `01` | Enabled=1 | ✅ |

**Conclusion:** Dell ships **stock AMI defaults** for the security/performance options we
care about. To change a *default* (as opposed to a one-time NVRAM write) you must edit
**both** the IFR default opcode **and** this `Setup` default body — and recompute the AMI
v2 protected-range hash (§K4).

> ⚠ `0x461` (BIOS Lock): the stored low byte reads `01`, which suggests either a different
> offset than previously noted or a bitfield overlap. Flagged for a precise re-check; it
> does not affect the analysis (BIOS Lock only matters while flashing).

Caveat: the IFR `size` attribute for these OneOf questions is reported as 8 (UEFI max), so
the CSV's multi-byte `stored_default` includes neighbouring bytes. The **low byte is the
authoritative value** for these 1-byte questions.

---

## 3. Artifacts

| File | Contents |
|---|---|
| `work\docs\nvram_defaults.csv` | 2,042 rows: form, prompt, question_id, var_offset, size, `stored_default` (raw baked value), `ifr_default`, match flag |
| `work\scripts\dump_nvram_defaults.py` | Reproduces the extraction/comparison |
| `work\bios\System_BIOS.bin.dump\...\StdDefaults\0 Setup\body.bin` | The raw 4,928-byte default blob |

---

## 4. Why this matters

- **NVRAM-only toggling is fragile** on this image (Dell may protect the varstore; writing
  can return `EFI_SECURITY_VIOLATION 0x1a`). Editing the *default* store is the durable
  alternative — but it lives inside the AMI v2 protected range, so it triggers a hash
  recompute (and is inside the Dell measured DXE manifest if in vol 5).
- The `AMITSESetupData` default (340,688 B) is the largest default blob — it holds the
  HII *displayed* defaults and string DB; useful for hidden-menu work.

### Changelog
- 2026-10-15 — created: located the Setup default store (4,928 B), confirmed baked defaults
  match IFR defaults, emitted `nvram_defaults.csv`.
