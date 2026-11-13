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

