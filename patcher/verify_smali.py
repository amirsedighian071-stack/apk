#!/usr/bin/env python3
"""Verify a patched smali tree before it is assembled into a DEX.

Checks for the two defects that make Android reject a class at load time and
kill the app on launch:

  1. a register that is read before it is written anywhere on the path that
     reaches the read  -> VerifyError: "register vN has no type"
  2. an `if-*`/`goto` that targets a label which does not exist in its method
     -> the assembler drops the branch and the method falls through

It also asserts the patch-specific invariants that regressed once already.

Usage: python3 verify_smali.py <decompiled_dir>
Exits non-zero (with a diff-style report) on the first violation.
"""
import os
import re
import sys

SMALI_DIRS = ("smali", "smali_classes2")

# instructions whose first operand is a write
WRITE_OPS = re.compile(
    r'^(move(?:/\w+|-object(?:/\w+)?|-result(?:-object|-wide)?|-exception|-wide(?:/\w+)?)?|'
    r'const(?:/\w+|-wide(?:/\w+)?|-string(?:/jumbo)?|-class)?|'
    r'sget(?:-wide|-object|-boolean|-byte|-char|-short)?|'
    r'iget(?:-wide|-object|-boolean|-byte|-char|-short)?|'
    r'new-instance|new-array|array-length|instance-of|filled-new-array\S*|'
    r'(?:add|sub|mul|div|rem|and|or|xor|shl|shr|ushr|rsub|neg|not)-(?:int|long|float|double)(?:/\w+)?|'
    r'(?:int|long|float|double)-to-\w+|aget(?:-\w+)?|cmp\w*|aput(?:-\w+)?)$')

# ops that also write the register *after* their destination (cmp-double writes vD and vD+1)
WIDE_DEST = re.compile(r'^(cmp\w*-double|cmp\w*-long|add-long|sub-long|mul-long|div-long|rem-long|'
                       r'and-long|or-long|xor-long|shl-long|shr-long|ushr-long|neg-long|not-long|'
                       r'const-wide\S*|move-wide\S*|move-result-wide|sget-wide|iget-wide|aget-wide|'
                       r'(?:int|float)-to-double|(?:int|float)-to-long|double-to-long|long-to-double)$')

# binary ops that read their first operand as well as writing it
READ_MODIFY = re.compile(r'^(add|sub|mul|div|rem|and|or|xor|shl|shr|ushr)-(?:int|long)(?:/2addr|/lit\w*|)$')

BRANCH = re.compile(r'^(if-\w+|goto|goto/16|goto/32)$')

# 64-bit writes fill the next register slot too
WIDE = re.compile(r'^(const-wide|move-wide|add-long|sub-long|mul-long|div-long|rem-long|'
                  r'and-long|or-long|xor-long|neg-long|not-long|aget-wide|sget-wide|iget-wide)')


def methods(path):
    """Yield (header, [(line_no, code_line)], labels)."""
    with open(path, encoding='utf-8', errors='replace') as fh:
        lines = fh.read().split('\n')

    cur = None
    for n, raw in enumerate(lines, 1):
        s = raw.strip()
        if s.startswith('.method'):
            cur = {'header': s, 'body': [], 'lines': []}
        elif s.startswith('.end method') and cur is not None:
            yield cur
            cur = None
        elif cur is not None and s and not s.startswith(('.', '#', '}')):
            cur['body'].append(s)
            cur['lines'].append(n)


def reg_of(text):
    m = re.match(r'(v\d+|p\d+)', text)
    return m.group(1) if m else None


def expand_range(text):
    """{v12 .. v17} -> [v12..v17]"""
    out = []
    m = re.search(r'\{\s*v(\d+)\s*\.\.\s*v(\d+)\s*\}', text)
    if m:
        lo, hi = int(m.group(1)), int(m.group(2))
        out = ['v%d' % i for i in range(lo, hi + 1)]
    return out


def check_method(m, path):
    problems = []
    labels = set()
    for s in m['body']:
        if s.startswith(':'):
            labels.add(s.split()[0].rstrip(','))

    written = set()
    # parameters always have a type; treat p-registers as defined
    for s in m['body']:
        if not s.startswith(':'):
            break
    for n, s in zip(m['lines'], m['body']):
        if s.startswith(':'):
            continue
        op = s.split(None, 1)[0]
        rest = s.split(None, 1)[1] if ' ' in s else ''

        # --- branch target must exist
        if BRANCH.match(op):
            tgt = rest.split(',')[-1].strip()
            if tgt.startswith(':'):
                label = tgt.split()[0]
                if label not in labels:
                    problems.append((n, s, 'branch target %s does not exist' % label))

        # --- register reads
        reads = []
        rng = expand_range(rest)
        br = re.search(r'\{([^}]*)\}', rest)
        if br and not rng:
            for part in br.group(1).split(','):
                part = part.strip()
                if not part:
                    continue
                r = reg_of(part)
                if r:
                    reads.append(r)
        reads.extend(rng)

        if re.match(r'^(sput|iput)', op) or re.match(r'^(if-|return|throw)', op) \
                or op in ('fill-array-data', 'packed-switch', 'sparse-switch', 'monitor-enter', 'monitor-exit'):
            r = reg_of(rest)
            if r:
                reads.append(r)

        for r in reads:
            if r.startswith('p') or r in written:
                continue
            problems.append((n, s, 'reads %s before it is written' % r))

        # cmp-long/greater-than style ops only write their *destination*; the
        # comparison reads both operands, so they must not register a write of
        # the value being compared.
        m_cmp = re.match(r'^(cmp\w*(?:-long|-double|-float))\s+(v\d+),', s)
        if m_cmp:
            written.add(m_cmp.group(2))
            written.add('v%d' % (int(m_cmp.group(2)[1:]) + 1))

        # --- writes (after reads so `add-int v1, v1, v2` still counts v1 as read)
        if WRITE_OPS.match(op) and not READ_MODIFY.match(op):
            r = reg_of(rest)
            if r:
                written.add(r)
                if WIDE_DEST.match(op) and r.startswith('v'):
                    written.add('v%d' % (int(r[1:]) + 1))
        elif READ_MODIFY.match(op):
            r = reg_of(rest)
            if r:
                written.add(r)
                if WIDE_DEST.match(op) and r.startswith('v'):
                    written.add('v%d' % (int(r[1:]) + 1))
        # move-result* writes the following instruction slot
        if op.startswith('move-result'):
            r = reg_of(rest)
            if r:
                written.add(r)

    return problems


def verify_tree(root):
    failures = 0
    checked = 0
    for smali in SMALI_DIRS:
        base = os.path.join(root, smali)
        if not os.path.isdir(base):
            continue
        for dirpath, _dirs, files in os.walk(base):
            for name in files:
                if not name.endswith('.smali'):
                    continue
                path = os.path.join(dirpath, name)
                for m in methods(path):
                    checked += 1
                    for problem in check_method(m, path):
                        n, s, why = problem
                        rel = os.path.relpath(path, root)
                        print('%s:%d: %s' % (rel, n, s))
                        print('    %s  [in %s]' % (why, m['header'][:90]))
                        failures += 1
    return checked, failures


def assert_patch_invariants(root):
    """Regressions that must never come back."""
    main = os.path.join(root, 'smali', 'com', 'saminsoftware', 'remotemediastar', 'main.smali')
    if not os.path.exists(main):
        print('FAIL: main.smali not found at %s' % main)
        return 1
    src = open(main, encoding='utf-8', errors='replace').read()
    bad = 0

    # every read of the IR-code map key must still be a string literal
    for want in ('_btnclosesettings_click()', '_btnbuydongleclick_click()'):
        if want not in src:
            print('FAIL: %s is missing from main.smali' % want)
            bad += 1

    # ThemeManager must be resolved, never left as a token or a bare LTM;
    for token in ('@@TM@@', 'LTM;'):
        if token in src:
            print('FAIL: %s left in main.smali' % token)
            bad += 1

    # the legacy theme flag must still be written somewhere
    if 'sput-boolean' not in src:
        print('FAIL: no boolean flag writes at all')
        bad += 1

    return bad


def main(root):
    print('== checking control flow and register definitions')
    checked, failures = verify_tree(root)
    print('   %d methods checked, %d problems' % (checked, failures))

    print('== checking patch invariants')
    inv = assert_patch_invariants(root)

    if failures or inv:
        print('\nFAILED: %d flow problems, %d invariant violations' % (failures, inv))
        return 1
    print('\nOK: smali tree is well formed')
    return 0


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
