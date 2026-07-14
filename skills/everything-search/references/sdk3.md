# Everything 1.5 SDK3 routing

Use this reference to decide whether a direct SDK3 integration is necessary. Prefer ES because it already covers ordinary indexed searches with less code. Checked against the official Everything 1.5 SDK documentation on 2026-07-14.

## Choose ES by default

Keep ES for one-shot searches, JSON results, paging, sorting, common properties, and query-language access. ES already passes Everything search syntax to the running application over local IPC.

## Choose SDK3 when the request needs

- a long-lived application integration rather than a subprocess;
- explicit requested-property lists and typed result access;
- programmatic sort, viewport, total-size, or omission control;
- advanced property discovery;
- change notifications, index journal access, run history, or other SDK-only state APIs;
- repeated high-volume queries where process startup and JSON parsing are measured bottlenecks.

## Search lifecycle

1. Create an `EVERYTHING3_SEARCH_STATE` with `Everything3_CreateSearchState`.
2. Set search text with the appropriate `Everything3_SetSearchText*` variant. The text uses Everything search syntax.
3. Configure matching, sorts, requested properties, viewport, totals, and other options.
4. Execute the search and inspect the returned result-list state and typed properties.
5. Destroy every created state object and check `Everything3_GetLastError` after failures.

Use the downloaded SDK headers and examples as the build-time source of truth. Match process architecture to the SDK binaries and keep the running Everything 1.5 build compatible with the SDK version.

## Boundaries

- SDK3 searches the Everything index; it does not provide general control of existing GUI tabs and columns.
- GUI actions belong to Everything.exe search commands; read [ui-commands.md](ui-commands.md).
- Search-language details belong to the syntax, functions, modifiers, and preprocessor references rather than being duplicated here.

## Online fallback

Open the official SDK page before using an untested state family, callback, property ID, memory-lifetime rule, or function signature. Confirm against the downloaded SDK headers before compiling.

Official source: [Everything 1.5 SDK](https://www.voidtools.com/forum/viewtopic.php?t=15853).
