# MediaStar Remote Dev — build notes

Fork of **Mediastar Remote 15.0.0** with a new application id, a 7‑theme engine,
animated page transitions and a developer page.

Output: **`MediaStar Remote Dev_15.0.1.apk`** (in the repository root).

| property | value |
|---|---|
| applicationId | `com.developeramira.remotemediastar` (installs alongside the original) |
| launcher label | `MediaStar Remote Dev` |
| versionCode / versionName | `16` / `15.0.1-dev` |
| min / target SDK | 21 / 36 |
| signature | v1 + v2 + v3 (self‑signed, `CN=Amir Sedighian`) |

The Java/Kotlin *classes* deliberately keep the original
`com.saminsoftware.remotemediastar` namespace. Only the manifest `package`
changes — B4A resolves activities by class name, so renaming the classes would
break every internal bridge call. The manifest therefore declares the
components fully qualified while the app id is new.

## What was added

### 1. Developer page («توسعه‌دهنده برنامه»)

Reachable from the new button at the bottom of the settings panel. It shows

> این برنامه توسط امیر صدیقیان ساخته شده است.

plus three working communication bridges:

| network | handle | URL |
|---|---|---|
| Instagram | `x.amirrezaa1` | https://instagram.com/x.amirrezaa1 |
| Telegram | `developer_as` | https://t.me/developer_as |
| GitHub | `developeramira` | https://github.com/developeramira |

The page is a `FrameLayout` overlay with fade + RTL-slide entrance and a
fade + slide exit.

### 2. Seven selectable themes

`light · dark · neon · classic · ocean · sunset · forest`

Each palette defines 17 semantic slots (`BG_TOP` … `SUCCESS`). The patcher
rewrites all **50** `Colors.RGB(r,g,b)` call sites in `main.smali` into
`ThemeManager.color(slot)`, so gradients, panels, keys, captions and accents all
follow the active theme. The choice is persisted in
`mediastar_theme_prefs/theme_id` and mirrored to the legacy `theme.txt` flag so
the untouched B4A code keeps working.

The gallery is opened by the existing «حالت تم» button
(`_btnthemesettings_click` → `ThemeManager.showThemeChooser()`).

### 3. Page transitions

| transition | implementation |
|---|---|
| settings page in | fade + RTL slide + slight scale (`showSettingsPanelIn`) |
| settings page out | fade + slide, `postDelayed(175 ms)` then `RemoveView` |
| remote screen | hero fade + scale (`_vv5` → `animateHero`) |
| theme gallery / developer page | fade + slide in, fade out |

Five transition styles are available in `ThemeManager`:
`EFFECT_FADE`, `EFFECT_SLIDE_RTL`, `EFFECT_SLIDE_LTR`, `EFFECT_ZOOM`,
`EFFECT_FLIP`.

## Repository layout

```
MediaStar Remote Dev_15.0.1.apk   the built, signed APK
Mediastar Remote_15.0.0.apk       untouched original
patcher/
  patch.py                        the whole transformation (stdlib only)
  build.sh                        decompile → patch → assemble → sign
  java/…/theme/ThemeManager.java  the theme / transition / developer engine
  stubs/                          compile-only stubs for ThemeManager (never packaged)
```

## Rebuilding

```bash
# toolchain: java, apktool, smali/baksmali jars, apksigner, a keystore
# (paths are overridable by environment variables, see build.sh)
./patcher/build.sh
```

`build.sh` needs a real `d8` for the Java→DEX step. If one is not available the
engine can be compiled once and its smali tree dropped into
`<decode>/smali/com/saminsoftware/remotemediastar/theme/`; `patch.py` only
rewrites `main.smali` and the manifest.

### Running just the patcher

```bash
apktool d -f -o build/dec "Mediastar Remote_15.0.0.apk"
python3 patcher/patch.py build/dec
```

The patcher is idempotent only on a fresh decode — always start from an
unmodified tree.

## Fixes applied after the first build

Three defects were found by static verification of the produced DEX and fixed:

1. **`LTM;` placeholder leak** — the template substitution ran before the
   `%`-formatting, so four call sites emitted a non-existent
   `LTM;->…` type (fatal `NoClassDefFoundError` on launch). All ThemeManager
   references are now emitted as an `@@TM@@` token and resolved once,
   immediately before the file is written, with an assertion that none survive.
2. **`_btnclosesettings_click` corruption** — the backward search for the
   insertion point had no lower bound and walked out of the method, deleting
   `_btnbuydongleclick_click` and merging it into `_btnclosesettings_click`.
   The patcher now replaces only the single `RemoveView()` instruction,
   bounds-checked, and fails loudly if the count is not exactly one.
3. **Infinite recursion in the colour lookup** — the new button used the key
   `"developer"`, which `_vvv5` does not know, so it fell through to
   `_vvv5(p, "")` and recurred forever on every settings open. The button now
   uses the existing `"Settings"` key.

## Notes

* The APK is signed with the keystore in `patcher/tools/release.jks`
  (alias `mediastar`, password `mediastar2026`). Committing the key is
  deliberate: the previous build was signed with a throwaway key, so it could
  neither be updated in place nor accumulate the signature reputation that
  antivirus engines score on. Keep using this key for every future build.

* `aapt2`-regenerated resources are byte-identical to the original for this
  app (a single drawable and one `resources.arsc`), so the original
  `resources.arsc` and icon are reused verbatim.

* IR blasting, dongle purchase and the transmitter picker are untouched.

## Fix: the APK would not install (15.0.1 → 15.0.2 build)

**Symptom.** Sideloading `MediaStar Remote Dev_15.0.1.apk` failed immediately
with *"App not installed"* / `INSTALL_PARSE_FAILED_NOT_APK`-class errors, and
at least one antivirus product flagged the file.

**Root cause.** `resources.arsc` was **DEFLATE-compressed and not 4-byte
aligned**. Since Android 11, an APK with `targetSdkVersion >= 30` is rejected
by the package manager unless the resource table is `STORED` and aligned — the
platform `mmap`s the table in place and cannot do that with compressed data.
Both `zip` and `apktool b` compress it by default, so the shipped file was
uninstallable on any modern device regardless of signature.

`resources.arsc` was also 22 bytes short of the original because the
decompiled tree dropped the alignment padding that the original table had.

**Fix.** `patcher/zipalign.py` rewrites the archive with correct local headers:
`resources.arsc` → `STORED` at a 4-byte boundary, `*.so` → `STORED` at 16384,
everything else left as the compiler emitted it. It runs between packaging and
signing.

One subtlety: **`apksigner` rewrites the whole archive**, and in doing so it
drops directory entries. A zip that contains `res/` and `res/drawable/` entries
therefore gets every offset shifted at signing time, silently undoing the
alignment. The zip is now built with `zip -D` (no directory entries), so the
offsets survive; `patcher/verify_apk.py` asserts this on the *signed* file:

```
$ python3 patcher/verify_apk.py "MediaStar Remote Dev_15.0.1.apk"
entry                            method   align  size   ok
res/drawable/icon.png            DEFLATE  0      206780 yes
AndroidManifest.xml              DEFLATE  0      3808   yes
classes.dex                      DEFLATE  0      346324 yes
resources.arsc                   STORED   0      932    yes
...
OK: 8 entries, resources.arsc stored and 4-byte aligned
```

The previous broken build for comparison:

```
resources.arsc                   DEFLATE  2      932    NO
FAIL: resources.arsc is compressed (must be STORED)
FAIL: resources.arsc is not 4-byte aligned
```

**Also fixed in the same rebuild.** The earlier build took `resources.arsc`
from the *original* APK while the manifest had been repackaged with the new
application id. The table's own package name (`com.saminsoftware.remotemediastar`)
therefore disagreed with the manifest's `com.developeramira.remotemediastar`,
which apktool reported as a package rename. Both now carry
`com.developeramira.remotemediastar`, and `androidsupportmultidexversion.txt`
was restored.

## Fix: the app still closed on launch (15.0.1 build 3)

**Symptom.** Build 2 installed and no longer failed verification on the boot
path, but the app still reported "keeps stopping".

**Two independent defects, both invisible to every earlier check.**

### 1. Arithmetic on a String register

The patched block that appends the developer entry to the settings panel ended
with

```
add-int v6, v19, v21
add-int v19, v6, v1
```

`v1` was assumed to still hold the original gap constant. It does not: the
statement immediately above is `const-string v1, "BuyDongleSettings"`, so on
every path reaching that instruction `v1` holds a **String**. The command was
in fact `Settings.brand`-style padding using a literal that had already been
clobbered. Assembling is fine; the verifier rejects the whole class.

Fixed to `add-int v19, v6, v5` — `v5` is the constant `0` written near the top
of `_vvvv0`.

### 2. A call to a method that does not exist

The developer button was wired with

```
invoke-static {v9}, ThemeManager->attachDeveloperButton(Landroid/view/View;)V
```

but `attachDeveloperButton` **did not exist** in `ThemeManager`. The build is
happy because the string is only a reference; Android resolves it on first
execution and throws `NoSuchMethodError`, which is exactly the "opens the
settings panel, app dies" symptom.

This is the deeper lesson: the patch called into the engine through
`ThemeManager` in three builds without ever checking that the target member
exists. Fixed by adding the method and its listener class
(`ThemeManager$11`) to `patcher/smali/theme/`, and by adding the gate below so
it cannot happen again.

The button also no longer relies on b4a's reflective
`main._v5.RunMethod("Developer", ...)` dispatch — that resolves the subroutine
name only at runtime, so a missing or misnamed callback there is equally
invisible at build time. A plain `OnClickListener` is used instead.

## New gate: cross-reference resolution

`patcher/verify_types.py` now also checks that **every `invoke-*` and field
access into a class defined in this tree names a member that actually exists**,
walking the superclass chain for inherited members so that legitimate
inheritance (`BALayout` overriding `ViewGroup`) is not flagged, and skipping
platform classes that cannot be inspected.

```
$ python3 patcher/verify_types.py build/dec
== type check: 1631 methods
OK: no type violations
== cross-reference check
OK: every call into a class we ship resolves
```

Calibrated in both directions: run against the previously shipped APK it
reports the defect immediately.

```
$ python3 patcher/verify_types.py /tmp/previous-build
main.smali:10891: add-int v19, v6, v1
    arithmetic on a obj register v1
FAILED: 1 type violation(s) - Android would reject these classes
```

## Permissions

`android.permission.WAKE_LOCK` is referenced only by b4a's
`StarterHelper.startServiceFromReceiver()`, which the app never reaches — the
`starter_BR` receiver has no intent filter and is never broadcast. It is not
declared, so that code path simply skips the wakelock branch. The declared set
stays at the two permissions the app genuinely uses:

| permission | why |
|---|---|
| `TRANSMIT_IR` | the app is an IR remote |
| `FOREGROUND_SERVICE` | the `starter` service |

`patch.py` now actively strips `WAKE_LOCK`, `INTERNET` and
`RECEIVE_BOOT_COMPLETED` if a future apktool version reintroduces them.

## Fix: the app closed immediately on launch (15.0.1 build 2)

**Symptom.** After the alignment fix the APK installed fine, but tapping the
icon produced *"MediaStar Remote Dev keeps stopping"* on a Xiaomi/MIUI device.

**Root cause.** A `VerifyError` in `main`, caused by the patcher itself.

The original b4a code that reads the legacy light/dark flag compiles to this
(blank lines elided):

```
invoke-static {}, File->getDirInternal()
move-result-object p0
const-string v0, "theme.txt"
invoke-static {p0, v0}, File->Exists(...)Z
move-result p0
const/4 v1, 0x0            <- the Else value
if-eqz p0, :cond_0
   ... ReadString / equals / sput-boolean p0, _vv1 ...
   goto :goto_0
:cond_0
sput-boolean v1, _vv1:Z    <- reads the constant
:goto_0
```

The old `patch_theme_loader()` replaced everything from the `getDirInternal()`
call down to `:cond_0` with a single `ThemeManager->install()`. That span
contained `const/4 v1, 0x0`, but **not** the two `sput-boolean v1` writes it
feeds, which are still live further down the method. So `v1` kept whatever it
held from earlier in `_activity_create` — the *string* `"Txt"` from the IR
code table — and the verifier saw a String written into a boolean field at a
branch merge point.

A `VerifyError` rejects the **whole class**, not just the method, so every
entry point into `main` died and Android reported a crash on launch.

The lesson that matters: this is invisible to smali assembly. `apktool b`
printed no warning, the DEX parsed cleanly, every method decoded, and the
class/method inventory was identical. Only a type-aware dataflow over the
control-flow graph catches it.

**Fix.** `patch_theme_loader()` now replaces only the *read*:

```
invoke-static {}, ThemeManager->isDark()Z
move-result v0
sput-boolean v0, _vv1:Z
```

The `Exists()` call, the `const/4 v1, 0x0`, the branch and the Else write are
all left exactly as b4a emitted them, so the method stays type-correct. The
`ThemeManager->install()` boot call moved to the unconditional path just
before the branch — inside the `if` it would be skipped on a fresh install,
where `mostCurrent` is already assigned but no theme has ever been saved.

**Guard.** Two new gates run before assembly, and a third after signing:

| script | what it proves |
|---|---|
| `patcher/verify_smali.py` | no branch to a label that does not exist; no register read before any write |
| `patcher/verify_types.py` | forward Dalvik type dataflow over the CFG — int / wide / float / double / obj / null, merged at every join point; catches a register holding the wrong type at an `sput`, `iput` or call argument |
| `patcher/verify_apk.py` | `resources.arsc` is STORED and 4-byte aligned in the **signed** file |

`verify_types.py` is calibrated to report nothing on the pristine 15.0.0 tree
and reports exactly the defect above on the broken build:

```
$ python3 patcher/verify_types.py build/dec            # pristine original
OK: no type violations

$ python3 patcher/verify_types.py /tmp/broken           # the 15.0.1 build
main.smali:895: sput-boolean v1, main->_vv2:Z
    writes a obj value into a int slot (register v1 holds obj)
FAILED: 3 type violation(s) - Android would reject these classes
```

`patcher/rebuild.py` runs the whole pipeline and refuses to sign if either
gate fails. It also verifies that `classes.dex` is byte-identical before and
after alignment and signing.

The prebuilt engine smali is now in the repository under
`patcher/smali/theme/`, so a rebuild needs no javac, no d8 and no Android SDK.

### About the antivirus warning

Nothing in the app triggers a detection heuristically — the DEX contains no
`http://` URLs, no `Runtime.exec`, no `su` paths, and the only
`DexClassLoader` reference comes from Basic4Android's own runtime. The flag is
a **reputation** false positive, which is common for:

* **self-signed certificates** that no engine has seen before,
* **DEX files that match no known-good build** (this one is ~22 KB larger than
  any published MediaStar release),
* **compressed resource tables** — the same defect that broke installation also
  looks like packing to a scanner.

The packaging defects are now gone, so the *heuristic* part of the score should
clear. The reputation part cannot be fixed from inside the file. To get rid of
the remaining warning, publish this `release.jks` signature on every subsequent
build and submit the APK for whitelisting:

| service | where |
|---|---|
| Google Play Protect | <https://support.google.com/googleplay/android-developer/contact/protectappeals> |
| Microsoft Defender | <https://www.microsoft.com/en-us/wdsi/filesubmission> |
| VirusTotal | <https://www.virustotal.com> (shows which engine fires) |

Until then, install with Play Protect's "Install anyway" prompt, or verify the
signature yourself:

```bash
apksigner verify --print-certs "MediaStar Remote Dev_15.0.1.apk"
# SHA-256: 7a304b42f64b04a0bc0d9e9b94cddfb97c3454077f6b4c82bb3d2a5c2dbe4bcc
```

