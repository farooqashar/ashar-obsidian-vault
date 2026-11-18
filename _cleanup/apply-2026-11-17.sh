#!/bin/bash
# Vault cleanup — 2026-11-17
# Idempotent: re-running is a no-op. Never deletes. mv -n everywhere.
# Optional: RETIRE_DUPES=1 ./apply-2026-11-17.sh   -> moves byte-identical
#           duplicate siblings to ~/.Trash (re-verified by shasum at run time).

set -uo pipefail

# Works both on the Mac and inside the device_bash VM.
if [ -n "${VAULT:-}" ]; then :
elif [ -d "$HOME/Desktop/Projects/ashar-mac" ]; then VAULT="$HOME/Desktop/Projects/ashar-mac"
elif [ -d "$HOME/mnt/ashar-mac" ]; then VAULT="$HOME/mnt/ashar-mac"
else echo "FATAL: vault not found"; exit 1; fi
CL="$VAULT/Clippings"
echo "vault: $VAULT"
echo

moved=0; already=0; mvskip=0; tagged=0; tagskip=0; tagfail=0

# ---------------------------------------------------------------- 1. FILE+RENAME
# src (loose, under Clippings/) | dest folder | new filename | tags
PLAN=$(cat <<'PLAN_EOF'
- Fediverse.Party - explore federated networks.md|Misc|Fediverse.Party - explore federated networks.md|privacy,personal-sites
AI meeting notes that stay on your computer.md|Companies-Products|Yogurt - AI meeting notes that stay on your computer.md|saas-products,privacy
ASCE Bridge Designer.md|Fun-Curiosities|ASCE Bridge Designer.md|fun
Arena AI The Official AI Ranking & LLM Leaderboard.md|AI-Agents|Arena AI - The Official AI Ranking & LLM Leaderboard.md|llm-providers,agent-infra
B'way Rush.md|NYC-Local|B'way Rush.md|nyc
Bring your own key (BYOK).md|AI-Agents|Linear - Bring your own key (BYOK).md|llm-providers,saas-products
Bring your own key (BYOK) 1.md|AI-Agents|Linear - Bring your own key (BYOK) 1.md|llm-providers,saas-products
Deno Deploy.md|Infra-DevOps|Deno Deploy.md|web-frameworks,saas-products
Introducing Claude Meetings, now in beta.md|AI-Agents|Introducing Claude Meetings, now in beta.md|llm-providers,agent-infra
Joomla.org.md|Infra-DevOps|Joomla.org.md|web-frameworks,personal-sites
Log in.md|Companies-Products|Powtoon - Log in.md|saas-products
Login to Wingman AI Personal Assistant.md|AI-Agents|Wingman - AI Personal Assistant.md|agent-infra,saas-products
Loop Breakpoint.md|AI-Agents|Loop Breakpoint.md|agent-infra,coding-agents
Make a Free Website - Free Website Builder.md|Companies-Products|Yola - Free Website Builder.md|saas-products,personal-sites
The Top Coding and Computer Science Platform for K-12 Schools.md|Companies-Products|CodeHS - Coding and CS Platform for K-12 Schools.md|saas-products
The web framework for content-driven websites.md|Infra-DevOps|Astro - The web framework for content-driven websites.md|web-frameworks,personal-sites
The web is more than enough.md|Reading|The web is more than enough.md|essays,web-frameworks
ToshibaNSTA ExploraVision.md|Misc|Toshiba-NSTA ExploraVision.md|
Turn any task into an agent that runs on a schedule.md|AI-Agents|JigJoy - Turn any task into an agent that runs on a schedule.md|agent-infra,saas-products
Underground 2 Revived.md|Fun-Curiosities|Underground 2 Revived - NFS Underground 2 in the browser.md|fun
What even is code mode?.md|AI-Agents|What even is code mode.md|coding-agents,agent-infra
What is AWS Emulator?.md|Infra-DevOps|What is AWS Emulator.md|aws,devops-practice
Which AI Made This?.md|AI-Agents|Which AI Made This.md|llm-providers,coding-agents
WikidataMain Page.md|Misc|Wikidata - Main Page.md|databases,scraping-data
ngrok deliver your apps, APIs, and AI on local and prod.md|Infra-DevOps|ngrok - deliver your apps, APIs, and AI on local and prod.md|networking,devops-practice
👋 Hi. I'm Sam..md|Misc|Sam Rose (samwho.dev).md|personal-sites,essays
PLAN_EOF
)

echo "=== 1. filing loose notes ==="
while IFS='|' read -r src dest new tags; do
  [ -z "${src:-}" ] && continue
  s="$CL/$src"; d="$CL/$dest/$new"
  if [ -f "$d" ] && [ ! -f "$s" ]; then
    echo "  --   already filed: $dest/$new"; already=$((already+1)); continue
  fi
  if [ ! -f "$s" ]; then
    echo "  SKIP source missing, dest also missing: $src"; mvskip=$((mvskip+1)); continue
  fi
  if [ -f "$d" ]; then
    echo "  SKIP collision, both exist: $src  ->  $dest/$new"; mvskip=$((mvskip+1)); continue
  fi
  mkdir -p "$CL/$dest"
  mv -n "$s" "$d"
  if [ -f "$d" ] && [ ! -f "$s" ]; then
    if [ "$src" = "$new" ]; then echo "  OK   $src  ->  $dest/"
    else echo "  OK   $src  ->  $dest/$new  (renamed)"; fi
    moved=$((moved+1))
  else
    echo "  SKIP mv did not take effect: $src"; mvskip=$((mvskip+1))
  fi
done <<< "$PLAN"

# ---------------------------------------------------------------------- 2. TAGS
echo
echo "=== 2. tagging ==="
while IFS='|' read -r src dest new tags; do
  [ -z "${src:-}" ] && continue
  [ -z "${tags:-}" ] && { echo "  --   left untagged by design: $new"; continue; }
  f="$CL/$dest/$new"
  [ -f "$f" ] || { echo "  SKIP not found for tagging: $dest/$new"; tagfail=$((tagfail+1)); continue; }
  out=$(TAGS="$tags" python3 -I - "$f" <<'PY'
import os, sys, re
path = sys.argv[1]
want = [t.strip() for t in os.environ['TAGS'].split(',') if t.strip()]
raw = open(path, 'rb').read()
try:
    txt = raw.decode('utf-8')
except UnicodeDecodeError:
    print("FAIL not utf-8"); sys.exit(0)

def nlines(s):
    # Web Clipper notes have no trailing newline; count a final
    # unterminated line the way awk 'END{print NR}' does.
    if s == '': return 0
    return s.count('\n') + (0 if s.endswith('\n') else 1)

if not txt.startswith('---\n'):
    print("FAIL no frontmatter"); sys.exit(0)
end = txt.find('\n---', 3)
if end == -1:
    print("FAIL unterminated frontmatter"); sys.exit(0)

lines = txt.split('\n')
# locate the tags: key inside the frontmatter only
fm_end = None
for i in range(1, len(lines)):
    if lines[i].rstrip() == '---':
        fm_end = i; break
if fm_end is None:
    print("FAIL no frontmatter end"); sys.exit(0)

ti = None
for i in range(1, fm_end):
    if re.match(r'^tags:\s*$', lines[i]) or re.match(r'^tags:\s*\S', lines[i]):
        ti = i; break
if ti is None:
    print("FAIL no tags key"); sys.exit(0)
if lines[ti].strip() != 'tags:':
    print("FAIL tags not a block list"); sys.exit(0)

# Only dash-lines that belong to the tags: block count as tags.
# A dash-line under author: or any other key is NOT a tag.
last = ti; existing = []
j = ti + 1
while j < fm_end and re.match(r'^\s+-\s', lines[j]):
    existing.append(lines[j].strip()[1:].strip().strip('"\''))
    last = j; j += 1

topical = [t for t in existing if t and t != 'clippings']
if topical:
    print("SKIP already tagged (" + ", ".join(topical) + ")"); sys.exit(0)

add = [t for t in want if t not in existing]
if not add:
    print("SKIP nothing to add"); sys.exit(0)
newlines = ['  - "%s"' % t for t in add]
out = lines[:last+1] + newlines + lines[last+1:]
new_txt = '\n'.join(out)

# Guards: exactly the intended lines added, exactly the intended bytes added,
# and the file's missing EOF newline preserved.
if nlines(new_txt) != nlines(txt) + len(add):
    print("FAIL line-count guard"); sys.exit(0)
expect = len(raw) + sum(len(l.encode('utf-8')) + 1 for l in newlines)
blob = new_txt.encode('utf-8')
if len(blob) != expect:
    print("FAIL byte-count guard (%d != %d)" % (len(blob), expect)); sys.exit(0)
if txt.endswith('\n') != new_txt.endswith('\n'):
    print("FAIL eof-newline guard"); sys.exit(0)
if blob[:len(raw.split(b'tags:')[0])] != raw[:len(raw.split(b'tags:')[0])]:
    print("FAIL prefix guard"); sys.exit(0)

open(path, 'wb').write(blob)
print("OK   +" + ",".join(add))
PY
)
  case "$out" in
    OK*)   echo "  $out   $dest/$new"; tagged=$((tagged+1)) ;;
    SKIP*) echo "  $out   $dest/$new"; tagskip=$((tagskip+1)) ;;
    *)     echo "  $out   $dest/$new"; tagfail=$((tagfail+1)) ;;
  esac
done <<< "$PLAN"

# -------------------------------------------------------- 3. DUPLICATE RETIREMENT
echo
echo "=== 3. duplicates ==="
RETIRE="${RETIRE_DUPES:-0}" VAULTDIR="$VAULT" python3 -I - <<'PY'
import os, re, glob, hashlib, collections, datetime, shutil
vault = os.environ['VAULTDIR']; retire = os.environ['RETIRE'] == '1'
os.chdir(vault)
src = collections.defaultdict(list)
for p in sorted(glob.glob('Clippings/**/*.md', recursive=True)):
    head = open(p, encoding='utf-8', errors='replace').read(800)
    m = re.search(r'^source:\s*"?(.*?)"?\s*$', head, re.M)
    u = (m.group(1) if m else '').strip()
    u = re.sub(r'[?&](utm_[^&]*|ref|fbclid|gclid)=[^&]*', '', u).rstrip('?&/')
    if u: src[u].append(p)

pairs = [(u, ps) for u, ps in src.items() if len(ps) > 1]
ident = []
for u, ps in sorted(pairs):
    hs = {p: hashlib.sha256(open(p, 'rb').read()).hexdigest() for p in ps}
    same = len(set(hs.values())) == 1
    print("  %s  %s" % ("IDENTICAL" if same else "differs  ", u[:90]))
    for p in ps:
        print("      %8d b  %s  %s" % (os.path.getsize(p), hs[p][:16], p))
    if same and len(ps) == 2:
        # keeper = the one without the ' 1' suffix, else the shorter name
        a, b = sorted(ps, key=lambda x: (len(x), x))
        ident.append((a, b))
print("  --> %d pair(s), %d byte-identical" % (len(pairs), len(ident)))

if not ident:
    pass
elif not retire:
    print("  retirement OFF (default). To retire the byte-identical siblings:")
    print("    cd ~/Desktop/Projects/ashar-mac/_cleanup && RETIRE_DUPES=1 ./apply-2026-11-17.sh")
else:
    trash = os.path.expanduser('~/.Trash')
    os.makedirs(trash, exist_ok=True)
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    for keeper, dupe in ident:
        if not (os.path.exists(keeper) and os.path.exists(dupe)):
            print("  SKIP retire, file missing: %s" % dupe); continue
        # re-verify at run time; this report's hashes are not what we trust
        if hashlib.sha256(open(keeper,'rb').read()).digest() != \
           hashlib.sha256(open(dupe,'rb').read()).digest():
            print("  SKIP retire, no longer identical: %s" % dupe); continue
        dst = os.path.join(trash, "%s__%s" % (stamp, dupe.replace('/', '__')))
        if os.path.exists(dst):
            print("  SKIP retire, trash target exists: %s" % dst); continue
        shutil.move(dupe, dst)
        print("  OK   retired -> ~/.Trash/%s" % os.path.basename(dst))
        print("       keeper kept: %s" % keeper)
PY

# ------------------------------------------------------------------ 4. VERIFY
echo
echo "=== 4. verification ==="
VAULTDIR="$VAULT" python3 -I - <<'PY'
import os, re, glob, collections
vault = os.environ['VAULTDIR']; os.chdir(vault)
loose = glob.glob('Clippings/*.md')
allmd = glob.glob('Clippings/**/*.md', recursive=True)
folders = sorted(d for d in os.listdir('Clippings') if os.path.isdir('Clippings/' + d))
print("  notes: %d   loose: %d   folders: %d (%s)" % (len(allmd), len(loose), len(folders), ", ".join(folders)))
for p in loose: print("    LOOSE:", p)
bad = []
for p in allmd:
    n = os.path.basename(p)[:-3]
    if len(os.path.basename(p)) > 80: bad.append(("over 80 chars", p))
    if re.search(r'[<>?*]', n): bad.append(("illegal char", p))
    if n.endswith('.'): bad.append(("trailing period", p))
    if '  ' in n: bad.append(("doubled space", p))
    if '—' in n or '–' in n: bad.append(("en/em dash", p))
for why, p in bad: print("    FILENAME %s: %s" % (why, p))
if not bad: print("  filenames: clean (<=80 chars, no <>?*, no trailing period, no doubled space, no dashes)")
cnt = collections.Counter(); untag = []
for p in sorted(allmd):
    t = open(p, encoding='utf-8', errors='replace').read()
    lines = t.split('\n'); fe = None
    for i in range(1, len(lines)):
        if lines[i].rstrip() == '---': fe = i; break
    tags = []
    if fe:
        for i in range(1, fe):
            if lines[i].strip() == 'tags:':
                j = i + 1
                while j < fe and re.match(r'^\s+-\s', lines[j]):
                    tags.append(lines[j].strip()[1:].strip().strip('"\'')); j += 1
                break
    top = [x for x in tags if x and x != 'clippings']
    for x in top: cnt[x] += 1
    if not top and os.path.dirname(p) != 'Clippings': untag.append(p)
print("  topical tags: %d distinct" % len(cnt))
print("  " + ", ".join("%s %d" % (k, v) for k, v in cnt.most_common()))
print("  deliberately untagged: %d" % len(untag))
for u in untag: print("    ", u)
PY

echo
echo "=== summary ==="
echo "  moved $moved   already filed $already   mv skipped $mvskip"
echo "  tagged $tagged   tag skipped $tagskip   tag failed $tagfail"
