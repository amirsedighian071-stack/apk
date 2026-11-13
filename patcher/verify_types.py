#!/usr/bin/env python3
"""Type-check a smali tree the way Android's verifier does.

Android rejects a whole class when any method fails verification, and the app
dies instantly with a VerifyError.  The defect that shipped in 15.0.1 was
exactly this shape:

    const-string v1, "Txt"      # v1 : String
    ...
    if-eqz p0, :cond_0          # the branch merges v1 as String
    ...
    :cond_0
    sput-boolean v1, ...        # boolean required, String supplied -> VerifyError

The instruction sequence is perfectly valid smali and assembles without a
warning; only a type-aware pass over the control-flow graph catches it.

This is a forward dataflow of coarse Dalvik types (int / wide / float / double
/ obj / unknown) with a conflict marker at merge points.  It is deliberately
conservative: a register whose type is not known is never reported.

Usage: python3 verify_types.py <decompiled_dir> [--verbose]
Exits non-zero if any problem is found.
"""
import os
import re
import sys

INT, WIDE, FLOAT, DOUBLE, OBJ, UNKNOWN, CONFLICT, ZERO = (
    'int', 'wide', 'float', 'double', 'obj', '?', '!', '0')

BAD = (CONFLICT,)

SMALI_DIRS = ('smali', 'smali_classes2')

# ---------------------------------------------------------------------------
# type rules
# ---------------------------------------------------------------------------
CONST_INT = ('const/4', 'const/16', 'const', 'const/high16')
CONST_WIDE = ('const-wide', 'const-wide/16', 'const-wide/32', 'const-wide/high16')

INT_OPS = {
    'add-int', 'sub-int', 'mul-int', 'div-int', 'rem-int', 'and-int', 'or-int',
    'xor-int', 'shl-int', 'shr-int', 'ushr-int', 'rsub-int', 'neg-int', 'not-int',
    'add-int/2addr', 'sub-int/2addr', 'mul-int/2addr', 'div-int/2addr',
    'rem-int/2addr', 'and-int/2addr', 'or-int/2addr', 'xor-int/2addr',
    'shl-int/2addr', 'shr-int/2addr', 'ushr-int/2addr',
    'add-int/lit16', 'rsub-int/lit16', 'add-int/lit8', 'rsub-int/lit8',
    'mul-int/lit16', 'mul-int/lit8', 'div-int/lit16', 'div-int/lit8',
    'rem-int/lit16', 'rem-int/lit8', 'and-int/lit16', 'and-int/lit8',
    'or-int/lit16', 'or-int/lit8', 'xor-int/lit16', 'xor-int/lit8',
    'shl-int/lit8', 'shr-int/lit8', 'ushr-int/lit8',
    'array-length', 'instance-of',
}
WIDE_OPS = {
    'add-long', 'sub-long', 'mul-long', 'div-long', 'rem-long', 'and-long',
    'or-long', 'xor-long', 'shl-long', 'shr-long', 'ushr-long', 'neg-long',
    'not-long', 'add-long/2addr', 'sub-long/2addr', 'mul-long/2addr',
    'div-long/2addr', 'rem-long/2addr', 'and-long/2addr', 'or-long/2addr',
    'xor-long/2addr', 'shl-long/2addr', 'shr-long/2addr', 'ushr-long/2addr',
    'neg-long/2addr', 'not-long/2addr',
}
FLOAT_OPS = {
    'add-float', 'sub-float', 'mul-float', 'div-float', 'rem-float',
    'add-float/2addr', 'sub-float/2addr', 'mul-float/2addr', 'div-float/2addr',
    'rem-float/2addr', 'neg-float', 'neg-float/2addr',
}
DOUBLE_OPS = {
    'add-double', 'sub-double', 'mul-double', 'div-double', 'rem-double',
    'add-double/2addr', 'sub-double/2addr', 'mul-double/2addr',
    'div-double/2addr', 'rem-double/2addr', 'neg-double', 'neg-double/2addr',
}
CONVERSIONS = {
    'int-to-long': WIDE, 'int-to-float': FLOAT, 'int-to-double': DOUBLE,
    'long-to-int': INT, 'long-to-float': FLOAT, 'long-to-double': DOUBLE,
    'float-to-int': INT, 'float-to-long': WIDE, 'float-to-double': DOUBLE,
    'double-to-int': INT, 'double-to-long': WIDE, 'double-to-float': FLOAT,
    'int-to-byte': INT, 'int-to-char': INT, 'int-to-short': INT,
}
CMP_INT = re.compile(r'^cmp\w*-(long|float|double)$')

OBJ_GET = ('sget-object', 'iget-object', 'aget-object', 'move-object',
           'move-object/from16', 'move-object/16', 'new-instance', 'new-array',
           'const-string', 'const-string/jumbo', 'const-class')

# value operand of a put must have this type
PUT_REQUIRED = {}
for op in ('sput-boolean', 'sput-byte', 'sput-char', 'sput-short',
           'iput-boolean', 'iput-byte', 'iput-char', 'iput-short',
           'aput-boolean', 'aput-byte', 'aput-char', 'aput-short'):
    PUT_REQUIRED[op] = INT
for op in ('sput-wide', 'iput-wide'):
    PUT_REQUIRED[op] = WIDE
for op in ('sput-object', 'iput-object', 'aput-object'):
    PUT_REQUIRED[op] = OBJ

# instruction -> type produced in its destination register
PRODUCES = {}
for op in CONST_INT:
    PRODUCES[op] = INT
for op in CONST_WIDE:
    PRODUCES[op] = WIDE
for op in INT_OPS:
    PRODUCES[op] = INT
for op in WIDE_OPS:
    PRODUCES[op] = WIDE
for op in FLOAT_OPS:
    PRODUCES[op] = FLOAT
for op in DOUBLE_OPS:
    PRODUCES[op] = DOUBLE
PRODUCES.update(CONVERSIONS)
for op in OBJ_GET:
    PRODUCES[op] = OBJ
for op in ('sget', 'sget-boolean', 'sget-byte', 'sget-char', 'sget-short',
           'iget', 'iget-boolean', 'iget-byte', 'iget-char', 'iget-short',
           'aget', 'aget-boolean', 'aget-byte', 'aget-char', 'aget-short',
           'filled-new-array/range'):
    PRODUCES.setdefault(op, INT)
PRODUCES['sget-wide'] = WIDE
PRODUCES['iget-wide'] = WIDE
PRODUCES['aget-wide'] = WIDE

WIDE_DEST_OPS = WIDE_OPS | set(CONST_WIDE) | {
    'move-wide', 'move-wide/from16', 'move-wide/16', 'move-result-wide',
    'sget-wide', 'iget-wide', 'aget-wide', 'int-to-long', 'float-to-long',
    'double-to-long', 'long-to-double',
}

TYPE_TAG = {
    'Z': INT, 'B': INT, 'C': INT, 'S': INT, 'I': INT,
    'J': WIDE, 'F': FLOAT, 'D': DOUBLE, 'L': OBJ, '[': OBJ,
}

PARAM_RE = re.compile(r'\((.*?)\)')


def parse_params(sig):
    m = PARAM_RE.search(sig)
    if not m:
        return []
    out = []
    body = m.group(1)
    i = 0
    while i < len(body):
        c = body[i]
        if c not in TYPE_TAG:
            i += 1
            continue
        out.append(TYPE_TAG[c])
        if c == 'L':
            j = body.find(';', i)
            i = len(body) if j < 0 else j + 1
        elif c == '[':
            while i < len(body) and body[i] == '[':
                i += 1
            if i < len(body) and body[i] == 'L':
                j = body.find(';', i)
                i = len(body) if j < 0 else j + 1
            else:
                i += 1
        else:
            i += 1
    return out


def return_type(sig):
    m = re.search(r'\)(.+)$', sig)
    if not m:
        return INT
    t = m.group(1)
    if not t or t == 'V':
        return INT
    return TYPE_TAG.get(t[0], UNKNOWN)


# ---------------------------------------------------------------------------
# parsing
# ---------------------------------------------------------------------------
def read_methods(path):
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    cur = None
    for n, raw in enumerate(lines, 1):
        s = raw.strip()
        if s.startswith('.method'):
            cur = {'header': s, 'ops': [], 'nums': [], 'labels': {}, 'regs': 0}
        elif s.startswith('.end method') and cur is not None:
            yield cur
            cur = None
        elif cur is not None:
            if s.startswith('.locals'):
                try:
                    cur['regs'] = int(s.split()[1])
                except (IndexError, ValueError):
                    pass
            elif s.startswith(':'):
                cur['labels'][s.split()[0].rstrip(',')] = len(cur['ops'])
            elif s and not s.startswith(('.', '#', '}')):
                cur['ops'].append(s)
                cur['nums'].append(n)


def reg_index(tok, regs, param_base):
    """Map v0../p0.. to a flat index so aliasing is handled."""
    if tok.startswith('v'):
        return int(tok[1:])
    if tok.startswith('p'):
        return param_base + int(tok[1:])
    return None


def categorize(tok):
    return tok


def expand_regs(text, regs, pbase):
    m = re.search(r'\{\s*v(\d+)\s*\.\.\s*v(\d+)\s*\}', text)
    if m:
        return ['v%d' % i for i in range(int(m.group(1)), int(m.group(2)) + 1)]
    m = re.search(r'\{\s*p(\d+)\s*\.\.\s*p(\d+)\s*\}', text)
    if m:
        return ['p%d' % i for i in range(int(m.group(1)), int(m.group(2)) + 1)]
    br = re.search(r'\{([^}]*)\}', text)
    if not br:
        return []
    out = []
    for part in br.group(1).split(','):
        part = part.strip()
        mm = re.match(r'^(v\d+|p\d+)', part)
        if mm:
            out.append(mm.group(1))
    return out


def dest_reg(text, regs, pbase):
    m = re.match(r'^(v\d+|p\d+)', text)
    return m.group(1) if m else None


# ---------------------------------------------------------------------------
# per-method dataflow
# ---------------------------------------------------------------------------
def analyse(m):
    ops = m['ops']
    if not ops:
        return []

    # total register count: .locals counts v-registers, params follow
    sig = m['header']
    params = parse_params(sig)
    wide_params = sum(2 if p in (WIDE, DOUBLE) else 1 for p in params)
    static = ' static ' in sig
    locals_n = m['regs']
    pbase = locals_n  # p0 is the first param register
    total = locals_n + wide_params + (0 if static else 1)

    def idx(tok):
        if tok.startswith('v'):
            return int(tok[1:])
        return pbase + int(tok[1:])

    def name(i, want_p=False):
        if i >= pbase:
            return 'p%d' % (i - pbase)
        return 'v%d' % i

    n = len(ops)
    # successors
    succ = [[] for _ in range(n)]
    for i, s in enumerate(ops):
        op, _, rest = s.partition(' ')
        nxt = i + 1
        if op.startswith('goto'):
            tgt = rest.split(',')[-1].strip()
            succ[i] = [m['labels'][tgt]] if tgt in m['labels'] else []
            continue
        if op.startswith('if-'):
            parts = [p.strip() for p in rest.split(',')]
            tgt = parts[-1]
            lst = [nxt] if nxt < n else []
            if tgt in m['labels']:
                lst.append(m['labels'][tgt])
            succ[i] = lst
            continue
        if op in ('return', 'return-void', 'return-object', 'return-wide',
                  'throw', 'packed-switch', 'sparse-switch'):
            succ[i] = []
            continue
        succ[i] = [nxt] if nxt < n else []

    entry = [UNKNOWN] * total

    def merge(a, b):
        out = list(a)
        for i in range(total):
            x, y = a[i], b[i]
            if x == y:
                out[i] = x
            elif x == UNKNOWN:
                out[i] = y
            elif y == UNKNOWN:
                out[i] = x
            elif x == ZERO:
                out[i] = y
            elif y == ZERO:
                out[i] = x
            else:
                out[i] = CONFLICT
        return out

    states = [None] * n
    worklist = [0]
    states[0] = list(entry)
    problems = []

    while worklist:
        i = worklist.pop()
        cur = list(states[i])
        s = ops[i]
        op, _, rest = s.partition(' ')

        before = list(cur)

        # ---- type constraint checks (use the state *before* the write)
        req = PUT_REQUIRED.get(op)
        if req:
            src = dest_reg(rest, locals_n, pbase)
            if src:
                have = cur[idx(src)]
                # there is no sput-float / sput-double: floats ride in sput and
                # doubles in sput-wide, so accept the sibling type.
                ok = {req}
                if req == INT:
                    ok.add(FLOAT)
                if req == WIDE:
                    ok.add(DOUBLE)
                if have not in (UNKNOWN, CONFLICT, ZERO) and have not in ok:
                    problems.append((m['nums'][i], s,
                                     'writes a %s value into a %s slot (register %s holds %s)'
                                     % (have, req, src, have)))

        # arithmetic needs a numeric register.  This is the 15.0.1 build 3
        # regression: `add-int v19, v6, v1` where v1 was the const-string
        # "BuyDongleSettings" left over from the statement above.  Assembling
        # is happy; the verifier rejects the whole class.
        numeric_check = None
        REF_TAKING = {'instance-of', 'array-length'}
        if op not in REF_TAKING and (op in INT_OPS or op in WIDE_OPS
                                     or op in FLOAT_OPS or op in DOUBLE_OPS):
            numeric_check = INT if op in INT_OPS else (
                WIDE if op in WIDE_OPS else (DOUBLE if op in DOUBLE_OPS else FLOAT))
        if numeric_check:
            # operand 0 is the destination, only the sources must be numeric
            operands = [t.strip() for t in rest.split(',')][1:]
            for tok in operands:
                r_ = re.match(r'^(v\d+|p\d+)', tok)
                if not r_:
                    continue
                have = cur[idx(r_.group(1))]
                if have in (UNKNOWN, CONFLICT, ZERO):
                    continue
                allowed = {INT, FLOAT}
                if numeric_check == WIDE:
                    allowed = {WIDE, DOUBLE}
                elif numeric_check == DOUBLE:
                    allowed = {DOUBLE, WIDE}
                if have == OBJ or have not in allowed:
                    problems.append((m['nums'][i], s,
                                     'arithmetic on a %s register %s' % (have, r_.group(1))))
                    break

        if op.startswith('invoke'):
            sig_str = rest.split('->')[-1] if '->' in rest else ''
            want = parse_params(sig_str)
            got = expand_regs(rest, locals_n, pbase)
            # invoke-virtual/direct/interface/super pass the receiver in the
            # first register slot; params follow it.  invoke-static does not.
            base_slot = 0 if op.startswith('invoke-static') else 1
            slot = base_slot
            for pos, w in enumerate(want):
                if slot >= len(got):
                    break
                have = cur[idx(got[slot])]
                if have in (UNKNOWN, CONFLICT, ZERO):
                    continue
                if (w == OBJ and have in (INT, WIDE, FLOAT, DOUBLE)) or \
                   (w in (INT, WIDE, FLOAT, DOUBLE) and have == OBJ):
                    problems.append((m['nums'][i], s,
                                     'argument %d expects %s but register %s holds %s'
                                     % (pos + 1, w, got[slot], have)))
                slot += 2 if w in (WIDE, DOUBLE) else 1

        # ---- transfer
        d = dest_reg(rest, locals_n, pbase)
        if op in CONST_INT and d:
            val = rest.split(',')[-1].strip()
            try:
                is_zero = int(val, 16) == 0 if val.lower().startswith(('0x', '-0x')) else int(val) == 0
            except ValueError:
                is_zero = False
            cur[idx(d)] = ZERO if is_zero else INT
        elif op in PRODUCES and d:
            t = PRODUCES[op]
            if op in OBJ_GET and op.startswith('move-object'):
                t = OBJ
            if op.startswith('move') and not op.startswith('move-'):
                # plain move copies the type
                src = dest_reg(rest.split(',')[1].strip() if ',' in rest else '', locals_n, pbase)
                t = cur[idx(src)] if src else UNKNOWN
            cur[idx(d)] = t
            if op in WIDE_DEST_OPS:
                j = idx(d)
                if j + 1 < total:
                    cur[j + 1] = WIDE
        elif op.startswith('move-result'):
            t = UNKNOWN
            if i > 0 and ops[i - 1].startswith('invoke'):
                prev = ops[i - 1]
                psig = prev.split('->')[-1] if '->' in prev else ''
                t = return_type(psig)
                if op == 'move-result-object':
                    t = OBJ if t != UNKNOWN else UNKNOWN
            if d:
                cur[idx(d)] = t
        elif op.startswith('move-object'):
            src = dest_reg(rest.split(',')[1].strip() if ',' in rest else '', locals_n, pbase)
            if d:
                cur[idx(d)] = cur[idx(src)] if src else OBJ
        elif op.startswith('move'):
            src = dest_reg(rest.split(',')[1].strip() if ',' in rest else '', locals_n, pbase)
            if d:
                cur[idx(d)] = cur[idx(src)] if src else UNKNOWN
        elif CMP_INT.match(op):
            if d:
                cur[idx(d)] = INT

        for j in succ[i]:
            if states[j] is None:
                states[j] = list(cur)
                worklist.append(j)
            else:
                merged = merge(states[j], cur)
                if merged != states[j]:
                    states[j] = merged
                    worklist.append(j)
    return problems


def scan(root, verbose=False):
    total_methods = 0
    findings = []
    for sd in SMALI_DIRS:
        base = os.path.join(root, sd)
        if not os.path.isdir(base):
            continue
        for dp, _dn, files in os.walk(base):
            for f in files:
                if not f.endswith('.smali'):
                    continue
                path = os.path.join(dp, f)
                for m in read_methods(path):
                    total_methods += 1
                    for num, s, why in analyse(m):
                        findings.append((os.path.relpath(path, root), num, s, why))
    return total_methods, findings


# ---------------------------------------------------------------------------
def verify_xrefs(root):
    """Every `invoke-*` / field access into a class defined in this DEX must
    name a member that actually exists.

    This is the check that was missing for three builds in a row.  A call to a
    method that does not exist on a class we ship is not caught by the smali
    assembler, by `apktool b`, by androguard, or by the type checker: the
    instructions are individually valid.  It only fails on a device, at the
    moment the call is reached, with NoSuchMethodError.

    Members of platform / library classes cannot be checked here, only classes
    defined in this tree.
    """
    import glob
    meth = {}
    fld = {}
    supers = {}
    for sd in SMALI_DIRS:
        base = os.path.join(root, sd)
        if not os.path.isdir(base):
            continue
        for path in glob.glob(os.path.join(base, '**', '*.smali'), recursive=True):
            cls = None
            for raw in open(path, encoding='utf-8', errors='replace'):
                line = raw.strip()
                if line.startswith('.class'):
                    cls = line.split()[-1]
                    meth.setdefault(cls, set())
                    fld.setdefault(cls, set())
                elif cls and line.startswith('.super'):
                    supers[cls] = line.split()[-1]
                elif cls and line.startswith('.method'):
                    sig = line.split(None, 1)[-1]
                    # strip modifiers: last token pair is name(params)ret
                    head = sig
                    name = head.split('(')[0].split()[-1]
                    desc = '(' + head.split('(', 1)[1] if '(' in head else '()V'
                    meth[cls].add((name, desc))
                elif cls and line.startswith('.field'):
                    parts = line.split()
                    for tok in parts:
                        if ':' in tok:
                            n, d = tok.split(':', 1)
                            fld[cls].add((n, d))
                            break

    def has_member(cls, key, table):
        """Walk the superclass chain within the classes we ship.  A member
        inherited from a parent we also define is legal; one inherited from a
        platform class cannot be checked and is assumed to exist."""
        seen = set()
        cur = cls
        while cur and cur in table and cur not in seen:
            seen.add(cur)
            if key in table[cur]:
                return True
            cur = supers.get(cur)
        return cur is not None and cur not in supers and cur not in table

    problems = []
    member_ref = re.compile(r'(L[^;]+;)->([\w$<>]+)(\([^)]*\)\S*)')
    field_ref = re.compile(r'(L[^;]+;)->([\w$]+) (\S+)$')
    for sd in SMALI_DIRS:
        base = os.path.join(root, sd)
        if not os.path.isdir(base):
            continue
        for path in glob.glob(os.path.join(base, '**', '*.smali'), recursive=True):
            rel = os.path.relpath(path, root)
            for n, raw in enumerate(open(path, encoding='utf-8', errors='replace'), 1):
                line = raw.strip()
                if line.startswith(('.', '#')):
                    continue
                if line.startswith('invoke'):
                    m = member_ref.search(line)
                    if not m:
                        continue
                    owner, name, desc = m.groups()
                    if owner not in meth:
                        continue
                    if not has_member(owner, (name, desc), meth):
                        problems.append((rel, n, line,
                                         '%s->%s%s does not exist' % (owner, name, desc)))
                elif line.split(' ')[0] in ('sget', 'sput', 'sget-object', 'sput-object',
                                            'sget-boolean', 'sput-boolean', 'sget-wide',
                                            'sput-wide', 'iget', 'iput', 'iget-object',
                                            'iput-object', 'iget-boolean', 'iput-boolean',
                                            'iget-wide', 'iput-wide'):
                    m = field_ref.search(line)
                    if not m:
                        continue
                    owner, name, desc = m.groups()
                    if owner not in fld:
                        continue
                    if not has_member(owner, (name, desc), fld):
                        problems.append((rel, n, line,
                                         '%s->%s:%s does not exist' % (owner, name, desc)))
    return problems


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    verbose = '--verbose' in sys.argv
    if len(args) != 1:
        sys.exit(__doc__)
    total, findings = scan(args[0], verbose)
    print('== type check: %d methods' % total)
    for rel, num, s, why in findings:
        print('%s:%d: %s' % (rel, num, s))
        print('    %s' % why)
    if findings:
        print('\nFAILED: %d type violation(s) - Android would reject these classes' % len(findings))
        return 1
    print('OK: no type violations')

    xref = verify_xrefs(args[0])
    print('== cross-reference check')
    for rel, num, line, why in xref:
        print('%s:%d: %s' % (rel, num, line))
        print('    %s' % why)
    if xref:
        print('\nFAILED: %d unresolvable member reference(s) - NoSuchMethodError/NoSuchFieldError on device'
              % len(xref))
        return 1
    print('OK: every call into a class we ship resolves')
    return 0


if __name__ == '__main__':
    sys.exit(main())


# ---------------------------------------------------------------------------
# cross-reference check: every call into a class we ship must resolve
