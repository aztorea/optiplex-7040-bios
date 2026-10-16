import struct, lzma

IMG = r'work\bios\System_BIOS.bin'
data = open(IMG, 'rb').read()

FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
FV_GUID   = struct.pack("<IHH", 0x5C60F367, 0xA505, 0x419A) + bytes.fromhex("859E2A4FF6CA6FE5")
BG_GUID   = struct.pack("<IHH", 0x1DB43EC9, 0xDF5F, 0x4CF5) + bytes.fromhex("AAF00E85DB4E149A")

# locate file 9E21FD93 and decompress
foff = data.find(FILE_GUID)
sec_off = foff + 24
secsize = data[sec_off] | (data[sec_off+1]<<8) | (data[sec_off+2]<<16)
stream = data[sec_off+24: sec_off+secsize]   # skip 20-byte guid + 4-byte prefix
dec = bytearray(lzma.decompress(stream, format=lzma.FORMAT_ALONE))
print('file @0x%X  section 0x%X  dec=0x%X' % (foff, secsize, len(dec)))

fv = dec.find(FV_GUID) - 0x10
print('FV 5C60F367 at dec 0x%X' % fv)

g = dec.find(BG_GUID)
print('BootGuardDxe FFS GUID first at dec 0x%X' % g)
# the GUID appears in the FFS header; ensure it's within the FV
off = g
size = dec[off+20] | (dec[off+21]<<8) | (dec[off+22]<<16)
ftype = dec[off+18]
print('  file: type=%02X attr=%02X size3=0x%X state=%02X' % (ftype, dec[off+19], size, dec[off+23]))
print('  file span dec 0x%X..0x%X' % (off, off+size))

# walk sections
p = off + 24
end = off + size
while p + 4 <= end:
    ssz = dec[p] | (dec[p+1]<<8) | (dec[p+2]<<16)
    stype = dec[p+3]
    print('  section @dec 0x%X size=0x%X type=%02X' % (p, ssz, stype))
    if stype == 0x10:  # PE32
        pe = p + 4
        e_lfanew = struct.unpack('<I', dec[pe+0x3C:pe+0x40])[0]
        print('    PE32 data @dec 0x%X  e_lfanew=0x%X  sig=%s' % (pe, e_lfanew, dec[pe+e_lfanew:pe+e_lfanew+4]))
        # optional header
        coff = pe + e_lfanew + 4
        nsec = struct.unpack('<H', dec[coff+2:coff+4])[0]
        optsize = struct.unpack('<H', dec[coff+16:coff+18])[0]
        optoff = coff + 20
        # PE32+ magic
        magic = struct.unpack('<H', dec[optoff:optoff+2])[0]
        imagesize = struct.unpack('<I', dec[optoff+56:optoff+60])[0]
        entry = struct.unpack('<I', dec[optoff+16:optoff+20])[0]
        print('    magic=%04X nsec=%d optsize=0x%X imagebase_entry=0x%X imagesize=0x%X' % (magic, nsec, optsize, entry, imagesize))
        sectab = optoff + optsize
        target_rva = 0x1070
        for s in range(nsec):
            so = sectab + s*40
            nm = dec[so:so+8].rstrip(b'\x00')
            vsize = struct.unpack('<I', dec[so+8:so+12])[0]
            vaddr = struct.unpack('<I', dec[so+12:so+16])[0]
            rsize = struct.unpack('<I', dec[so+16:so+20])[0]
            raw   = struct.unpack('<I', dec[so+20:so+24])[0]
            print('      sec %-8s va=0x%X vsize=0x%X raw=0x%X rsize=0x%X' % (nm.decode(errors='replace'), vaddr, vsize, raw, rsize))
            if vaddr <= target_rva < vaddr + max(vsize, rsize):
                fo = pe + raw + (target_rva - vaddr)
                print('    -> RVA 0x1070 at dec 0x%X bytes=%s' % (fo, dec[fo:fo+8].hex(' ')))
                print('       around: %s' % dec[fo-8:fo+16].hex(' '))
        break
    p = (p + ssz + 3) & ~3
