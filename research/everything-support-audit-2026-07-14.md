# Everything support documentation audit

Researched 2026-07-14 against the 36 official voidtools support pages requested. This audit compares those pages with the current `skills/everything-search/SKILL.md` and its disclosed references. It does not change the production skill.

> Implementation status: the P0, P1, recent-change, and SDK-generation recommendations were applied on 2026-07-14. Findings below describe the pre-change baseline.

## Conclusion

The skill already has the right shape: a short routed procedure plus conditional references. Most of the support site is GUI administration, server operation, localization, or historical material and should not be copied into the skill.

Four changes are justified:

1. **Fix duplicate-search syntax in `references/search-functions.md`.** The current capability map says `find-dupes:` and property-specific `*-dupe:`. Current Everything 1.5 documentation uses `dupe:<property-list>`, `distinct:<property-list>`, and `unique:<property-list>`. Content identity is `dupe:size;sha256`; hashing is restricted to equal-size candidates but can still be slow, and duplicate modes need an explicit refresh to include new results. [Find Duplicates](https://www.voidtools.com/support/everything/find_duplicates)
2. **Check the native ES exit code before parsing JSON.** Exit code 0 is success; documented failures include malformed/missing options, export failure, unknown switches, IPC query failure, and a missing Everything IPC window. The current skill only explains codes 7 and 8 after the command; it should capture `$LASTEXITCODE`, reject every nonzero result, and parse JSON only on success. [Command Line Interface](https://www.voidtools.com/support/everything/command_line_interface)
3. **Add a disclosed troubleshooting reference and a pointer that fires only when expected matches are missing or stale.** It should cover result omissions, named-instance isolation, offline folder indexes, exclusions/not-yet-indexed locations, and NTFS/ReFS junction and hard-link limitations. [Result Omissions](https://www.voidtools.com/support/everything/result_omissions), [Multiple Instances](https://www.voidtools.com/support/everything/multiple_instances), [Folder Indexing](https://www.voidtools.com/support/everything/folder_indexing), [Indexes](https://www.voidtools.com/support/everything/indexes)
4. **Add `rc:`/`recentchange:` to the search-functions capability map.** It searches files changed since Everything started; loading the NTFS USN journal can extend that window. This is useful query vocabulary, not a core step. [Recent Changes](https://www.voidtools.com/support/everything/recent_changes)

Do not add ETP, HTTP, Everything Server, service administration, INI editing, plugin management, uninstalling, translations, or exhaustive option tables to `SKILL.md`. They are separate operational branches and would create sprawl without improving ordinary local-index search.

## Prioritized recommendation matrix

| Priority | Destination | Recommendation | Why |
|---|---|---|---|
| P0 | Disclosed `search-functions.md` | Replace `find-dupes:` / `*-dupe:` with `dupe:`, `distinct:`, `unique:`, and the scoped content example `dupe:size;sha256`; include the refresh caveat. | Current production reference is materially wrong for the documented Everything 1.5 duplicate model. |
| P0 | `SKILL.md` search step | Immediately capture `$LASTEXITCODE`; stop on any nonzero value; parse JSON only on zero. Keep detailed code meanings in a reference. | Prevents an error message or partial output from being mistaken for valid JSON/search results. |
| P1 | New disclosed troubleshooting reference | Explain missing/stale results: omissions hide but do not de-index; named instances have separate settings/data; folder-indexed offline sources remain listed; exclusions and incomplete indexing remove coverage; junctions are not followed; hard-link changes update only the first indexed link. | Conditional facts are valuable only on the troubleshooting branch, so progressive disclosure is the correct rung. |
| P1 | `SKILL.md` troubleshooting pointer | On an unexpectedly empty/stale result, read the troubleshooting reference before declaring absence. | A short conditional pointer changes runtime behavior without loading the core with diagnostics. |
| P1 | Verification policy | Verify `-json`, `-argv`, `-viewport-offset`, `-viewport-count`, and `-ipc2` against the pinned current ES 1.5 release/source, not this legacy-oriented CLI support page. | The requested CLI page documents general switches and an “Everything 1.4” section; it does not establish those 1.5 ES switches. |
| P2 | Disclosed `search-functions.md` | Add `rc:` / `recentchange:` and state its default session window versus optional USN-journal history. | Useful, low-cost query capability; not universal enough for the core steps. |
| P2 | Disclosed SDK reference | State explicitly that `/support/everything/sdk` is the DLL/Lib/WM_COPYDATA SDK over IPC, while the skill's SDK3 branch must use the separate official SDK3 headers/forum documentation. | Prevents mixing SDK generations and lifetimes. |
| P2 | Existing safety reference or future remote branch | If remote operation is ever added, disclose that HTTP/ETP may expose every indexed name and permit downloads; Everything Server is a distinct 1.5 centralized-index product. | Security-critical only if that branch exists. |
| Omit | Core and references | GUI customization, shortcuts, language packs, translation workflow, archived builds, and changelog-style feature summaries. | No effect on the skill's routed local-search behavior. |

## Version and product boundaries

- The current [Search Syntax](https://www.voidtools.com/support/everything/search_syntax), [Search Modifiers](https://www.voidtools.com/support/everything/search_modifiers), [Find Duplicates](https://www.voidtools.com/support/everything/find_duplicates), [Properties](https://www.voidtools.com/support/everything/properties), [Index Journal](https://www.voidtools.com/support/everything/index_journal), [Result Omissions](https://www.voidtools.com/support/everything/result_omissions), [Everything Server](https://www.voidtools.com/support/everything/everything_server), and [Plugins](https://www.voidtools.com/support/everything/plugins) pages explicitly require Everything 1.5. The skill already checks for a `1.5.*` running instance before using its 1.5 references; keep that gate.
- The [Command Line Interface](https://www.voidtools.com/support/everything/command_line_interface) page distinguishes switches that work with any Everything version from an Everything 1.4 switch set. It is useful for stable ES behavior and return codes, but it is not sufficient authority for the skill's 1.5-only ES switches.
- [What's New](https://www.voidtools.com/support/everything/whats_new) separates 1.5 features (property indexing, Index Journal, Everything Server, duplicates, undo, result omissions, plugins) from 1.4 features (size/date/attribute indexing, fast sorting, ReFS, content search) and 1.3 features (service, recent changes, histories, file lists, folder indexing, filters, bookmarks). Use the feature page itself—not this summary—to document behavior.
- [SDK](https://www.voidtools.com/support/everything/sdk) describes the classic DLL/Lib and WM_COPYDATA IPC SDK and requires Everything to run in the background. It is not the skill's SDK3 source of truth.
- In 1.5, HTTP, ETP/FTP, and Everything Server are plugins. [Plugins](https://www.voidtools.com/support/everything/plugins)

## Operational findings relevant to safety

- The recommended NTFS setup is the Everything service, which performs privileged volume reading while the client runs as a standard user. Running the whole client as administrator is the alternative. [Installing Everything](https://www.voidtools.com/support/everything/installing_everything)
- The local Everything service exposes NTFS filenames to any local user but cannot itself be used to read file contents. That is a local metadata-privacy boundary, not a remote file server. [Everything Service](https://www.voidtools.com/support/everything/everything_service)
- ETP and HTTP can expose every indexed file/folder for search and download unless download is disabled. A future remote branch must require explicit configuration and authentication review. [ETP](https://www.voidtools.com/support/everything/etp), [HTTP](https://www.voidtools.com/support/everything/http)
- Everything Server is different from the Everything service: it shares a centralized index and changes, uses Windows shares for file access, supports credentials/path remapping, and encrypts connections. Business/enterprise hosting requires a site license. [Everything Server](https://www.voidtools.com/support/everything/everything_server)
- `Everything.exe -create-file-list` scans the supplied filesystem path to create an EFU. It is not an indexed ES lookup and must not be presented as the skill's near-instant no-recursion search path. [File Lists](https://www.voidtools.com/support/everything/file_lists)
- Editing `Everything.ini` while Everything is running loses the edits when Everything exits; the app must be stopped and the file saved as UTF-8. This matters only if an explicit configuration branch is added. [INI](https://www.voidtools.com/support/everything/ini)
- Index Journal supports undoing moves/renames and also exposes delete actions. It is a mutation surface, not a read-only search. Its default journal is about 1 MB / 5,000 changes. [Index Journal](https://www.voidtools.com/support/everything/index_journal)
- Result-list GUI shortcuts include rename, recycle-bin delete, and permanent delete. Keep GUI/result actions behind the existing explicit mutation guard. [Keyboard Shortcuts](https://www.voidtools.com/support/everything/keyboard_shortcuts), [Results](https://www.voidtools.com/support/everything/results)
- Run history records files/folders opened from Everything and is stored in `Run History.csv`; search history records prior GUI searches, is disabled by default, and is stored in `Search History.csv` when enabled. These are private user data and should not be read or changed during an ordinary search. [Run History](https://www.voidtools.com/support/everything/run_history), [Search History](https://www.voidtools.com/support/everything/search_history)

## Page-by-page disposition

| Official page | Material finding | Disposition |
|---|---|---|
| [Everything](https://www.voidtools.com/support/everything) | Support index and product overview. | Omit; navigation only. |
| [Installing Everything](https://www.voidtools.com/support/everything/installing_everything) | Service is the recommended NTFS privilege boundary; portable/install options differ. | Reference only if the skill later installs Everything itself; current skill installs only ES. |
| [Using Everything](https://www.voidtools.com/support/everything/using_everything) | GUI search, result actions, CSV/TXT/EFU export. | Omit from core; UI branch already owns GUI actions. |
| [Search Syntax](https://www.voidtools.com/support/everything/search_syntax) | 1.5 operators, term grammar, wildcards, macros, entities; OR has higher default precedence than AND. | Already disclosed correctly; retain as authority. |
| [Search Modifiers](https://www.voidtools.com/support/everything/search_modifiers) | 1.5 matching, parsing, content, filter, and result-management modifiers. | Already disclosed; do not duplicate the catalog. |
| [Command Line Interface](https://www.voidtools.com/support/everything/command_line_interface) | Stable ES invocation, offsets/limits, columns, sorts, exports, mutations, limitations, and codes 0–8. | Add exit-code gate to core; disclose details; verify 1.5-only switches elsewhere. |
| [Command Line Options](https://www.voidtools.com/support/everything/command_line_options) | `Everything.exe` startup, service, install, instance, UI, index, export, and destructive switches. | Keep in guarded UI/admin reference; no bulk copy. |
| [Customizing](https://www.voidtools.com/support/everything/customizing) | Fonts, colors, layout, localization, context menus. | Omit. |
| [ETP](https://www.voidtools.com/support/everything/etp) | Remote search/download server; all indexed items may be exposed. | Omit until a remote-server branch exists; then add security reference. |
| [Everything Server](https://www.voidtools.com/support/everything/everything_server) | 1.5 centralized encrypted index sharing, credentials, remapping, Windows-share file access, licensing. | Omit from local skill; future enterprise branch only. |
| [Everything Service](https://www.voidtools.com/support/everything/everything_service) | Privileged local NTFS index helper; filenames visible to local users, no content access. | One operational note outside core; no service-management steps. |
| [File Lists](https://www.voidtools.com/support/everything/file_lists) | EFU creation/loading; command-line creation scans the target path. | Omit unless an EFU branch is requested. |
| [Find Duplicates](https://www.voidtools.com/support/everything/find_duplicates) | Current 1.5 `dupe:`, `distinct:`, `unique:` model and hash/refresh caveats. | P0 correction to `search-functions.md`. |
| [Folder Indexing](https://www.voidtools.com/support/everything/folder_indexing) | Adds shares/FAT/other folders; offline sources remain indexed. | Troubleshooting reference for stale candidates. |
| [HTTP](https://www.voidtools.com/support/everything/http) | Browser/API search with offset/count/JSON and optional file download. | Omit until remote API branch; security warning is mandatory then. |
| [Index Journal](https://www.voidtools.com/support/everything/index_journal) | 1.5 audit of creates/moves/renames/modifies/deletes, real-time, undo/delete/export. | SDK/admin reference only; mutation guard required. |
| [Indexes](https://www.voidtools.com/support/everything/indexes) | Indexed metadata and fast sorts trade memory for speed; junction/hard-link limitations. | Keep performance principle; add limitations to troubleshooting. |
| [INI](https://www.voidtools.com/support/everything/ini) | Generated configuration, storage locations, many hidden settings, stop-before-edit rule. | Omit; future config branch only. |
| [Keyboard Shortcuts](https://www.voidtools.com/support/everything/keyboard_shortcuts) | Remappable GUI commands including file mutations. | Omit catalog; existing UI safety is sufficient. |
| [Multiple Instances](https://www.voidtools.com/support/everything/multiple_instances) | Unique names, separate settings/data, `-instance` targeting. | Add conditional troubleshooting/routing note. |
| [Options](https://www.voidtools.com/support/everything/options) | Exhaustive GUI configuration including indexes, excludes, histories, service/server settings. | Omit catalog; cite from narrow branches only. |
| [Plugins](https://www.voidtools.com/support/everything/plugins) | 1.5 HTTP/ETP/Everything Server packaging and safe mode. | Omit from local search. |
| [Previous Versions](https://www.voidtools.com/support/everything/previous_versions) | Archived builds and old change notes. | Omit; verify current behavior from current docs/build. |
| [Properties](https://www.voidtools.com/support/everything/properties) | 1.5 metadata can be gathered on demand or indexed for instant search/sort. | Already captured by indexed-first rule; retain disclosed catalog pointer. |
| [Recent Changes](https://www.voidtools.com/support/everything/recent_changes) | `rc:`/`recentchange:` query and optional USN history. | Add to search-functions reference. |
| [Result Omissions](https://www.voidtools.com/support/everything/result_omissions) | Hides results without removing/ceasing monitoring; may explain false absence. | Add to troubleshooting reference. |
| [Results](https://www.voidtools.com/support/everything/results) | GUI selection, sorting, opening, copying, exporting, renaming/deleting. | Omit; current UI mutation boundary covers it. |
| [Run History](https://www.voidtools.com/support/everything/run_history) | Open-count/date database, `runcount:`/`daterun:`, CSV persistence. | Query functions may be disclosed; never read/change history by default. |
| [SDK](https://www.voidtools.com/support/everything/sdk) | Classic DLL/Lib/WM_COPYDATA IPC SDK; running Everything required. | Mark generation boundary; keep SDK3 authority separate. |
| [Search History](https://www.voidtools.com/support/everything/search_history) | Disabled-by-default GUI history, CSV persistence, clear/edit UI. | Omit from search execution; privacy/admin branch only. |
| [Searching](https://www.voidtools.com/support/everything/searching) | Older broad catalog of functions, filters, dates/sizes, regex/content examples. | Use only to fill tested reference gaps; prefer the current 1.5 pages for 1.5 syntax. |
| [Supported Languages](https://www.voidtools.com/support/everything/supported_languages) | UI translation inventory and language pack. | Omit. |
| [Translating](https://www.voidtools.com/support/everything/translating) | Translation template/process. | Omit. |
| [Troubleshooting](https://www.voidtools.com/support/everything/troubleshooting) | Debug console/logging, database rebuild, crash/hang and result diagnosis. | Disclose only selected non-destructive diagnosis; rebuild requires explicit intent. |
| [Uninstalling Everything](https://www.voidtools.com/support/everything/uninstalling_everything) | Removes service/startup/context-menu/protocol/association system changes. | Omit; outside search scope. |
| [What's New](https://www.voidtools.com/support/everything/whats_new) | Feature-to-version index for 1.3/1.4/1.5. | Use for orientation only, never as exact syntax authority. |

## Suggested minimal implementation sequence

1. Correct the duplicate row in `references/search-functions.md` and add one scoped example plus refresh caveat.
2. Add the ES `$LASTEXITCODE` gate to the existing local-search step; keep the current code 7/8 diagnostics, but make all nonzero codes fatal.
3. Create one compact `references/troubleshooting.md` and add one conditional pointer from the search branch.
4. Add `rc:` to the search-functions capability map.
5. Re-run skill evaluations for duplicate queries, ES nonzero output, named instances, omitted results, and stale offline paths.

This keeps each meaning in one place: execution invariants in `SKILL.md`, conditional product facts in disclosed references, and the full voidtools catalogs at their official URLs.
