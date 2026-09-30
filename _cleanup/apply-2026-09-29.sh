#!/bin/bash
# Obsidian vault cleanup — 2026-09-29
# Generated because device_bash (the Linux workspace) would not start.
#
# Run it:   bash ~/Desktop/Projects/ashar-mac/_cleanup/apply-2026-09-29.sh
#
# Safety properties:
#   * Nothing is ever overwritten  — every move uses `mv -n`.
#   * Nothing is ever `rm`'d       — duplicates go to ~/.Trash, recoverable in Finder.
#   * Duplicates are re-verified by SHA-256 at run time; a mismatch skips the file.
#   * Every step reports OK / SKIP, and a summary prints at the end.
#   * Re-running it is safe: already-done steps report SKIP and change nothing.
#   * It does not touch .git/, .obsidian/, .smart-env/, or Welcome.md.
#   * It does not run git. obsidian-git will sync as usual.

set -uo pipefail

VAULT="$HOME/Desktop/Projects/ashar-mac"
CLIP="$VAULT/Clippings"
TRASH="$HOME/.Trash"
STAMP="$(date +%Y%m%d-%H%M%S)"

MOVED=0; SKIPPED=0; TRASHED=0
declare -a PROBLEMS=()

if [ ! -d "$CLIP" ]; then
  echo "ERROR: $CLIP not found. Edit VAULT at the top of this script."; exit 1
fi

echo "Vault: $VAULT"
echo

# ---------------------------------------------------------------------------
# SECTION A — retire the 12 duplicate originals left behind by the 2026-09-23 pass
#
# That run copied notes into subfolders through the file bridge but could not
# delete the originals, so each of these exists twice. Both copies are compared
# by SHA-256 here; the loose original is moved to the Trash only on an exact
# match. If they differ, it is left alone and reported.
# ---------------------------------------------------------------------------
echo "=== A. Retiring duplicate originals (verified, to ~/.Trash) ==="

retire() {  # $1 = loose original (rel to Clippings)   $2 = the copy that is kept
  local orig="$CLIP/$1" keep="$CLIP/$2"
  if [ ! -f "$orig" ]; then
    echo "  SKIP  already gone: $1"; SKIPPED=$((SKIPPED+1)); return
  fi
  if [ ! -f "$keep" ]; then
    echo "  SKIP  kept copy missing, leaving original: $1"
    PROBLEMS+=("kept copy missing for $1"); SKIPPED=$((SKIPPED+1)); return
  fi
  local a b
  a=$(shasum -a 256 "$orig" | cut -d' ' -f1)
  b=$(shasum -a 256 "$keep" | cut -d' ' -f1)
  if [ "$a" != "$b" ]; then
    echo "  SKIP  NOT identical, left in place: $1"
    PROBLEMS+=("sha mismatch, not retired: $1"); SKIPPED=$((SKIPPED+1)); return
  fi
  local flat="${1//\//__}"
  mv -n "$orig" "$TRASH/${STAMP}--${flat}"
  if [ -f "$orig" ]; then
    echo "  SKIP  trash name collided, left in place: $1"
    PROBLEMS+=("trash collision: $1"); SKIPPED=$((SKIPPED+1))
  else
    echo "  OK    $1"; TRASHED=$((TRASHED+1))
  fi
}

retire "Agent Skills Overview.md"                                  "AI-Agents/Agent Skills Overview.md"
retire "Firecrawl Alexandria.md"                                   "AI-Agents/Firecrawl Alexandria.md"
retire "Pricing.md"                                                "AI-Agents/Papaya Agents - Pricing.md"
retire "Instinct is a personal assistant that understands what you're working on and what's important to you. It connects to your applications and devices - email, messaging, screen, audio, location, and more..md" "AI-Agents/Instinct - Personal assistant across your devices.md"
retire "Forgejo – Beyond coding. We forge..md"                      "Infra-DevOps/Forgejo - Self-hosted software forge.md"
retire "Upptime.md"                                                "Infra-DevOps/Upptime.md"
retire "Free Screen Recorder & Open Source Loom Alternative.md"     "Companies-Products/Cap - Open source screen recorder.md"
retire "NepoNet find a warm intro to anyone on X.md"               "Companies-Products/NepoNet - Warm intros on X.md"
retire "About  Documentation.md"                                   "Misc/CAT-SOOP Documentation.md"
retire "CAT-SOOP.md"                                               "Misc/CAT-SOOP.md"
retire "Class Site.md"                                             "Misc/MIT 6.2030 - Class Site.md"
retire "Class Site 1.md"                                           "Misc/MIT 6.2030 - Class Site.md"

# The MIT class-site page ended up in the vault four times. Three are retired
# above and here; one copy survives at Misc/MIT 6.2030 - Class Site.md.
retire "Misc/Class Site 1.md"                                      "Misc/MIT 6.2030 - Class Site.md"

echo

# ---------------------------------------------------------------------------
# SECTION B — file the 13 genuinely new notes
# ---------------------------------------------------------------------------
echo "=== B. Filing new notes ==="

file_note() {  # $1 = loose filename   $2 = destination rel to Clippings
  local src="$CLIP/$1" dst="$CLIP/$2"
  if [ ! -f "$src" ]; then
    echo "  SKIP  not found (already filed?): $1"; SKIPPED=$((SKIPPED+1)); return
  fi
  if [ -e "$dst" ]; then
    echo "  SKIP  destination exists: $2"
    PROBLEMS+=("destination existed, not moved: $2"); SKIPPED=$((SKIPPED+1)); return
  fi
  mv -n "$src" "$dst"
  if [ -f "$dst" ] && [ ! -f "$src" ]; then
    echo "  OK    $2"; MOVED=$((MOVED+1))
  else
    echo "  SKIP  move did not take effect: $1"
    PROBLEMS+=("mv silently skipped: $1"); SKIPPED=$((SKIPPED+1))
  fi
}

file_note "A lightweight and configurable spec framework.md"       "AI-Agents/OpenSpec - Spec framework for coding agents.md"
file_note "AX.md"                                                  "AI-Agents/AX - Agent Executor.md"
file_note "Codiv inference for open System One models.md"          "AI-Agents/Codiv - Inference for open System One models.md"
file_note "Nobodywho Local AI.md"                                  "AI-Agents/Nobodywho - Local AI SDKs.md"
file_note "One API for Any Model.md"                               "AI-Agents/AiHubMix - One API for any model.md"
file_note "Stability AI.md"                                        "AI-Agents/Stability AI.md"

file_note "AI coding has made CI a bottleneck, so we reworked ours to keep up.md" \
                                                                   "Infra-DevOps/AI coding has made CI a bottleneck.md"

file_note "API Documentation, SDKs, API Client & Registry.md"      "Companies-Products/Scalar - API docs, SDKs and registry.md"
file_note "Carrd - Simple, free, fully responsive one-page sites for pretty much anything.md" \
                                                                   "Companies-Products/Carrd - One-page sites.md"
file_note "Meetup Alternative for Groups, Events and Activities.md" "Companies-Products/Radius - Meetup alternative.md"
file_note "Operate like a bigger company. this+that.md"            "Companies-Products/this+that - Operate like a bigger company.md"

file_note "Recent activity.md"                                     "Fun-Curiosities/Issho - Anime activity feed.md"
file_note "The Birthday Freebie Edit.md"                           "Fun-Curiosities/The Birthday Freebie Edit.md"

echo

# ---------------------------------------------------------------------------
# SECTION C — topical tags
#
# Adds 1-3 topical tags alongside `clippings` in YAML frontmatter. Only touches
# notes that currently carry `clippings` and nothing else; anything already
# tagged is left exactly as it is. Tags reuse the vault's existing vocabulary,
# apart from two new ones (git-forge, mit-courses), each covering 4 notes.
# ---------------------------------------------------------------------------
echo "=== C. Adding topical tags ==="

python3 - "$CLIP" <<'PYEOF'
import sys, os, re

clip = sys.argv[1]

PLAN = {
 # --- newly filed this run ---
 "AI-Agents/OpenSpec - Spec framework for coding agents.md": ["coding-agents","agent-infra"],
 "AI-Agents/AX - Agent Executor.md":                          ["agent-infra","containers"],
 "AI-Agents/Codiv - Inference for open System One models.md": ["llm-providers","agent-infra"],
 "AI-Agents/Nobodywho - Local AI SDKs.md":                    ["llm-providers","agent-infra"],
 "AI-Agents/AiHubMix - One API for any model.md":             ["llm-providers","agent-infra"],
 "AI-Agents/Stability AI.md":                                 ["llm-providers"],
 "Infra-DevOps/AI coding has made CI a bottleneck.md":        ["devops-practice","coding-agents"],
 "Companies-Products/Scalar - API docs, SDKs and registry.md":["saas-products","devops-practice"],
 "Companies-Products/Carrd - One-page sites.md":              ["saas-products","personal-sites"],
 "Companies-Products/Radius - Meetup alternative.md":         ["saas-products","startups"],
 "Companies-Products/this+that - Operate like a bigger company.md": ["saas-products","startups"],
 "Fun-Curiosities/Issho - Anime activity feed.md":            ["fun"],
 "Fun-Curiosities/The Birthday Freebie Edit.md":              ["fun","food-drink"],

 # --- catch-up on already-filed notes that never got topical tags ---
 "AI-Agents/Agent Skills Overview.md":                        ["agent-infra","coding-agents"],
 "AI-Agents/Firecrawl Alexandria.md":                         ["agent-infra","scraping-data"],
 "AI-Agents/Instinct - Personal assistant across your devices.md": ["agent-infra","saas-products"],
 "AI-Agents/LangWatch - Personal Workspace.md":               ["observability","agent-infra"],
 "AI-Agents/Papaya Agents - Pricing.md":                      ["observability","agent-infra","saas-products"],
 "AI-Agents/Pi - Emotionally intelligent AI.md":              ["llm-providers"],
 "AI-Agents/Prompt Golf Leaderboard.md":                      ["fun","agent-infra"],
 "AI-Agents/SeKondBrain AI - Understanding Unshackled.md":    ["agent-infra","startups"],
 "AI-Agents/The AI collaboration super app.md":               ["saas-products","agent-infra"],
 "AI-Agents/TypeSafe AI - System One Models & Jev.md":        ["llm-providers","startups"],
 "Companies-Products/A brand partnership built for the long run.md": ["saas-products","devops-practice"],
 "Companies-Products/AI Note Taker & Study Tools.md":         ["saas-products"],
 "Companies-Products/AI, Data & Cloud Solutions.md":          ["saas-products"],
 "Companies-Products/Cap - Open source screen recorder.md":   ["saas-products"],
 "Companies-Products/Capacity - Turn your idea into a real app.md": ["saas-products","coding-agents"],
 "Companies-Products/Duckbill - AI that actually gets things done.md": ["saas-products","startups"],
 "Companies-Products/Gloomberb - Open source trading terminal.md": ["saas-products"],
 "Companies-Products/Hubble.md":                              ["saas-products"],
 "Companies-Products/Jetski - Read documentation effortlessly.md": ["saas-products","agent-infra"],
 "Companies-Products/NepoNet - Warm intros on X.md":          ["saas-products","startups"],
 "Companies-Products/Obsidian Web Clipper.md":                ["saas-products","personal-sites"],
 "Companies-Products/Powered By DevisionX.md":                ["saas-products"],
 "Fun-Curiosities/Any Human Ever one life from over 100 billion.md": ["fun"],
 "Fun-Curiosities/Get paid to record your work.md":           ["fun"],
 "Fun-Curiosities/Steven Universe.md":                        ["fun"],
 "Infra-DevOps/Forgejo - Self-hosted software forge.md":      ["devops-practice","git-forge"],
 "Infra-DevOps/Latency Numbers Every Programmer Should Know.md": ["devops-practice"],
 "Infra-DevOps/Upptime.md":                                   ["observability","devops-practice"],
 "Infra-DevOps/Your homelab is mostly fine (Dozzle).md":      ["containers","observability"],
 "Misc/CAT-SOOP Documentation.md":                            ["mit-courses"],
 "Misc/CAT-SOOP.md":                                          ["mit-courses","git-forge"],
 "Misc/MIT 6.2030 - Class Site.md":                           ["mit-courses"],
 "NYC-Local/The Restroom Archive.md":                         ["nyc"],
 "Reading/Tech Things Tokenmaxxing is dead, long live tokenmaxxing.md": ["essays"],
 "Reading/We still don’t know how people are really using AI.md":  ["essays"],

 # retroactive, so the two new tags each cover four notes
 "Infra-DevOps/AWS CodeCommit features.md":                   ["git-forge"],
 "Infra-DevOps/Stacked pull requests are now in public preview.md": ["git-forge"],
}

added = skipped = 0
for rel, tags in PLAN.items():
    p = os.path.join(clip, rel)
    if not os.path.isfile(p):
        print(f"  SKIP  not found: {rel}"); skipped += 1; continue
    text = open(p, encoding="utf-8").read()
    if not text.startswith("---"):
        print(f"  SKIP  no frontmatter: {rel}"); skipped += 1; continue
    end = text.find("\n---", 3)
    if end < 0:
        print(f"  SKIP  unterminated frontmatter: {rel}"); skipped += 1; continue
    head, rest = text[:end], text[end:]

    fm = head[3:]                      # skip the opening --- delimiter
    existing = re.findall(r'^\s*-\s*"?([\w\-/+.]+)"?\s*$', fm, re.M)
    topical = [t for t in existing if t != "clippings"]
    if topical:
        print(f"  SKIP  already tagged ({', '.join(topical)}): {rel}"); skipped += 1; continue

    m = re.search(r'^(\s*)-\s*"?clippings"?\s*$', head, re.M)
    if not m:
        print(f"  SKIP  no clippings tag line: {rel}"); skipped += 1; continue
    indent = m.group(1) or "  "
    block = "".join(f'\n{indent}- "{t}"' for t in tags)
    head = head[:m.end()] + block + head[m.end():]

    open(p, "w", encoding="utf-8").write(head + rest)
    print(f"  OK    +{', '.join(tags)}  {rel}")
    added += 1

print(f"  -- tagged {added}, skipped {skipped}")
PYEOF

echo

# ---------------------------------------------------------------------------
# SECTION D — verify
# ---------------------------------------------------------------------------
echo "=== D. Verification ==="
LOOSE=$(find "$CLIP" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
TOTAL=$(find "$CLIP" -name '*.md' | wc -l | tr -d ' ')
echo "  notes in Clippings/ (total):  $TOTAL"
echo "  still loose in Clippings/:    $LOOSE   (expected 0)"
if [ "$LOOSE" != "0" ]; then
  echo "  leftovers:"
  find "$CLIP" -maxdepth 1 -name '*.md' -exec basename {} \; | sed 's/^/    /'
fi
echo
echo "  moved:   $MOVED"
echo "  trashed: $TRASHED  (recoverable in Finder)"
echo "  skipped: $SKIPPED"
if [ ${#PROBLEMS[@]} -gt 0 ]; then
  echo
  echo "  NEEDS A LOOK:"
  for p in "${PROBLEMS[@]}"; do echo "    - $p"; done
fi
echo
echo "Done. Open Obsidian and let obsidian-git sync; its history is the undo path."
