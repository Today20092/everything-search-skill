# Everything search troubleshooting

Read this reference only when ES fails or indexed results are unexpectedly empty, stale, or duplicated. Diagnose with read-only checks first; change Everything's configuration only when the user asks.

## ES exit codes

Capture `$LASTEXITCODE` immediately after ES returns. Code 0 is the only success code; keep output unparsed for every other code.

| Code | Meaning | Action |
|---|---|---|
| 1 | Failed to register the window class | Report the client failure. |
| 2 | Failed to create the listening window | Report the client failure. |
| 3 | Out of memory | Stop and report the resource failure. |
| 4 | A command-line option is missing its value | Correct the invocation before retrying. |
| 5 | Failed to create the export file | Check the requested destination; ordinary JSON searches should not export. |
| 6 | Unknown switch | Verify the switch against the pinned ES release before retrying. |
| 7 | Failed to send an Everything IPC query | Retry once with `-ipc2`, then report the failure. |
| 8 | Everything IPC window not found | Confirm Everything 1.5 and the intended instance are running, then retry with `-ipc2`. |

Use `-instance <name>` only when the user identifies a named instance. Each instance has separate settings and data, so guessing a name can query the wrong index.

## Missing or stale results

Check the smallest applicable cause:

1. Confirm the query is reaching the intended default or named instance.
2. Retry the query with `disable-result-omissions:` and `disable-temporary-result-omissions:`. Omissions hide results without removing them from the index or stopping change monitoring.
3. Confirm the location is included and indexing has completed. Excluded and not-yet-indexed locations are absent.
4. Treat folder-indexed files from an offline volume or share as stale candidates; they remain in the index while the source is offline.
5. Account for index boundaries: NTFS/ReFS junction targets are not followed, and a hard-link change may update only the first indexed link.
6. If results are duplicated, check whether an automatically indexed NTFS volume was also added as a folder index.

Rebuild or reconfigure the database only after the user explicitly requests that change. A read-only search is complete when these applicable checks and a refined query still produce no match.

Official sources: [ES command-line interface](https://www.voidtools.com/support/everything/command_line_interface), [Result Omissions](https://www.voidtools.com/support/everything/result_omissions), [Multiple Instances](https://www.voidtools.com/support/everything/multiple_instances), [Folder Indexing](https://www.voidtools.com/support/everything/folder_indexing), [Indexes](https://www.voidtools.com/support/everything/indexes), and [Troubleshooting](https://www.voidtools.com/support/everything/troubleshooting).
