---
name: everything-search
description: "Route Everything work: search Windows files and folders, compose Everything 1.5 queries, manage bookmarks and filters, control tabs/columns/layout, or assess and build direct SDK3 integrations."
---

# Everything Search

Route each request before touching the local machine. Local index searches use the official `es.exe` client over IPC and return indexed paths without recursively scanning each drive.

## Route

Classify the request before checking local prerequisites:

- **Compose or explain a query:** follow **Compose a query** and return the query. Local Windows, Everything, and ES installations are not required.
- **Search the local index:** follow **Search the local index**.
- **Manage bookmarks or filters:** follow **Manage bookmarks and filters**.
- **Change the Everything GUI:** follow **Control the Everything GUI**. ES cannot execute GUI search commands.
- **Evaluate or build an SDK3 integration:** follow **Evaluate or build SDK3**.

## Compose a query

1. Read only the reference needed to translate the request:
   - [search-syntax.md](references/search-syntax.md) for operators, wildcards, macros, entities, quoting, and argument boundaries.
   - [search-functions.md](references/search-functions.md) for property predicates, comparisons, dates, ranges, lists, formulas, or slow properties.
   - [search-modifiers.md](references/search-modifiers.md) for case, path, regex, whole-word, punctuation, indexed, or content matching behavior.
   - [search-preprocessor.md](references/search-preprocessor.md) for computed, conditional, environment-derived, or macro-parameter searches.
2. Prefer indexed name, path, extension, size, and date terms before disk-backed properties or `content:`.
3. Translate the request into the smallest query that covers every requested constraint. Verify version-sensitive terms against the relevant official source under **Documentation policy**.

The query-composition branch is complete when the query covers every requested constraint and each version-sensitive term has been verified.

## Search the local index

1. Require Windows and a running Everything 1.5 instance.
2. Resolve ES with `(Get-Command es.exe -ErrorAction SilentlyContinue).Source`.
3. When ES is absent, offer two choices: install it manually from the official [ES releases](https://github.com/voidtools/ES/releases), or let the agent run `scripts/install-es.ps1`. Run the installer after explicit user permission, then resolve `es.exe` again before searching.
4. Run `& $es -get-everything-version` and require a `1.5.*` response before using the 1.5 search-language references.
5. Compose the query with **Compose a query**.
6. Run ES from PowerShell. Pass each complete Everything term as a separate array item; keep phrases, grouped expressions, and preprocessor expressions intact. Add `-argv` under PowerShell 7 or later:

    ```powershell
    $es = (Get-Command es.exe -ErrorAction Stop).Source
    $esArgs = @('-json', '-n', '50', '-size', '-date-modified', '-date-format', '3', 'report', 'ext:pdf', 'dm:thisyear')
    if ($PSVersionTable.PSVersion.Major -ge 7) { $esArgs = @('-argv') + $esArgs }
    & $es @esArgs
    ```

7. Parse the JSON and report the most relevant full paths. Treat results as candidates: confirm a path still exists before reading, editing, moving, or deleting it.
8. Refine broad searches before increasing the 50-result cap. For human-facing document or media searches, exclude irrelevant tooling directories such as `.git` or `node_modules` when they dominate the results. Paginate only when needed with `-viewport-offset <offset> -viewport-count <count>`; omit `-n` on paged requests.

The search is complete when the returned candidates answer the request, or a refined query returns no match.

## Manage bookmarks and filters

1. Read [bookmarks-filters.md](references/bookmarks-filters.md).
2. Choose a filter for a reusable search constraint, or a bookmark when the user wants a saved search plus filter, sort, columns, view, or folder organization.
3. Resolve the running Everything executable and require build `1.5.0.1384` or later for the documented headless import-and-save workflow.
4. Inspect the current instance's bookmark or filter CSV only to copy its exact header and detect existing names, macros, and keyboard shortcuts. Reject ambiguous collisions before changing state.
5. Preview the entries to add. After the user has supplied or approved their names and searches, create a UTF-8 import CSV that contains only those entries and uses the current file's exact columns.
6. Back up the current native CSV. Load the import with `Everything.exe -search-command` and `/load-bookmarks <filename>` or `/load-filters <filename>`, then run `/save-all`. Do not edit the native CSV while Everything is running.
7. Re-read the native CSV and verify every approved entry and field. Keep the backup until verification succeeds.

The branch is complete when every approved entry is present exactly once with the intended search and metadata, or no settings were changed and the collision or unsupported build is reported.

## Control the Everything GUI

1. Read [ui-commands.md](references/ui-commands.md).
2. Resolve the executable path for the running Everything instance and its full four-part version. Check the requested command's minimum build before execution.
3. Identify the target window or tab. When the existing target is ambiguous, create a new tab or window for presentation changes.
4. For configuration, database, application-exit, or file-changing commands, preview the exact effect and obtain explicit user intent before execution.
5. Execute only the requested command sequence, then verify the intended GUI or persistent state.

The GUI branch is complete when the intended state is observed, or the command is withheld with the unsupported build or unresolved target reported.

## Evaluate or build SDK3

1. Read [sdk3.md](references/sdk3.md).
2. Prefer ES unless the request needs a documented SDK-only capability or measured subprocess overhead justifies direct integration.
3. For an SDK implementation, account for connection, search-state creation and destruction, requested properties, result-list lifetime, errors, architecture, and Everything build compatibility.
4. For a build request, implement against the downloaded SDK headers and examples, then run the smallest integration check that connects, searches, reads one requested property, and releases every created state and result list.

An SDK evaluation is complete when the ES-versus-SDK choice is justified and every applicable lifecycle requirement is accounted for. An SDK build is complete when its integration check passes.

## Documentation policy

Use the local references first. When an exact function, modifier, preprocessor function, UI command, or SDK behavior is absent or version-sensitive, open only the official voidtools page linked at the bottom of the relevant reference and verify that item before composing or executing it. Treat the official page as authoritative and the local file as tested routing guidance.

Result paths and requested metadata enter the agent conversation. Avoid searching sensitive locations or properties beyond what the user requested, and follow the active agent provider's privacy terms.

## Useful ES options

- Scope recursively: `-path 'C:\Users\Name\Documents'`
- Files only: add `/a-d`
- Folders only: add `/ad`
- Sort newest first: `-sort-date-modified-descending`
- Return a later page: `-viewport-offset 50 -viewport-count 50`
- Request more columns: `-extension`, `-attributes`, `-date-created`, or `-date-accessed`

Keep `-json` for machine-readable output. Keep every complete search term in the argument array so PowerShell does not interpret Everything operators such as `|`, `<`, or `>`. Preserve phrases, grouped expressions, and complete preprocessor expressions as single array items.

## Failures and limits

- Exit code 8 means Everything IPC was not found. Confirm Everything 1.5 is running, then retry with `-ipc2`; use `-instance 1.5a` only for an older named alpha instance.
- Exit code 7 means the IPC query failed. Retry once with `-ipc2`, then report the error.
- Everything returns its index, so excluded or not-yet-indexed locations may be absent.
- For file contents, first narrow by path/name/extension, then use a local text-search tool in the candidate directories. Use Everything `content:` only when the user explicitly wants it; content and unindexed metadata searches can touch disk and be slow.
