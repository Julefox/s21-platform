# Loose settings assets

This folder mirrors the engine's `settings/` asset namespace. A JSON file here
becomes a settings (stgs) asset at runtime without rebuilding an rpak:

```
platform\settings\itemflav\loot\main_weapon\my_gun.json
        -> settings/itemflav/loot/main_weapon/my_gun.rpak
```

The path IS the asset name — mirror the reference tree exactly. Reference dumps
of every shipped asset (copy field names and shapes from these):

```
<reference asset dump>/common/settings/
```

Client only. The dedi has no disk-override module, so registration in script is
guarded `#if CLIENT || UI`.

---

## The one rule: every file needs a donor

A settings asset is a typed binary record of ~40 fields laid out by a packed
`settings_layout` (stlt). We do not author that layout — we **clone an existing
packed asset of the same type** and overwrite only the keys you list. Fields you
omit keep the donor's valid values.

```json
{
  "_donor": "settings/itemflav/loot/main_weapon/flatline.rpak",
  "layoutAsset": "settings_layout/settings_itemtype_loot_main_weapon_layout.rpak",
  "uniqueId": 1090000001,
  "settings": { "...": "only what differs from the donor" }
}
```

Without `_donor` the record has null string pointers and the client crashes on
the first `Localize`. Pick a donor of the **same item type**, and prefer one
whose arrays are empty — arrays are not writable (below), so a donor's array
contents come along for the ride.

### Field types

| writable | not writable |
|---|---|
| bool, int, float, string, asset | float2, float3, arrays |

Strings and assets are both plain pointers, so an asset field just takes the
target's path string. Array fields (`childClassnames`, `skins`, ...) keep the
donor's contents and are skipped with a warning if you list them.

### uniqueId

Positive 31-bit int, unique against every packed asset. Keep new ones in the
`1090000000+` band. `settingsAssetID` must be `"SAID"` + the id zero-padded to
11 digits and must agree with `uniqueId`.

---

## Folder map

Only the categories that matter for modding are stubbed out. Add more by
mirroring the reference tree.

| folder | what it defines |
|---|---|
| `itemflav/character` | a legend |
| `itemflav/ability` | tactical / ultimate / passive |
| `itemflav/class`, `itemflav/class_perk` | legend class and its perks |
| `itemflav/character_skin` | legend skins |
| `itemflav/character_execution` | finishers |
| `itemflav/character_intro_quip`, `character_kill_quip` | voice lines |
| `itemflav/character_emote` | emotes |
| `itemflav/loot/main_weapon` | a gun (see that folder's README) |
| `itemflav/loot/melee_weapon` | a melee weapon |
| `itemflav/weapon_category` | gun category (ar, smg, ...) |
| `itemflav/weapon_skin`, `weapon_charm` | gun cosmetics |
| `itemflav/melee_skin` | heirlooms |
| `itemflav/lore` | lore blurbs referenced by `loreFlav` |
| `itemflav/skydive_emote`, `skydive_trail` | drop cosmetics |
| `player/mp` | player movement/physics settings |

---

## Getting a new item registered

Authoring the JSON is step one of several. In order:

1. **JSON here** — path mirrors the asset name, donor required.
2. **Register it in script.** Script cannot list files on disk, so the asset has
   to be named. For weapons that is `DISK_WEAPON_FLAVORS` in `sh_weapons.gnut`;
   other types register through their own `AddCallback_RegisterRootItemFlavors`
   block. Guard it `#if CLIENT || UI`.
3. **Persistence slots (pdef).** Menus store per-item state keyed by SAID. An
   item missing from `cfg/server/pdef_autogen.pdef` raises
   `Invalid persistent var name` the moment a menu touches it. Weapons need 12
   lines — see the main_weapon README; characters need ~57. Any pdef edit then
   needs the re-bless loop, and **dedi restarts before client** (the client gets
   the schema over the wire, never from disk).
4. **Localization.** Unresolved `#TOKEN`s render raw. Audit and import with the
   `s21-localization-import` skill.
5. **Content.** Models, scripts/weapons entries, loot rows — see the
   `s21-weapon-content-port` skill.

Steps 3 and 4 are the ones people forget; each fails loudly but only once the UI
actually touches the item.

---

## Verifying

Client log, newest folder under `platform\logs\client\`:

```
[SETTINGS-DISK] scan complete: N file(s) found, N parsed, 0 failed
[SETTINGS-DISK] built '<asset>' donor='<donor>' uniqueId=... written=N skipped=0 (attempt 1)
```

`scan complete` fires at boot (~3s) — that is only the JSON parse. `built` comes
later, on the first lookup after the donor's pak is resident. That split is
deliberate: building at boot always fails because no content pak is loaded yet.

`sdk_settings_disk 1` is the default; `sdk_settings_disk_verbose 1` logs a line
per field written.

| symptom | cause |
|---|---|
| no `[SETTINGS-DISK]` lines | module not attached — `VSettingsDiskS21` missing from `s_SafeModeAllowlist` |
| `scan complete` but never `built` | donor never resident, or `_donor` path wrong |
| `unknown field '<x>'` | not in this layout — check a reference JSON |
| `unsupported dataType` | float2/float3/array — drop the key |
| `Invalid persistent var name` | step 3 |
| raw `#WPN_...` in the UI | step 4 |
