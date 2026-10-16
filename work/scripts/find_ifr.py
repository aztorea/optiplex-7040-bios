import os, struct

MOD = r"work\bios\System_BIOS.bin.dump\5 4F1C52D3-D824-4D2A-A2F0-EC40C23C5916\2 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\1 Volume image section\0 5C60F367-A505-419A-859E-2A4FF6CA6FE5\70 899407D7-99FE-43D8-9A21-79EC328CAC21"
body = open(os.path.join(MOD, "body.bin"), "rb").read()
IFR_START, IFR_END = 0x29CC8, 0x29CC4 + 0x229B5

def find_all(pat, lo, hi):
    r, o = [], lo
    while True:
        i = body.find(pat, o, hi)
        if i < 0: break
        r.append(i); o = i + 1
    return r

print("=== SuppressIf(0A 82) + True(46 02) + Ref(0F 0F .. FormId) ===")
for i in find_all(bytes.fromhex("0a 82 46 02"), IFR_START, IFR_END):
    seg = body[i:i+24]
    # Ref payload starts at i+4: 0F 0F then FormId appears at seg[4+13..]
    rid = struct.unpack_from("<H", body, i+4+13)[0] if body[i+4] == 0x0F else -1
    qid = struct.unpack_from("<H", body, i+4+4)[0] if body[i+4] == 0x0F else -1
    print("   @0x%06X  fv(=+0xF2468)=0x%06X  refFormId=0x%04X qid=0x%04X  %s"
          % (i, i + 0xF2468, rid, qid, seg.hex(' ')))

print("\n=== all True(46 02) immediately before Ref(0F 0F) ===")
for i in find_all(bytes.fromhex("46 02 0f 0f"), IFR_START, IFR_END):
    print("   @0x%06X  prev2=%s" % (i, body[i-2:i].hex(' ')))

print("\n=== all False(47 02) occurrences ===")
for i in find_all(bytes.fromhex("47 02"), IFR_START, IFR_END):
    print("   @0x%06X  ctx=%s" % (i, body[i-4:i+6].hex(' ')))
