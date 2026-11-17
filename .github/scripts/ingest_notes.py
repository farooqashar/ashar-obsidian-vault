"""Sync the vault's notes into MongoDB Atlas so they can be searched by meaning.

Each note is split into chunks (one per heading section, merged or split to a
sensible size) and stored in the `notes` collection of the `vault` database:

    { _id: "<path>#<n>", path, title, folder, heading, tags, source, created,
      text, hash, updated_at }

Atlas Automated Embedding (Voyage AI `voyage-4`) turns `text` into vectors by
itself, so this script never calls an embedding model. Only chunks whose text
changed are rewritten, so unchanged notes cost no embedding tokens. Chunks for
deleted or renamed notes are removed.

The `ask_notes` tool in github.com/farooqashar/ashar-mcp searches this index.

Usage (from the vault root):
    MONGODB_URI=... python .github/scripts/ingest_notes.py
    python .github/scripts/ingest_notes.py --dry-run   # no database; just shows the chunks

Runs on every push via .github/workflows/sync-notes-search.yml.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

DB_NAME = os.environ.get("NOTES_DB", "vault")
COLLECTION = os.environ.get("NOTES_COLLECTION", "notes")
INDEX_NAME = "notes_vector"
EMBED_MODEL = "voyage-4"

# Folders and files that aren't notes.
SKIP_DIRS = {".git", ".github", ".obsidian", ".smart-env", ".trash", "_cleanup"}
SKIP_FILES = {"Welcome.md"}

# Chunk size in characters (~4 chars per token). Big enough to keep a section's
# context together, small enough that a search hit points at the relevant part.
MAX_CHARS = 4000
MIN_CHARS = 400

INDEX_DEFINITION = {
    "fields": [
        {"type": "autoEmbed", "modality": "text", "path": "text", "model": EMBED_MODEL},
        {"type": "filter", "path": "folder"},
        {"type": "filter", "path": "tags"},
    ]
}

FRONTMATTER = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.S)
HEADING = re.compile(r"^(#{1,3})\s+(.+?)\s*#*\s*$", re.M)


# ----------------------------------------------------------- parsing ---

def parse_frontmatter(raw: str) -> tuple[dict, str]:
    """Split simple YAML frontmatter (what Obsidian Web Clipper writes) from the body.
    Handles `key: value` and `key:` followed by `  - item` lists. No YAML dependency."""
    m = FRONTMATTER.match(raw)
    if not m:
        return {}, raw
    meta: dict = {}
    key = None
    for line in m.group(1).splitlines():
        item = re.match(r"^\s+-\s+(.*)$", line)
        if item and key:
            if not isinstance(meta.get(key), list):
                meta[key] = []
            meta[key].append(_unquote(item.group(1)))
            continue
        kv = re.match(r"^([\w-]+):\s*(.*)$", line)
        if kv:
            key, value = kv.group(1), kv.group(2).strip()
            meta[key] = _unquote(value) if value else None
    return meta, raw[m.end():]


def _unquote(s: str) -> str:
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "\"'":
        s = s[1:-1]
    return s


def clean(text: str) -> str:
    """Drop markdown noise that wastes tokens without adding meaning."""
    text = re.sub(r"!\[[^\]]*\]\([^)]*\)", "", text)            # images
    text = re.sub(r"\[([^\]]+)\]\((?:https?://)[^)]*\)", r"\1", text)  # links -> link text
    text = re.sub(r"\[\[([^\]|]+\|)?([^\]]+)\]\]", r"\2", text)  # [[wiki|links]]
    text = re.sub(r"<[^>]+>", "", text)                          # stray HTML
    text = re.sub(r"[ \t]+\n", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def sections(body: str) -> list[tuple[str, str]]:
    """Split a note body on headings (#, ##, ###) into (heading, text) pairs."""
    out: list[tuple[str, str]] = []
    last_end, heading = 0, ""
    for m in HEADING.finditer(body):
        out.append((heading, body[last_end:m.start()]))
        heading, last_end = m.group(2).strip(), m.end()
    out.append((heading, body[last_end:]))
    return [(h, clean(t)) for h, t in out if clean(t)]


def split_long(text: str) -> list[str]:
    """Split text longer than MAX_CHARS on paragraph boundaries."""
    if len(text) <= MAX_CHARS:
        return [text]
    parts, current = [], ""
    for para in text.split("\n\n"):
        while len(para) > MAX_CHARS:                 # one giant paragraph
            parts.append((current + "\n\n" + para[:MAX_CHARS]).strip() if current else para[:MAX_CHARS])
            current, para = "", para[MAX_CHARS:]
        if current and len(current) + len(para) + 2 > MAX_CHARS:
            parts.append(current)
            current = para
        else:
            current = f"{current}\n\n{para}" if current else para
    if current:
        parts.append(current)
    return parts


def chunk_note(rel_path: str, raw: str) -> list[dict]:
    meta, body = parse_frontmatter(raw)
    p = Path(rel_path)
    title = meta.get("title") or p.stem
    parts = p.parts
    folder = parts[1] if len(parts) > 2 and parts[0] == "Clippings" else (parts[0] if len(parts) > 1 else "")
    tags = meta.get("tags") if isinstance(meta.get("tags"), list) else ([meta["tags"]] if meta.get("tags") else [])
    description = meta.get("description") or ""

    # Merge small sections forward so each chunk carries enough context.
    merged: list[tuple[str, str]] = []
    for heading, text in sections(body):
        if merged and len(merged[-1][1]) < MIN_CHARS:
            prev_h, prev_t = merged[-1]
            merged[-1] = (prev_h or heading, f"{prev_t}\n\n{('## ' + heading + chr(10)) if heading else ''}{text}")
        else:
            merged.append((heading, text))
    if not merged and description:
        merged = [("", description)]

    chunks = []
    for heading, text in merged:
        for piece in split_long(text):
            n = len(chunks)
            # The title (and description on the first chunk) go into the embedded text,
            # so a section about "pricing" still knows which product it's about.
            header = f"# {title}\n" + (f"Section: {heading}\n" if heading else "")
            if n == 0 and description:
                header += f"Summary: {description}\n"
            full = f"{header}\n{piece}"
            chunks.append({
                "_id": f"{rel_path}#{n}",
                "path": rel_path,
                "title": title,
                "folder": folder,
                "heading": heading,
                "tags": tags,
                "source": meta.get("source") or None,
                "created": meta.get("created") or None,
                "text": full,
                "hash": hashlib.sha256(full.encode()).hexdigest(),
            })
    return chunks


def collect(root: Path) -> list[dict]:
    chunks: list[dict] = []
    for f in sorted(root.rglob("*.md")):
        rel = f.relative_to(root)
        if rel.parts[0] in SKIP_DIRS or rel.name in SKIP_FILES or any(p.startswith(".") for p in rel.parts):
            continue
        chunks.extend(chunk_note(rel.as_posix(), f.read_text(encoding="utf-8", errors="replace")))
    return chunks


# -------------------------------------------------------------- sync ---

def sync(collection, chunks: list[dict]) -> dict:
    """Upsert new or changed chunks and delete chunks that no longer exist."""
    from pymongo import DeleteOne, ReplaceOne

    existing = {d["_id"]: d.get("hash") for d in collection.find({}, {"hash": 1})}
    wanted = {c["_id"]: c for c in chunks}
    now = datetime.now(timezone.utc)

    ops = [ReplaceOne({"_id": cid}, {**c, "updated_at": now}, upsert=True)
           for cid, c in wanted.items() if existing.get(cid) != c["hash"]]
    upserts = len(ops)
    ops += [DeleteOne({"_id": cid}) for cid in existing.keys() - wanted.keys()]
    for i in range(0, len(ops), 500):
        collection.bulk_write(ops[i:i + 500], ordered=False)
    return {"upserted": upserts, "deleted": len(ops) - upserts, "unchanged": len(wanted) - upserts}


def ensure_index(collection) -> str:
    """Create the Automated Embedding vector index if it isn't there yet."""
    from pymongo.operations import SearchIndexModel

    names = {ix["name"] for ix in collection.list_search_indexes()}
    if INDEX_NAME in names:
        return "exists"
    collection.create_search_index(
        SearchIndexModel(definition=INDEX_DEFINITION, name=INDEX_NAME, type="vectorSearch")
    )
    return "created (Atlas embeds all notes in the background; give it a few minutes)"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--root", default=".", help="vault root (default: current directory)")
    ap.add_argument("--dry-run", action="store_true", help="print chunk stats; don't touch the database")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    chunks = collect(root)
    notes = len({c["path"] for c in chunks})
    chars = sum(len(c["text"]) for c in chunks)
    print(f"{notes} notes -> {len(chunks)} chunks, ~{chars // 4:,} tokens")

    if args.dry_run:
        sizes = sorted(len(c["text"]) for c in chunks)
        if sizes:
            print(f"chunk chars: min {sizes[0]}, median {sizes[len(sizes) // 2]}, max {sizes[-1]}")
        folders: dict[str, int] = {}
        for c in chunks:
            folders[c["folder"] or "(root)"] = folders.get(c["folder"] or "(root)", 0) + 1
        for name, n in sorted(folders.items(), key=lambda kv: -kv[1]):
            print(f"  {name}: {n}")
        return 0

    uri = os.environ.get("MONGODB_URI")
    if not uri:
        print("MONGODB_URI is not set; nothing synced.", file=sys.stderr)
        return 1

    from pymongo import MongoClient

    client = MongoClient(uri, appname="ashar-vault-ingest")
    coll = client[DB_NAME][COLLECTION]
    if COLLECTION not in client[DB_NAME].list_collection_names():
        client[DB_NAME].create_collection(COLLECTION)  # search indexes need the collection to exist
    stats = sync(coll, chunks)
    print(f"sync: {stats['upserted']} upserted, {stats['deleted']} deleted, {stats['unchanged']} unchanged")
    print(f"index {INDEX_NAME}: {ensure_index(coll)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
