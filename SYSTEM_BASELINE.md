# System Baseline — DESKTOP-7OGJ352

> Captured: 2026-10-15
> Method: read-only WMI/CIM + PowerShell queries. No changes made to the system.
> Raw capture: `work\logs\system_baseline_raw.txt` (517 lines)
> Installed software: `work\logs\system_installed_programs.txt` (323 entries)
> Python packages: `work\logs\system_python_packages.txt` (272 entries)

**Important context:** this is the *physical machine* that the BIOS image in this
project (`OptiPlex_7040_1.24.0.exe`) targets. The BIOS version, service tag, CPU
CPUID and chipset all match the extracted firmware — see the "Cross-check vs. BIOS
image" section at the end.

---

## 1. Identity

| Field | Value |
|---|---|
| Host name | `DESKTOP-7OGJ352` |
| User | `Ghost` (local admin, active) |
| Domain / Workgroup | `WORKGROUP` (standalone workstation) |
| Manufacturer / Model | Dell Inc. `OptiPlex 7040` |
| System type | x64-based PC, System Family `OptiPlex` |
| Chassis type | 3 (Desktop) |
| Service Tag / Serial | `6JR8SD2` |
| Motherboard | Dell `0Y7WYT` (A00), serial `/6JR8SD2/CN7016368901GL/` |
| SMBIOS | 3.0 |

## 2. Firmware / BIOS

| Field | Value |
|---|---|
| Vendor | Dell Inc. |
| BIOS version | **1.24.0** |
| BIOS release date | 2022-07-14 |
| SMBIOS BIOS version | 1.24.0 |
| Boot mode | **UEFI** |
| Secure Boot | **Disabled** (registry `UEFISecureBootEnabled = 0`) |

> 1.24.0 is the exact version unpacked in `work\bios\System_BIOS.bin` (Dell PFS
> section "System BIOS with BIOS Guard v1.24.0").

## 3. Processor

| Field | Value |
|---|---|
| CPU | Intel(R) Core(TM) i7-6700 @ 3.40 GHz |
| Cores / Threads | 4 / 8 |
| Max / Current clock | 3408 MHz |
| L2 / L3 cache | 1 MB / 8 MB |
| Family / Model / Stepping | Intel Family 6, Model 94 (0x5E), Stepping 3 |
| CPUID | `BFEBFBFF 000506E3` → **0x506E3** (Skylake-S) |
| Socket | Socket 0 |

## 4. Memory

| Slot | Manufacturer ID | Part number | Serial | Size | Speed |
|---|---|---|---|---|---|
| DIMM1–DIMM4 (4 populated) | `80AD000080AD` (SK Hynix) | `HMA41GU6AFR8N-TF` | 2698626x | 8 GB each | 2133 MHz |
| Total | | | | **32 GB** DDR4 (32,654 MB usable) | |
| Max capacity / slots | | | | 64 GB / 4 | |

## 5. Storage

| Field | Value |
|---|---|
| Disk 0 | 1 TB NVMe PCIe SSD (HP/OEM `PCIe SSD`), serial `6479_A743_F020_01A0.`, firmware `ECFM53.0` |
| Health | Healthy / OK, GPT partitioning |
| Partition 1 | EFI System — 200 MB |
| Partition 2 | Microsoft Reserved — 16 MB |
| Partition 3 | C: — 999 GB (NTFS), ~112.5 GB free |
| Partition 4 | Recovery — 924 MB |

## 6. Graphics

| Field | Value |
|---|---|
| GPU | NVIDIA GeForce RTX 3060 (12 GB) |
| Driver | 596.36 (Windows `32.0.15.9636`, 2026-04-22) |
| CUDA | 13.2 |
| Display | 1920 × 1080 |

## 7. Networking

| Field | Value |
|---|---|
| Primary NIC | Intel(R) Ethernet Connection (2) I219-LM, MAC `F4-8E-38-B4-3C-F2`, 1 Gbps, Up |
| Secondary | Phantom TAP-Windows Adapter V9 (VPN/tunnel), MAC `00-FF-CE-5C-A0-BA`, Disconnected |
| IPv4 | `192.168.100.5` (DHCP, server `192.168.100.1`) |
| IPv6 | `2800:410:f430:3700::1` + SLAAC addresses |
| DNS | `2800:410:533:53::53`, `2001:4860:4860::8844`, `200.32.192.130`, `200.32.205.130` |
| Time zone | (UTC−05:00) Chetumal |

## 8. Operating system

| Field | Value |
|---|---|
| Edition | Microsoft Windows 11 **Pro** |
| Version / Build | 25H2, `10.0.26200` (Build 26200.9711) |
| Architecture | 64-bit |
| Original install date | 2026-05-13 |
| Last boot | 2026-10-14 09:34 |
| System drive | `C:` (NTFS) |
| Locale | en-US |

### Security posture

| Item | State |
|---|---|
| Microsoft Defender Antivirus | Enabled, Real-time protection ON, Behavior monitor ON |
| Defender signatures | `1.461.34.0` (2026-10-14) |
| Engine version | `1.1.26090.9` |
| Virtualization-based Security (VBS) | **Running** |
| HVCI (Hypervisor-enforced Code Integrity) | Configured & Running |
| App Control for Business policy | Enforced (user-mode policy Off) |
| UEFI Code Readonly | Available |
| DMA Protection | Available |
| Secure Boot | **Disabled** (Confirm-SecureBootUEFI = False; no PK present) |
| TPM | **TPM 2.0 present, ready, enabled, activated, owned** — Nuvoton (NTC), fw 1.3.0.1, spec 2.0, ManagedAuthLevel Full, not locked out |
| BitLocker | C: **FullyDecrypted**, Protection **Off**, Encryption Method None |
| Defender exclusions | **None** (no path/extension/process exclusions) |
| Controlled Folder Access | Off |
| Windows activation | **Licensed** (product key ...`9KXTP`) |

## 9. Users

| Account | Enabled | Notes |
|---|---|---|
| `Administrator` | No | built-in |
| `Guest` | No | built-in |
| `DefaultAccount` | No | system-managed |
| `WDAGUtilityAccount` | No | system-managed |
| **`Ghost`** | Yes | local admin, last logon 2026-10-14 |

Members of local **Administrators**: `DESKTOP-7OGJ352\Administrator`, `DESKTOP-7OGJ352\Ghost`.

## 10. Software & runtime

| Field | Value |
|---|---|
| Installed programs | 323 (see `work\logs\system_installed_programs.txt`) |
| .NET Framework | 4.8.09221 (Release 533509) |
| Embedded Python | `3.11.9` at `python_embeded\python.exe`, 272 packages (`work\logs\system_python_packages.txt`) |
| Recent Windows updates | KB5127690, KB5127648, KB5127647 (2026-10-14); KB5054156 (2025-11-12) |

Driver vendors present: Microsoft, Intel, NVIDIA, Dell, Realtek, ELAN, Iriun, TAP-Windows.

Auto-start entries (user `Ghost`): uTorrent, Neat Download Manager, MuMuPlayer.
(Realtek/Waves audio helpers run as `Public`.)

---

## 11. Cross-check vs. the extracted BIOS image

| Attribute | Live system | Extracted `System_BIOS.bin` | Match |
|---|---|---|---|
| Vendor | Dell Inc. | Dell Inc. (Model Information) | ✅ |
| Model | OptiPlex 7040 | OptiPlex 7040 / Model `6b9` | ✅ |
| BIOS version | 1.24.0 | "System BIOS v1.24.0" | ✅ |
| CPU microcode CPUID | `0x506E3` | FIT microcode `CpuSignature 000506E3h` | ✅ |
| Chipset | Skylake-S / (SPT-H PCH) | ME chipset `SPT-H D`; Skylake | ✅ |
| Secure Boot | Disabled | Image has Secure Boot form data, but platform SB is off | ✅ consistent |

The firmware being analyzed is the same firmware currently installed on this machine.

---

## 12. Admin-gated detail (captured in an elevated session)

Original: `work\logs\system_baseline_admin.txt` (elevated, `Running as Administrator: True`).

| Item | Result |
|---|---|
| TPM | Present / Ready / Enabled / Activated / **Owned**; Manufacturer `NTC` (Nuvoton); firmware 1.3.0.1; spec 2.0, rev 1.16; `ManagedAuthLevel: Full`; `LockedOut: False` |
| BitLocker | C: `VolumeStatus: FullyDecrypted`, `ProtectionStatus: Off`, `EncryptionMethod: None`, 0% encrypted |
| Defender exclusions | empty (no ExclusionPath/Extension/Process) |
| Real-time / Behavior monitoring | enabled (not disabled) |
| Controlled Folder Access | `EnableControlledFolderAccess: 0` (off) |
| Secure Boot | `Confirm-SecureBootUEFI: False`; `Get-SecureBootUEFI -Name PK` returned empty (no Platform Key) |
| Windows activation | `LicenseStatus: 1` (Licensed), `PartialProductKey: 9KXTP` |
| SSD SMART | Temperature 34 °C (max 75), Wear 0 |

### Boot configuration (UEFI)

Boot Manager holds a Windows Boot Manager entry plus firmware applications:
Diskette Drive, CD/DVD/CD-RW Drive, PCIe SSD, **Parrot** (a Linux/other OS entry),
and USB Storage Device.

---

## 13. Evidence files

| File | Contents |
|---|---|
| `work\logs\system_baseline_raw.txt` | Full raw output of non-elevated queries |
| `work\logs\system_baseline_admin.txt` | Elevated capture (TPM, BitLocker, Defender, boot config, SMART) |
| `work\logs\system_installed_programs.txt` | 323 installed programs |
| `work\logs\system_python_packages.txt` | `pip freeze` of the embedded Python (272) |
| `collect_system_baseline.ps1` | Re-runnable non-elevated collector |
| `collect_system_baseline_admin.ps1` | Re-runnable elevated collector |
