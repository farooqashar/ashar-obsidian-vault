#!/bin/bash
# Obsidian vault cleanup — 2026-11-11
# Files 13 loose notes into the taxonomy, cleans filenames, adds topical tags.
# mv -n everywhere. No rm, ever. No git commands. Re-running is a no-op.
#
#   ./apply-2026-11-11.sh              # file + rename + tag (safe, default)
#   RETIRE_DUPES=1 ./apply-2026-11-11.sh   # ALSO move 3 byte-identical dupes to ~/.Trash

set -uo pipefail

VAULT="${VAULT:-$HOME/Desktop/Projects/ashar-mac}"
CL="$VAULT/Clippings"
SCRATCH="${TMPDIR:-/tmp}/vault-cleanup-$$"
mkdir -p "$SCRATCH"

[ -d "$CL" ] || { echo "FATAL: no Clippings dir at $CL"; exit 1; }

moved=0; already=0; missing=0; collide=0
tagged=0; tagskip=0; tagfail=0
retired=0; retireskip=0

# ---------------------------------------------------------------- helpers

# file_note <src-basename> <dest-subfolder> <dest-basename>
file_note() {
  local src="$CL/$1" destdir="$CL/$2" dest="$CL/$2/$3"
  if [ -f "$dest" ] && [ ! -f "$src" ]; then
    echo "OK   already filed: $2/$3"; already=$((already+1)); return 0
  fi
  if [ ! -f "$src" ]; then
    echo "SKIP missing source: $1"; missing=$((missing+1)); return 1
  fi
  if [ -e "$dest" ]; then
    echo "SKIP collision, left loose: $1 -> $2/$3"; collide=$((collide+1)); return 1
  fi
  [ -d "$destdir" ] || { echo "SKIP no such folder: $2"; missing=$((missing+1)); return 1; }
  mv -n "$src" "$dest"
  if [ -f "$dest" ] && [ ! -f "$src" ]; then
    echo "OK   filed: $1 -> $2/$3"; moved=$((moved+1)); return 0
  else
    echo "SKIP mv did not take effect: $1"; collide=$((collide+1)); return 1
  fi
}

# has_topical_tags <file>  -> 0 if a non-clippings tag already present
# Only reads the frontmatter: starts after the line-1 '---' and stops at the
# CLOSING '---', so the opening delimiter is never parsed as a tag and a '---'
# horizontal rule in the body is never reached.
# Counts ONLY dash-lines inside the tags: block. Other frontmatter keys are
# YAML lists too -- `author:` is often `  - "[[Name]]"` -- and counting those
# makes every note with a byline look already-tagged.
has_topical_tags() {
  local n
  n=$(awk '
    NR==1 && $0=="---" { fm=1; next }
    fm && $0=="---"    { exit }
    fm && /^tags:/     { intags=1; next }
    fm && intags && /^[[:space:]]*-[[:space:]]/ { print; next }
    fm && intags && /^[^[:space:]]/            { intags=0 }
  ' "$1" | grep -v '"clippings"' | wc -l | tr -d '[:space:]')
  [ "${n:-0}" != "0" ]
}

# tag_note <relative-path-under-Clippings> <tag> [<tag> ...]
tag_note() {
  local rel="$1"; shift
  local f="$CL/$rel"
  if [ ! -f "$f" ]; then
    echo "SKIP tag, no such file: $rel"; tagfail=$((tagfail+1)); return 1
  fi
  if has_topical_tags "$f"; then
    echo "SKIP already tagged: $rel"; tagskip=$((tagskip+1)); return 0
  fi
  local block="" t
  for t in "$@"; do block="${block}  - \"${t}\""$'\n'; done
  local tmp="$SCRATCH/tag.$$"
  # Web Clipper notes do not end with a newline. Remember that, so the rewrite
  # can reproduce it byte for byte instead of silently appending one.
  local had_nl=1
  [ -n "$(tail -c 1 "$f")" ] && had_nl=0
  awk -v newt="$block" '
    NR==1 && $0=="---" { fm=1; print; next }
    fm && $0=="---"    { fm=0; print; next }
    fm && /^tags:/     { intags=1; print; next }
    fm && intags && !done && /^[[:space:]]*-[[:space:]]*"clippings"[[:space:]]*$/ {
        print; printf "%s", newt; done=1; next }
    { print }
  ' "$f" > "$tmp"
  if [ ! -s "$tmp" ]; then
    echo "SKIP tag, awk produced nothing: $rel"; tagfail=$((tagfail+1)); return 1
  fi
  # The rewrite must differ from the original by exactly the new tag lines.
  # awk 'END{print NR}', not wc -l: wc -l does not count a final line that has
  # no newline after it, which is every note in this vault.
  local want got
  want=$(( $(awk 'END{print NR}' "$f") + $# ))
  got=$(awk 'END{print NR}' "$tmp")
  if [ "$want" -ne "$got" ]; then
    echo "SKIP tag, line count $got != expected $want: $rel"; tagfail=$((tagfail+1)); return 1
  fi
  # in-place update: no mv over a real file, no rm
  if [ "$had_nl" = "0" ]; then
    local sz; sz=$(wc -c < "$tmp" | tr -d '[:space:]')
    head -c $((sz-1)) "$tmp" > "$f"      # drop the newline awk added at EOF
  else
    cat "$tmp" > "$f"
  fi
  echo "OK   tagged: $rel [$*]"; tagged=$((tagged+1))
}

# retire_dupe <rel-keep> <rel-dupe>   (only if byte-identical RIGHT NOW)
retire_dupe() {
  local keep="$CL/$1" dupe="$CL/$2" rel="$2"
  if [ ! -f "$dupe" ]; then echo "SKIP retire, already gone: $rel"; retireskip=$((retireskip+1)); return 0; fi
  if [ ! -f "$keep" ]; then echo "SKIP retire, keeper missing: $1"; retireskip=$((retireskip+1)); return 1; fi
  local a b
  a=$(shasum -a 256 "$keep"  | awk '{print $1}')
  b=$(shasum -a 256 "$dupe" | awk '{print $1}')
  if [ "$a" != "$b" ]; then
    echo "SKIP retire, NO LONGER identical: $rel"; retireskip=$((retireskip+1)); return 1
  fi
  mkdir -p "$HOME/.Trash"
  local flat="${rel//\//__}"
  local target="$HOME/.Trash/$(date +%Y%m%d-%H%M%S)__${flat}"
  mv -n "$dupe" "$target"
  if [ ! -f "$dupe" ]; then
    echo "OK   retired to ~/.Trash: $rel"; retired=$((retired+1))
  else
    echo "SKIP retire, mv did not take effect: $rel"; retireskip=$((retireskip+1))
  fi
}

# ---------------------------------------------------------------- 1. file + rename

echo "== filing loose notes =="

file_note "More Confidence, Not More Code Review.md" \
          "AI-Agents" "More Confidence, Not More Code Review.md"

file_note "APM.md" \
          "AI-Agents" "APM - A dependency manager for AI agents.md"

file_note "Google AI Studio.md" \
          "AI-Agents" "Google AI Studio.md"

file_note "Learns how you work, then gets to work..md" \
          "AI-Agents" "Town - The unusually helpful AI work assistant.md"

file_note "Zone Neurofeedback Earbuds & In-Ear EEG Focus Tracking.md" \
          "Companies-Products" "Zone - Neurofeedback Earbuds & In-Ear EEG Focus Tracking.md"

file_note "Runtime Promises - What AWS Lambda Was Hiding.md" \
          "Infra-DevOps" "Runtime Promises - What AWS Lambda Was Hiding.md"

file_note "Long Island Rail Road Jamaica On-Time Performance.md" \
          "NYC-Local" "Long Island Rail Road Jamaica On-Time Performance.md"

file_note "Long Island Rail Road Jamaica On-Time Performance 1.md" \
          "NYC-Local" "Long Island Rail Road Jamaica On-Time Performance 1.md"

file_note "Farmingdale State College.md" \
          "NYC-Local" "Long Island Potato Festival (Farmingdale State College).md"

file_note "State of New York  Open Data.md" \
          "NYC-Local" "State of New York - Open Data.md"

file_note "New York's Highest Court, Decoded.md" \
          "NYC-Local" "New York's Highest Court, Decoded.md"

file_note "Find Defensive Driving Discounts & Courses by State.md" \
          "Misc" "Find Defensive Driving Discounts & Courses by State (GEICO).md"

# 112-char filename; the clipper flattened "simplifaisoul/osiris:" into one word.
# Resolved by find so the long name never has to be typed twice.
OSIRIS_SRC=$(find "$CL" -maxdepth 1 -name 'simplifaisoul*osiris*OSINT*.md' -print 2>/dev/null)
if [ "$(printf '%s\n' "$OSIRIS_SRC" | grep -c . )" = "1" ] && [ -n "$OSIRIS_SRC" ]; then
  file_note "$(basename "$OSIRIS_SRC")" \
            "Misc" "OSIRIS - Open Source Global Intelligence Platform (GitHub).md"
elif [ -f "$CL/Misc/OSIRIS - Open Source Global Intelligence Platform (GitHub).md" ]; then
  echo "OK   already filed: Misc/OSIRIS - Open Source Global Intelligence Platform (GitHub).md"
  already=$((already+1))
else
  echo "SKIP OSIRIS source ambiguous or missing"; missing=$((missing+1))
fi

# ---------------------------------------------------------------- 2. tags

echo
echo "== tagging =="

tag_note "AI-Agents/More Confidence, Not More Code Review.md"            coding-agents devops-practice
tag_note "AI-Agents/APM - A dependency manager for AI agents.md"         agent-infra coding-agents
tag_note "AI-Agents/Google AI Studio.md"                                 llm-providers agent-infra
tag_note "AI-Agents/Town - The unusually helpful AI work assistant.md"   agent-infra saas-products
tag_note "Companies-Products/Zone - Neurofeedback Earbuds & In-Ear EEG Focus Tracking.md" startups saas-products
tag_note "Infra-DevOps/Runtime Promises - What AWS Lambda Was Hiding.md" aws kubernetes devops-practice
tag_note "NYC-Local/Long Island Rail Road Jamaica On-Time Performance.md"    nyc scraping-data
tag_note "NYC-Local/Long Island Rail Road Jamaica On-Time Performance 1.md"  nyc scraping-data
tag_note "NYC-Local/Long Island Potato Festival (Farmingdale State College).md" nyc food-drink
tag_note "NYC-Local/State of New York - Open Data.md"                    nyc scraping-data
tag_note "NYC-Local/New York's Highest Court, Decoded.md"                nyc scraping-data
tag_note "Misc/OSIRIS - Open Source Global Intelligence Platform (GitHub).md" scraping-data

# Deliberately untagged, carried forward from previous weeks + 1 new:
#   Misc/Find Defensive Driving Discounts & Courses by State (GEICO).md  (NEW)
#   Misc/Depop - Search.md, Misc/Childhood Poverty is Everyone's Problem.md,
#   Misc/Atlas Corps Leadership Institute (ACLI).md,
#   Misc/National Walkout to Freeze AI · October 20.md,
#   Misc/Page Not Found (Apple Music).md,
#   Companies-Products/Chirie auto Chisinau - livrare aeroport 247.md

# ---------------------------------------------------------------- 3. duplicates (OFF by default)

echo
if [ "${RETIRE_DUPES:-0}" = "1" ]; then
  echo "== retiring byte-identical duplicates to ~/.Trash =="
  retire_dupe "Companies-Products/Braindate - Reinventing the way people meet and learn.md" \
              "Companies-Products/Braindate - Reinventing the way people meet and learn 1.md"
  retire_dupe "AI-Agents/TinyFish - Web infrastructure for AI agents.md" \
              "AI-Agents/TinyFish - Web infrastructure for AI agents 1.md"
  retire_dupe "Fun-Curiosities/Requests, Please - a WAF simulator game.md" \
              "Fun-Curiosities/Requests, Please - a WAF simulator game 1.md"
  # NOT eligible (verified not byte-identical): ssh exe.dev, FreeHire, LIRR Jamaica
else
  echo "== duplicates: nothing retired (RETIRE_DUPES unset) =="
fi

# ---------------------------------------------------------------- summary

echo
echo "---------------------------------------------"
echo "moved $moved, already filed $already, missing source $missing, collisions $collide"
echo "tagged $tagged, already tagged $tagskip, tag problems $tagfail"
echo "retired $retired, retire skipped $retireskip"
LOOSE=$(find "$CL" -maxdepth 1 -name '*.md' | wc -l | tr -d '[:space:]')
TOTAL=$(find "$CL" -name '*.md' | wc -l | tr -d '[:space:]')
echo "loose notes remaining: $LOOSE   total notes: $TOTAL"
echo "---------------------------------------------"
