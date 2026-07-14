# Bookmarks and filters

Use this branch to add reusable items to Everything without GUI automation. The entries are not stored in `Everything.ini`: bookmarks live in `Bookmarks.csv`, filters in `Filters.csv`, and the filenames may include an Everything instance suffix.

## Choose the item

| Need | Use |
|---|---|
| A reusable constraint that combines with typed search text | Filter |
| A saved search that can also restore filter, sort, columns, view, index, or a shortcut | Bookmark |
| Nested organization | Bookmark folder |

Everything supports bookmark folders. Filters are a flat list.

## Headless import workflow

Everything keeps its native CSV data in memory, so editing `Bookmarks.csv` or `Filters.csv` while it runs can be overwritten. Import a prepared CSV instead:

1. Resolve the executable and full build for the running instance. Require `1.5.0.1384` or later: `/load-bookmarks`, `/load-filters`, and reload commands arrived in `1.5.0.1379a`; `/save-all` arrived in `1.5.0.1384a`.
2. Locate the instance's current native CSV. `app_data=1` in the executable-adjacent `Everything.ini` places data under `%APPDATA%\Everything`; `app_data=0` keeps it beside `Everything.exe`. Preserve any instance suffix in the filename.
3. Read the native CSV with a CSV parser. Copy its exact header because columns can vary by build. Check the proposed names and case-insensitive macros for collisions; check nonzero keyboard shortcut values too. Stop for user direction instead of creating a duplicate or replacing an entry implicitly.
4. Back up the native CSV with a timestamped filename in the same directory.
5. Create a UTF-8 import CSV containing the copied header and only the approved new rows. Use CSV quoting rather than string concatenation. Preserve empty fields; use an existing row as the field-convention template. A bookmark folder is a `Type=1` row; a bookmark is `Type=0` and names its parent in `Folder`.
6. Run one import command, quoting the absolute CSV path inside the search command:

   ```powershell
   & $everything -search-command "/load-bookmarks `"$importCsv`""
   # or
   & $everything -search-command "/load-filters `"$importCsv`""
   & $everything -search-command '/save-all'
   ```

7. Re-read the native CSV and verify that each entry occurs exactly once and that its search, macro, folder, and requested presentation fields match. If verification fails, report it and retain the backup; do not guess at repair.

`Everything.ini` is still useful for interface settings such as `filters_visible` and bookmark remember flags. Set supported INI values through `Everything.exe -search-command '/<option>=<value>'` when possible. Direct INI edits require Everything to be exited first, saved as UTF-8, and restarted.

## Existing-item operations

- Activate a bookmark: `Everything.exe -bookmark <name>` or `/open-bookmark <name>` through `-search-command`.
- Activate a filter: `Everything.exe -filter <name>`.
- Reload an externally replaced native file: `/reload-bookmarks` or `/reload-filters`. This is for a deliberate whole-file replacement performed while Everything was stopped, not the normal add-entry path.

## Official sources

- [Everything INI](https://www.voidtools.com/support/everything/ini/)
- [Everything 1.5 search commands](https://www.voidtools.com/forum/viewtopic.php?t=10091)
- [Developer warning about live bookmark and filter files](https://www.voidtools.com/forum/viewtopic.php?t=12723)
- [Bookmark folders and flat filters](https://www.voidtools.com/forum/viewtopic.php?t=12301)
