S21 disk localization — agent guide
=====================================

This folder is the LIVE language tables the client loads when disk localization
is enabled. Treat it as product data, not a scratch pad.

Layout (keep it clean)
----------------------
  localization_<lang>.txt     Full table per language (engine loads these)
  _custom_catalog_en.json     English authority for CUSTOM (human) keys only
  _translate_work/
    entries_<lang>.json       Per-language custom translations only
  tools/
    loc_safe_merge.py         validate + safe rebuild (preferred)
    loc_catalog.py            extract/verify custom catalog
  README.txt                  this file

Languages
---------
  arabic english french german italian japanese korean
  mspanish polish portuguese russian schinese spanish tchinese

Do not leave backup copies, *Copy*, *.bak, pre_*, or one-off scripts in this
tree. Temporary work goes elsewhere; only the files above should remain.

How the client uses this
------------------------
  ConVar:  localize_disk 1
  Load:    platform/localization/localization_<DetectLanguage()>.txt
  Hot text edit same language:  reload_localization
  Hot switch language (SDK):    language <name>
  Clear override:               language clear

  DetectLanguage is boot-cached by retail; the SDK language command overrides
  and reloads disk tables. Audio (miles) is separate.

File format (UTF-8 only)
------------------------
  "localization_spanish"
  {
      // comments: //  #  /* */
      "fca8cf6a685cb818" "Retail string"     // hex GUID key (>=10 hex digits)
      "DEV_MENU" "Dev Menu"                  // human token (hashed at load)
      "#TOKEN" "value"                       // leading # stripped
  }

  Rules:
  - Encoding MUST be UTF-8 (never UTF-16, never ANSI/Windows-1252 save).
  - Prefer LF newlines.
  - Escapes inside values:  \"   \\   \n
  - Non-breaking space (U+00A0) in retail strings is intentional (e.g. "%s5\xa0s.").
  - Later duplicate keys win (same hash).
  - Placeholders that MUST be preserved when translating: %s1 %s2 … %$rui/…%
    %[BUTTON|MOUSE]% and color ticks `0 `1 `2 `3

Two layers of content
---------------------
  1) RETAIL HEX KEYS
     Come from official localization_*.rpak (extract with RSX as .locl).
     Source of truth is the rpak backup / clean .locl dump — NOT a previously
     corrupted live .txt.

  2) CUSTOM HUMAN KEYS
     Bridge / Flowstate / menu extras. English set is _custom_catalog_en.json.
     Translations live only in _translate_work/entries_<lang>.json.
     English human strings for catalog extract come from localization_english.txt
     custom section (or re-extract via tools/loc_catalog.py extract).

HARD RULES — read before changing anything
------------------------------------------
  1. NEVER re-save localization_*.txt in an editor that changes encoding.
  2. NEVER rebuild retail hex blocks FROM a live .txt if size exploded or
     mojibake appears (Ãƒ Ã‚ â€™ Ã£ etc.). That means the file is corrupted;
     re-extract .locl from rpak and merge again.
  3. NEVER hand-merge by pasting whole languages through chat/LLM output into
     the big .txt (encoding and quote damage). Edit entries_*.json only, then merge.
  4. NEVER run in-place "fix encoding" / double-decode / chardet rewrites on
     the full tables without a validate pass that refuses write on failure.
  5. ALWAYS write UTF-8 without BOM (or BOM only if already present and parse OK).
  6. ALWAYS keep %sN / %$…% / %[…]% counts equal to English on custom keys.
  7. ALWAYS run tools/loc_safe_merge.py validate before and after changes.
  8. merge REFUSES to write a language if engine parse fails or mojibake markers
     are present — do not bypass that.

Safe edit workflows
-------------------
  A) Fix one custom string (grammar / accents)
     1. Edit _translate_work/entries_<lang>.json only (UTF-8).
     2. python tools/loc_safe_merge.py validate
     3. python tools/loc_safe_merge.py merge --retail-dir <dir-with-clean-.locl>
     4. In-game: language <lang>   or   reload_localization

  B) Add a new custom key
     1. Add English to localization_english.txt custom section OR to catalog
        via loc_catalog.py extract after editing english.
     2. Add translations to every entries_<lang>.json (same key).
     3. validate + merge as above.

  C) Restore retail strings after corruption
     1. RSX-extract clean .locl from original localization_*.rpak (+ optional (01) patch pak):
          rsx -nogui -export --exporttypes locl --exportdir <out> <rpak> [<patch.rpak>]
     2. python tools/loc_safe_merge.py merge --retail-dir <out>
        (script accepts <out> or <out>/localization containing .locl files)
     3. validate; confirm moji=0 and pairs ~equal across languages.

  D) Translate workflow (LLM batch)
     - Input: _custom_catalog_en.json (and/or English entries).
     - Output: ONLY _translate_work/entries_<lang>.json
     - Never emit full localization_*.txt from the model.
     - After batch: validate (format tokens + mojibake + key coverage) then merge.

Tools
-----
  LOC_DIR defaults to the parent of tools/. Override with env LOC_DIR if needed.

  python tools/loc_safe_merge.py validate
  python tools/loc_safe_merge.py merge --retail-dir <path-to-locl-dir>
  python tools/loc_safe_merge.py merge --retail-dir <path> --no-backup

  python tools/loc_catalog.py extract    # refresh catalog from english txt (unescapes \\n/\\\" into real chars)
  python tools/loc_catalog.py verify     # custom key coverage on all live .txt (fails on missing OR extra)

  merge creates _merge_bak_<timestamp>/ unless --no-backup. Delete old backups
  after you confirm the run; do not accumulate them in this folder long-term.

Health checklist (green = shippable)
------------------------------------
  [ ] All localization_*.txt UTF-8, parse OK (validate live section)
  [ ] moji markers = 0 in every file
  [ ] Pair counts MATCH across languages (same retail set + same custom count)
  [ ] Every entries_*.json has the same key set as _custom_catalog_en.json (no missing, no extra)
  [ ] Every localization_*.txt has the same custom key set as the catalog (no missing, no extra)
  [ ] No %sN / %$rui / %[btn] / `0-3 color-tick count mismatch vs English on custom keys
  [ ] No *Copy*, *.bak, pre_*, or scratch scripts left in this directory

What not to touch here
----------------------
  - Subtitles (subtitles_*.rpak) — separate system
  - Dedi-only localization_dedi_* — not client disk tables
  - RPak archives themselves — only extract FROM them; do not repack for this path

If something looks “broken” in-game
-----------------------------------
  1. Confirm localize_disk 1 and the log line [LOC-DISK] Reload/Queue lang='…'
  2. Confirm the active language name matches a localization_<lang>.txt file
  3. reload_localization or language <lang>
  4. If text is mojibake: do NOT re-save the file — restore via C) above
  5. If only custom keys wrong: fix entries_*.json and merge

End of guide.
