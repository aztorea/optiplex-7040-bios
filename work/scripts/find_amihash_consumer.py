import glob, os

G = bytes.fromhex('CBC91F44A4BC4A5B8696703451D0B053')
d = open(r'work\bios\System_BIOS.bin','rb').read()

occ = []
s = 0
while True:
    i = d.find(G, s)
    if i < 0:
        break
    occ.append(i); s = i + 1
print('GUID byte occurrences in image:', [hex(i) for i in occ])
print()
print('--- extracted files containing the GUID bytes ---')
for f in glob.glob(r'work\bios\System_BIOS.bin.dump\**\*', recursive=True):
    if not os.path.isfile(f):
        continue
    try:
        if os.path.getsize(f) > 0x3000000:
            continue
        b = open(f, 'rb').read()
    except Exception:
        continue
    p = 0
    o = []
    while True:
        k = b.find(G, p)
        if k < 0:
            break
        o.append(hex(k))
        p = k + 1
    if o:
        print('  %-90s %s' % (f.split('System_BIOS.bin.dump')[-1], o))