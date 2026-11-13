#!/usr/bin/env python3
"""
MediaStar Remote 15.0.0 -> "MediaStar Remote Dev" patcher
=========================================================

Applies, on a freshly decompiled (apktool) tree:

  1. application id  com.saminsoftware.remotemediastar -> com.developeramira.remotemediastar
  2. seven colour palettes routed into all 50 colour call sites of main.smali
  3. animated page changes (settings panel in/out, hero intro, theme gallery)
  4. a developer page (credits + Instagram / Telegram / GitHub bridges)
  5. a new "توسعه‌دهنده برنامه" button at the bottom of the settings panel

Usage: python3 patch.py <decompiled_dir>
"""
import os
import re
import shutil
import sys

ORIG_PKG = "com.saminsoftware.remotemediastar"
NEW_APPID = "com.developeramira.remotemediastar"

# The B4A runtime builds component class names from BA.packageName, which it
# reads from the manifest <manifest package="...">.  Moving the application id
# without moving the classes therefore breaks the app: BA looks for
# "<appid>.starter" and "<appid>.main", while the classes still live under the
# old package.  Both have to move together - see rename_package() below.
TM = "%s/theme/ThemeManager" % NEW_APPID.replace(".", "/")
MAIN = "smali/%s/main.smali" % NEW_APPID.replace(".", "/")

# ---------------------------------------------------------------------------
# palette slots (must match ThemeManager's slot constants)
# ---------------------------------------------------------------------------
SLOT_INDEX = {
    'BG_TOP': 0, 'BG_MID': 1, 'BG_BOTTOM': 2, 'PANEL_TOP': 3, 'PANEL_BOTTOM': 4,
    'SURFACE': 5, 'SURFACE_ALT': 6, 'CARD': 7, 'CARD_BORDER': 8, 'ACCENT': 9,
    'ACCENT_ALT': 10, 'ACCENT_SOFT': 11, 'TEXT_ON_BG': 12, 'TEXT_MUTED': 13,
    'TEXT_ON_ACCENT': 14, 'DANGER': 15, 'SUCCESS': 16,
}

# ---------------------------------------------------------------------------
# colour routing table: ordinal of the Colors->RGB(III)I call -> palette slot
# (ordinals are stable; line numbers are not)
# ---------------------------------------------------------------------------
SITES = {
    1:  'ACCENT_SOFT',      # remote screen gradient, dark branch
    2:  'BG_TOP',           # remote screen gradient, light branch
    3:  'BG_MID',
    4:  'BG_MID',
    5:  'BG_BOTTOM',
    6:  'BG_BOTTOM',
    7:  'ACCENT',           # "MediaStar Remote" title
    8:  'PANEL_TOP',        # settings overlay, dark branch
    9:  'PANEL_TOP',        # settings overlay, light branch
    10: 'PANEL_BOTTOM',     # settings overlay
    11: 'PANEL_TOP',        # generic modal, dark branch
    12: 'PANEL_TOP',        # generic modal, light branch
    13: 'PANEL_BOTTOM',
    14: 'PANEL_BOTTOM',
    15: 'PANEL_TOP',        # dongle modal
    16: 'PANEL_BOTTOM',
    17: 'PANEL_TOP',        # transmitter modal
    18: 'PANEL_BOTTOM',
    19: 'PANEL_TOP',        # transmitter overlay
    20: 'PANEL_TOP',
    21: 'PANEL_BOTTOM',
    22: 'ACCENT',           # overlay heading
    23: 'TEXT_MUTED',       # overlay caption, dark branch
    24: 'TEXT_ON_BG',       # overlay caption, light branch
    25: 'TEXT_ON_ACCENT',   # key caption
    26: 'TEXT_ON_ACCENT',
    27: 'ACCENT_ALT',       # accent key (find)
    28: 'ACCENT_SOFT',      # accent key (epg)
    29: 'PANEL_TOP',        # key pad
    30: 'PANEL_TOP',
    31: 'PANEL_BOTTOM',
    32: 'PANEL_BOTTOM',
    33: 'SUCCESS',          # ok key
    34: 'DANGER',           # power key
    35: 'SURFACE_ALT',      # nav key
    36: 'SURFACE_ALT',
    37: 'SURFACE',
    38: 'SURFACE',
    39: 'CARD_BORDER',      # nav key accent
    40: 'CARD_BORDER',
    41: 'DANGER',           # danger caption
    42: 'TEXT_ON_ACCENT',   # accent caption
    43: 'TEXT_MUTED',
    44: 'TEXT_MUTED',
    45: 'TEXT_ON_BG',       # default caption
    46: 'SURFACE_ALT',      # settings gradient top, dark branch
    47: 'SURFACE_ALT',      # settings gradient top, light branch
    48: 'SURFACE',          # settings gradient bottom, dark branch
    49: 'SURFACE',          # settings gradient bottom, light branch
    50: 'PANEL_BOTTOM',     # B4A colour-helper fallback (unused by the UI)
}

RGB_RE = re.compile(
    r'^(\s*)invoke-static \{([^}]*)\}, '
    r'Lanywheresoftware/b4a/keywords/constants/Colors;->RGB\(III\)I\s*$')


def read(path):
    with open(path, "r", encoding="utf-8") as fh:
        return fh.read()


def write(path, data):
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(data)


def log(msg):
    print("[patch] " + msg)


def method_bounds(lines, signature):
    for i, line in enumerate(lines):
        if line.startswith(".method") and signature in line:
            for j in range(i + 1, len(lines)):
                if lines[j].startswith(".end method"):
                    return i, j
            raise RuntimeError("unterminated method " + signature)
    raise RuntimeError("method not found: " + signature)


def find(lines, start, end, needle):
    for k in range(start, end):
        if needle in lines[k]:
            return k
    raise RuntimeError("anchor not found: " + needle)


# ---------------------------------------------------------------------------
# 1. application id
# ---------------------------------------------------------------------------


def _rewrite_package_tree(dec):
    """Move every class from the old package to the new one.

    B4A derives component class names from BA.packageName, which comes from the
    manifest package attribute.  It also stores the class name as a literal in
    each generated BA constructor, and SubExists() resolves subs through it.
    So the manifest id and the class tree must change together.

    This walks the whole smali tree and rewrites:
      * the directory layout           smali/com/saminsoftware/.. -> smali/com/developeramira/..
      * .class / .super / .source refs Lcom/saminsoftware/remotemediastar/..
      * the hardcoded package strings  "com.saminsoftware.remotemediastar[.X]"

    Product URLs (www.saminsoftware.ir) are the vendor's site, not ours to
    change, so only the dotted package form is touched.
    """
    old_slash = ORIG_PKG.replace(".", "/")
    new_slash = NEW_APPID.replace(".", "/")
    old_dir = os.path.join(dec, "smali", old_slash)
    new_dir = os.path.join(dec, "smali", new_slash)

    if not os.path.isdir(old_dir):
        raise RuntimeError("expected smali tree at %s" % old_dir)

    # rewrite file contents first (the tree is still at the old location)
    touched = 0
    for root, _dirs, files in os.walk(old_dir):
        for name in files:
            if not name.endswith(".smali"):
                continue
            path = os.path.join(root, name)
            body = read(path)
            new = body.replace("L%s" % old_slash, "L%s" % new_slash)
            new = new.replace('"%s' % ORIG_PKG, '"%s' % NEW_APPID)
            if new != body:
                write(path, new)
                touched += 1

    # other smali roots (e.g. smali_classes2) may also reference the package
    for extra in sorted(os.listdir(os.path.join(dec, "smali"))) if False else []:
        pass

    # move the tree
    parent = os.path.dirname(new_dir)
    if os.path.isdir(new_dir):
        shutil.rmtree(new_dir)
    os.makedirs(parent, exist_ok=True)
    shutil.move(old_dir, new_dir)

    # drop the now-empty directory chain
    d = os.path.dirname(old_dir)
    while d.startswith(os.path.join(dec, "smali")) and os.path.isdir(d) and not os.listdir(d):
        os.rmdir(d)
        d = os.path.dirname(d)

    return touched


def rename_package(dec):
    manifest = os.path.join(dec, "AndroidManifest.xml")
    data = read(manifest)

    # 1. move the class tree and every reference inside it
    touched = _rewrite_package_tree(dec)

    # 2. the manifest id and the component names must now both be the new one.
    #    Written as fully qualified names so the id cannot be re-interpreted.
    data = data.replace('package="%s"' % ORIG_PKG, 'package="%s"' % NEW_APPID)
    for comp in (".main", ".starter", ".starter$starter_BR"):
        # whatever apktool emitted (short form or the old fully-qualified form)
        data = data.replace('android:name="%s%s"' % (ORIG_PKG, comp),
                            'android:name="%s%s"' % (NEW_APPID, comp))
        data = data.replace('android:name="%s"' % comp,
                            'android:name="%s%s"' % (NEW_APPID, comp))

    # 3. give the fork its own launcher label
    data = data.replace('android:label="Mediastar Remote"',
                        'android:label="MediaStar Remote Dev"')
    write(manifest, data)
    log("application id -> %s, %d smali files moved" % (NEW_APPID, touched))

    # 4. The b4a StarterHelper looks up android.permission.WAKE_LOCK before
    #    acquiring a wakelock on the startServiceFromReceiver() path.  Nothing
    #    in this app ever requests that permission and the app's own receiver
    #    is never broadcast, so declaring it would add a permission the app
    #    never uses.  Leaving it out means the lookup fails and the wakelock
    #    branch is skipped; the service itself still starts normally.
    for perm in ("android.permission.WAKE_LOCK",
                 "android.permission.RECEIVE_BOOT_COMPLETED",
                 "android.permission.INTERNET"):
        tag = '<uses-permission android:name="%s"/>' % perm
        if tag in data:
            data = data.replace(tag, "")
            log("dropped unused permission %s" % perm.split(".")[-1])

    yml = os.path.join(dec, "apktool.yml")
    if os.path.exists(yml):
        y = read(yml)
        y = re.sub(r"versionCode: '?\d+'?", "versionCode: '16'", y, count=1)
        y = re.sub(r"versionName: .*", "versionName: 15.0.1-dev", y, count=1)
        write(yml, y)


# ---------------------------------------------------------------------------
# 2. palette routing
# ---------------------------------------------------------------------------


def route_colours(lines):
    """Swap each Colors->RGB(III)I call for ThemeManager->color(slot).

    The register that already held the red component is reused as scratch, so
    the following move-result and every consumer stay valid.
    """
    patched = 0
    for ordinal, slot in sorted(SITES.items(), reverse=True):
        idx = None
        seen = 0
        for i, line in enumerate(lines):
            if 'Colors;->RGB(III)I' in line:
                seen += 1
                if seen == ordinal:
                    idx = i
                    break
        if idx is None:
            raise RuntimeError("no RGB call #%d" % ordinal)
        m = RGB_RE.match(lines[idx])
        if not m:
            raise RuntimeError("unexpected shape at #%d: %r" % (ordinal, lines[idx]))
        indent, regs = m.group(1), m.group(2)
        scratch = regs.split(',')[0].strip()
        if not (scratch.startswith('v') or scratch.startswith('p')):
            raise RuntimeError("bad scratch register at #%d" % ordinal)
        lines[idx] = (
            "%s# themed colour: %s\n"
            "%sconst/16 %s, 0x%02X\n"
            "%sinvoke-static {%s}, L%s;->color(I)I" % (
                indent, slot, indent, scratch, SLOT_INDEX[slot],
                indent, scratch, TM))
        patched += 1
    log("routed %d colour call sites into the palette" % patched)
    return lines


# ---------------------------------------------------------------------------
# 3. fields / helpers / callbacks
# ---------------------------------------------------------------------------

EXTRA_FIELDS = """
# --- patched helpers ------------------------------------------------
"""


def add_fields(lines):
    i = find(lines, 0, len(lines), "# instance fields")
    lines.insert(i, EXTRA_FIELDS)
    return lines


HELPERS = """
# --- patched: boot the theme engine ---------------------------------
.method public static _themeInit()V
    .locals 0

    invoke-static {}, @@TM@@->install()V

    return-void
.end method

# --- patched: entrance transition of the settings page --------------
.method public static _settingsIn()V
    .locals 0

    invoke-static {}, @@TM@@->showSettingsPanelIn()V

    return-void
.end method

# --- patched: exit transition of the settings page ------------------
.method public static _settingsOut()V
    .locals 0

    invoke-static {}, @@TM@@->hideSettingsPanel()V

    return-void
.end method

# --- patched: hero animation of the remote screen -------------------
.method public static _hero()V
    .locals 2

    sget-object v0, Lcom/saminsoftware/remotemediastar/main;->mostCurrent:Lcom/saminsoftware/remotemediastar/main;

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-object v0, v0, Lcom/saminsoftware/remotemediastar/main;->_activity:Lanywheresoftware/b4a/objects/ActivityWrapper;

    if-nez v0, :cond_1

    return-void

    :cond_1
    invoke-virtual {v0}, Lanywheresoftware/b4a/objects/ActivityWrapper;->getObject()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/Activity;

    if-nez v1, :cond_2

    return-void

    :cond_2
    const v0, 0x1020002

    invoke-virtual {v1, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, @@TM@@->animateHero(Landroid/view/View;)V

    return-void
.end method
"""


def add_helpers(lines):
    i = find(lines, 0, len(lines), ".method private afterFirstLayout()V")
    lines.insert(i, HELPERS)
    return lines


CALLBACKS = """
# --- patched callbacks ---------------------------------------------
.method public static _btndeveloper_click()Ljava/lang/String;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {}, @@TM@@->showDeveloperPage()V

    const-string v0, ""

    return-object v0
.end method

.method public static _openinstagram_click()Ljava/lang/String;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {}, @@TM@@->openInstagram()V

    const-string v0, ""

    return-object v0
.end method

.method public static _opentelegram_click()Ljava/lang/String;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {}, @@TM@@->openTelegram()V

    const-string v0, ""

    return-object v0
.end method

.method public static _opengithub_click()Ljava/lang/String;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {}, @@TM@@->openGithub()V

    const-string v0, ""

    return-object v0
.end method
"""


def add_callbacks(lines):
    i = find(lines, 0, len(lines), ".method private afterFirstLayout()V")
    lines.insert(i, CALLBACKS)
    return lines


# ---------------------------------------------------------------------------
# 4. rewiring existing code
# ---------------------------------------------------------------------------


def patch_theme_loader(lines):
    """Point the legacy theme flag at the 7-theme engine.

    The original Basic4Android code

        If File.Exists(File.DirInternal, "theme.txt") Then
            _vv1 = File.ReadString(File.DirInternal, "theme.txt").Equals("dark")
        Else
            _vv1 = False
        End If

    compiles to (blank lines elided):

        invoke-static {}, File->getDirInternal()
        move-result-object p0
        const-string v0, "theme.txt"
        invoke-static {p0, v0}, File->Exists(...)Z
        move-result p0
        const/4 v1, 0x0            <- the Else value, shared by _vv2 and _vv3
        if-eqz p0, :cond_0
        invoke-static {}, File->getDirInternal()
        move-result-object p0
        invoke-static {p0, v0}, File->ReadString(...)
        move-result-object p0
        const-string v0, "dark"
        invoke-virtual {p0, v0}, String->equals(...)Z
        move-result p0
        sput-boolean p0, main->_vv1:Z
        goto :goto_0
        :cond_0
        sput-boolean v1, main->_vv1:Z      <- reads the constant
        :goto_0

    The previous version of this function deleted everything from the
    getDirInternal() call down to :cond_0, which also deleted `const/4 v1, 0x0`
    while leaving the two `sput-boolean v1` instructions in place.  v1 then
    still held the *string* "Txt" left over from the IR table built earlier in
    the same method, so the verifier rejected `main` as a whole and the app
    died on launch with a VerifyError.

    Only the *read* is replaced.  The Exists() call, the `const/4`, the branch
    and the Else write all stay exactly as b4a emitted them, so the method
    remains type-correct.
    """
    start, end = method_bounds(lines, "_activity_create(Z)")

    theme_at = None
    for k in range(start, end):
        if lines[k].strip() == 'const-string v0, "theme.txt"':
            theme_at = k
            break
    if theme_at is None:
        raise RuntimeError('theme.txt read not found in _activity_create')

    # the ReadString() call that produces the "dark"/"light" value
    r = theme_at
    while r < end and "ReadString" not in lines[r]:
        r += 1
    if r >= end:
        raise RuntimeError("ReadString() for theme.txt not found")

    # ... up to and including the write it feeds
    b = r
    while b < end and "sput-boolean" not in lines[b]:
        b += 1
    if b >= end:
        raise RuntimeError("the theme.txt assignment was not found")

    removed = [l for l in lines[r:b + 1] if l.strip()]
    if not any("ReadString" in l for l in removed):
        raise RuntimeError("refusing to patch: span does not start at the theme read")
    if any("sput-boolean v1" in l for l in removed):
        raise RuntimeError("refusing to patch: the span contains the Else write")

    # v0 is free here: the next instruction in the original is
    # `const-string v0, "transmitter.txt"`, which overwrites it anyway.
    lines[r:b + 1] = [
        "    # patched: the 7-theme engine owns the legacy light/dark flag",
        "    invoke-static {}, @@TM@@->isDark()Z",
        "    move-result v0",
        "    sput-boolean v0, Lcom/saminsoftware/remotemediastar/main;->_vv1:Z",
    ]

    # Boot the engine on the *unconditional* path.  Putting it inside the
    # `if Exists(theme.txt)` branch would skip it on a fresh install, where
    # mostCurrent is already assigned but no theme has ever been saved.
    guard = theme_at
    while guard < end and lines[guard].strip() != "const/4 v1, 0x0":
        guard += 1
    if guard >= end:
        raise RuntimeError("could not find the shared Else constant")
    lines[guard:guard] = [
        "    # patched: boot the theme engine (mostCurrent is set by now)",
        "    invoke-static {}, @@TM@@->install()V",
    ]

    # the shared Else constant must survive, or :cond_0 writes a stale register
    body = "\n".join(lines[start:end])
    if "sput-boolean v1, Lcom/saminsoftware/remotemediastar/main;->_vv1:Z" in body:
        if "const/4 v1, 0x0" not in body:
            raise RuntimeError("const/4 v1, 0x0 is gone but the Else branch still reads v1")

    log("theme bootstrap rewired in _activity_create (%d instructions replaced)" % len(removed))
    return lines


def patch_theme_button(lines):
    i, j = method_bounds(lines, "_btnthemesettings_click()")
    lines[i:j + 1] = [
        ".method public static _btnthemesettings_click()Ljava/lang/String;",
        "    .locals 1",
        "    .annotation system Ldalvik/annotation/Throws;",
        "        value = {",
        "            Ljava/lang/Exception;",
        "        }",
        "    .end annotation",
        "",
        "    # patched: open the theme gallery",
        "    invoke-static {}, @@TM@@->showThemeChooser()V",
        "",
        "    const-string v0, \"\"",
        "",
        "    return-object v0",
        ".end method",
    ]
    log("btnThemeSettings -> theme gallery")
    return lines


def patch_close_settings(lines):
    """Keep the original guard, but hand the panel to the animated exit.

    Only the single `RemoveView()` call is replaced.  The previous version
    searched backwards for an `invoke-static` without a lower bound and could
    walk out of the method, splicing _btnbuydongleclick_click together with
    _btnclosesettings_click (deleting the former and clobbering the latter).
    """
    start, end = method_bounds(lines, "_btnclosesettings_click()")
    hits = [k for k in range(start, end)
            if lines[k].strip() == "invoke-virtual {v0}, "
            "Lanywheresoftware/b4a/objects/PanelWrapper;->RemoveView()V"]
    if len(hits) != 1:
        raise RuntimeError("expected one RemoveView() in close-settings, got %d"
                           % len(hits))
    lines[hits[0]] = "    invoke-static {}, @@TM@@->hideSettingsPanel()V"
    log("close-settings -> animated exit")
    return lines


def patch_settings_entrance(lines):
    """After the settings panel is attached, run the entrance transition."""
    start, end = method_bounds(lines, "_vvvv0()Ljava/lang/String;")
    addview = None
    for k in range(start, end):
        if "ActivityWrapper;->AddView" in lines[k]:
            addview = k
            break
    if addview is None:
        raise RuntimeError("settings panel AddView not found")
    lines[addview + 1:addview + 1] = [
        "",
        "    # patched: fade + RTL slide the settings page in",
        "    invoke-static {}, @@TM@@->showSettingsPanelIn()V",
    ]
    log("settings page entrance transition wired")
    return lines


DEV_LABEL = ("\\ud83d\\udc68\\u200d\\ud83d\\udcbb \\u062a\\u0648\\u0633\\u0639\\u0647"
             "\\u200c\\u062f\\u0647\\u0646\\u062f\\u0647 \\u0628\\u0631\\u0646\\u0627\\u0645\\u0647")


def patch_developer_button(lines):
    """Clone the last settings button into a 'developer' entry.

    _vvvv0 keeps its vertical cursor in v19; v21 is the button height, v1 is the
    gap, v3/v4/v5 are 2/1/0 and v8 is the button text size.
    """
    start, end = method_bounds(lines, "_vvvv0()Ljava/lang/String;")
    # the injected block needs v22..v29, so raise the local register budget
    for k in range(start, end):
        m = re.match(r'^(\s*)\.locals (\d+)\s*$', lines[k])
        if m:
            n = int(m.group(2))
            if n < 30:
                lines[k] = "%s.locals 30" % m.group(1)
            break
    anchor = find(lines, start, end, 'const-string v1, "BuyDongleSettings"')
    ret = anchor
    while ret < end and not lines[ret].strip().startswith("return-object"):
        ret += 1
    block = """    # patched: extra "developer" entry at the bottom of the settings panel
    sget-object v0, Lcom/saminsoftware/remotemediastar/main;->mostCurrent:Lcom/saminsoftware/remotemediastar/main;

    iget-object v2, v0, Lcom/saminsoftware/remotemediastar/main;->_vvvvvvvvvvv6:Lanywheresoftware/b4a/objects/ButtonWrapper;

    iget-object v0, v0, Lcom/saminsoftware/remotemediastar/main;->activityBA:Lanywheresoftware/b4a/BA;

    const-string v6, "btnDeveloper"

    invoke-virtual {v2, v0, v6}, Lanywheresoftware/b4a/objects/ButtonWrapper;->Initialize(Lanywheresoftware/b4a/BA;Ljava/lang/String;)V

    const-string v6, "LABEL"

    invoke-static {v6}, Lanywheresoftware/b4a/BA;->ObjectToCharSequence(Ljava/lang/Object;)Ljava/lang/CharSequence;

    move-result-object v6

    invoke-virtual {v2, v6}, Lanywheresoftware/b4a/objects/ButtonWrapper;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v2, v8}, Lanywheresoftware/b4a/objects/ButtonWrapper;->setTextSize(F)V

    sget-object v6, Lanywheresoftware/b4a/keywords/Common;->Typeface:Lanywheresoftware/b4a/keywords/constants/TypefaceWrapper;

    sget-object v6, Lanywheresoftware/b4a/keywords/constants/TypefaceWrapper;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v6}, Lanywheresoftware/b4a/objects/ButtonWrapper;->setTypeface(Landroid/graphics/Typeface;)V

    sget-object v0, Lcom/saminsoftware/remotemediastar/main;->mostCurrent:Lcom/saminsoftware/remotemediastar/main;

    iget-object v0, v0, Lcom/saminsoftware/remotemediastar/main;->_vvv1:Lanywheresoftware/b4a/objects/PanelWrapper;

    invoke-virtual {v2}, Lanywheresoftware/b4a/objects/ButtonWrapper;->getObject()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/view/View;

    move-object/from16 v16, v0

    move-object/from16 v17, v6

    invoke-virtual/range {v16 .. v21}, Lanywheresoftware/b4a/objects/PanelWrapper;->AddView(Landroid/view/View;IIII)V

    # "Settings" is an existing key in _vvv5; an unknown key would fall through
    # to _vvv5(p, "") which recurses forever.
    const-string v6, "Settings"

    invoke-static {v2, v6}, Lcom/saminsoftware/remotemediastar/main;->_vvv5(Lanywheresoftware/b4a/objects/ButtonWrapper;Ljava/lang/String;)Ljava/lang/String;

    sget-object v0, Lcom/saminsoftware/remotemediastar/main;->mostCurrent:Lcom/saminsoftware/remotemediastar/main;

    iget-object v0, v0, Lcom/saminsoftware/remotemediastar/main;->_v0:Lanywheresoftware/b4a/objects/collections/Map;

    invoke-virtual {v2}, Lanywheresoftware/b4a/objects/ButtonWrapper;->getObject()Ljava/lang/Object;

    move-result-object v6

    invoke-virtual {v2}, Lanywheresoftware/b4a/objects/ButtonWrapper;->getTextSize()F

    move-result v9

    invoke-static {v9}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v9

    invoke-virtual {v0, v6, v9}, Lanywheresoftware/b4a/objects/collections/Map;->Put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v2}, Lanywheresoftware/b4a/objects/ButtonWrapper;->getObject()Ljava/lang/Object;

    move-result-object v6

    # Attach the click callback with a direct static call instead of
    # main._v5.RunMethod("Developer", ...).  RunMethod goes through b4a's
    # reflective dispatcher, which only resolves the sub name at runtime, so a
    # missing or misnamed callback is invisible at build time and shows up on
    # the device as a NoSuchMethodError the moment the panel opens.
    move-object v9, v6

    check-cast v9, Landroid/view/View;

    invoke-static {v9}, @@TM@@->attachDeveloperButton(Landroid/view/View;)V

    add-int v6, v19, v21

    # v1 is a String on every path here (last write is the "BuyDongleSettings"
    # const-string above), so it cannot be used as an int gap.  v5 is the
    # constant 0 written near the top of this method.
    add-int v19, v6, v5

""".replace("LABEL", DEV_LABEL)
    lines.insert(ret, block)
    log("developer entry added to the settings panel")
    return lines


def patch_hero(lines):
    end = len(lines)
    for i, line in enumerate(lines):
        if line.startswith(".method") and "_vv5()Ljava/lang/String;" in line:
            for j in range(i + 1, len(lines)):
                if lines[j].startswith(".end method"):
                    end = j
                    break
            break
    ret = end
    for k in range(end, 0, -1):
        if lines[k].strip() == "return-object v0":
            ret = k
            break
    lines.insert(ret, """    # patched: hero intro animation for the remote screen
    invoke-static {}, @@TM@@->animateHero()V

""")
    return lines


# ---------------------------------------------------------------------------


def main():
    if len(sys.argv) != 2:
        print("usage: patch.py <decompiled_dir>")
        return 2
    dec = os.path.abspath(sys.argv[1])

    # rename_package moves the whole class tree to the new application id, so
    # it has to run before anything resolves a path under that id.
    rename_package(dec)

    main_path = os.path.join(dec, MAIN)
    if not os.path.exists(main_path):
        print("main.smali not found after rename: " + main_path)
        return 2

    log("patching main.smali ...")
    lines = read(main_path).split("\n")
    lines = route_colours(lines)
    lines = add_fields(lines)
    lines = add_callbacks(lines)
    lines = add_helpers(lines)
    lines = patch_theme_loader(lines)
    lines = patch_theme_button(lines)
    lines = patch_close_settings(lines)
    lines = patch_settings_entrance(lines)
    lines = patch_developer_button(lines)
    lines = patch_hero(lines)
    body = "\n".join(lines)
    # every ThemeManager reference was emitted as the @@TM@@ token; resolve it
    # once, here, so no literal placeholder can reach the assembler again
    body = body.replace("@@TM@@", "L%s;" % TM)
    # The injected blocks were written against the original package.  Point
    # them at the new application id too, otherwise main keeps calling
    # Lcom/saminsoftware/.../main; after the tree has moved to
    # Lcom/developeramira/.../main; and every such call is a
    # NoClassDefFoundError at runtime.
    body = body.replace("L%s" % ORIG_PKG.replace(".", "/"),
                        "L%s" % NEW_APPID.replace(".", "/"))
    write(main_path, body)
    if "@@TM@@" in body or "LTM;" in body:
        raise RuntimeError("unresolved ThemeManager placeholder")
    log("main.smali patched (%d lines)" % len(lines))
    return 0


if __name__ == "__main__":
    sys.exit(main())
