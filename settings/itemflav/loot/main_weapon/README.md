# Adding a weapon that menus can see

A weapon added only as `scripts/weapons/<name>.txt` + a `survival_loot.csv` row
is fully playable but **invisible to every menu**. All UI enumerates
`GetAllItemFlavorsOfType`, which is fed by `settings` rpak assets. This folder
lets you author one of those assets as a loose JSON file instead of rebuilding
an rpak.

Everything below is required. Skipping any step produces a *different* error, so
work the list top to bottom.

---

## 1. The flavor JSON (this folder)

`<name>.json` here becomes the settings asset
`settings/itemflav/loot/main_weapon/<name>.rpak`.

```json
{
  "_donor": "settings/itemflav/loot/main_weapon/flatline.rpak",
  "layoutAsset": "settings_layout/settings_itemtype_loot_main_weapon_layout.rpak",
  "uniqueId": 1090000001,
  "settings": {
    "assetName": "settings/itemflav/loot/main_weapon/<name>.rpak",
    "itemType": "loot_main_weapon",
    "settingsAssetID": "SAID01090000001",
    "localizationKey_NAME": "#WPN_...",
    "localizationKey_NAME_SHORT": "#WPN_..._SHORT",
    "localizationKey_DESCRIPTION_LONG": "#WPN_..._LONGDESC",
    "localizationKey_DESCRIPTION_SHORT": "#WPN_..._DESC",
    "icon": "rui/menu/battlepass/weapon_icons/icon_...",
    "entityClassname": "mp_weapon_<name>",
    "category": "settings/itemflav/weapon_category/ar.rpak",
    "statsCategory": "ar",
    "armoryScale": 1.06,
    "battlePassScale": 1.8
  }
}
```

**`_donor` is required.** A settings asset is a typed binary record with ~40
fields; we clone an existing packed flavor's header and data block, then
overwrite only the keys listed under `settings`. Every field you do not mention
keeps the donor's valid value. Without a donor, string fields would be null
pointers and the client crashes on the first `Localize`.

Donor rules:

* Same layout (any `loot/main_weapon` flavor).
* **Prefer a donor with an empty `childClassnames`** (flatline, alternator, car,
  g7, kraber, ...). Arrays are not writable yet, so a donor with a crate child —
  hemlok, autopistol — leaks that child classname onto your weapon and hijacks
  the real weapon's flavor mapping.
* Reference JSONs to copy field names from:
  `<reference asset dump>/common/settings/itemflav/loot/main_weapon/`

`uniqueId` must be a positive 31-bit int, unique against every packed flavor.
Keep new ones in the `1090000000+` band. Next free is `1090000003`.
`settingsAssetID` must be `"SAID" + uniqueId zero-padded to 11 digits`
and must agree with `uniqueId`.

Writable field types: bool, int, float, string, asset. **Not** writable:
float2/float3 and arrays (`childClassnames`, `skins`) — those keep the donor's
values.

## 2. Register it in script

`platform/scripts/vscripts/sh_weapons.gnut`:

```squirrel
const array<asset> DISK_WEAPON_FLAVORS = [
    $"settings/itemflav/loot/main_weapon/<name>.rpak",
]
```

The registration loop is guarded `#if CLIENT || UI` on purpose — only the client
half has the disk-override module; an unguarded call raises a script error on
the dedi.

**Do not bother editing `base_itemflavors.json`.** The shipped registration path
reads the `weapons` array of `settings/base_itemflavors.rpak`, but the copy under
`the reference asset dump` is an RSX extraction artifact — the
engine loads the packed asset out of `common.rpak`, so editing the JSON has no
runtime effect without rebuilding that rpak. The script list above is the
supported way in. (Overriding `base_itemflavors` from disk would remove the need
for the script edit, but it needs dynamic-array authoring, which the writer does
not support yet.)

## 3. Give it persistence slots (pdef)

**This is the step people miss.** Menus store per-weapon state in the pdef, and a
weapon absent from it fails with `Invalid persistent var name` the moment a menu
touches it. A weapon needs exactly 12 lines in
`cfg/server/pdef_autogen.pdef`:

* 1 member of `$ENUM_START eWeaponFlavor` — backs every enum-indexed array,
  e.g. `mastery_weapons[eWeaponFlavor]`.
* 11 vars in the loadouts struct — `weapon_charm_for_<SAID>`,
  `weapon_skin_for_<SAID>`, and `weapon_skin_for_<SAID>_fav00..07`, all
  registered by `sh_weapon_cosmetics.nut`.

Do it with the tool, which handles both files and is idempotent:

```
python <sdk tools>/pdef_add_disk_weapon.py SAID01090000001 <name> --apply
```

### The re-bless loop (required after ANY pdef edit)

Editing the pdef changes its version hash, and the engine refuses to boot until
that hash is the **last** entry of `blessed_pdef_versions` in
`persistent_player_data_manifest.rson`. The hash is only known after the engine
computes it, so:

1. Start the dedi. It fails with
   `PDef version DG-<hash> is not last item in 'blessed_pdef_versions'`.
2. `python <sdk tools>/pdef_bless_from_log.py --apply`
3. Start the dedi again.

**Restart order is always dedi first, then client.** The client never reads the
pdef from disk — the dedi ships it over the wire as a BZ2 `PersistenceDefFile`.
A client-only restart silently keeps the old schema.

Note: adding pdef entries shifts persistence offsets, so existing mastery/stats
data may reset. `$SCRIPT_VERSION` is unchanged, so there is no migration path.

## 4. Localization

The four `localizationKey_*` tokens must resolve or the menu shows the raw
token. Retail tables key strings by name hash, not token name, so grep proves
nothing — audit and import with the `s21-localization-import` skill:

```
python <skill>\tools\loc_missing_audit.py
```

Borrowing an existing weapon's tokens (e.g. `#WPN_HEMLOK`) is fine for testing.

## 5. Content side

The weapon still needs its `scripts/weapons/mp_weapon_<name>.txt`, any
`survival_loot.csv` row, and its models/registry definitions. That is a separate
pipeline — see the `s21-weapon-content-port` skill.

---

## Verifying

Client log (`platform/logs/client/<newest GUID>/message.log`):

```
[SETTINGS-DISK] scan complete: N file(s) found, N parsed, 0 failed
[SETTINGS-DISK] built '.../<name>.rpak' donor='...' uniqueId=... written=15 skipped=0 (attempt 1)
```

`scan complete` at ~3s is the JSON parse. `built` comes later — the asset is
built on the first lookup after its donor's pak is resident, which is by design;
building at boot would always fail because no content pak is loaded yet.

Toggles: `sdk_settings 1` (default), `sdk_settings_verbose 1` for a
line per field written.

## Failure map

| symptom | cause |
|---|---|
| no `[SETTINGS-DISK]` lines at all | module not attached — check `VSettingsDiskS21` is in `s_SafeModeAllowlist` |
| `scan complete` but no `built` | donor never became resident, or `_donor` path is wrong |
| `donor not loaded` warning | typo in `_donor`, or donor is in a pak that never loads |
| `unknown field '<x>'` | the layout has no such field; check a reference JSON |
| `unsupported dataType` | float2/float3/array — not writable, drop the key |
| `Invalid persistent var name "..."` | step 3 not done, or dedi not restarted after the pdef edit |
| weapon shows the raw `#WPN_...` token | step 4 |
| a crate/child weapon takes your weapon's name | donor had a non-empty `childClassnames` |
