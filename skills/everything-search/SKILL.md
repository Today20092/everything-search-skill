---
name: everything-search
description: Search the local Windows Everything index and route Everything 1.5 query, GUI-command, or SDK3 work. Use when the user asks an agent to find files or folders anywhere on the computer, compose advanced Everything syntax, configure Everything tabs/columns/layout, or evaluate direct SDK integration.
---

# Everything Search

Use the official `es.exe` command-line client to query the already-running Everything application over local IPC. Return indexed paths without recursively scanning each drive.

## Resolve prerequisites

1. Require Windows and a running Everything 1.5 instance.
2. Resolve ES with `(Get-Command es.exe -ErrorAction SilentlyContinue).Source`.
3. When ES is absent, offer two choices: install it manually from the official [ES releases](https://github.com/voidtools/ES/releases), or let the agent run `scripts/install-es.ps1`. Run the installer only after explicit user permission, then resolve `es.exe` again before searching.
4. Run `& $es -get-everything-version` and require a `1.5.*` response before relying on the 1.5 syntax and UI references.

## Search

1. Read only the reference needed to translate the request:
   - [search-syntax.md](references/search-syntax.md) for operators, wildcards, macros, entities, quoting, and argument boundaries.
   - [search-functions.md](references/search-functions.md) for property predicates, comparisons, dates, ranges, lists, formulas, or slow properties.
   - [search-modifiers.md](references/search-modifiers.md) for case, path, regex, whole-word, punctuation, indexed, or content matching behavior.
   - [search-preprocessor.md](references/search-preprocessor.md) for computed, conditional, environment-derived, or macro-parameter searches.
   - [ui-commands.md](references/ui-commands.md) only when the user asks to change the Everything window, tabs, columns, layout, files, or settings. ES cannot execute these commands.
   - [sdk3.md](references/sdk3.md) only when evaluating or building a direct SDK integration.
2. Prefer indexed name, path, extension, size, and date terms before disk-backed properties or `content:`. Translate the request into the smallest query that answers it.
3. Run ES from PowerShell. Pass each whitespace-separated Everything term as a separate array item:

   ```powershell
   $es = (Get-Command es.exe -ErrorAction Stop).Source
   $args = @('-json', '-n', '50', '-size', '-date-modified', '-date-format', '3', 'report', 'ext:pdf', 'dm:thisyear')
   & $es @args
   ```

4. Parse the JSON and report the most relevant full paths. Treat results as candidates: confirm a path still exists before reading, editing, moving, or deleting it.
5. Refine broad searches before increasing the 50-result cap. Paginate only when needed with `-o <offset>`.

The search is complete when the returned candidates answer the request, or a refined query returns no match.

## Documentation policy

Use the local references first. When an exact function, modifier, preprocessor function, UI command, or SDK behavior is absent or version-sensitive, open only the official voidtools page linked at the bottom of the relevant reference and verify that item before composing or executing it. Treat the official page as authoritative and the local file as tested routing guidance.

Result paths and requested metadata enter the agent conversation. Avoid searching sensitive locations or properties beyond what the user requested, and follow the active agent provider's privacy terms.

## Useful ES options

- Scope recursively: `-path 'C:\Users\Name\Documents'`
- Files only: add `/a-d`
- Folders only: add `/ad`
- Sort newest first: `-sort-date-modified-descending`
- Return a later page: `-o 50 -n 50`
- Request more columns: `-extension`, `-attributes`, `-date-created`, or `-date-accessed`

Keep `-json` for machine-readable output. Keep every search term in the argument array so PowerShell does not interpret Everything operators such as `|`, `<`, or `>`. Do not combine separate terms into one PowerShell string; ES treats an argument containing spaces as a literal phrase. Preserve a quoted phrase or complete preprocessor expression as one array item.

## Failures and limits

- Exit code 8 means Everything IPC was not found. Confirm Everything 1.5 is running, then retry with `-ipc2`; use `-instance 1.5a` only for an older named alpha instance.
- Exit code 7 means the IPC query failed. Retry once with `-ipc2`, then report the error.
- Everything returns its index, so excluded or not-yet-indexed locations may be absent.
- For file contents, first narrow by path/name/extension, then use a local text-search tool in the candidate directories. Use Everything `content:` only when the user explicitly wants it; content and unindexed metadata searches can touch disk and be slow.
