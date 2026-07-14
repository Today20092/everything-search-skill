# Everything Search Agent Skill

[![Install with skills.sh](https://img.shields.io/badge/skills.sh-install-111827?style=for-the-badge&logo=npm&logoColor=white)](https://www.skills.sh/today20092/everything-search-skill/everything-search) [![Windows](https://img.shields.io/badge/platform-Windows-0078D4?style=for-the-badge&logo=windows11&logoColor=white)](https://www.microsoft.com/windows/) [![Everything 1.5](https://img.shields.io/badge/Everything-1.5-ff5a1f?style=for-the-badge)](https://www.voidtools.com/forum/viewtopic.php?f=12&t=9787) [![Agent Skills compatible](https://img.shields.io/badge/Agent%20Skills-compatible-412991?style=for-the-badge&logo=openai&logoColor=white)](https://www.skills.sh/docs) [![MIT License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE) [![GitHub stars](https://img.shields.io/github/stars/Today20092/everything-search-skill?style=for-the-badge&logo=github&label=Stars)](https://github.com/Today20092/everything-search-skill/stargazers)

Give Codex, Claude Code, and other Agent Skills-compatible assistants fast access to the local Windows filesystem through [Everything](https://www.voidtools.com/) and its official [ES command-line interface](https://github.com/voidtools/ES).

## Why this exists

AI coding agents usually locate files by walking directories. That works inside one repository, but it is slow and incomplete when the request spans an entire Windows computer. Everything already maintains a near-instant local index; this skill teaches an agent to query that index safely instead of scanning every drive.

This skill deliberately uses the official `es.exe` client directly. It adds no Node or Python wrapper, bundles no third-party executable, and keeps ordinary read-only search separate from Everything GUI commands that can change application or filesystem state.

The skill was developed with guidance from [mattpocock/skills](https://github.com/mattpocock/skills). Its [research skill](https://github.com/mattpocock/skills/blob/main/skills/engineering/research/SKILL.md) guided how we gathered and verified the Everything search syntax, ES CLI, SDK3, and UI-command information against official voidtools documentation.

## What it covers

- Name, path, extension, date, size, attribute, and indexed-property searches
- AND, OR, NOT, grouping, quoting, wildcards, macros, and character entities
- Search functions, modifiers, formulas, and preprocessor routing
- JSON results, paging, sorting, and candidate verification
- Conditional diagnostics for ES failures and missing, stale, omitted, or duplicated results
- Headless bookmark and filter creation through Everything's supported CSV import commands
- Guarded Everything 1.5 tab, column, and layout commands
- Guidance for deciding when a direct Everything SDK3 integration is justified
- Local progressive references with official voidtools documentation as the version-sensitive fallback

## Install

Copy and paste this command to install the skill globally for Codex:

```powershell
npx skills add Today20092/everything-search-skill --skill everything-search -g -a codex
```

[View the skill on skills.sh](https://www.skills.sh/today20092/everything-search-skill/everything-search)

To inspect the skills available in the repository before installing:

```powershell
npx skills add Today20092/everything-search-skill --list
```

The Skills CLI also supports Claude Code, Cursor, GitHub Copilot, and other Agent Skills-compatible clients.

## Requirements

1. Windows 10 or Windows 11
2. [Everything 1.5](https://www.voidtools.com/forum/viewtopic.php?f=12&t=9787) installed and running
3. The official [ES CLI](https://github.com/voidtools/ES/releases) installed as `es.exe` and available on `PATH`, or permission for the agent to run the optional installer included with this skill
4. Windows PowerShell 5.1 or PowerShell 7 for the optional installer

The official ES installation guide recommends placing `es.exe` in `%LOCALAPPDATA%\Microsoft\WindowsApps`, which is normally already on `PATH`.

Verify the prerequisite:

```powershell
es.exe -version
```

### Optional ES installation

When `es.exe` is missing, the skill can offer to run `scripts/install-es.ps1` after receiving explicit permission. The script:

- queries the official `voidtools/ES` GitHub repository for the latest release;
- selects the asset matching the Windows architecture;
- verifies the GitHub-provided SHA-256 digest;
- installs only `es.exe` into `%LOCALAPPDATA%\Microsoft\WindowsApps` by default;
- does not modify the system `PATH`, install Everything, or require administrator access.

The digest checks the downloaded archive against GitHub's release metadata. It protects transfer integrity but does not replace trust in the official voidtools GitHub repository.

From a cloned repository, run it manually with:

```powershell
& .\skills\everything-search\scripts\install-es.ps1
```

Use `-WhatIf` to preview and `-InstallDirectory` to choose another destination.

## Example requests

- “Find every PDF named like invoice anywhere on this computer.”
- “Show the five largest videos modified this year.”
- “Locate folders named node_modules outside archived projects.”
- “Find case-sensitive README.md files.”
- “Create a new Everything tab with Name, Path, Size, and Date Modified columns.”
- “Add a workdocs: filter for PDFs and Word documents under my work folder.”
- “Create a Projects bookmark folder with saved searches for each active project.”
- “Would this request benefit from the Everything SDK instead of ES?”

## Design and safety

Ordinary searches use local IPC between `es.exe` and the running Everything application. Search results are treated as candidates because indexed paths can become stale. The skill verifies a path before reading or changing it.

Filenames, paths, and requested metadata returned by ES enter the agent conversation. Depending on the chosen agent and provider, that information may be transmitted off the computer under the provider's privacy terms. Review the query and provider policy before searching sensitive locations.

Content searches and unindexed properties can touch disk, so the skill narrows candidates with indexed terms first. GUI commands, persistent bookmark and filter imports, and file-changing commands are routed separately and require explicit user intent.

The repository does not distribute Everything, ES, or the SDK. Install those components from voidtools.

## Repository layout

```text
skills/everything-search/
├── SKILL.md
├── agents/openai.yaml
├── scripts/install-es.ps1
└── references/
    ├── bookmarks-filters.md
    ├── sdk3.md
    ├── search-functions.md
    ├── search-modifiers.md
    ├── search-preprocessor.md
    ├── search-syntax.md
    ├── troubleshooting.md
    └── ui-commands.md
```

Manual routing and safety evaluations live in [`skills/everything-search/evals/cases.md`](skills/everything-search/evals/cases.md).

## Related work

[CodingRookie98/everything-search](https://github.com/CodingRookie98/everything-search) is another public Agent Skill for Everything. It provides a Node.js wrapper around ES. This repository takes a different approach: direct ES invocation, progressive Everything 1.5 language references, explicit GUI/SDK routing, and no runtime wrapper.

## Attribution

Everything is developed by [voidtools](https://www.voidtools.com/). This independent skill is not affiliated with or endorsed by voidtools. “Everything” is used here solely to identify the compatible product.

## License

The original skill instructions and documentation in this repository are available under the [MIT License](LICENSE). Everything, ES, and the Everything SDK have their own licenses and are not included.
