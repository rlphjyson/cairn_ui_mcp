import 'dart:convert';
import 'dart:io';

import 'cairn_index.g.dart';
import 'models.dart';

/// The knowledge the server answers from: the cairn_ui API plus the Cairn
/// site's examples, guides, blocks and templates.
class CairnIndex {
  CairnIndex._(Json raw)
    : cairnUiVersion = raw['cairnUiVersion']! as String,
      modules = <ApiModule>[
        for (final Object? m in raw['modules']! as List<Object?>)
          ApiModule(m! as Json),
      ],
      tokenFiles = <String, List<ApiClass>>{
        for (final MapEntry<String, Object?> e
            in (raw['tokens']! as Json).entries)
          e.key: <ApiClass>[
            for (final Object? c in e.value! as List<Object?>)
              ApiClass(c! as Json),
          ],
      },
      docs = <DocPage>[
        for (final Object? d in raw['docs']! as List<Object?>)
          DocPage(d! as Json),
      ],
      blocks = <Block>[
        for (final Object? b in raw['blocks']! as List<Object?>)
          Block(b! as Json),
      ],
      templates = <Template>[
        for (final Object? t in raw['templates']! as List<Object?>)
          Template(t! as Json),
      ] {
    final Map<String, ApiModule> byName = <String, ApiModule>{
      for (final ApiModule m in modules) m.name: m,
    };
    components = <Component>[
      for (final Object? c in raw['components']! as List<Object?>)
        Component(c! as Json, _moduleFor(c as Json, byName, modules)),
    ];
  }

  /// Decodes the index compiled into the package.
  factory CairnIndex.bundled() => CairnIndex.fromJson(
    jsonDecode(utf8.decode(gzip.decode(base64.decode(cairnIndexBase64))))
        as Json,
  );

  /// Builds an index from decoded JSON (used by tests).
  factory CairnIndex.fromJson(Json raw) => CairnIndex._(raw);

  static ApiModule? _moduleFor(
    Json c,
    Map<String, ApiModule> byName,
    List<ApiModule> modules,
  ) {
    final String slug = (c['slug']! as String).replaceAll('-', '_');
    final String? lives = (c['livesIn'] as String?)?.replaceAll('.dart', '');
    final ApiModule? direct =
        byName[slug] ?? (lives == null ? null : byName[lives]);
    if (direct != null) return direct;
    // Fall back to the module that declares a widget named like the component
    // (the "Form Field" card lives in the `form` module).
    final String want = _norm(c['name']! as String);
    for (final ApiModule m in modules) {
      for (final ApiClass k in m.classes) {
        if (_norm(k.name) == want) return m;
      }
    }
    return null;
  }

  /// The cairn_ui version the index was built from.
  final String cairnUiVersion;

  /// One per component directory.
  final List<ApiModule> modules;

  /// Token files, keyed by file stem (`colors`, `radius`, ...).
  final Map<String, List<ApiClass>> tokenFiles;

  /// Guides.
  final List<DocPage> docs;

  /// Composed screens.
  final List<Block> blocks;

  /// Whole-app templates.
  final List<Template> templates;

  /// Every component card.
  late final List<Component> components;

  /// Finds a component by slug, display name or a widget class name, ignoring
  /// case, spaces and the `Cairn` prefix.
  Component? findComponent(String query) {
    final String q = _norm(query);
    if (q.isEmpty) return null;
    for (final Component c in components) {
      if (_norm(c.slug) == q || _norm(c.name) == q) return c;
    }
    for (final Component c in components) {
      for (final String w in c.widgetNames) {
        if (_norm(w) == q) return c;
      }
    }
    return null;
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceFirst(RegExp(r'^cairn'), '')
      .replaceAll(RegExp(r'[^a-z0-9]'), '');

  /// Finds a doc page by slug or title.
  DocPage? findDoc(String query) {
    final String q = _norm(query);
    for (final DocPage d in docs) {
      if (_norm(d.slug) == q || _norm(d.title) == q) return d;
    }
    return null;
  }

  /// Finds a block by slug or name.
  Block? findBlock(String query) {
    final String q = _norm(query);
    for (final Block b in blocks) {
      if (_norm(b.slug) == q || _norm(b.name) == q) return b;
    }
    return null;
  }

  /// Finds a template by slug or name.
  Template? findTemplate(String query) {
    final String q = _norm(query);
    for (final Template t in templates) {
      if (_norm(t.slug) == q || _norm(t.name) == q) return t;
    }
    return null;
  }

  /// The token classes in a token file group (`colors`, `radius`, ...).
  List<ApiClass> tokenGroup(String group) =>
      tokenFiles[group == 'theme' ? 'cairn_theme' : group] ??
      const <ApiClass>[];

  /// The groups a client can ask for.
  List<String> get tokenGroups => <String>[
    for (final String k in tokenFiles.keys)
      if (tokenFiles[k]!.isNotEmpty) k == 'cairn_theme' ? 'theme' : k,
  ];
}
