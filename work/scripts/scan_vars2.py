import struct

VARS = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars.fd"
data = open(VARS, "rb").read()

def guid_str(b):
    return f"{struct.unpack('<I',b[0:4])[0]:08X}-{struct.unpack('<H',b[4:6])[0]:04X}-{struct.unpack('<H',b[6:8])[0]:04X}-{b[8:10].hex().upper()}-{b[10:16].hex().upper()}"

# scan for variable headers: StartId == 0x55AA (little endian -> AA 55)
marker = b"\xaa\x55"
i = 0
count = 0
print(f"{'offset':>8} {'state':>5} {'attr':>8} {'namesz':>6} {'datasz':>6}  name")
while True:
    j = data.find(marker, i)
    if j < 0:
        break
    i = j + 1
    # header: StartId(2) State(1) Reserved(1) Attributes(4) NameSize(4) DataSize(4) Guid(16) Name(...)
    if j + 32 > len(data):
        continue
    start_id = struct.unpack("<H", data[j:j+2])[0]
    state = data[j+2]
    reserved = data[j+3]
    attr = struct.unpack("<I", data[j+4:j+8])[0]
    namesz = struct.unpack("<I", data[j+8:j+12])[0]
    datasz = struct.unpack("<I", data[j+12:j+16])[0]
    guid = data[j+16:j+32]
    if namesz == 0 or namesz > 256 or datasz > 4096:
        continue
    namebytes = data[j+32:j+32+namesz]
    if len(namebytes) < namesz:
        continue
    try:
        name = namebytes.decode("utf-16-le").rstrip("\x00")
    except Exception:
        continue
    # print printable-ish names only
    if all(32 <= ord(c) < 127 for c in name) and len(name) > 0:
        count += 1
        print(f"0x{j:06X} 0x{state:02X} 0x{attr:08X} {namesz:6} {datasz:6}  {name}   [{guid_str(guid)}]")
print("total plausible vars:", count)
