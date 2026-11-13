#!/usr/bin/env python3
"""Assert that no reference to the old application id survives anywhere.

Moving the application id is only safe if it is total.  B4A derives component
class names from BA.packageName (which comes from the manifest
<manifest package="...">), and it also stores class names as string literals
that SubExists() and the event dispatcher resolve at runtime.  A single missed
reference produces a NoSuchMethodError / NoClassDefFoundError on the device and
nothing at all at build time.

This is the final gate on that: it scans every smali file and the manifest and
fails if the old package is still referenced in class-descriptor or
application-id form.  The vendor's product URLs (www.saminsoftware.ir) are
legitimate and deliberately not matched.

Usage: python3 normalize_pkg.py <decompiled_dir>
"""
import os
import re
import sys

OLD_APPID = "com.saminsoftware.remotemediastar"
NEW_APPID = "com.developeramira.remotemediastar"

# Lcom/saminsoftware/remotemediastar/...  and  "com.saminsoftware.remotemediastar..."
PATTERNS = [
    re.compile(r'Lcom/saminsoftware/remotemediastar[/;]'),
    re.compile(r'"com\.saminsoftware\.remotemediastar"'),
    re.compile(r'"com\.saminsoftware\.remotemediastar\.'),
]


def scan(root):
    hits = []
    for base in ("smali", "smali_classes2"):
        d = os.path.join(root, base)
        if not os.path.isdir(d):
            continue
        for dirpath, _dirs, files in os.walk(d):
            for name in files:
                if not name.endswith(".smali"):
                    continue
                path = os.path.join(dirpath, name)
                with open(path, encoding="utf-8", errors="replace") as fh:
                    for n, line in enumerate(fh, 1):
                        for pat in PATTERNS:
                            if pat.search(line):
                                hits.append((os.path.relpath(path, root), n,
                                             line.strip()))
                                break

    manifest = os.path.join(root, "AndroidManifest.xml")
    if os.path.exists(manifest):
        with open(manifest, encoding="utf-8", errors="replace") as fh:
            body = fh.read()
        for pat in (re.compile(r'package="%s"' % re.escape(OLD_APPID)),
                    re.compile(r'"%s\.' % re.escape(OLD_APPID))):
            for m in pat.finditer(body):
                hits.append(("AndroidManifest.xml", 1, m.group(0)))

    # every component the manifest declares must name a class that exists
    missing = []
    if os.path.exists(manifest):
        with open(manifest, encoding="utf-8", errors="replace") as fh:
            body = fh.read()
        for comp in re.findall(r'android:name="(%s\.[\w$.]+)"' % re.escape(NEW_APPID), body):
            rel = comp.replace(".", "/") + ".smali"
            if not os.path.exists(os.path.join(root, "smali", rel)):
                missing.append(comp)
    return hits, missing


def main(dec):
    hits, missing = scan(dec)
    print("== stale application-id references")
    for path, n, line in hits:
        print("%s:%d: %s" % (path, n, line[:120]))
    print("== declared components present in the dex tree")
    for comp in missing:
        print("MISSING CLASS: %s" % comp)

    if hits or missing:
        print("\nFAILED: %d stale reference(s), %d missing component class(es)"
              % (len(hits), len(missing)))
        return 1
    print("OK: no stale references, every declared component resolves")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
