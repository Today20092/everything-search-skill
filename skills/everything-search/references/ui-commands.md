# Everything 1.5 UI search commands

Search commands act on an Everything GUI window. They are not index queries and `es.exe` cannot execute them. Checked against the official Everything 1.5 documentation on 2026-07-14.

## Boundary

- Use ES for read-only file discovery.
- Use Everything's search box, a bookmark, or `Everything.exe -search-command` for UI commands.
- Treat UI automation as an explicit user-directed branch. Locate the installed Everything executable and verify the exact command before execution.
- The SDK search-text API does not turn search commands into UI actions.

## Minimum builds

Compare the running executable's full four-part file version with the command being used:

| Capability | Minimum Everything build |
|---|---|
| `-columns`, `-add-columns`, `-remove-columns` | 1.5.0.1347a |
| `-new-tab` | 1.5.0.1357a |
| `-search-command` and `/new-tab` | 1.5.0.1362a |
| `/columns` and `/add-columns` | 1.5.0.1367a |
| JSON column objects | 1.5.0.1374a |

Verify commands not listed here against the official sources immediately before execution.

## Safe UI examples

- `/command "File | New Tab"` creates a new tab through the named menu command.
- `/columns name;path;size;date-modified;width;height;length` replaces the visible columns.
- `/add-columns width;height;length` adds canonical property columns.
- `/focus-search` focuses the search box.

Column lists use semicolon-delimited canonical property names. `/columns` also accepts a JSON array of column objects with names and widths.

For a new tab with a known column set, prefer the direct command-line options:

```powershell
& $everythingExe -new-tab -columns 'name;path;size;date-modified'
```

The equivalent search-command sequence is:

```powershell
& $everythingExe -search-command '/new-tab' -search-command '/columns name;path;size;date-modified'
```

Everything processes repeated `-search-command` options in order. Verify the active Everything instance, executable path, and required build before running either form.

## Safety classes

| Class | Examples | Rule |
|---|---|---|
| Window presentation | tabs, focus, columns, layout, sidebars | Execute only after verifying the target window and exact command. |
| Application/configuration | macros, settings, database/index commands, close/exit | Require explicit user intent and explain the persistent effect. |
| File operations | cut, delete, rename, move, copy/overwrite | Preview targets and request the authority appropriate to the mutation. Never infer file changes from a search request. |

Commands using silent, overwrite, permanent-delete, database-delete, or exit-without-saving behavior deserve the strongest guardrails. Do not combine unreviewed commands.

## Online fallback

Open the official page immediately before executing a command not listed above. Verify syntax, minimum build, supported switches, whether it requires enabling all search commands, and whether it changes files, configuration, the database, or application state.

Official sources: [Search Commands](https://www.voidtools.com/forum/viewtopic.php?f=12&t=10091) and [Everything.exe command-line options](https://www.voidtools.com/forum/viewtopic.php?f=12&t=10479).
