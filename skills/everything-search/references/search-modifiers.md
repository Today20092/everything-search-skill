# Everything 1.5 search modifiers

Use modifiers to change how a literal term or search function matches. Checked against the official Everything 1.5 documentation on 2026-07-14.

## Composition

- Prefix a term or function: `case:ABC`, `regex:content:^foo`, or `path:wholeword:report`.
- Apply a modifier to a group: `case:<FOO BAR>`.
- Prefix with `no-` to disable it: `no-path:abc`.
- Prefix with `::` to bypass a user macro and select the built-in modifier: `::case:`.
- Prefix with `?` to enable it for the rest of the search: `?case: FOO BAR`.
- Dashes are optional in modifier names.
- Modifiers apply from right to left, inner to outer.

## Capability map

| Behavior | Common modifiers | Use |
|---|---|---|
| Text sensitivity | `case:`, `diacritics:`, `wholeword:`, `exact:` | Tighten literal or property text matching. |
| Position | `prefix:`, `suffix:`, `startwith:`, `endwith:` | Match word/value boundaries. Verify the exact modifier for the property involved. |
| Scope | `name:`, `path:`, `file:`, `folder:` | Select filename/full-path or file/folder behavior. |
| Pattern matching | `wildcards:`, `regex:`, `fast-regex:` | `regex:` changes parsing of `|` and semicolon lists. |
| Regex behavior | `dotall:`, `multiline:`, `global:`, `ungreedy:` | Use only with a regex term/function. |
| Punctuation/spacing | punctuation and whitespace modifiers | Defaults can inherit Everything Search-menu settings; verify names when overriding them. |
| Value conversion | `atoi:`, `atof:`, `hex-to-number:`, `len:` | Compare text/property values as numbers or lengths. |
| Storage source | `indexed:`, `not-indexed:` / `from-disk:` | Force indexed or disk-backed property/content lookup. |
| Content bytes/encoding | `binary:`, `hex:`, encoding/content modifiers | Disk work may be slow; narrow with indexed terms first. |
| Presentation/filter state | highlight/filter/menu modifiers | Visible effects may require an Everything GUI client. |

## Pitfalls

- `regex:` consumes search operators differently; keep the complete regex term in one PowerShell argument.
- A modifier can override an Everything UI setting for only its term, group, or the remainder of the query.
- `from-disk:` and content/encoding modifiers may touch many files. Scope them by path, extension, size, or date first.
- User macros can shadow built-in names. Use the `::` form when deterministic built-in behavior matters.

## Online fallback

Open the official page for any modifier not listed here or when combining regex, filter, encoding, indexed/disk, omission, highlight, or multi-string behavior. Verify its default, inverse `no-` form, scope, and client-specific effects.

Official source: [Search Modifiers](https://www.voidtools.com/forum/viewtopic.php?f=12&t=10860).
