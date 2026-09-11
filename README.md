# s21-platform

The R5Flowstate S21 bridge platform product: Squirrel game scripts, menus and
UI resources, datatables, cfg, and localization. These are the files the
running game loads from `platform/`.

This is not the SDK. The SDK builds `client.dll` and `server.dll` and lives in
its own repository. Nothing here is compiled.

## What loads what

The bridge runs two engines against one script tree: a Season 21 client and a
Season 3 dedicated server. Scripts carry all three arities in one file
(`#if SERVER`, `#if CLIENT`, `#if UI`) and each VM compiles the half it owns.

| Path | Loaded by |
|---|---|
| `scripts/vscripts/` | all three VMs (server, client, UI) |
| `scripts/*.txt` | both engines (weapons, loot, propdata, playlists) |
| `resource/` | client and UI (menus, RUI, fonts, overviews) |
| `datatable/` | both engines |
| `cfg/` | both engines at boot |
| `localization/` | client and UI |
| `playlists_r5_patch.txt` | both engines |

## Using it

Drop the tree over an install's `platform/` folder. There is no build step and
no deploy; the engine reads these files directly.
