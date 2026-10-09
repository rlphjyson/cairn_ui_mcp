# cairn_ui_mcp

A [Model Context Protocol](https://modelcontextprotocol.io) server for
[Cairn UI](https://github.com/rlphjyson/cairn_ui), the Flutter component
library. Add it to your AI assistant and it can look up Cairn's components,
exact constructor parameters, design tokens, themes, blocks and whole-app
templates, instead of guessing an API from memory.

```
You:        Build a settings screen with a dark-mode switch and a danger zone.
Assistant:  → search_components("switch") → get_component("Switch")
            → get_component("Alert Dialog") → get_tokens("spacing")
            …writes code that compiles against the real API.
```

It works offline, needs no API key, and ships its knowledge inside the binary.
Everything it says is generated from the library's own source, so it cannot
describe a parameter that does not exist.

- [Install](#install)
- [Connect your editor](#connect-your-editor)
- [What it provides](#what-it-provides)
- [Using it](#using-it)
- [Where the knowledge comes from](#where-the-knowledge-comes-from)
- [Develop](#develop)

## Install

You need the [Dart SDK](https://dart.dev/get-dart) (it comes with Flutter).

```bash
dart pub global activate --source git https://github.com/rlphjyson/cairn_ui_mcp.git
cairn_ui_mcp --info
# cairn_ui_mcp 0.1.0: cairn_ui 0.2.0, 70 components, 8 guides, 5 blocks, 5 templates.
```

Make sure `~/.pub-cache/bin` (on Windows, `%LOCALAPPDATA%\Pub\Cache\bin`) is on
your `PATH`. To update, run the same command again.

**No Dart?** Download a prebuilt binary for Windows, macOS or Linux from the
[releases page](https://github.com/rlphjyson/cairn_ui_mcp/releases) and use its
full path as the `command` below.

## Connect your editor

The server speaks MCP over stdio, which is what every editor expects. If
`cairn_ui_mcp` is on your `PATH`, the command is just `cairn_ui_mcp`; otherwise
use the absolute path to the binary.

### Claude Code

```bash
claude mcp add cairn-ui -- cairn_ui_mcp
```

### Claude Desktop

`claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "cairn-ui": { "command": "cairn_ui_mcp" }
  }
}
```

### Cursor

`.cursor/mcp.json` in your project, or `~/.cursor/mcp.json` for every project:

```json
{
  "mcpServers": {
    "cairn-ui": { "command": "cairn_ui_mcp" }
  }
}
```

### VS Code (GitHub Copilot)

`.vscode/mcp.json`:

```json
{
  "servers": {
    "cairn-ui": { "type": "stdio", "command": "cairn_ui_mcp" }
  }
}
```

### Windsurf

`~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "cairn-ui": { "command": "cairn_ui_mcp" }
  }
}
```

### Zed

`settings.json`:

```json
{
  "context_servers": {
    "cairn-ui": { "command": { "path": "cairn_ui_mcp", "args": [] } }
  }
}
```

### Cline

Open *MCP Servers → Configure* and add:

```json
{
  "mcpServers": {
    "cairn-ui": { "command": "cairn_ui_mcp", "args": [], "disabled": false }
  }
}
```

### Codex

`~/.codex/config.toml`:

```toml
[mcp_servers.cairn-ui]
command = "cairn_ui_mcp"
```

### Anything else

Run `cairn_ui_mcp` as a stdio MCP server. There are no arguments to pass and no
environment variables to set.

## What it provides

### Tools

| Tool | What it returns |
| --- | --- |
| `cairn_overview` | Start here: what Cairn is, install, the conventions to follow, what is available. |
| `list_components` | Every component with its widgets, category and a one-line description. Filter by category. |
| `search_components` | Best matches for a need in plain words ("confirm before deleting", "bottom navigation"), each with an example. |
| `get_component` | The full reference: quick start, every variant example, and the exact public API: constructors, parameters with types, defaults and docs, enums, helper functions. |
| `get_tokens` | Colours, radius, spacing, typography, shadows, motion, tones, OKLCH and theme values with their docs. |
| `get_theme` | The `CairnTheme` API, installing light and dark, `copyWith`, the radius scale, and the guide. |
| `list_blocks`, `get_block` | Composed screens (login, dashboard shell, settings, pricing, team roster) with full source. |
| `list_templates`, `get_template` | The whole-app templates (e-commerce, dashboard, blog, documentation, SaaS landing) and how to mount them. |
| `get_docs` | The guides: introduction, installation, quick start, theming, accessibility and more. |

Every tool is read-only.

### Resources

Readable by clients that support MCP resources:
`cairn://overview`, `cairn://components`, `cairn://components/{slug}`,
`cairn://tokens`, `cairn://tokens/{group}`, `cairn://theme`, `cairn://docs`,
`cairn://docs/{slug}`, `cairn://blocks/{slug}`, `cairn://templates/{slug}`,
`cairn://llms.txt` and `cairn://llms-full.txt`.

### Prompts

| Prompt | Use it to |
| --- | --- |
| `build_screen` | Build a screen from a description, with the right lookup process baked in. |
| `migrate_to_cairn` | Convert Material code to Cairn components and tokens. |
| `review_cairn_usage` | Check code for invented widgets, wrong parameters, hard-coded colours and missing semantics. |

## Using it

Mention Cairn and the assistant will reach for the tools. Prompts that work well:

- "Use Cairn UI to build a login screen with email, password and a social button."
- "Which Cairn component should I use for a command palette? Show me its API."
- "Make this screen use Cairn tokens instead of hard-coded colours."
- "Set up a Cairn theme with a 4px radius and a blue primary, light and dark."
- "Start from the Cairn dashboard template and rename it for my product."

If an assistant ignores the server, tell it explicitly: "use the cairn-ui MCP
server".

`cairn_ui_mcp --llms` and `--llms-full` print the same knowledge as
[llms.txt](https://llmstxt.org) files, for tools that take a file instead of a
server.

## Where the knowledge comes from

`tool/build_index.dart` parses source files (no network, no Flutter) and writes
`lib/src/index/cairn_index.g.dart`, a gzipped JSON document compiled into the
package so `dart compile exe` produces a self-contained binary:

| Source | Gives |
| --- | --- |
| `cairn_ui` `lib/src/components/**` | Public widgets, constructors, parameters, enums and functions, with the library's own doc comments |
| `cairn_ui` `lib/src/tokens/**`, `lib/src/theme/**` | Every design token and the theme API |
| `cairn_site` `lib/src/data/**` | Each component's quick start and variant examples, the guides, blocks and templates |

Rebuild it when either changes:

```bash
dart run tool/build_index.dart --cairn-ui ../cairn_ui --site ../cairn_site
dart test
```

## Develop

```bash
dart pub get
dart analyze --fatal-infos
dart test                          # index, search, rendering, and the server over a real MCP connection
dart run bin/cairn_ui_mcp.dart --info
dart compile exe bin/cairn_ui_mcp.dart -o build/cairn_ui_mcp
```

Layout:

```
bin/cairn_ui_mcp.dart       the executable (stdio server, --info, --llms)
lib/src/server/             tools, resources and prompts (dart_mcp)
lib/src/index/              typed models and the generated index
lib/src/search/             plain-language ranking with synonyms
lib/src/render/             Markdown rendering, llms.txt
tool/                       the index generator (analyzer-based)
test/                       index, search, rendering and end-to-end server tests
```

### Limitations

- The index describes one `cairn_ui` version (shown by `--info`). It does not
  read your project's installed version; update the server when you update
  Cairn.
- Search is keyword and synonym based, not semantic. It is tuned for the
  component catalogue.
- Components built in a loop on the site (Swap) and Sheet have no variant
  snippets yet; their quick start and API are complete.

## Licence

MIT. See [LICENSE](LICENSE).
