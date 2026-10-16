import os
import re
import csv
import glob

DUMP = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
OUT_CSV = r"C:\Users\Ghost\Desktop\bestproject\work\docs\modules_catalog.csv"
OUT_MD = r"C:\Users\Ghost\Desktop\bestproject\work\docs\modules_catalog.md"
os.makedirs(os.path.dirname(OUT_CSV), exist_ok=True)

# ---- known GUIDs (keys for the most important modules) ----
KNOWN = {
    "D6A2CB7F-6A18-4E2F-B43B-9920A733700A": "DXE Core",
    "52C05B14-0B98-496C-BC3B-04B50211D680": "PEI Core",
    "1BA0062E-C779-4582-8566-336AE8F78F09": "SEC Core / Volume Top File",
    "899407D7-99FE-43D8-9A21-79EC328CAC21": "Setup (HII config driver)",
    "B1DA0ADF-4F77-4070-A88E-BFFE1C60529A": "AMITSE (Setup Engine)",
    "FE612B72-203C-47B1-8560-A66D946EB371": "AMITSESetupData",
    "5C60F367-A505-419A-859E-2A4FF6CA6FE5": "DXE driver volume (main)",
    "BDB6C5ED-6BF3-4909-837C-353F6DCBB6A2": "DXE driver volume (secondary)",
    "CBC91F44-A4BC-4A5B-8696-703451D0B053": "AMI v2 protected ranges hash",
    "FC510EE7-FFDC-11D4-BD41-0080C73C8881": "DXE apriori file",
    "1B45CC0A-156A-428A-AF62-49864DA0E6E6": "PEI apriori file",
    "7B9A0A12-42F8-4D4C-82B6-32F0CA1953F4": "BUP/Recovery?",
    "17088572-377F-44EF-8F4E-B09FFF46A070": "Microcode container (FIT)",
}

re_first = re.compile(rb"[\x20-\x7e]{5,}")
re_utf16 = re.compile((rb"(?:[\x20-\x7e]\x00){5,}"))


def strings_from(path, limit=2500):
    try:
        data = open(path, "rb").read()
    except OSError:
        return []
    out = []
    for m in re_first.finditer(data):
        out.append(m.group().decode("latin-1"))
        if len(out) >= limit:
            break
    for m in re_utf16.finditer(data):
        s = m.group().decode("utf-16-le", "ignore")
        if len(s) >= 5:
            out.append(s)
        if len(out) >= limit * 2:
            break
    # de-dup preserve order
    seen = set()
    uniq = []
    for s in out:
        s = s.strip()
        if s and s not in seen:
            seen.add(s)
            uniq.append(s)
    return uniq


HINTS = [
    ("PciBus/PciHostBridge", ["PciBus", "PciHostBridge", "PciRootBridge", "PciEnumerator"]),
    ("CPU", ["CpuDxe", "CpuIo", "MpInit", "CpuInit", "PowerMgmt", "CpuPolicy", "CpuMp"]),
    ("PCH init", ["PchInit", "PchSmi", "PchReset", "PchPolicy", "PchGro", "PchGpio"]),
    ("System Agent", ["SaInit", "SystemAgent", "SaPolicy", "SaPci", "SaGop", "Igd", "IhvSa"]),
    ("Memory/MRC", ["Mrc", "MemInit", "MemoryInit", "MemPolicy", "Ddr", "FastBoot"]),
    ("Setup/HII", ["Setup", "Hii", "FormBrowser", "FormCallback", "ConfigAccess"]),
    ("USB", ["Xhci", "Uhci", "UsbBus", "UsbCore", "UsbPei", "USB Device", "UsbRt"]),
    ("SATA/AHCI", ["Sata", "Ahci", "AtaAtapi", "SataController"]),
    ("NVMe", ["NvmExpress", "Nvme", "NVMe"]),
    ("Network", ["Tcp", "Udp", "Snp", "Mnp", "Pxe", "Http", "Ip4", "Ip6", "Realtek", "Intel(R) PRO", "NetworkStack"]),
    ("Graphics/GOP", ["GraphicsOutput", "Gop", "Vbios", "IntelGop", "Int10"]),
    ("ME/HECI", ["HECI", "MeCls", "MeBx", "Manageability", "Mebx", "Cse", "ME Region", "Intel(R) ME"]),
    ("TPM/Security", ["Tcg", "Tpm", "SecureBoot", "SmmAccess", "SecurityPmm", "ImageVerification", "SecureBootConfig"]),
    ("SMM", ["Smm", "SMI", "PiSmm", "MmCore", "SmmCore"]),
    ("Runtime/Variable", ["Variable", "Runtime", "BootManager", "BdsDxe", "DevicePath"]),
    ("Capsule/FWUpdate", ["Capsule", "FirmwareUpdate", "Fmp", "Esrt", "UefiPxe"]),
    ("ACPI", ["Acpi", "Dsdt", "Ssdt", "AcpiTable"]),
    ("Console/Input", ["Console", "ConSplit", "Keyboard", "Mouse", "Terminal"]),
    ("Storage (NVMe/SD)", ["BlockIo", "DiskIo", "Partition", "Fat", "SdMmc", "Scsi"]),
    ("Dell/OEM", ["Dell", "OptiPlex", "DellDiag", "SupportAssist"]),
    ("AMI modules", ["AMI", "Ami", "Aptio", "AMITSE"]),
    ("Intel RC", ["RC ", "ReferenceCode", "Intel(R)"]),
]

NOISE = re.compile(r'^[0-9A-Fa-f\-]{6,}$')
BAD = ("EFI_", "Pcd", "gEfi", "gAmi", "\\", ";", "$", ".data", ".reloc", ".text",
       ".rdata", "http", "Copyright", "$IBIOSI$", "iBSP", "%s", "\\r\\n")

# strings that strongly indicate a firmware module identity
IDENT_KW = ["Dxe", "Pei", "Smm", "Init", "Driver", "Hook", "Policy", "Setup",
            "Runtime", "Core", "Pch", "SaInit", "SystemAgent", "Cpu", "Usb", "Usb",
            "Sata", "Ahci", "Nvme", "Pci", "Mebx", "HECI", "Tpm", "Acpi", "Gop",
            "Graphics", "Console", "Variable", "Boot", "Capsule", "Hii", "Form",
            "Config", "Reset", "Smbus", "Spi", "Thermal", "Power", "Memory", "Mrc"]


def guess(strings):
    joined = "\n".join(strings)
    for label, keys in HINTS:
        for k in keys:
            if k in joined:
                return label
    return ""


def pick_notable(strings, n=8):
    cand = []
    for s in strings:
        if len(s) < 6 or len(s) > 55:
            continue
        if NOISE.match(s) or any(b in s for b in BAD):
            continue
        score = 0
        kw = sum(2 for k in IDENT_KW if k in s)
        score += min(kw, 8)
        if re.search(r"[A-Z][a-z]+[A-Z]", s):
            score += 2
        if s.endswith("Dxe") or s.endswith("Pei") or s.endswith("Smm") or s.endswith(".efi"):
            score += 3
        if score > 0:
            cand.append((score, s))
    cand.sort(key=lambda x: (-x[0], len(x[1])))
    picked, seen = [], set()
    for _, s in cand:
        if s not in seen:
            seen.add(s)
            picked.append(s)
        if len(picked) >= n:
            break
    return picked


rows = []
for root, dirs, files in os.walk(DUMP):
    if "info.txt" not in files:
        continue
    try:
        txt = open(os.path.join(root, "info.txt"), encoding="utf-8", errors="replace").read()
    except OSError:
        continue
    if "Type: File" not in txt:
        continue

    def field(k):
        m = re.search(rf"^{k}:\s*(.*)$", txt, re.M)
        return m.group(1).strip() if m else ""

    subtype = field("Subtype")
    guid = field("File GUID")
    offset = field("Offset")
    size = field("Full size")
    # find PE32 body
    pe = glob.glob(os.path.join(root, "*PE32 image section", "body.bin"))
    strs = []
    if pe:
        strs = strings_from(pe[0])
    g = guess(strs)
    notable = pick_notable(strs)
    rows.append({
        "subtype": subtype, "guid": guid, "offset": offset, "size": size,
        "known": KNOWN.get(guid, ""), "function_hint": g,
        "notable_strings": " | ".join(notable),
        "path": os.path.relpath(root, DUMP),
    })

rows.sort(key=lambda r: (r["subtype"], r["guid"]))

with open(OUT_CSV, "w", newline="", encoding="utf-8") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

from collections import Counter
cnt = Counter(r["subtype"] for r in rows)
print("modules:", len(rows))
print(cnt.most_common())
print("with PE32 + notable strings:", len([r for r in rows if r["notable_strings"]]))

# ---------------- markdown ----------------
lines = []
lines.append("# OptiPlex 7040 (BIOS 1.24.0) - Complete Firmware Module Catalog\n")
lines.append(f"Total FFS files: **{len(rows)}**. "
             f"DXE drivers: **{cnt.get('DXE driver',0)}**, SMM: **{cnt.get('SMM module',0)}**, "
             f"PEI: **{cnt.get('PEI module',0)}**, Freeform: **{cnt.get('Freeform',0)}**.\n")
lines.append("Function is inferred from embedded strings (best-effort); GUID = FFS file GUID. "
             "See `modules_catalog.csv` for full data.\n")

for sub, _ in cnt.most_common():
    grp = [r for r in rows if r["subtype"] == sub]
    lines.append(f"\n## {sub} ({len(grp)})\n")
    lines.append("| GUID | Size | Function (inferred) | Known | Notable strings |")
    lines.append("|------|------|---------------------|-------|-----------------|")
    for r in grp:
        ns = r["notable_strings"].replace("|", "\\|")[:120]
        lines.append(f"| `{r['guid']}` | {r['size']} | {r['function_hint']} | {r['known']} | {ns} |")

open(OUT_MD, "w", encoding="utf-8").write("\n".join(lines) + "\n")

print("\nsample (refined):")
for r in rows:
    if r["subtype"] == "DXE driver" and r["notable_strings"]:
        print(f'  {r["guid"]}  hint={r["function_hint"]:<18} {r["notable_strings"][:80]}')
print("\nCSV:", OUT_CSV)
print("MD :", OUT_MD)
