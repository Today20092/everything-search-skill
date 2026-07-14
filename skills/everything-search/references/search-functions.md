# Everything 1.5 search functions

Use this reference when a request depends on a file or folder property. It is a capability map, not a duplicate of the full catalog. Checked against the official Everything 1.5 documentation on 2026-07-14.

## Grammar

- Write `function:value`, for example `date-modified:today` or `size:>10mb`.
- Dashes in function names are optional: `date-modified:` and `datemodified:` are equivalent.
- Quote spaces and `|` inside values: `artist:"John Doe"`.
- Use `<`, `<=`, `>`, `>=`, equality/inequality, or `start..end` where the property's type supports them.
- Use `unknown` to match a missing/unknown property value where supported.
- A semicolon list is OR within one function: `width:1920;3840`.
- A grouped subexpression applies the function to each term: `content:<alpha|beta>`.
- `$property-name:` substitutes the current result's property in supported filename functions.
- A formula containing `$property-name:` can compare or transform properties when no outer function is specified.

## Date and size values

- Dates accept locale forms and ISO 8601. Prefer unambiguous ISO values such as `dm:2026-07-14`.
- Common date constants include `today`, `yesterday`, weekdays, months, `mtd`, `qtd`, `ytd`, and `unknown`.
- Relative values include `2days`, `3months`, and `4hours`.
- Use ranges such as `dm:2026-01-01..2026-06-30` and comparisons such as `size:>1gb`.
- Size suffixes use the active Everything size standard; avoid assuming decimal versus binary when the boundary must be exact.

## Capability map

| Need | Start with | Notes |
|---|---|---|
| Name and location | `name:`, `path:`, `parent:`, `ancestor:`, `wfn:` | `parent:` is immediate; `ancestor:` is recursive. |
| Type | `file:`, `folder:`, `ext:`, built-in type macros | Prefer explicit extensions when exactness matters. |
| Size and timestamps | `size:`, `dm:`, `dc:`, `da:` | Indexed when the corresponding property is enabled. |
| Filesystem and attributes | `attrib:`, `volume:`, `index-type:`, IDs/FRNs | Consult the catalog for exact property names and value formats. |
| Content | `content:`, encoding/content-specific functions | Usually disk-backed unless content indexing is enabled. Narrow first. |
| Duplicate detection | `dupe:`, `distinct:`, `unique:` | Pass a semicolon-separated property list. For content identity, narrow first and use `dupe:size;sha256`; hashing can be slow, and new results require a refresh. |
| Recent changes | `rc:`, `recentchange:` | Matches changes since Everything started; optional NTFS USN-journal loading can extend the history. |
| Hashes and binary data | hash properties, first-byte functions | Narrow by indexed criteria before reading files. |
| Images, audio, and video | dimensions, duration, bitrate, codec, camera/media properties | Availability depends on property handlers and indexing. |
| Documents and executables | author/title/page-count, version/signature/PE properties | May require disk access or property indexing. |
| Shortcuts and relationships | shortcut target, sibling/child/descendant/ancestor functions | Verify the exact relationship function before use. |
| Result shaping | `sort:`, `count:`, columns/layout functions | Window/layout functions are GUI state, not ES JSON formatting controls. |

## Performance rule

Build the query from indexed terms first: path, name, extension, type, size, and indexed dates. Add `content:`, hashes, media metadata, or other disk-backed properties only after the candidate set is small. Everything may reorder terms, but a narrow indexed prefix still reduces disk work.

## Online fallback

Open the official catalog before using a function not named above, an alias, an exact/unknown comparison, property substitution, formulas, weighted search, column-header search, or a version-specific property. Verify the function's aliases, accepted value type, indexing requirement, and examples.

Official sources: [Search Functions](https://www.voidtools.com/forum/viewtopic.php?f=12&t=10176), [Find Duplicates](https://www.voidtools.com/support/everything/find_duplicates), and [Recent Changes](https://www.voidtools.com/support/everything/recent_changes).
