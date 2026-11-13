#!/usr/bin/env python3
"""Rebuild the signed APK from the untouched original.

An end-to-end pipeline that needs no Android SDK, no d8 and no javac: the patch
is applied at the smali/resource level, the tree is assembled with apktool,
aligned, signed, and then verified.

  python3 patcher/rebuild.py [--src ORIGINAL.apk] [--out DEV.apk]

Stages
  1. apktool d          original  -> build/dec
  2. patch.py           rewrites _activity_create, adds the theme engine hooks
  3. smali              patcher/smali/theme/*  (prebuilt ThemeManager)
  4. verify_smali.py    control flow / register definitions
  5. verify_types.py    Dalvik type checking (catches VerifyError defects)
  6. apktool b          -> build/rebuilt.apk
  7. zipalign.py        resources.arsc STORED + 4-byte aligned
  8. apksigner sign     v1 + v2 + v3
  9. verify_apk.py      re-checks the *signed* file
 10. apksigner verify   certificate + schemes

Stage 5 is what stops the class of bug that shipped in 15.0.1: a deleted
`const/4` that left `sput-boolean` reading a String.  That assembles cleanly,
installs fine, and kills the app on launch with a VerifyError.
"""
import argparse
import os
import shutil
import subprocess
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
TOOLS = os.path.join(HERE, "tools")
JAVA = os.environ.get("JAVA") or shutil.which("java") or "/usr/bin/java"
APKTOOL = os.path.join(TOOLS, "apktool.jar")
APKSIGNER = os.path.join(TOOLS, "apksigner.jar")
KEYSTORE = os.path.join(TOOLS, "release.jks")
KS_PASS = os.environ.get("KS_PASS", "mediastar2026")
KS_ALIAS = os.environ.get("KS_ALIAS", "mediastar")
WORK = os.environ.get("WORK", os.path.join(ROOT, "build"))

TM_DIR = "com/saminsoftware/remotemediastar/theme"


def run(cmd, **kw):
    print("  $ %s" % " ".join(str(c) for c in cmd))
    return subprocess.run(cmd, check=True, **kw)


def stage(n, title):
    print("\n==> [%d] %s" % (n, title))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default=os.path.join(ROOT, "Mediastar Remote_15.0.0.apk"))
    ap.add_argument("--out", default=os.path.join(ROOT, "MediaStar Remote Dev_15.0.1.apk"))
    ap.add_argument("--skip-decode", action="store_true",
                    help="reuse an existing build/dec tree")
    args = ap.parse_args()

    for tool in (APKTOOL, APKSIGNER, KEYSTORE):
        if not os.path.exists(tool):
            sys.exit("missing %s - see patcher/README.md" % tool)

    dec = os.path.join(WORK, "dec")
    os.makedirs(WORK, exist_ok=True)

    stage(1, "decompile %s" % os.path.basename(args.src))
    if not args.skip_decode or not os.path.isdir(dec):
        shutil.rmtree(dec, ignore_errors=True)
        run([JAVA, "-jar", APKTOOL, "d", "-f", "-o", dec, args.src], stdout=subprocess.DEVNULL)
    # apktool keeps the original signature files around; they must not be
    # repackaged or the new signature block is rejected
    for junk in ("build", "original", "apktool.yml.orig"):
        shutil.rmtree(os.path.join(dec, junk), ignore_errors=True) \
            if os.path.isdir(os.path.join(dec, junk)) else None

    stage(2, "apply patch.py")
    run([sys.executable, os.path.join(HERE, "patch.py"), dec])

    stage(3, "drop in the prebuilt theme engine")
    dest = os.path.join(dec, "smali", TM_DIR)
    shutil.rmtree(dest, ignore_errors=True)
    shutil.copytree(os.path.join(HERE, "smali", "theme"), dest)

    stage(4, "control-flow check")
    run([sys.executable, os.path.join(HERE, "verify_smali.py"), dec])

    stage(5, "Dalvik type check")
    run([sys.executable, os.path.join(HERE, "verify_types.py"), dec])

    stage(6, "assemble with apktool")
    rebuilt = os.path.join(WORK, "rebuilt.apk")
    if os.path.exists(rebuilt):
        os.remove(rebuilt)
    run([JAVA, "-jar", APKTOOL, "b", dec, "-o", rebuilt], stdout=subprocess.DEVNULL)

    stage(7, "align")
    aligned = os.path.join(WORK, "aligned.apk")
    run([sys.executable, os.path.join(HERE, "zipalign.py"), rebuilt, aligned])

    stage(8, "sign")
    if os.path.exists(args.out):
        os.remove(args.out)
    run([JAVA, "-jar", APKSIGNER, "sign", "--min-sdk-version", "21",
         "--ks", KEYSTORE, "--ks-pass", "pass:" + KS_PASS,
         "--key-pass", "pass:" + KS_PASS, "--ks-key-alias", KS_ALIAS,
         "--v1-signing-enabled", "true", "--v2-signing-enabled", "true",
         "--v3-signing-enabled", "true", "--out", args.out, aligned],
        stderr=subprocess.DEVNULL)

    stage(9, "verify the signed archive")
    run([sys.executable, os.path.join(HERE, "verify_apk.py"), args.out])

    stage(10, "verify signature")
    run([JAVA, "-jar", APKSIGNER, "verify", "--print-certs", args.out])

    # final sanity: the DEX that went in is byte-identical to the one in the zip
    with zipfile.ZipFile(rebuilt) as z, zipfile.ZipFile(args.out) as o:
        if z.read("classes.dex") != o.read("classes.dex"):
            sys.exit("FAIL: classes.dex changed during alignment/signing")

    print("\nOK: %s (%d bytes)" % (args.out, os.path.getsize(args.out)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
