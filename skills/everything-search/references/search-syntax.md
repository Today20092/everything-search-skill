# Everything 1.5 search syntax

Use this reference for the query grammar shared by the Everything GUI, Everything.exe searches, ES, and SDK3 search text. Checked against the official Everything 1.5 documentation on 2026-07-14.

## Passing terms to ES

Put each whitespace-separated search term in its own PowerShell argument-array item. For example, `report ext:pdf dm:thisyear` becomes `@('report', 'ext:pdf', 'dm:thisyear')`. Preserve an exact phrase as one item containing Everything quotes, such as `'"project plan"'`. Keep a grouped term or complete preprocessor expression intact.

## Operators

| Syntax | Meaning | Example |
|---|---|---|
| space | AND | `report ext:pdf` |
| `\|` | OR | `ext:docx\|ext:pdf` |
| `!` | NOT | `report !archive` |
| `< >` | group | `<invoice\|receipt> ext:pdf` |
| `" "` | literal text / escaped operators | `"project plan"` |
| `*` | zero or more characters except `\` | `*.xlsx` |
| `**` | zero or more characters including `\` | `C:\**\report.pdf` |
| `?` | one character except `\` | `budget?.csv` |

Using a wildcard matches the whole filename. Use `stem:` when the extension should not participate, for example `stem:*draft`.

## Macros and entities

Everything provides built-in type macros such as `audio:`, `zip:`, `doc:`, `exe:`, `image:`, and `video:`. These expand to configured extension lists and may be redefined by user macros. Use an explicit `ext:` list when exact extensions matter.

Character entities safely represent operator characters and Unicode values inside a query:

- `&sp:`, `&vert:`, `&excl:`, `&lt:`, `&gt:`, and `&quot:` represent space, `|`, `!`, `<`, `>`, and `"`.
- `&#NN:` and `&#xHH:` represent decimal and hexadecimal Unicode code points.
- Prefer quotes for ordinary phrases; use entities when the character must remain literal inside a function or nested expression.

## Common filters

- `file:` / `folder:` — files or folders only.
- `ext:pdf;docx` — extension list.
- `name:hosts` — basename match.
- `path:projects` — match against the full path.
- `parent:"C:\Program Files"` — immediate parent only.
- `size:>1gb`, `size:10mb..50mb` — size comparison or range.
- `dm:today`, `dm:thisweek`, `dm:2026-01-01..2026-06-30` — modified date.
- `dc:`, `da:` — created or accessed date.
- `case:`, `wholeword:`, `regex:` — apply a search modifier; read [search-modifiers.md](search-modifiers.md) for composition rules.
- `count:100` — server-side result limit; prefer ES `-n` for ordinary paging.

## Examples

- Recent PowerPoints anywhere: `file: ext:ppt;pptx dm:thismonth`
- Folders named node_modules outside archives: `folder: name:node_modules !path:archive`
- Large videos under Downloads: use ES `-path` with `file: video: size:>1gb`
- Exact filename: `wfn:"Quarterly Report.xlsx"`

Everything reorders search functions from faster indexed work to slower disk-backed work. Narrow `content:`, media metadata, checksums, and other unindexed-property searches with an indexed path, extension, name, size, or date filter.

Official sources: [Search Syntax](https://www.voidtools.com/forum/viewtopic.php?t=16895), [Everything 1.5 Help](https://www.voidtools.com/forum/viewtopic.php?f=12&t=12666), and [ES CLI](https://github.com/voidtools/ES).
