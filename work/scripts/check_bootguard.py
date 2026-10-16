#!/usr/bin/env python
"""Read-only Boot Guard / FPF checker for the OptiPlex 7040 (ME 11.x).

Runs Intel's MEInfoWin64.exe -verbose (tools\\MEInfo_v11r46\\) and decodes the
"FPF" column of the Boot Guard policy table, which reports the *burned fuse*
state of the platform (not just what the image asks for). Read-only: MEInfo
talks to the ME over HECI via the signed Intel MEI driver; it never writes.

Usage:
  python_embeded\\python.exe work\\scripts\\check_bootguard.py            run + parse (needs Admin)
  python_embeded\\python.exe work\\scripts\\check_bootguard.py --parse F  parse an existing dump

Outputs:
  work\\bios\\meinfo_verbose.txt   raw MEInfo output
  work\\bios\\bootguard_fpf.txt    decoded summary

Exit codes: 0 = parsed, 2 = not elevated, 3 = MEInfo missing/failed to run.
"""

import argparse
import ctypes
import os
import re
import subprocess
import sys

MEINFO_DIR = os.path.join("tools", "MEInfo_v11r46")
MEINFO_EXE = "MEInfoWin64.exe"
RAW_OUT = os.path.join("work", "bios", "meinfo_verbose.txt")
SUM_OUT = os.path.join("work", "bios", "bootguard_fpf.txt")

# Boot Guard policy rows MEInfo prints as two columns: FPF | ME
BG_KEYS = [
    "Force Boot Guard ACM",
    "Protect BIOS Environment",
    "CPU Debugging",
    "BSP Initialization",
    "Measured Boot",
    "Verified Boot",
    "Key Manifest ID",
    "Enforcement Policy",
]

INTEL_MEI_GUIDS = [
    "{E2D1FF34-3458-49A9-88DA-8E6915CE9BE5}",  # HECI
]


def is_admin() -> bool:
    try:
        return bool(ctypes.windll.shell32.IsUserAnAdmin())
    except Exception:
        return False


def run_meinfo() -> str:
    exe = os.path.join(MEINFO_DIR, MEINFO_EXE)
    if not os.path.isfile(exe):
        raise FileNotFoundError(exe)
    env = dict(os.environ)
    env["PATH"] = os.path.abspath(MEINFO_DIR) + os.pathsep + env.get("PATH", "")
    p = subprocess.run(
        [os.path.abspath(exe), "-verbose"],
        cwd=os.path.abspath(MEINFO_DIR),
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=120,
    )
    return p.stdout.decode("utf-8", "replace")


def parse(text: str):
    """MEInfo v11 layout: <key> <FPF value>, then a
    `Retrieving Variable "…"` line, then the ME value on its own line."""
    out = {"version": None, "bg": {}, "oem_key": [], "notes": []}
    m = re.search(r"MEInfo Version:\s*(\S+)", text)
    if m:
        out["version"] = m.group(1)

    lines = text.splitlines()
    for i, raw in enumerate(lines):
        s = raw.strip()
        if not s:
            continue
        for k in BG_KEYS:
            if s.startswith(k):
                fpf = s[len(k):].strip()
                me = ""
                for j in range(i + 1, min(i + 8, len(lines))):
                    if lines[j].strip().startswith("Retrieving Variable"):
                        for m2 in range(j + 1, min(j + 5, len(lines))):
                            if lines[m2].strip():
                                me = lines[m2].strip()
                                break
                        break
                out["bg"][k] = (fpf, me)

    for raw in lines:
        s = raw.strip()
        if s.startswith("OEM Public Key Hash"):
            out["oem_key"].append(s)
        elif re.search(r"(FPF HW Source|Fusing Patch|FPF and ME Config Status)", s):
            out["notes"].append(s)
    return out


def onoff(v: str) -> bool:
    return v.strip().lower().startswith("enabled")


def verdict(bg: dict):
    """Return (provisioned, mode, route_text)."""
    rows = {k: v[0] for k, v in bg.items()}
    force_acm = onoff(rows.get("Force Boot Guard ACM", "Disabled"))
    verified = onoff(rows.get("Verified Boot", "Disabled"))
    measured = onoff(rows.get("Measured Boot", "Disabled"))

    provisioned = force_acm or verified or measured
    if verified:
        mode = "Verified"
    elif measured:
        mode = "Measured-only"
    elif force_acm:
        mode = "ACM-forced, no verify/measure"
    else:
        mode = "Disabled"

    if mode == "Verified":
        route = ("Verified enforcement is ACTIVE: in-FV edits (W2/W3) WILL halt at "
                 "BootGuardDxe -> build/flash the W2b base (BootGuardDxe bypass).")
    elif mode == "Measured-only":
        route = ("Measured-only: the ACM measures but does not enforce, so in-FV "
                 "edits (W2/W3) boot unchanged; W2b bypass is optional but safer.")
    else:
        route = ("Boot Guard not provisioned: in-FV edits boot as-is; W2b bypass "
                 "is harmless and still recommended.")
    return provisioned, mode, route


def summarize(text: str) -> str:
    p = parse(text)
    lines = []
    lines.append("Boot Guard / FPF report (read-only, MEInfo)")
    lines.append("=" * 46)
    lines.append(f"MEInfo version : {p['version']}")
    if not p["bg"]:
        lines.append("")
        lines.append("!! No Boot Guard policy table found in output.")
        lines.append("   MEInfo likely failed (needs Admin + the Intel MEI driver).")
        return "\n".join(lines)

    lines.append("")
    lines.append(f"{'policy row':<28}{'FPF':<12}{'ME'}")
    lines.append(f"{'-'*28}{'-'*12}{'-'*12}")
    for k in BG_KEYS:
        if k in p["bg"]:
            fpf, me = p["bg"][k]
            flag = "  <== FPF/ME MISMATCH" if (me and fpf.lower() != me.lower()) else ""
            lines.append(f"{k:<28}{fpf:<12}{me}{flag}")

    if p["notes"]:
        lines.append("")
        for l in p["notes"]:
            lines.append("  " + l)

    if p["oem_key"]:
        lines.append("")
        lines.append("OEM key material:")
        for l in p["oem_key"]:
            lines.append("  " + l)

    provisioned, mode, route = verdict(p["bg"])
    lines.append("")
    lines.append(f"FPF provisioned : {'YES' if provisioned else 'NO'}")
    lines.append(f"Boot Guard mode : {mode}")
    lines.append("")
    lines.append(">>> ROUTE: " + route)
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--parse", metavar="FILE",
                    help="parse an existing MEInfo dump instead of running it")
    args = ap.parse_args()

    if args.parse:
        text = open(args.parse, encoding="utf-8", errors="replace").read()
    else:
        if not is_admin():
            print("WARNING: not running elevated. MEInfo needs Administrator.")
            print("         re-run from an elevated pwsh, or use --parse.")
            # keep going anyway — MEInfo may still print an error we can read
        try:
            text = run_meinfo()
        except FileNotFoundError:
            print(f"ERROR: {os.path.join(MEINFO_DIR, MEINFO_EXE)} not found.")
            return 3
        except Exception as e:
            print(f"ERROR running MEInfo: {e}")
            return 3
        os.makedirs(os.path.dirname(RAW_OUT), exist_ok=True)
        with open(RAW_OUT, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"raw output -> {RAW_OUT}")

    summary = summarize(text)
    print(summary)
    with open(SUM_OUT, "w", encoding="utf-8") as f:
        f.write(summary + "\n")
    print(f"\nsummary    -> {SUM_OUT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
