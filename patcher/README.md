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

* The APK is signed with a freshly generated self-signed key. Updating an
  installed copy requires using the same keystore.
* `aapt2`-regenerated resources are byte-identical to the original for this
  app (a single drawable and one `resources.arsc`), so the original
  `resources.arsc` and icon are reused verbatim.
* IR blasting, dongle purchase and the transmitter picker are untouched.
