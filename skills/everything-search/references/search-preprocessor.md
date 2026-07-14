# Everything 1.5 search preprocessor

Use the preprocessor only when the query must compute or expand search text. Ordinary property filters do not need it. Checked against the official Everything 1.5 documentation on 2026-07-14.

## Processing model

- `[function:arg1,arg2,...]` is a termprocessor expression. It expands within a search term and its output is treated as quoted text.
- `#[function:arg1,arg2,...#]:` is the advanced first-pass preprocessor form. Its output participates in search parsing, so operators in the output remain active.
- Everything 1.5 performs the advanced preprocessor pass first, splits the query into terms, then expands termprocessor expressions.
- Searches executed from the command line or through an Everything query are automatically expanded.
- `$param:` references the text passed to a user macro.

## Common uses

- String and path manipulation: length, find/replace, filename/path parts, quoting, and joining.
- Arithmetic and bitwise evaluation: `[eval:1+2]`.
- Conditional expansion and definitions.
- Date/time generation and conversion.
- Environment, settings, clipboard, and current-window values when the execution context supplies them.
- Reusable bookmark/filter macros with parameters.

Examples from the official syntax include `[len:abc]`, `[eval:1<<17]`, and path-part extraction. Look up the exact function before using any operation beyond these examples.

## ES and PowerShell

Keep each complete processor expression in one PowerShell argument-array item. Use single-quoted PowerShell strings when the expression contains `$`, `|`, `<`, `>`, or quotes so PowerShell does not expand or execute them. Test the expanded query on a narrow path before relying on a complex expression.

## Context limits

Some processor functions depend on the main Everything search window. The official documentation identifies `[clipboard:]` as main-search-window-only, so do not assume every processor function works through ES or SDK search text.

## Online fallback

The function catalog is large and version-sensitive. Open the official page to verify every nontrivial processor function, its argument escaping, return quoting, pass timing, and execution-context requirement.

Official source: [Search Preprocessor](https://www.voidtools.com/forum/viewtopic.php?f=12&t=10099).
