import '../index/cairn_index.dart';
import '../index/models.dart';

/// Turns index entries into Markdown an assistant can read and quote.
class Renderer {
  Renderer(this.index);

  final CairnIndex index;

  static const String importLine = "import 'package:cairn_ui/cairn_ui.dart';";

  /// The conventions every assistant should follow when writing Cairn code.
  static const String conventions =
      '''
- Import the whole library with one line: `$importLine`. There are no per-component imports.
- Every public widget is prefixed `Cairn` (`CairnButton`, `CairnCard`). Do not invent widgets that are not listed by `list_components`.
- Colours, radii, spacing and type come from the theme, never literals: `CairnTheme.of(context).primary`, `theme.radiusScale.md`, `CairnSpacing.s4`, `theme.textStyle(CairnTypography.sm)`.
- Read the theme with `CairnTheme.of(context)`. Install it with `ThemeData(extensions: [CairnTheme.light])` or `CairnTheme.materialTheme(CairnTheme.light)`.
- Icon-only buttons use `CairnButton.icon(...)` and need a `semanticLabel`.
- Prefer a Cairn component over a Material one when both exist; Cairn has no ripple, so interactions are colour and shadow transitions.
- `CairnTone` (neutral, primary, success, warning, info, destructive) colours state-bearing components such as Status, Steps, Timeline and Radial Progress.
- Components that open overlays (toasts, dialogs, sheets) need a Navigator or a `CairnToaster` above them.
''';

  /// A short orientation for a fresh conversation.
  String overview() {
    final StringBuffer b = StringBuffer()
      ..writeln('# Cairn UI ${index.cairnUiVersion}')
      ..writeln()
      ..writeln(
        'Cairn UI is a Flutter component library: ${index.modules.length} '
        'component modules on one design-token layer (OKLCH colour, a '
        'multiplier-based radius scale, a Tailwind spacing scale, a type '
        'scale), light and dark themes, and golden tests.',
      )
      ..writeln()
      ..writeln('## Install')
      ..writeln()
      ..writeln(
        '```yaml\ndependencies:\n  cairn_ui: ^${_minor(index.cairnUiVersion)}\n```',
      )
      ..writeln()
      ..writeln('```dart\n$importLine\n```')
      ..writeln()
      ..writeln('## Conventions')
      ..writeln()
      ..writeln(conventions)
      ..writeln('## What is available')
      ..writeln();
    for (final String cat in _categoryOrder) {
      final List<Component> cs = index.components
          .where((Component c) => c.category == cat)
          .toList();
      if (cs.isEmpty) continue;
      b.writeln(
        '- **${cs.first.categoryLabel}**: ${cs.map((Component c) => c.name).join(', ')}',
      );
    }
    b
      ..writeln()
      ..writeln(
        '${index.blocks.length} blocks (${index.blocks.map((Block x) => x.name).join(', ')}) '
        'and ${index.templates.length} whole-app templates '
        '(${index.templates.map((Template t) => t.name).join(', ')}).',
      )
      ..writeln()
      ..writeln('## How to use this server')
      ..writeln()
      ..writeln(
        '1. `search_components` with the user\'s need in plain words, or '
        '`list_components` to browse.\n'
        '2. `get_component` for the exact constructor, parameters, enums and '
        'copy-pasteable examples. Do not guess parameter names.\n'
        '3. `get_tokens` / `get_theme` before writing any colour, spacing or '
        'theme code.\n'
        '4. `get_block` or `get_template` when the user wants a whole screen or '
        'app.\n'
        '5. `get_docs` for installation, theming, accessibility and '
        'architecture guides.',
      );
    return b.toString();
  }

  static const List<String> _categoryOrder = <String>[
    'forms',
    'display',
    'overlays',
    'navigation',
    'data',
  ];

  String _minor(String v) {
    final List<String> p = v.split('.');
    return p.length >= 2 ? '${p[0]}.${p[1]}.0' : v;
  }

  /// A table of components, optionally for one category.
  String componentList({String? category}) {
    final String? cat = category?.toLowerCase();
    final List<Component> cs = <Component>[
      for (final Component c in index.components)
        if (cat == null ||
            c.category == cat ||
            c.categoryLabel.toLowerCase() == cat ||
            c.categoryLabel.toLowerCase().startsWith(cat))
          c,
    ];
    final StringBuffer b = StringBuffer()
      ..writeln('# Components${category == null ? '' : ' — $category'}')
      ..writeln()
      ..writeln('| Component | Widgets | Category | What it is |')
      ..writeln('| --- | --- | --- | --- |');
    for (final Component c in cs) {
      b.writeln(
        '| ${c.name} (`${c.slug}`) | ${c.widgetNames.map((String w) => '`$w`').join(', ')} '
        '| ${c.categoryLabel} | ${c.description} |',
      );
    }
    b
      ..writeln()
      ..writeln(
        '${cs.length} components. Call `get_component` with a name or slug for the full API.',
      );
    return b.toString();
  }

  /// One component in full.
  String component(
    Component c, {
    bool quickStart = true,
    bool variants = true,
    bool api = true,
  }) {
    final StringBuffer b = StringBuffer()
      ..writeln('# ${c.name}')
      ..writeln()
      ..writeln(c.description)
      ..writeln()
      ..writeln(
        '- Category: ${c.categoryLabel}\n'
        '- Widgets: ${c.widgetNames.map((String w) => '`$w`').join(', ')}\n'
        '- Import: `${Renderer.importLine}`',
      );
    if (c.note != null) {
      b
        ..writeln()
        ..writeln('> ${c.note}');
    }
    if (quickStart && c.quickStart.isNotEmpty) {
      b
        ..writeln()
        ..writeln('## Quick start')
        ..writeln()
        ..writeln('```dart\n${c.quickStart.trim()}\n```');
    }
    if (variants && c.variants.isNotEmpty) {
      b
        ..writeln()
        ..writeln('## Variants and examples');
      for (final Variant v in c.variants) {
        b
          ..writeln()
          ..writeln('### ${v.label}')
          ..writeln()
          ..writeln('```dart\n${v.code.trim()}\n```');
      }
    }
    final ApiModule? m = c.module;
    if (api && m != null) {
      b
        ..writeln()
        ..writeln('## API');
      for (final ApiClass cls in m.classes) {
        b
          ..writeln()
          ..write(apiClass(cls));
      }
      for (final ApiEnum e in m.enums) {
        b
          ..writeln()
          ..write(apiEnum(e));
      }
      for (final ApiFunction f in m.functions) {
        b
          ..writeln()
          ..write(apiFunction(f));
      }
    }
    return b.toString();
  }

  /// A class with its constructors, parameters, statics and members.
  String apiClass(ApiClass cls, {int level = 3}) {
    final String h = '#' * level;
    final StringBuffer b = StringBuffer()
      ..writeln('$h `${cls.name}`${cls.isWidget ? ' (widget)' : ''}');
    if (cls.doc.isNotEmpty) {
      b
        ..writeln()
        ..writeln(cls.doc);
    }
    for (final ApiConstructor ctor in cls.constructors) {
      final String ctorName = ctor.name.isEmpty
          ? cls.name
          : '${cls.name}.${ctor.name}';
      b
        ..writeln()
        ..writeln('**Constructor** `$ctorName(${_paramList(ctor.params)})`');
      if (ctor.doc.isNotEmpty) {
        b
          ..writeln()
          ..writeln(ctor.doc);
      }
      if (ctor.params.isNotEmpty) {
        b
          ..writeln()
          ..writeln('| Parameter | Type | Required | Default | Description |')
          ..writeln('| --- | --- | --- | --- | --- |');
        for (final ApiParam p in ctor.params) {
          b.writeln(
            '| `${p.name}` | `${_cell(p.type)}` | ${p.required ? 'yes' : ''} '
            '| ${p.defaultValue == null ? '' : '`${_cell(p.defaultValue!)}`'} '
            '| ${_cell(p.doc)} |',
          );
        }
      }
    }
    if (cls.statics.isNotEmpty) {
      b
        ..writeln()
        ..writeln('**Static members**')
        ..writeln();
      for (final ApiMember s in cls.statics) {
        final String sig =
            s.signature ??
            '${s.type} ${s.name}${s.value != null ? ' = ${s.value}' : ''}';
        b.writeln('- `$sig`${s.doc.isEmpty ? '' : ' — ${_oneLine(s.doc)}'}');
      }
    }
    if (cls.members.isNotEmpty) {
      b
        ..writeln()
        ..writeln('**Members**')
        ..writeln();
      for (final ApiMember s in cls.members) {
        final String sig = s.signature ?? '${s.type} get ${s.name}';
        b.writeln('- `$sig` — ${_oneLine(s.doc)}');
      }
    }
    return b.toString();
  }

  /// An enum and its values.
  String apiEnum(ApiEnum e, {int level = 3}) {
    final StringBuffer b = StringBuffer()
      ..writeln('${'#' * level} `${e.name}` (enum)');
    if (e.doc.isNotEmpty) {
      b
        ..writeln()
        ..writeln(e.doc);
    }
    b.writeln();
    for (final EnumValue v in e.values) {
      b.writeln(
        '- `${e.name}.${v.name}`${v.doc.isEmpty ? '' : ' — ${_oneLine(v.doc)}'}',
      );
    }
    return b.toString();
  }

  /// A top-level function.
  String apiFunction(ApiFunction f, {int level = 3}) {
    final StringBuffer b = StringBuffer()
      ..writeln('${'#' * level} `${f.name}()` (function)')
      ..writeln()
      ..writeln('`${f.returns} ${f.name}(${_paramList(f.params)})`');
    if (f.doc.isNotEmpty) {
      b
        ..writeln()
        ..writeln(f.doc);
    }
    return b.toString();
  }

  String _paramList(List<ApiParam> params) {
    final List<ApiParam> positional = <ApiParam>[
      for (final ApiParam p in params)
        if (!p.named) p,
    ];
    final List<ApiParam> named = <ApiParam>[
      for (final ApiParam p in params)
        if (p.named) p,
    ];
    final StringBuffer b = StringBuffer();
    b.write(positional.map((ApiParam p) => p.signature).join(', '));
    if (named.isNotEmpty) {
      if (positional.isNotEmpty) b.write(', ');
      b.write('{${named.map((ApiParam p) => p.signature).join(', ')}}');
    }
    return b.toString();
  }

  String _cell(String s) => _oneLine(s).replaceAll('|', r'\|');

  String _oneLine(String s) => s.replaceAll(RegExp(r'\s*\n\s*'), ' ').trim();

  /// Token classes for [group], or every group.
  String tokens({String? group}) {
    final List<String> groups = group == null || group == 'all'
        ? index.tokenGroups
        : <String>[group];
    final StringBuffer b = StringBuffer()..writeln('# Design tokens');
    for (final String g in groups) {
      final List<ApiClass> classes = index.tokenGroup(g);
      if (classes.isEmpty) {
        b
          ..writeln()
          ..writeln(
            '_No token group named `$g`. Groups: ${index.tokenGroups.join(', ')}._',
          );
        continue;
      }
      for (final ApiClass c in classes) {
        b
          ..writeln()
          ..write(apiClass(c, level: 2));
      }
    }
    return b.toString();
  }

  /// The theme API plus the guide pages that explain it.
  String theme() {
    final StringBuffer b = StringBuffer()..writeln('# Theming');
    for (final ApiClass c in index.tokenGroup('theme')) {
      b
        ..writeln()
        ..write(apiClass(c, level: 2));
    }
    final DocPage? page = index.findDoc('theming');
    if (page != null) {
      b
        ..writeln()
        ..writeln('## Guide: ${page.title}')
        ..writeln()
        ..writeln(page.markdown);
    }
    return b.toString();
  }

  /// A doc page.
  String doc(DocPage d) => '# ${d.title}\n\n${d.summary}\n\n${d.markdown}';

  /// The docs index.
  String docList() {
    final StringBuffer b = StringBuffer()
      ..writeln('# Guides')
      ..writeln();
    for (final DocPage d in index.docs) {
      b.writeln('- `${d.slug}` — **${d.title}** (${d.group}): ${d.summary}');
    }
    return b.toString();
  }

  /// A block with its code.
  String block(Block x) {
    final StringBuffer b = StringBuffer()
      ..writeln('# ${x.name} block')
      ..writeln()
      ..writeln(x.description)
      ..writeln()
      ..writeln('Built from: ${x.uses.join(', ')}')
      ..writeln()
      ..writeln('```dart\n${x.code.trim()}\n```');
    return b.toString();
  }

  /// The blocks index.
  String blockList() {
    final StringBuffer b = StringBuffer()
      ..writeln('# Blocks')
      ..writeln()
      ..writeln('Whole screens composed only from Cairn components.')
      ..writeln();
    for (final Block x in index.blocks) {
      b.writeln('- `${x.slug}` — **${x.name}**: ${x.description}');
    }
    return b.toString();
  }

  /// A template.
  String template(Template t) {
    final String pkg = 'cairn_template_${t.slug}';
    final String widget = switch (t.slug) {
      'shop' => 'ShopApp',
      'dashboard' => 'DashboardApp',
      'blog' => 'BlogApp',
      'docs' => 'DocsApp',
      'landing' => 'LandingApp',
      _ => 'App',
    };
    final StringBuffer b = StringBuffer()
      ..writeln('# ${t.name} template (${t.kind.toLowerCase()})')
      ..writeln()
      ..writeln(t.description)
      ..writeln()
      ..writeln(
        'Package: `$pkg` (in `templates/${t.slug}` of the cairn_site repository).',
      )
      ..writeln();
    b.writeln('## Screens');
    for (final (String, String) s in t.screens) {
      b.writeln('- **${s.$1}** — ${s.$2}');
    }
    b
      ..writeln()
      ..writeln('Built from: ${t.uses.join(', ')}')
      ..writeln()
      ..writeln('## Use it')
      ..writeln()
      ..writeln(
        '```yaml\ndependencies:\n  cairn_ui: ^${_minor(index.cairnUiVersion)}\n'
        '  $pkg:\n    git:\n      url: https://github.com/rlphjyson/cairn_site.git\n'
        '      path: templates/${t.slug}\n```',
      )
      ..writeln()
      ..writeln(
        "```dart\nimport 'package:$pkg/$pkg.dart';\n\n"
        'MaterialApp(\n'
        '  theme: CairnTheme.materialTheme(CairnTheme.light),\n'
        '  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),\n'
        '  home: const Scaffold(body: $widget()),\n'
        ');\n```',
      )
      ..writeln()
      ..writeln(
        'Each template is a standalone package with its own assets, tests and '
        'an HTML tutorial (`doc/index.html`) covering content changes, theming, '
        'connecting a backend and migration.',
      );
    return b.toString();
  }

  /// The templates index.
  String templateList() {
    final StringBuffer b = StringBuffer()
      ..writeln('# Templates')
      ..writeln();
    for (final Template t in index.templates) {
      b.writeln('- `${t.slug}` — **${t.name}** (${t.kind}): ${t.summary}');
    }
    return b.toString();
  }

  /// A compact `llms.txt` index, following https://llmstxt.org.
  String llmsTxt({String siteUrl = 'https://rlphjyson.github.io/cairn_site'}) {
    final StringBuffer b = StringBuffer()
      ..writeln('# Cairn UI')
      ..writeln()
      ..writeln(
        '> A modern, accessible Flutter component library: '
        '${index.modules.length} components on a design-token layer. '
        'Version ${index.cairnUiVersion}. Install with `flutter pub add cairn_ui`.',
      )
      ..writeln()
      ..writeln(conventions)
      ..writeln('## Components')
      ..writeln();
    for (final Component c in index.components) {
      b.writeln(
        '- [${c.name}]($siteUrl/components/${c.slug}): ${c.description}',
      );
    }
    b
      ..writeln()
      ..writeln('## Guides')
      ..writeln();
    for (final DocPage d in index.docs) {
      b.writeln('- [${d.title}]($siteUrl/docs/${d.slug}): ${d.summary}');
    }
    b
      ..writeln()
      ..writeln('## Templates')
      ..writeln();
    for (final Template t in index.templates) {
      b.writeln('- [${t.name}]($siteUrl/templates/${t.slug}): ${t.summary}');
    }
    b
      ..writeln()
      ..writeln('## Optional')
      ..writeln()
      ..writeln(
        '- [MCP server](https://github.com/rlphjyson/cairn_ui_mcp): live component, token and snippet lookup for AI assistants.',
      );
    return b.toString();
  }

  /// A full-text `llms-full.txt`: every component in full plus the guides.
  String llmsFull() {
    final StringBuffer b = StringBuffer()
      ..writeln(overview())
      ..writeln('\n---\n');
    for (final Component c in index.components) {
      b
        ..writeln(component(c, variants: true))
        ..writeln('\n---\n');
    }
    b
      ..writeln(tokens())
      ..writeln('\n---\n');
    for (final DocPage d in index.docs) {
      b
        ..writeln(doc(d))
        ..writeln('\n---\n');
    }
    return b.toString();
  }
}
