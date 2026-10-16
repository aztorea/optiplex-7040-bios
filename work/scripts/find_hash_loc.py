import binascii, re, sys

PATH = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
data = open(PATH, "rb").read()

hashes = {
    "AMI_v2_range_6C8E1C15": "6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098",
    "IBB_BPM_F41A1C24": "F41A1C2439602D17C6737325B06B47963CD15103EDC9EFDBFB730488FEEA3420",
    "PCR0_FV_DXE_3A5C91FE": "3A5C91FEEAAA9FA292E58CF8C1F5B3C400697B345C17D30CFCE5521F6EC43E92",
    "SystemMap_B_054BE301": "054BE301691C079241C0A623F98C370350FB48C971ADE9022A7D6DE6B7BCBFCC",
}

for name, hx in hashes.items():
    pat = bytes.fromhex(hx)
    idx = 0
    found = []
    while True:
        i = data.find(pat, idx)
        if i < 0:
            break
        found.append(i)
        idx = i + 1
    locs = ", ".join(f"0x{i:X} (vol-base off, abs 0x{0xFF700000+i:X})" for i in found) or "NOT FOUND"
    print(f"{name:24} -> {locs}")

# Also: search for the ASCII/hex variants maybe base64? report raw count
print("\n-- sanity: image size 0x%X --" % len(data))
