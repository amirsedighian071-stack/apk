#!/usr/bin/env python3
"""Structural checks for a built APK.

Android 11+ refuses to install an APK with targetSdkVersion >= 30 unless
``resources.arsc`` is stored uncompressed and 4-byte aligned.  ZIP producers
(``zip``, ``apktool b``, and apksigner's re-write of the archive) do not
guarantee either, so the build has to assert it before the APK ships.

Usage: python3 verify_apk.py some.apk
Exits non-zero on the first violation.
"""
import struct
import sys
import zipfile

LOCAL_HEADER = "<IHHHHHIIIHH"
LOCAL_MAGIC = 0x04034B50
ALIGN = {"resources.arsc": 4}


def main(path):
    data = open(path, "rb").read()
    zf = zipfile.ZipFile(path)

    bad = zf.testzip()
    if bad is not None:
        sys.exit("FAIL: corrupt entry %r" % bad)

    print("%-32s %-8s %-6s %-6s %s" % ("entry", "method", "align", "size", "ok"))
    failures = []

    for info in zf.infolist():
        if info.is_dir():
            continue
        off = info.header_offset
        (magic, _ver, _flags, method, _t, _d, _crc,
         _csize, usize, name_len, extra_len) = struct.unpack(
            LOCAL_HEADER, data[off:off + 30])
        if magic != LOCAL_MAGIC:
            sys.exit("FAIL: bad local header magic for %r" % info.filename)

        data_off = off + 30 + name_len + extra_len
        want = ALIGN.get(info.filename, 1)
        aligned = data_off % want == 0

        payload = zf.read(info.filename)
        intact = len(payload) == usize

        is_arsc = info.filename == "resources.arsc"
        if is_arsc and method != zipfile.ZIP_STORED:
            failures.append("resources.arsc is compressed (must be STORED)")
        if not aligned:
            failures.append("%s is not %d-byte aligned" % (info.filename, want))
        if not intact:
            failures.append("%s does not read back at its stated size" % info.filename)

        print("%-32s %-8s %-6d %-6d %s" % (
            info.filename,
            "STORED" if method == zipfile.ZIP_STORED else "DEFLATE",
            data_off % want,
            usize,
            "yes" if aligned and intact else "NO"))

    for msg in failures:
        print("FAIL:", msg)
    if failures:
        sys.exit(1)
    print("\nOK: %d entries, resources.arsc stored and %d-byte aligned"
          % (len([i for i in zf.infolist() if not i.is_dir()]), ALIGN["resources.arsc"]))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
