import 'package:dart_mcp/server.dart';

import '../index/cairn_index.dart';
import '../index/models.dart';
import '../render/markdown.dart';
import '../search/search.dart';

/// The server's version, reported to clients.
const String serverVersion = '0.1.0';

/// A Model Context Protocol server that answers questions about Cairn UI.
///
/// Everything it says comes from [CairnIndex], which is generated from the
/// library's own source, so an assistant can look up the real constructor and
/// parameters instead of guessing them.
base class CairnServer extends MCPServer
    with ToolsSupport, ResourcesSupport, PromptsSupport {
  CairnServer(super.channel, {CairnIndex? index})
    : index = index ?? CairnIndex.bundled(),
      super.fromStreamChannel(
        implementation: Implementation(
          name: 'cairn-ui',
          version: serverVersion,
        ),
        instructions: _instructions,
      ) {
    renderer = Renderer(this.index);
    _registerTools();
    _registerResources();
    _registerPrompts();
  }

  /// The knowledge base.
  final CairnIndex index;

  /// Markdown rendering over [index].
  late final Renderer renderer;

  static const String _instructions =
      'Cairn UI is a Flutter component library. Use these tools whenever the '
      'user asks for Flutter UI built with Cairn, or mentions CairnButton, '
      'CairnCard or any Cairn* widget. Start with `search_components` or '
      '`list_components`, then call `get_component` for the exact API; never '
      'guess a parameter name. Use `get_tokens` and `get_theme` before writing '
      'colours, spacing or theme code, and `get_block` / `get_template` for '
      'whole screens and apps.';

  // ---------------------------------------------------------------- tools

  static final ToolAnnotations _readOnly = ToolAnnotations(
    readOnlyHint: true,
    idempotentHint: true,
    openWorldHint: false,
  );

  CallToolResult _text(String markdown) =>
      CallToolResult(content: <Content>[TextContent(text: markdown)]);

  CallToolResult _error(String message) => CallToolResult(
    isError: true,
    content: <Content>[TextContent(text: message)],
  );

  String? _arg(CallToolRequest r, String key) {
    final Object? v = r.arguments?[key];
    if (v is String && v.trim().isNotEmpty) return v.trim();
    return null;
  }

  void _registerTools() {
    registerTool(
      Tool(
        name: 'cairn_overview',
        description:
            'Start here. What Cairn UI is, how to install it, the conventions '
            'to follow when writing Cairn code, and what is available.',
        inputSchema: Schema.object(),
        annotations: _readOnly,
      ),
      (CallToolRequest r) => _text(renderer.overview()),
    );

    registerTool(
      Tool(
        name: 'list_components',
        description:
            'List every Cairn component with its widget names, category and a '
            'one-line description. Optionally filter by category: forms, '
            'display, overlays, navigation or data.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'category': Schema.string(
              description: 'forms | display | overlays | navigation | data',
            ),
          },
        ),
        annotations: _readOnly,
      ),
      (CallToolRequest r) =>
          _text(renderer.componentList(category: _arg(r, 'category'))),
    );

    registerTool(
      Tool(
        name: 'search_components',
        description:
            'Find components for a need described in plain words, for example '
            '"confirm before deleting", "bottom navigation for a phone app", '
            '"show a loading state" or "pick a date". Returns the best matches '
            'with a short example for each.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'query': Schema.string(
              description: 'What the user wants to build.',
            ),
            'limit': Schema.int(description: 'Maximum results (default 6).'),
          },
          required: <String>['query'],
        ),
        annotations: _readOnly,
      ),
      _search,
    );

    registerTool(
      Tool(
        name: 'get_component',
        description:
            'The full reference for one component: description, import, quick '
            'start, copy-pasteable examples for every variant, and the exact '
            'public API (constructors, parameters with types, defaults and '
            'docs, enums, helper functions). Accepts a name ("Alert Dialog"), '
            'a slug ("alert-dialog") or a widget class ("CairnAlertDialog").',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'name': Schema.string(
              description: 'Component name, slug or class.',
            ),
            'sections': Schema.list(
              description:
                  'Limit the answer: any of quick_start, variants, api. '
                  'Default: all.',
              items: Schema.string(),
            ),
          },
          required: <String>['name'],
        ),
        annotations: _readOnly,
      ),
      _getComponent,
    );

    registerTool(
      Tool(
        name: 'get_tokens',
        description:
            'Design tokens with their values and docs. Groups: colors, radius, '
            'spacing, typography, shadows, motion, tones, oklch, theme. Omit '
            'the group for all of them.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'group': Schema.string(
              description:
                  'colors | radius | spacing | typography | shadows | motion | tones | oklch | theme | all',
            ),
          },
        ),
        annotations: _readOnly,
      ),
      (CallToolRequest r) => _text(renderer.tokens(group: _arg(r, 'group'))),
    );

    registerTool(
      Tool(
        name: 'get_theme',
        description:
            'How to theme a Cairn app: the CairnTheme API (every colour slot), '
            'installing light and dark themes, customising with copyWith, the '
            'radius scale and the guide text.',
        inputSchema: Schema.object(),
        annotations: _readOnly,
      ),
      (CallToolRequest r) => _text(renderer.theme()),
    );

    registerTool(
      Tool(
        name: 'list_blocks',
        description:
            'List the composed screens (login, dashboard shell, settings, pricing, team roster).',
        inputSchema: Schema.object(),
        annotations: _readOnly,
      ),
      (CallToolRequest r) => _text(renderer.blockList()),
    );

    registerTool(
      Tool(
        name: 'get_block',
        description:
            'The full source of one composed screen, built only from Cairn components.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'name': Schema.string(
              description: 'Block name or slug, e.g. "login".',
            ),
          },
          required: <String>['name'],
        ),
        annotations: _readOnly,
      ),
      (CallToolRequest r) {
        final String? q = _arg(r, 'name');
        final Block? b = q == null ? null : index.findBlock(q);
        if (b == null) {
          return _error(
            'No block named "${q ?? ''}". ${_names(index.blocks.map((Block x) => x.slug))}',
          );
        }
        return _text(renderer.block(b));
      },
    );

    registerTool(
      Tool(
        name: 'list_templates',
        description:
            'List the whole-app templates (e-commerce, dashboard, blog, '
            'documentation, SaaS landing) with what each contains.',
        inputSchema: Schema.object(),
        annotations: _readOnly,
      ),
      (CallToolRequest r) => _text(renderer.templateList()),
    );

    registerTool(
      Tool(
        name: 'get_template',
        description:
            'Details of one template: screens, components used, how to add the '
            'package and mount it.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'name': Schema.string(
              description: 'Template name or slug, e.g. "shop".',
            ),
          },
          required: <String>['name'],
        ),
        annotations: _readOnly,
      ),
      (CallToolRequest r) {
        final String? q = _arg(r, 'name');
        final Template? t = q == null ? null : index.findTemplate(q);
        if (t == null) {
          return _error(
            'No template named "${q ?? ''}". ${_names(index.templates.map((Template x) => x.slug))}',
          );
        }
        return _text(renderer.template(t));
      },
    );

    registerTool(
      Tool(
        name: 'get_docs',
        description:
            'The guides: introduction, installation, quick start, theming, '
            'accessibility and more. Omit the page to list them.',
        inputSchema: Schema.object(
          properties: <String, Schema>{
            'page': Schema.string(description: 'Guide slug or title.'),
          },
        ),
        annotations: _readOnly,
      ),
      (CallToolRequest r) {
        final String? q = _arg(r, 'page');
        if (q == null) return _text(renderer.docList());
        final DocPage? d = index.findDoc(q);
        if (d == null) {
          return _error(
            'No guide named "$q". ${_names(index.docs.map((DocPage x) => x.slug))}',
          );
        }
        return _text(renderer.doc(d));
      },
    );
  }

  String _names(Iterable<String> names) => 'Available: ${names.join(', ')}.';

  CallToolResult _search(CallToolRequest r) {
    final String? q = _arg(r, 'query');
    if (q == null) return _error('Give a `query`.');
    final int limit = ((r.arguments?['limit'] as num?)?.toInt() ?? 6).clamp(
      1,
      20,
    );
    final List<Hit> hits = searchComponents(index, q, limit: limit);
    if (hits.isEmpty) {
      return _text(
        'No component matches "$q". Call `list_components` to browse, or try '
        'simpler words (for example "dialog", "table", "navigation").',
      );
    }
    final StringBuffer b = StringBuffer()
      ..writeln('# Matches for "$q"')
      ..writeln();
    for (final Hit h in hits) {
      final Component c = h.component;
      b
        ..writeln(
          '## ${c.name} — ${c.widgetNames.map((String w) => '`$w`').join(', ')}',
        )
        ..writeln()
        ..writeln(c.description);
      if (c.quickStart.isNotEmpty) {
        b
          ..writeln()
          ..writeln('```dart\n${c.quickStart.trim()}\n```');
      }
      b
        ..writeln()
        ..writeln('Full reference: `get_component` with `${c.slug}`.')
        ..writeln();
    }
    return _text(b.toString());
  }

  CallToolResult _getComponent(CallToolRequest r) {
    final String? q = _arg(r, 'name');
    if (q == null) return _error('Give a component `name`.');
    final Component? c = index.findComponent(q);
    if (c == null) {
      final List<Hit> near = searchComponents(index, q, limit: 5);
      return _error(
        'No component named "$q".'
        '${near.isEmpty ? '' : ' Did you mean: ${near.map((Hit h) => h.component.name).join(', ')}?'}'
        ' Call `list_components` for the full list.',
      );
    }
    final List<String> sections = <String>[
      for (final Object? s
          in (r.arguments?['sections'] as List<Object?>? ?? const <Object?>[]))
        if (s is String) s.toLowerCase(),
    ];
    final bool all = sections.isEmpty;
    return _text(
      renderer.component(
        c,
        quickStart: all || sections.contains('quick_start'),
        variants: all || sections.contains('variants'),
        api: all || sections.contains('api'),
      ),
    );
  }

  // ------------------------------------------------------------ resources

  void _registerResources() {
    void fixed(
      String uri,
      String name,
      String description,
      String Function() body,
    ) {
      addResource(
        Resource(
          uri: uri,
          name: name,
          description: description,
          mimeType: 'text/markdown',
        ),
        (ReadResourceRequest r) => ReadResourceResult(
          contents: <ResourceContents>[
            TextResourceContents(
              uri: r.uri,
              mimeType: 'text/markdown',
              text: body(),
            ),
          ],
        ),
      );
    }

    fixed(
      'cairn://overview',
      'Cairn UI overview',
      'What Cairn is, install and conventions.',
      renderer.overview,
    );
    fixed(
      'cairn://components',
      'Component list',
      'Every component and its widgets.',
      () => renderer.componentList(),
    );
    fixed(
      'cairn://tokens',
      'Design tokens',
      'Every token group with values.',
      () => renderer.tokens(),
    );
    fixed(
      'cairn://theme',
      'Theming',
      'CairnTheme API and the theming guide.',
      renderer.theme,
    );
    fixed(
      'cairn://docs',
      'Guides',
      'The documentation pages.',
      renderer.docList,
    );
    fixed('cairn://blocks', 'Blocks', 'Composed screens.', renderer.blockList);
    fixed(
      'cairn://templates',
      'Templates',
      'Whole-app templates.',
      renderer.templateList,
    );
    fixed(
      'cairn://llms.txt',
      'llms.txt',
      'A compact index for language models.',
      () => renderer.llmsTxt(),
    );
    fixed(
      'cairn://llms-full.txt',
      'llms-full.txt',
      'Every component in full plus the guides.',
      renderer.llmsFull,
    );

    ReadResourceResult? templated(
      ReadResourceRequest r,
      String prefix,
      String? Function(String id) body,
    ) {
      if (!r.uri.startsWith(prefix)) return null;
      final String? text = body(
        Uri.decodeComponent(r.uri.substring(prefix.length)),
      );
      if (text == null) return null;
      return ReadResourceResult(
        contents: <ResourceContents>[
          TextResourceContents(
            uri: r.uri,
            mimeType: 'text/markdown',
            text: text,
          ),
        ],
      );
    }

    addResourceTemplate(
      ResourceTemplate(
        uriTemplate: 'cairn://components/{slug}',
        name: 'A component',
        description: 'The full reference for one component.',
        mimeType: 'text/markdown',
      ),
      (ReadResourceRequest r) =>
          templated(r, 'cairn://components/', (String id) {
            final Component? c = index.findComponent(id);
            return c == null ? null : renderer.component(c);
          }),
    );
    addResourceTemplate(
      ResourceTemplate(
        uriTemplate: 'cairn://tokens/{group}',
        name: 'A token group',
        description:
            'colors, radius, spacing, typography, shadows, motion, tones, oklch or theme.',
        mimeType: 'text/markdown',
      ),
      (ReadResourceRequest r) => templated(
        r,
        'cairn://tokens/',
        (String id) => renderer.tokens(group: id),
      ),
    );
    addResourceTemplate(
      ResourceTemplate(
        uriTemplate: 'cairn://docs/{slug}',
        name: 'A guide',
        description: 'One documentation page.',
        mimeType: 'text/markdown',
      ),
      (ReadResourceRequest r) => templated(r, 'cairn://docs/', (String id) {
        final DocPage? d = index.findDoc(id);
        return d == null ? null : renderer.doc(d);
      }),
    );
    addResourceTemplate(
      ResourceTemplate(
        uriTemplate: 'cairn://blocks/{slug}',
        name: 'A block',
        description: 'The source of one composed screen.',
        mimeType: 'text/markdown',
      ),
      (ReadResourceRequest r) => templated(r, 'cairn://blocks/', (String id) {
        final Block? b = index.findBlock(id);
        return b == null ? null : renderer.block(b);
      }),
    );
    addResourceTemplate(
      ResourceTemplate(
        uriTemplate: 'cairn://templates/{slug}',
        name: 'A template',
        description: 'One whole-app template.',
        mimeType: 'text/markdown',
      ),
      (ReadResourceRequest r) =>
          templated(r, 'cairn://templates/', (String id) {
            final Template? t = index.findTemplate(id);
            return t == null ? null : renderer.template(t);
          }),
    );
  }

  // -------------------------------------------------------------- prompts

  void _registerPrompts() {
    GetPromptResult user(String description, String text) => GetPromptResult(
      description: description,
      messages: <PromptMessage>[
        PromptMessage(
          role: Role.user,
          content: Content.text(text: text),
        ),
      ],
    );

    addPrompt(
      Prompt(
        name: 'build_screen',
        description:
            'Build a Flutter screen or widget with Cairn UI from a description.',
        arguments: <PromptArgument>[
          PromptArgument(
            name: 'description',
            description: 'What the screen should do and show.',
            required: true,
          ),
          PromptArgument(
            name: 'platform',
            description: 'mobile or web (default mobile).',
          ),
        ],
      ),
      (GetPromptRequest r) {
        final String d = r.arguments?['description'] as String? ?? 'a screen';
        final String p = r.arguments?['platform'] as String? ?? 'mobile';
        return user(
          'Build a Cairn UI screen',
          'Build this $p Flutter screen using Cairn UI: $d\n\n'
              'Process: call `search_components` for each need, then `get_component` '
              'for every widget you use so the parameter names are exact; call '
              '`get_tokens` before choosing colours, spacing or text styles. Use '
              'only Cairn widgets and theme tokens (no hard-coded colours or '
              'magic numbers). Check `list_blocks` and `list_templates` first in '
              'case a block already does most of this. Keep the code compiling: '
              'one import (`package:cairn_ui/cairn_ui.dart`), const where possible, '
              'semantic labels on icon-only buttons, and handle light and dark.\n\n'
              'Conventions:\n${Renderer.conventions}',
        );
      },
    );

    addPrompt(
      Prompt(
        name: 'migrate_to_cairn',
        description:
            'Convert Material or other widgets in a snippet to Cairn UI.',
        arguments: <PromptArgument>[
          PromptArgument(
            name: 'code',
            description: 'The Flutter code to convert.',
            required: true,
          ),
        ],
      ),
      (GetPromptRequest r) => user(
        'Migrate to Cairn UI',
        'Convert this Flutter code to Cairn UI. For every Material widget that '
            'has a Cairn equivalent, use `search_components` then `get_component` '
            'to get the exact API, keep behaviour identical, replace hard-coded '
            'colours and sizes with Cairn tokens, and list anything with no Cairn '
            'equivalent.\n\n```dart\n${r.arguments?['code'] ?? ''}\n```',
      ),
    );

    addPrompt(
      Prompt(
        name: 'review_cairn_usage',
        description:
            'Review code that uses Cairn UI for API misuse and token violations.',
        arguments: <PromptArgument>[
          PromptArgument(
            name: 'code',
            description: 'The code to review.',
            required: true,
          ),
        ],
      ),
      (GetPromptRequest r) => user(
        'Review Cairn usage',
        'Review this Flutter code that uses Cairn UI. Verify each Cairn widget '
            'and parameter against `get_component`, flag invented widgets or '
            'parameters, hard-coded colours/radii/spacing that should be tokens, '
            'icon-only buttons without a `semanticLabel`, and missing theme setup. '
            'Return concrete fixes.\n\nConventions:\n${Renderer.conventions}\n\n'
            '```dart\n${r.arguments?['code'] ?? ''}\n```',
      ),
    );
  }
}
