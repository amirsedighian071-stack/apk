#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# MediaStar Remote - full rebuild pipeline
#   decompile (apktool) -> patch smali -> resources (aapt2) -> dex (smali+d8)
#   -> package -> zipalign -> sign (apksigner)
# ---------------------------------------------------------------------------
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
WORK="${WORK:-/tmp/msr-build}"
SRC_APK="${SRC_APK:-$ROOT/Mediastar Remote_15.0.0.apk}"
OUT_APK="${OUT_APK:-$ROOT/MediaStar Remote Dev_15.0.1.apk}"

# tool locations (overridable through the environment)
JAVA="${JAVA:-/tmp/jdk/jdk4py/java-runtime/bin/java}"
KEYTOOL="${KEYTOOL:-/tmp/jdk/jdk4py/java-runtime/bin/keytool}"
APKTOOL="${APKTOOL:-/tmp/apktool.jar}"
AAPT2="${AAPT2:-/tmp/aa/package/bin/x64/linux/aapt2}"
D8JAR="${D8JAR:-/tmp/bt/d8.jar}"
APKSIGNER="${APKSIGNER:-/tmp/bt/apksigner.jar}"
ANDROID_JAR="${ANDROID_JAR:-/tmp/android36.jar}"
SMALI_LIB="${SMALI_LIB:-/tmp/alpk/package/java-binaries}"
JAVAC_JAR="${JAVAC_JAR:-/tmp/tj/package/tools.jar}"
KEYSTORE="${KEYSTORE:-/tmp/release.jks}"
KS_PASS="${KS_PASS:-mediastar2026}"
KS_ALIAS="${KS_ALIAS:-mediastar}"

DEC="$WORK/dec"
GEN="$WORK/gen"
CLS="$WORK/classes"
DEX="$WORK/dex"
PKG="$WORK/pkg"

echo "==> clean workspace"
rm -rf "$DEC" "$GEN" "$CLS" "$DEX" "$PKG"
mkdir -p "$WORK" "$GEN" "$CLS" "$DEX" "$DEX/out" "$PKG"

# ---------------------------------------------------------------- decompile
if [ ! -f "$DEC/AndroidManifest.xml" ]; then
    echo "==> decompiling $SRC_APK"
    "$JAVA" -jar "$APKTOOL" d -f -o "$DEC" "$SRC_APK" >/dev/null
fi
rm -rf "$DEC/build" "$DEC/original" "$DEC/unknown" "$DEC/AndroidManifest.xml.orig" 2>/dev/null || true

# ------------------------------------------------------------------ patcher
echo "==> patching smali"
cp "$HERE/patch.py" "$WORK/patch.py"
python3 "$WORK/patch.py" "$DEC"

echo "==> compiling the theme engine"
SMALI_CP="$SMALI_LIB/smali-3.0.5.jar:$SMALI_LIB/smali-baksmali-3.0.3.jar:$SMALI_LIB/smali-dexlib2-3.0.5.jar:$SMALI_LIB/smali-util-3.0.5.jar:$SMALI_LIB/guava-33.4.0-jre.jar:$SMALI_LIB/commons-io-2.15.1.jar:$SMALI_LIB/jcommander-1.64.jar:$SMALI_LIB/antlr-runtime-3.5.2.jar"

rm -rf "$WORK/stubs" "$WORK/stubcls" "$WORK/tmcls"
mkdir -p "$WORK/stubcls" "$WORK/tmcls"
cp -r "$HERE/stubs" "$WORK/stubs"
"$JAVA" -cp "$JAVAC_JAR" com.sun.tools.javac.Main -source 8 -target 8 \
    -bootclasspath "$ANDROID_JAR" -nowarn \
    -d "$WORK/stubcls" $(find "$WORK/stubs" -name '*.java') 2>&1 | grep -v '^Note' || true
"$JAVA" -cp "$JAVAC_JAR" com.sun.tools.javac.Main -source 8 -target 8 \
    -bootclasspath "$ANDROID_JAR" -classpath "$WORK/stubcls" -nowarn \
    -d "$WORK/tmcls" -encoding UTF-8 \
    "$HERE/java/com/saminsoftware/remotemediastar/theme/ThemeManager.java" 2>&1 | grep -v '^Note' || true

echo "==> dexing the theme engine"
mkdir -p "$WORK/tmdex"
"$JAVA" -Xmx2g -cp "$D8JAR" com.android.tools.r8.D8 --min-api 21 --debug \
    --output "$WORK/tmdex" $(find "$WORK/tmcls" -name '*.class') 2>&1 | grep -v 'not found\|desugaring\|^Warning' || true

echo "==> assembling smali -> dex"
"$JAVA" -Xmx1500m -cp "$SMALI_CP" com.android.tools.smali.smali.Main a "$DEC/smali" -o "$DEX/classes.dex" -a 21

echo "==> merging dex files (d8)"
"$JAVA" -Xmx2g -cp "$D8JAR" com.android.tools.r8.D8 --min-api 21 --debug \
    --output "$DEX/out" "$DEX/classes.dex" "$WORK/tmdex/classes.dex" 2>&1 | grep -v 'not found\|desugaring\|^Warning' || true

echo "==> compiling resources (aapt2)"
"$AAPT2" compile --dir "$DEC/res" -o "$WORK/res.zip"
"$AAPT2" link -o "$WORK/base.apk" -I "$ANDROID_JAR" \
    --manifest "$DEC/AndroidManifest.xml" \
    --min-sdk-version 21 --target-sdk-version 36 \
    --version-code 16 --version-name 15.0.1-dev \
    --java "$GEN" --no-version-vectors \
    "$WORK/res.zip"

echo "==> packaging"
cd "$PKG"
unzip -q -o "$WORK/base.apk"
rm -rf META-INF
cp "$DEX/out/classes.dex" classes.dex
if [ -f "$DEC/androidsupportmultidexversion.txt" ]; then
    cp "$DEC/androidsupportmultidexversion.txt" .
fi
rm -f "$WORK/unsigned.apk"
zip -X -r -q -9 "$WORK/unsigned.apk" . -x '.*'

echo "==> signing"
"$JAVA" -jar "$APKSIGNER" sign \
    --ks "$KEYSTORE" --ks-pass "pass:$KS_PASS" --key-pass "pass:$KS_PASS" \
    --ks-key-alias "$KS_ALIAS" \
    --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
    --out "$OUT_APK" "$WORK/unsigned.apk" 2>&1 | grep -v 'WARNING' || true

echo "==> verifying"
"$JAVA" -jar "$APKSIGNER" verify --verbose "$OUT_APK" 2>&1 | grep -v WARNING | head -12
ls -la "$OUT_APK"
