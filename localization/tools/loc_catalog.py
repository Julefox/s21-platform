#!/usr/bin/env python3
"""
Custom localization catalog helpers (human keys only).

Resolves localization root as parent of tools/ (or LOC_DIR env).

Commands:
  extract   Build _custom_catalog_en.json from localization_english.txt human keys
  verify    Every language .txt has the same custom key set as the catalog

  python tools/loc_catalog.py extract
  python tools/loc_catalog.py verify
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parent
LOC_DIR = Path(os.environ.get("LOC_DIR", str(TOOLS_DIR.parent))).resolve()
CATALOG_PATH = LOC_DIR / "_custom_catalog_en.json"

PAIR = re.compile(r'^([\t ]*)"((?:\\.|[^"\\])*)"([\t ]+)"((?:\\.|[^"\\])*)"')

SECTION_HEADERS = [
	("DEV", "// DEV"),
	("FREE_ROAM", "// FREE ROAM (survival_dev / loadscreen)"),
	("MOVEMENT_RECORDER", "// MOVEMENT RECORDER (loadscreen)"),
	("BRIDGE", "// BRIDGE (auth / create / credits)"),
	("SERVER_BROWSER", "// SERVER BROWSER (main menu + lobby)"),
	("HUD", "// HUD / BADGES / BLEEDOUT"),
	("HUB", "// HUB"),
	("LAB", "// LAB (developer tools)"),
	("FLOWSTATE", "// FLOWSTATE"),
	("TRAINING", "// TRAINING"),
	("PLAYLIST_MAP", "// PLAYLIST / MAP"),
	("OTHER", "// OTHER CUSTOM"),
]

LANGS = [
	"arabic", "english", "french", "german", "italian", "japanese", "korean",
	"mspanish", "polish", "portuguese", "russian", "schinese", "spanish", "tchinese",
]


def is_hex_key(k: str) -> bool:
	if len(k) < 10:
		return False
	return all(c in "0123456789abcdefABCDEF" for c in k)


def unescape_loc_val(s: str) -> str:
	"""Loc-file value -> real characters. JSON stores real newlines/quotes."""
	out: list[str] = []
	i = 0
	n = len(s)
	while i < n:
		if s[i] == "\\" and i + 1 < n:
			nxt = s[i + 1]
			if nxt == "n":
				out.append("\n")
			elif nxt == "t":
				out.append("\t")
			elif nxt == '"':
				out.append('"')
			elif nxt == "\\":
				out.append("\\")
			else:
				out.append(nxt)
			i += 2
			continue
		out.append(s[i])
		i += 1
	return "".join(out)


def section_of(k: str) -> str:
	u = k.upper()
	if k.startswith("HUB_"):
		return "HUB"
	if k.startswith("LAB_"):
		return "LAB"
	if k.startswith("SETTING_") or k.startswith("FRSETTING_"):
		return "HUD"
	if k.startswith("BRIDGE_SB_") or k in (
		"MAINMENU_BROWSE_SERVERS",
		"MAINMENU_CONTINUE_LOCALLY",
		"BRIDGE_CONNECT_FAILED_HINT_BROWSE",
	):
		return "SERVER_BROWSER"
	if k.startswith("BRIDGE_"):
		return "BRIDGE"
	if k.startswith("FS_") or k.startswith("SCORE_EVENT_FS_") or k.startswith("SCORE_EVENT_SUR_"):
		return "FLOWSTATE"
	if k in ("PL_FREE_ROAM", "PL_FREE_ROAM_DESC", "MAP_DEVELOPER"):
		return "FREE_ROAM"
	if "MOVEMENT_RECORDER" in u:
		return "MOVEMENT_RECORDER"
	if k.startswith("DEV_") or k in ("DEV_MENU", "DEV_ONLY"):
		return "DEV"
	if k.startswith("HUD_") or k.startswith("BLEEDOUT_") or k.startswith("BADGE_") or k.startswith("INVALID_BADGE"):
		return "HUD"
	if k.startswith("TRAINING_"):
		return "TRAINING"
	if k.startswith("PL_") or k.startswith("MAP_") or u.startswith("MP_RR_"):
		return "PLAYLIST_MAP"
	return "OTHER"


def parse_pairs(text: str) -> list[tuple[str, str]]:
	out: list[tuple[str, str]] = []
	for line in text.splitlines():
		m = PAIR.match(line)
		if not m:
			continue
		k, v = m.group(2), m.group(4)
		if k.startswith("#"):
			k = k[1:]
		out.append((k, v))
	return out


def extract_english(path: Path) -> dict:
	text = path.read_text(encoding="utf-8")
	pairs = parse_pairs(text)
	custom: dict[str, str] = {}
	order: list[str] = []
	for k, v in pairs:
		if is_hex_key(k):
			continue
		if k not in custom:
			order.append(k)
		custom[k] = unescape_loc_val(v)
	sections: dict[str, list[str]] = {sid: [] for sid, _ in SECTION_HEADERS}
	for k in order:
		sid = section_of(k)
		sections.setdefault(sid, []).append(k)
	for sid in sections:
		sections[sid] = sorted(sections[sid], key=str.upper)
	return {
		"count": len(custom),
		"order": order,
		"entries": custom,
		"sections": sections,
	}


def verify(catalog: dict) -> dict:
	report = {"ok": True, "loc_dir": str(LOC_DIR), "langs": {}}
	want = set(catalog["entries"].keys())
	for lang in LANGS:
		path = LOC_DIR / f"localization_{lang}.txt"
		if not path.exists():
			report["ok"] = False
			report["langs"][lang] = {"error": "missing file"}
			continue
		pairs = parse_pairs(path.read_text(encoding="utf-8"))
		human = {k for k, _ in pairs if not is_hex_key(k)}
		hexn = sum(1 for k, _ in pairs if is_hex_key(k))
		missing = sorted(want - human)
		extra = sorted(human - want)
		ok = not missing and not extra
		if not ok:
			report["ok"] = False
		report["langs"][lang] = {
			"hex": hexn,
			"human": len(human),
			"missing_count": len(missing),
			"extra_count": len(extra),
			"missing": missing[:20],
			"extra": extra[:20],
			"ok": ok,
		}
	return report


def main() -> int:
	ap = argparse.ArgumentParser()
	ap.add_argument("cmd", choices=["extract", "verify"])
	ap.add_argument("--catalog", default=str(CATALOG_PATH))
	args = ap.parse_args()
	print(f"LOC_DIR={LOC_DIR}", file=sys.stderr)

	if args.cmd == "extract":
		en = LOC_DIR / "localization_english.txt"
		if not en.exists():
			print(f"missing {en}", file=sys.stderr)
			return 1
		cat = extract_english(en)
		out = Path(args.catalog)
		out.write_text(json.dumps(cat, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
		print(json.dumps({"ok": True, "count": cat["count"], "catalog": str(out)}))
		return 0

	if args.cmd == "verify":
		cat = json.loads(Path(args.catalog).read_text(encoding="utf-8"))
		print(json.dumps(verify(cat), indent=2, ensure_ascii=False))
		return 0

	return 1


if __name__ == "__main__":
	sys.exit(main())
