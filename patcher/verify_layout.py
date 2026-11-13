#!/usr/bin/env python3
"""Layout sanity gate for the hand-built B4A view tree.

This app has no XML layouts.  Every widget is positioned by absolute pixel
offsets computed in main._vvvv0 / main._vv5, so a mistake does not look like a
broken layout file - it silently draws one button on top of another, or
corrupts a live register and shifts unrelated text.

Two invariants are checked:

  1. PanelWrapper->AddView register sets are always {vN .. vN+5}.

     AddView takes (panel, view, left, top, width, height) from consecutive
     registers.  The stock code keeps that block in v16..v21 and copies the
     geometry in right before each call.  A call using any other block either
     reads stale geometry or, worse, the same block as the previous call -
     which puts the new button exactly on top of the old one.

  2. Every routed colour site stages its palette slot in a field.

     The palette routing rewrites `Colors.RGB(r,g,b)` into a constant slot plus
     a call to ThemeManager.color().  It must not write the value into a
     register that the original instruction sequence still reads, so the slot
     travels through main->_paletteSlot instead.  A site that calls color(I)
     directly is passing whatever happens to be in that register.

Usage: python3 verify_layout.py <decompiled_dir>
"""
import os
import re
import sys

ADDVIEW = re.compile(
    r'invoke-virtual/range \{v(\d+) \.\. v(\d+)\}, '
    r'Lanywheresoftware/b4a/objects/PanelWrapper;->AddView')

COLOR_ARG = re.compile(r'L[\w/$]+/theme/ThemeManager;->color\(I\)I')
COLOR_NONE = re.compile(r'L[\w/$]+/theme/ThemeManager;->color\(\)I')
SLOT_STAGE = re.compile(r'sput (?:v\d+|p\d+), L[\w/$]+/main;->_paletteSlot:I')


def main(dec):
    pkg = None
    for cand in ("com/developeramira/remotemediastar", "com/saminsoftware/remotemediastar"):
        p = os.path.join(dec, "smali", *cand.split("/"), "main.smali")
        if os.path.exists(p):
            pkg, path = cand, p
            break
    if pkg is None:
        print("SKIP: main.smali not found")
        return 1

    lines = open(path, encoding="utf-8").read().split("\n")
    problems = []

    # 1. AddView register blocks must be consecutive and 6 wide
    for n, line in enumerate(lines, 1):
        m = ADDVIEW.search(line)
        if not m:
            continue
        lo, hi = int(m.group(1)), int(m.group(2))
        if hi - lo != 5:
            problems.append("%s:%d AddView spans v%d..v%d (expected 6 consecutive "
                            "registers: left, top, width, height)" % (
                                os.path.basename(path), n, lo, hi))

    # 2. no routed colour site may pass a register to color(I)
    routed = sum(1 for l in lines if SLOT_STAGE.search(l))
    for n, line in enumerate(lines, 1):
        if COLOR_ARG.search(line):
            problems.append("%s:%d calls color(I) with a register argument; the "
                            "slot must be staged in main->_paletteSlot" % (
                                os.path.basename(path), n))

    # 3. the settings panel must contain the developer entry exactly once
    dev = sum(1 for l in lines if 'const-string v6, "btnDeveloper"' in l)
    if dev != 1:
        problems.append("developer button declared %d times (expected 1)" % dev)

    print("== layout invariants")
    for p in problems:
        print("   " + p)
    if problems:
        print("\nFAILED: %d layout problem(s)" % len(problems))
        return 1
    print("OK: %d routed colour sites, AddView blocks consistent, "
          "developer entry present once" % routed)
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
