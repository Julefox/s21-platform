#!/usr/bin/env python3
"""
Safe localization rebuild for S21 disk tables.

Resolves the localization root as the parent of this tools/ directory
(or LOC_DIR env). No machine-specific paths.

Commands:
  validate   Audit custom JSON + live .txt (no write)
  merge      Rebuild localization_<lang>.txt from retail .locl + custom JSON
             Refuses to write any language that fails parse or mojibake checks

Examples (run from anywhere):
  python tools/loc_safe_merge.py validate
  python tools/loc_safe_merge.py merge --retail-dir path/to/extracted_locl
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

# This file lives at: <loc_root>/tools/loc_safe_merge.py
TOOLS_DIR = Path(__file__).resolve().parent
LOC_DIR = Path(os.environ.get("LOC_DIR", str(TOOLS_DIR.parent))).resolve()
TW = LOC_DIR / "_translate_work"
CATALOG_PATH = LOC_DIR / "_custom_catalog_en.json"

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

# Classic multi-pass UTF-8 mojibake fragments. Any hit => refuse write.
MOJI_MARKERS = (
	"Ãƒ", "Ã‚", "â€™", "Ã£", "Ã¢â", "ï¿½", "Â¡", "Â¿", "ÃÂ",
)


def escape_custom_val(v: str) -> str:
	v = v.replace("\\", "\\\\")
	v = v.replace("\r\n", "\n").replace("\r", "\n").replace("\n", "\\n")
	v = v.replace('"', '\\"')
	return v


def _unescaped_quote_count(line: str) -> int:
	q = 0
	j = 0
	n = len(line)
	while j < n:
		if line[j] == "\\" and j + 1 < n:
			j += 2
			continue
		if line[j] == '"':
			q += 1
		j += 1
	return q


def _sanitize_retail_line(line: str) -> str:
	"""Collapse rare RSX double-backslash-quote (\\\\\") so engine parse accepts the line."""
	if not line.strip().startswith('"'):
		return line
	if _unescaped_quote_count(line) in (2, 4):
		return line
	needle = chr(92) + chr(92) + '"'
	repl = chr(92) + '"'
	fixed = line
	for _ in range(32):
		if _unescaped_quote_count(fixed) == 4:
			break
		if needle not in fixed:
			break
		fixed = fixed.replace(needle, repl, 1)
	return fixed


def extract_retail_body(locl_text: str) -> str:
	lines = locl_text.splitlines()
	body: list[str] = []
	in_block = False
	for line in lines:
		stripped = line.strip()
		if not in_block:
			if stripped == "{":
				in_block = True
			continue
		if stripped == "}":
			break
		body.append(_sanitize_retail_line(line.rstrip("\r\n")))
	return "\n".join(body)


def engine_parse_ok(text: str) -> tuple[bool, int, str]:
	"""Mirror of client disk ParseLoclText quote walk."""
	s = text
	n = len(s)

	def skip(p: int) -> int:
		while p < n:
			while p < n and s[p] in " \t\r\n":
				p += 1
			if p + 1 < n and s[p : p + 2] == "//":
				p += 2
				while p < n and s[p] != "\n":
					p += 1
				continue
			if p < n and s[p] == "#":
				p += 1
				while p < n and s[p] != "\n":
					p += 1
				continue
			if p + 1 < n and s[p : p + 2] == "/*":
				p += 2
				while p + 1 < n and s[p : p + 2] != "*/":
					p += 1
				if p + 1 < n:
					p += 2
				continue
			break
		return p

	def pq(p: int) -> tuple[str | None, int]:
		p = skip(p)
		if p >= n or s[p] != '"':
			return None, p
		p += 1
		while p < n and s[p] != '"':
			if s[p] == "\\" and p + 1 < n:
				p += 2
			else:
				p += 1
		if p >= n or s[p] != '"':
			return None, p
		return "ok", p + 1

	p = 0
	name, p = pq(p)
	if name is None:
		return False, 0, "asset name"
	p = skip(p)
	if p >= n or s[p] != "{":
		return False, 0, "open brace"
	p += 1
	count = 0
	while p < n:
		p = skip(p)
		if p < n and s[p] == "}":
			return True, count, ""
		k, p = pq(p)
		if k is None:
			return False, count, f"key@{s.count(chr(10), 0, p) + 1}"
		v, p = pq(p)
		if v is None:
			return False, count, f"val@{s.count(chr(10), 0, p) + 1}"
		count += 1
	return False, count, "eof"


def moji_count(text: str) -> int:
	return sum(text.count(m) for m in MOJI_MARKERS)


def fmt_sig(s: str) -> dict:
	return {
		"pct_s": sorted(re.findall(r"%s\d+", s)),
		"rui": sorted(re.findall(r"%\$[^%\s]+%", s)),
		"btn": sorted(re.findall(r"%\[[^\]]+\]%", s)),
		"ticks": sorted(re.findall(r"`[0-3]", s)),
	}


def load_catalog() -> dict:
	if not CATALOG_PATH.exists():
		raise SystemExit(f"missing catalog: {CATALOG_PATH}")
	return json.loads(CATALOG_PATH.read_text(encoding="utf-8"))


def load_entries(lang: str, catalog: dict) -> dict[str, str]:
	base = dict(catalog["entries"])
	if lang == "english":
		return base
	path = TW / f"entries_{lang}.json"
	if not path.exists():
		return base
	data = json.loads(path.read_text(encoding="utf-8"))
	entries = data.get("entries", data)
	base.update(entries)
	return base


def build_custom_block(catalog: dict, translations: dict[str, str]) -> str:
	lines: list[str] = [
		"",
		"\t// ============================================================",
		"\t// CUSTOM TEXT KEYS (human tokens)",
		"\t// ============================================================",
	]
	placed: set[str] = set()
	for sid, header in SECTION_HEADERS:
		keys = catalog.get("sections", {}).get(sid) or []
		if not keys:
			continue
		lines.append("")
		lines.append(f"\t{header}")
		for k in keys:
			val = translations.get(k, catalog["entries"].get(k, k))
			lines.append(f'\t"{k}" "{escape_custom_val(val)}"')
			placed.add(k)
	missing = [k for k in catalog["entries"] if k not in placed]
	if missing:
		lines.append("")
		lines.append("\t// OTHER CUSTOM")
		for k in sorted(missing, key=str.upper):
			val = translations.get(k, catalog["entries"][k])
			lines.append(f'\t"{k}" "{escape_custom_val(val)}"')
	return "\n".join(lines)


def validate_entries(catalog: dict) -> dict:
	en = catalog["entries"]
	report: dict = {"ok": True, "loc_dir": str(LOC_DIR), "langs": {}}
	for lang in LANGS:
		if lang == "english":
			continue
		path = TW / f"entries_{lang}.json"
		if not path.exists():
			report["ok"] = False
			report["langs"][lang] = {"error": "missing json"}
			continue
		data = json.loads(path.read_text(encoding="utf-8"))
		e = data.get("entries", data)
		miss = sorted(set(en) - set(e))
		extra = sorted(set(e) - set(en))
		moji = 0
		fmt_bad: list[str] = []
		for k, v in e.items():
			moji += moji_count(v)
			if k not in en:
				continue
			se, st = fmt_sig(en[k]), fmt_sig(v)
			for field in ("pct_s", "rui", "btn", "ticks"):
				if se[field] != st[field]:
					fmt_bad.append(f"{k}:{field} en={se[field]} tr={st[field]}")
		ok = not miss and not extra and moji == 0 and not fmt_bad
		if not ok:
			report["ok"] = False
		report["langs"][lang] = {
			"ok": ok,
			"count": len(e),
			"missing": len(miss),
			"extra": len(extra),
			"moji": moji,
			"fmt_bad": fmt_bad[:10],
		}
	return report


def validate_live_txt() -> list[dict]:
	rows = []
	for lang in LANGS:
		p = LOC_DIR / f"localization_{lang}.txt"
		if not p.exists():
			rows.append({"lang": lang, "ok": False, "error": "missing"})
			continue
		t = p.read_text(encoding="utf-8")
		ok, n, err = engine_parse_ok(t)
		moji = moji_count(t)
		rows.append({
			"lang": lang,
			"ok": ok and moji == 0,
			"pairs": n,
			"moji": moji,
			"parse_err": err,
			"bytes": p.stat().st_size,
		})
	return rows


def merge_all(retail_dir: Path, backup: bool) -> dict:
	catalog = load_catalog()
	retail_dir = retail_dir.resolve()
	bak_dir = None
	if backup:
		bak_dir = LOC_DIR / f"_merge_bak_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
		bak_dir.mkdir(exist_ok=True)

	results = []
	all_ok = True
	for lang in LANGS:
		locl = retail_dir / f"localization_{lang}.locl"
		if not locl.exists():
			# also accept nested localization/ from RSX export
			locl2 = retail_dir / "localization" / f"localization_{lang}.locl"
			locl = locl2 if locl2.exists() else locl
		if not locl.exists():
			results.append({"lang": lang, "ok": False, "error": f"missing .locl for {lang}", "written": False})
			all_ok = False
			continue

		dest = LOC_DIR / f"localization_{lang}.txt"
		if bak_dir and dest.exists():
			shutil.copy2(dest, bak_dir / dest.name)

		body = extract_retail_body(locl.read_text(encoding="utf-8"))
		tr = load_entries(lang, catalog)
		custom = build_custom_block(catalog, tr)
		out = (
			f'"localization_{lang}"\n'
			"{\n"
			"\t// --- retail hex keys (from rpak via RSX .locl) ---\n"
			f"{body}\n"
			f"{custom}\n"
			"}\n"
		)
		ok, pairs, err = engine_parse_ok(out)
		moji = moji_count(out)
		if not ok or moji:
			all_ok = False
			results.append({
				"lang": lang, "ok": False, "pairs": pairs, "moji": moji,
				"parse_err": err, "written": False,
			})
			continue
		dest.write_text(out, encoding="utf-8", newline="\n")
		results.append({
			"lang": lang, "ok": True, "pairs": pairs, "moji": moji,
			"bytes": dest.stat().st_size, "written": True,
		})
	return {"ok": all_ok, "loc_dir": str(LOC_DIR), "backup": str(bak_dir) if bak_dir else None, "results": results}


def main() -> int:
	ap = argparse.ArgumentParser(description="Safe S21 localization validate/merge")
	ap.add_argument("cmd", choices=["validate", "merge"])
	ap.add_argument(
		"--retail-dir",
		type=Path,
		default=None,
		help="Directory containing localization_<lang>.locl (or localization/ subfolder from RSX)",
	)
	ap.add_argument("--no-backup", action="store_true", help="Do not snapshot .txt before merge")
	args = ap.parse_args()

	print(f"LOC_DIR={LOC_DIR}", file=sys.stderr)

	if args.cmd == "validate":
		cat = load_catalog()
		rep = validate_entries(cat)
		print(json.dumps(rep, indent=2, ensure_ascii=False))
		print("\n--- live txt ---")
		live = validate_live_txt()
		for r in live:
			print(
				f"{r['lang']:12} ok={r.get('ok')} pairs={r.get('pairs', '-')} "
				f"moji={r.get('moji', '-')} {r.get('parse_err') or r.get('error') or ''}"
			)
		live_ok = all(r.get("ok") for r in live)
		pair_set = {r.get("pairs") for r in live if r.get("pairs") is not None}
		if len(pair_set) > 1:
			print(f"PAIR COUNT MISMATCH across languages: {sorted(pair_set)}")
			live_ok = False
		return 0 if rep["ok"] and live_ok else 2

	if args.cmd == "merge":
		if not args.retail_dir:
			print("merge requires --retail-dir <folder-with-.locl>", file=sys.stderr)
			return 1
		cat = load_catalog()
		rep = validate_entries(cat)
		hard = False
		for _lang, info in rep["langs"].items():
			if info.get("error") or info.get("missing") or info.get("extra") or info.get("moji") or info.get("fmt_bad"):
				hard = True
		if hard:
			print("REFUSING MERGE: fix validate issues first", file=sys.stderr)
			print(json.dumps(rep, indent=2, ensure_ascii=False))
			return 3
		out = merge_all(args.retail_dir, backup=not args.no_backup)
		print(json.dumps(out, indent=2, ensure_ascii=False))
		return 0 if out["ok"] else 2

	return 1


if __name__ == "__main__":
	sys.exit(main())
