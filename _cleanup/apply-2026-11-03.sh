#!/bin/bash
# Obsidian vault cleanup - apply script generated 2026-11-03
# Files 21 loose notes in Clippings/ into the settled taxonomy, renames them,
# and adds topical tags. Never deletes. Safe to re-run (second run is a no-op).
set -uo pipefail
VAULT="${VAULT:-$HOME/Desktop/Projects/ashar-mac}"
C="$VAULT/Clippings"
[ -d "$C" ] || { echo "FATAL: Clippings folder not found at $C"; exit 1; }
command -v python3 >/dev/null || { echo "FATAL: python3 not found"; exit 1; }

TABLE=$(cat <<'TBL'
An agent workforce to scale your work..md|AI-Agents/Grep - An agent workforce to scale your work.md|agent-infra,saas-products
GitHub Universe 2026 Evolving every layer of the stack.md|AI-Agents/GitHub Universe 2026 - Evolving every layer of the stack.md|coding-agents,git-forge,agent-infra
Microsoft Copilot Studio  Create AI Agents.md|AI-Agents/Microsoft Copilot Studio - Create AI agents.md|agent-infra,saas-products
Professional Control of Visual AI.md|AI-Agents/Comfy - Professional control of visual AI.md|llm-providers,saas-products
The AI Workspace  Build, Distribute & Govern AI Agents.md|AI-Agents/Sim - The AI workspace to build and govern AI agents.md|agent-infra,saas-products
The GitHub Copilot harness is now the Microsoft Copilot harness.md|AI-Agents/The GitHub Copilot harness is now the Microsoft Copilot harness.md|coding-agents,agent-infra
What is Tessl?  Tessl Docs.md|AI-Agents/What is Tessl - Tessl Docs.md|coding-agents,agent-infra
The Local Cloud Development Sandbox for AI Agents.md|Infra-DevOps/LocalStack - The local cloud development sandbox for AI agents.md|aws,containers,devops-practice
AuthZed The Authorization Platform for AI and Modern Applications.md|Companies-Products/AuthZed - The authorization platform for modern apps.md|saas-products,databases
Realtime voice, video, and AI for developers.md|Companies-Products/Daily - Realtime voice, video, and AI for developers.md|saas-products,networking,agent-infra
the open-source search engine for tech jobs.md|Companies-Products/FreeHire - the open-source search engine for tech jobs.md|saas-products,scraping-data
the open-source search engine for tech jobs 1.md|Companies-Products/FreeHire - the open-source search engine for tech jobs 1.md|saas-products,scraping-data
About.md|Fun-Curiosities/Hackertube - YouTube videos Hacker News recommends.md|fun,scraping-data
Die Schweiz 11 in Minecraft.md|Fun-Curiosities/Die Schweiz 1-1 in Minecraft.md|fun,personal-sites
Local Wikipedia The Encyclopedia For Local People.md|Fun-Curiosities/Local Wikipedia - The encyclopedia for local people.md|fun,personal-sites
Make text like it’s 1997.md|Fun-Curiosities/Make text like it’s 1997.md|fun,personal-sites
Product Graveyard - SaaSHub's Startup Graveyard.md|Fun-Curiosities/Product Graveyard - SaaSHub's Startup Graveyard.md|fun,startups,saas-products
Requests, Please a WAF simulator game.md|Fun-Curiosities/Requests, Please - a WAF simulator game.md|fun,networking
Requests, Please a WAF simulator game 1.md|Fun-Curiosities/Requests, Please - a WAF simulator game 1.md|fun,networking
Sparks of Weight-Space Programming LLMs can natively read & write neural network weights.md|Reading/Sparks of Weight-Space Programming - LLMs read and write NN weights.md|essays
*Page Not Found.md|Misc/Page Not Found (Apple Music).md|
TBL
)

moved=0; already=0; missing=0; collided=0; tagged=0; tagskip=0; tagerr=0

while IFS='|' read -r src dest tags; do
  [ -z "${src:-}" ] && continue
  D="$C/$dest"
  # resolve source: literal path, else single glob match
  S="$C/$src"
  if [ ! -f "$S" ]; then
    # pattern source (e.g. a leading invisible character): resolve via find,
    # and only when it matches exactly one file
    cands=()
    while IFS= read -r line; do cands+=( "$line" ); done < <(find "$C" -maxdepth 1 -type f -name "$src" -print)
    if [ "${#cands[@]}" -eq 1 ]; then
      S="${cands[0]}"
    elif [ "${#cands[@]}" -gt 1 ]; then
      echo "SKIP ambiguous pattern ($src matched ${#cands[@]} files), left alone"
      collided=$((collided+1)); continue
    fi
  fi

  if [ -f "$D" ] && [ ! -f "$S" ]; then
    echo "OK   already filed:   $dest"; already=$((already+1))
  elif [ ! -f "$S" ]; then
    echo "SKIP missing source:  $src"; missing=$((missing+1)); continue
  elif [ -f "$D" ]; then
    echo "SKIP collision, both exist, left alone: $src -> $dest"; collided=$((collided+1)); continue
  else
    mkdir -p "$(dirname "$D")"
    mv -n "$S" "$D"
    if [ -f "$D" ] && [ ! -f "$S" ]; then
      echo "OK   filed:           $(basename "$S")"
      echo "       -> $dest"; moved=$((moved+1))
    else
      echo "SKIP mv did nothing:  $src"; collided=$((collided+1)); continue
    fi
  fi

  [ -z "${tags:-}" ] && { echo "       (left untagged by design)"; continue; }
  res=$(TAGS="$tags" python3 - "$D" <<'PY'
import os, re, sys
p = sys.argv[1]
new = [t for t in os.environ["TAGS"].split(",") if t]
t = open(p, encoding="utf-8").read()
if not t.startswith("---"):
    print("NO-FRONTMATTER"); raise SystemExit
end = t.find("\n---", 3)
if end == -1:
    print("UNTERMINATED-FRONTMATTER"); raise SystemExit
head = t[3:end] + "\n"          # trailing newline so the last tag line matches
rest = t[end:]
m = re.search(r'^tags:[ \t]*\n((?:[ \t]+-[ \t]*\S.*\n)+)', head, re.M)
if not m:
    print("NO-TAG-BLOCK"); raise SystemExit
cur = [x.strip().lstrip("-").strip().strip('"') for x in m.group(1).strip().splitlines()]
if [x for x in cur if x != "clippings"]:
    print("HAS-TOPICAL"); raise SystemExit
add = "".join('  - "%s"\n' % x for x in new if x not in cur)
if not add:
    print("NOOP"); raise SystemExit
head = head[:m.end(1)] + add + head[m.end(1):]
open(p, "w", encoding="utf-8").write("---" + head.rstrip("\n") + rest)
print("TAGGED")
PY
)
  case "$res" in
    TAGGED)            echo "       tags + $tags"; tagged=$((tagged+1));;
    HAS-TOPICAL|NOOP)  echo "       tags already present, skipped"; tagskip=$((tagskip+1));;
    *)                 echo "       TAG PROBLEM ($res) - frontmatter untouched"; tagerr=$((tagerr+1));;
  esac
done <<< "$TABLE"

echo
echo "---------------------------------------------"
echo "moved:            $moved"
echo "already filed:    $already"
echo "missing source:   $missing"
echo "collisions:       $collided"
echo "tagged:           $tagged"
echo "tag skipped:      $tagskip"
echo "tag problems:     $tagerr"
echo "loose .md left in Clippings/: $(find "$C" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')"
echo "total notes:                  $(find "$C" -name '*.md' | wc -l | tr -d ' ')"
echo "---------------------------------------------"
echo "Nothing was deleted. No git commands were run."

# ---------------------------------------------------------------------------
# Optional: retire byte-identical duplicate copies to ~/.Trash
# OFF by default. Deleting is off by default in this vault by design.
# Run with:  RETIRE_DUPES=1 ./apply-2026-11-03.sh
# Each pair is re-verified by SHA-256 at run time and skipped on any mismatch.
# Nothing is ever rm'd; files go to ~/.Trash where you can put them back.
# ---------------------------------------------------------------------------
if [ "${RETIRE_DUPES:-0}" = "1" ]; then
  echo
  echo "Retiring byte-identical duplicates to ~/.Trash"
  STAMP=$(date +%Y%m%d-%H%M%S)
  mkdir -p "$HOME/.Trash"
  PAIRS=$(cat <<'PRS'
Companies-Products/Braindate - Reinventing the way people meet and learn.md|Companies-Products/Braindate - Reinventing the way people meet and learn 1.md
AI-Agents/TinyFish - Web infrastructure for AI agents.md|AI-Agents/TinyFish - Web infrastructure for AI agents 1.md
Fun-Curiosities/Requests, Please - a WAF simulator game.md|Fun-Curiosities/Requests, Please - a WAF simulator game 1.md
PRS
)
  retired=0; dskip=0
  while IFS='|' read -r keep drop; do
    [ -z "${keep:-}" ] && continue
    K="$C/$keep"; R="$C/$drop"
    if [ ! -f "$R" ]; then echo "  SKIP already gone: $drop"; dskip=$((dskip+1)); continue; fi
    if [ ! -f "$K" ]; then echo "  SKIP keeper missing, left alone: $keep"; dskip=$((dskip+1)); continue; fi
    hk=$(shasum -a 256 "$K" | awk '{print $1}')
    hr=$(shasum -a 256 "$R" | awk '{print $1}')
    if [ "$hk" != "$hr" ]; then
      echo "  SKIP not identical any more, left alone: $drop"; dskip=$((dskip+1)); continue
    fi
    rel="${drop//\//__}"
    mv -n "$R" "$HOME/.Trash/${STAMP}__${rel}"
    if [ ! -f "$R" ]; then
      echo "  OK   retired: $drop  (sha ${hk:0:12})"; retired=$((retired+1))
    else
      echo "  SKIP mv did nothing: $drop"; dskip=$((dskip+1))
    fi
  done <<< "$PAIRS"
  echo "  retired=$retired skipped=$dskip"
  echo "  total notes now: $(find "$C" -name '*.md' | wc -l | tr -d ' ')"
else
  echo
  echo "Duplicate retirement not run (RETIRE_DUPES unset). 3 byte-identical copies"
  echo "are flagged in the report; re-run with RETIRE_DUPES=1 to move them to ~/.Trash."
fi
