#!/usr/bin/env python3
"""
zipalign.py - minimal, correct APK zipalign
===========================================

Android will not install an APK whose ``resources.arsc`` is DEFLATE-compressed
when ``targetSdkVersion >= 30``, and every *stored* entry must have its data
offset aligned (4 bytes for ``.arsc`` and other uncompressed entries, 16 KiB
page alignment for 64-bit ``.so`` files).

``zip -X -r`` satisfies neither requirement, which is why the first build of
this fork could not be installed.

This tool rebuilds the archive:

  * ``resources.arsc``  -> STORED, data offset aligned to 4
  * ``*.so``            -> STORED, data offset aligned to 16384 (64-bit pages)
  * other entries       -> keep their method; STORED ones aligned to 4

Alignment is achieved with a standard "extra field" (id 0xD935) inserted in the
local file header, which is the same trick zipalign uses.

Usage: python3 zipalign.py in.apk out.apk
"""
import struct
import sys
import zipfile
import zlib

ALIGN_ARSC = 4
ALIGN_SO = 16384
ALIGN_DEFAULT = 4


def _align_extra(offset_after_name, align):
    """Build an extra field so that (offset_after_name + len(extra)) % align == 0."""
    if not align:
        return b""
    rem = (offset_after_name + 4) % align          # 4 bytes for the extra header
    need = (align - rem) % align
    if need:
        # total extra length = 4 + need  -> must be >= 4 to be a valid field
        payload = need
        return struct.pack("<HH", 0xD935, payload) + b"\x00" * payload
    return b"\x00\x00\x00\x00"                      # empty extra field


def do_align(src, dst):
    """Rebuild the archive with correctly aligned local headers."""
    import io

    with zipfile.ZipFile(src) as zin:
        entries = [(i, zin.read(i.filename)) for i in zin.infolist()]

    buf = io.BytesIO()
    central = []

    for info, data in entries:
        name = info.filename
        raw_name = name.encode("utf-8")

        if name == "resources.arsc":
            method, align = zipfile.ZIP_STORED, ALIGN_ARSC
        elif name.endswith(".so"):
            method, align = zipfile.ZIP_STORED, ALIGN_SO
        elif info.compress_type == zipfile.ZIP_STORED:
            method, align = zipfile.ZIP_STORED, ALIGN_DEFAULT
        else:
            method, align = zipfile.ZIP_DEFLATED, 0

        payload = data if method == zipfile.ZIP_STORED else _deflate(data)
        crc = zlib.crc32(data) & 0xFFFFFFFF
        local_off = buf.tell()

        y, mo, d, h, mi, se = info.date_time
        if y < 1980:
            y, mo, d, h, mi, se = 1980, 1, 1, 0, 0, 0
        dos_time = (h << 11) | (mi << 5) | (se // 2)
        dos_date = ((y - 1980) << 9) | (mo << 5) | d

        # size the extra field so the *data* starts on the wanted boundary
        extra = b""
        if align:
            base = local_off + 30 + len(raw_name)
            pad = (align - (base + 4) % align) % align
            extra = struct.pack("<HH", 0xD935, pad) + b"\x00" * pad
        data_off = local_off + 30 + len(raw_name) + len(extra)
        assert not align or data_off % align == 0, (name, data_off, align)

        buf.write(struct.pack(
            "<IHHHHHIIIHH",
            0x04034B50, 20, 0, method, dos_time, dos_date,
            crc, len(payload), len(data), len(raw_name), len(extra)))
        buf.write(raw_name)
        buf.write(extra)
        assert buf.tell() == data_off
        buf.write(payload)

        central.append(dict(name=raw_name, method=method, dos_time=dos_time,
                            dos_date=dos_date, crc=crc, csize=len(payload),
                            usize=len(data), off=local_off,
                            attr=info.external_attr, sys=info.create_system))

    cd_start = buf.tell()
    for e in central:
        buf.write(struct.pack(
            "<IHHHHHHIIIHHHHHII",
            0x02014B50, (e["sys"] << 8) | 20, 20, 0, e["method"],
            e["dos_time"], e["dos_date"], e["crc"], e["csize"], e["usize"],
            len(e["name"]), 0, 0, 0, 0, e["attr"], e["off"]))
        buf.write(e["name"])
    cd_size = buf.tell() - cd_start
    buf.write(struct.pack("<IHHHHIIH", 0x06054B50, 0, 0,
                          len(central), len(central), cd_size, cd_start, 0))

    with open(dst, "wb") as fp:
        fp.write(buf.getvalue())
    return dst


def _deflate(data):
    co = zlib.compressobj(9, zlib.DEFLATED, -15)
    return co.compress(data) + co.flush()


def main():
    if len(sys.argv) != 3:
        print("usage: zipalign.py <in.apk> <out.apk>")
        return 2
    do_align(sys.argv[1], sys.argv[2])
    print("aligned ->", sys.argv[2])
    return 0


if __name__ == "__main__":
    sys.exit(main())
