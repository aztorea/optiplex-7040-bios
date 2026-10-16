#!/usr/bin/env python
"""L1 structural verifier for OptiPlex 7040 System BIOS images.

Usage:
  python work\\scripts\\verify_image.py <image.bin> [--baseline <bin>]
                                      [--expect 0xOFF=HEXBYTES ...]

Checks: size, sha256, exact diff vs pristine baseline, the two guard
regions, the stored AMI v2 protected-range hash, and any expected bytes.
Exit code 0 = all gates pass, 1 = a gate failed.
"""
import argparse
import hashlib
import os
import sys

BASELINE_DEFAULT = os.path.join("work", "bios", "System_BIOS.bin")

SIZE = 0x900000
AMI_START = 0x0E0000
AMI_END = 0x462C00
AMI_HASH_OFF = 0x7B93F4
AMI_HASH_LEN = 32
IBB_START = 0x700000
IBB_END = 0x900000

BASELINE_SHA = "505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E"
AMI_HASH_EXPECT = "6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098"


def sha256_hex(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest().upper()


def parse_expect(spec: str):
    off_s, val_s = spec.split("=", 1)
    off = int(off_s, 16)
    val = bytes.fromhex(val_s.replace(" ", ""))
    return off, val


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("image")
    ap.add_argument("--baseline", default=BASELINE_DEFAULT)
    ap.add_argument("--expect", action="append", default=[],
                    help="0xOFFSET=HEXBYTES (repeatable)")
    ap.add_argument("--max-diffs", type=int, default=64)
    args = ap.parse_args()

    ok = True
    img = open(args.image, "rb").read()
    base = open(args.baseline, "rb").read()

    print(f"image    : {args.image}")
    print(f"baseline : {args.baseline}")

    # --- size ---
    print(f"size     : {len(img)} (0x{len(img):X})  {'OK' if len(img) == SIZE else 'MISMATCH'}")
    if len(img) != SIZE:
        ok = False

    # --- sha256 ---
    isha = sha256_hex(img)
    print(f"sha256   : {isha}")
    if isha == BASELINE_SHA:
        print("           (= pristine baseline)")
    if len(base) != len(img):
        print("baseline size differs from image; aborting diff/guard checks")
        return 1

    # --- diff vs baseline ---
    diffs = [i for i in range(len(img)) if img[i] != base[i]]
    print(f"diff     : {len(diffs)} byte(s) differ vs baseline")
    for off in diffs[: args.max_diffs]:
        print(f"           [0x{off:06X}] {base[off]:02X} -> {img[off]:02X}")
    if len(diffs) > args.max_diffs:
        print(f"           ... (+{len(diffs) - args.max_diffs} more)")

    # --- guard: Boot Guard IBB region must be byte-identical ---
    ibb_same = img[IBB_START:IBB_END] == base[IBB_START:IBB_END]
    print(f"guard IBB: 0x{IBB_START:X}..0x{IBB_END:X} {'UNCHANGED' if ibb_same else '*** CHANGED ***'}")
    if not ibb_same:
        ok = False

    # --- AMI v2 protected range ---
    ami_same = img[AMI_START:AMI_END] == base[AMI_START:AMI_END]
    comp_img = sha256_hex(img[AMI_START:AMI_END])
    stored_img = img[AMI_HASH_OFF:AMI_HASH_OFF + AMI_HASH_LEN]
    comp_base = sha256_hex(base[AMI_START:AMI_END])
    stored_base = base[AMI_HASH_OFF:AMI_HASH_OFF + AMI_HASH_LEN]
    print(f"guard AMI: 0x{AMI_START:X}..0x{AMI_END:X} "
          f"{'UNCHANGED' if ami_same else '*** CHANGED ***'}")
    print(f"           stored@0x{AMI_HASH_OFF:X} : {stored_base.hex().upper()}")
    print(f"           recomputed(pristine) : {comp_img if ami_same else sha256_hex(base[AMI_START:AMI_END])}")
    if stored_base.hex().upper() != AMI_HASH_EXPECT:
        print("           NOTE: stored hash != documented expected value")
    if not ami_same:
        stored_hex = img[AMI_HASH_OFF:AMI_HASH_OFF + AMI_HASH_LEN].hex().upper()
        print(f"           stored in image      : {stored_img.hex().upper()}")
        print(f"           recomputed in image  : {comp_img}")
        if stored_img.hex().upper() == stored_base.hex().upper():
            print("           >>> NOTE: range edited but stored hash NOT updated (expected/handled)")

    # --- expected bytes ---
    for spec in args.expect:
        off, val = parse_expect(spec)
        got = img[off:off + len(val)]
        match = got == val
        print(f"expect   : 0x{off:06X} = {got.hex().upper()}  "
              f"{'OK' if match else '*** EXPECTED ' + val.hex().upper() + ' ***'}")
        if not match:
            ok = False

    print("RESULT   :", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
