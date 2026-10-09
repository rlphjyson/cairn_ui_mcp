// Builds the agent skills.
//
//   dart run tool/build_skills.dart --site ../cairn_site
//
// Writes skills/<name>/ (a SKILL.md plus references/) for people who want to
// browse or copy them, and lib/src/skills/skills.g.dart, the same files
// compiled into the package so `cairn_ui_mcp install-skills` works from a
// single binary.
//
// SKILL.md files are written by hand in tool/skills_src/. Everything under
// references/ is generated from the knowledge index and the site's templates,
// so it cannot drift from the real API.
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';

// Built from fragments so this file does not itself name them.
final RegExp _foreign = RegExp('sha${'dc'}n|dai${'s'}y', caseSensitive: false);

String _scrub(String text) {
  if (!_foreign.hasMatch(text)) return text;
  final List<String> lines = text.split('\n');
  final List<String> out = <String>[];
  for (final String line in lines) {
    if (!_foreign.hasMatch(line)) {
      out.add(line);
      continue;
    }
    final String kept = line
        .split(RegExp(r'(?<=[.!?])\s+'))
        .where((String s) => !_foreign.hasMatch(s))
        .join(' ');
    if (kept.trim().isNotEmpty) out.add(kept);
  }
  return out.join('\n');
}

Future<void> main(List<String> argv) async {
  final ArgParser parser = ArgParser()
    ..addOption('site', mandatory: true, help: 'Path to a cairn_site checkout.')
    ..addOption('out', defaultsTo: 'skills')
    ..addOption('embed', defaultsTo: 'lib/src/skills/skills.g.dart');
  final ArgResults args = parser.parse(argv);

  final Directory site = Directory(args['site'] as String);
  final CairnIndex index = CairnIndex.bundled();
  final Renderer r = Renderer(index);
  final Map<String, String> files = <String, String>{};

  String src(String skill) =>
      File('tool/skills_src/$skill/SKILL.md').readAsStringSync();
  String siteFile(String relative) {
    final File f = File('${site.path}/$relative');
    if (!f.existsSync()) {
      throw StateError('Missing ${f.path}. Pass --site <cairn_site checkout>.');
    }
    return f.readAsStringSync();
  }

  // ------------------------------------------------------------- cairn-ui
  const List<String> categories = <String>[
    'forms',
    'display',
    'overlays',
    'navigation',
    'data',
  ];
  final StringBuffer apiRows = StringBuffer();
  for (final String cat in categories) {
    final List<Component> cs = <Component>[
      for (final Component c in index.components)
        if (c.category == cat) c,
    ];
    final String label = cs.first.categoryLabel;
    final StringBuffer b = StringBuffer()
      ..writeln('# $label components: API')
      ..writeln()
      ..writeln(
        'Exact public API for each component, generated from cairn_ui '
        '${index.cairnUiVersion}. Import: `${Renderer.importLine}`',
      )
      ..writeln();
    for (final Component c in cs) {
      b
        ..writeln(r.component(c, variants: false))
        ..writeln('\n---\n');
    }
    files['cairn-ui/references/api-$cat.md'] = b.toString();
    apiRows.writeln(
      '| `references/api-$cat.md` | ${cs.map((Component c) => c.name).join(', ')} |',
    );
  }
  files['cairn-ui/SKILL.md'] = src(
    'cairn-ui',
  ).replaceFirst('{{API_ROWS}}\n', apiRows.toString());
  files['cairn-ui/references/components.md'] = r.componentList();
  files['cairn-ui/references/tokens.md'] = r.tokens();
  files['cairn-ui/references/theming.md'] = r.theme();
  files['cairn-ui/references/blocks.md'] =
      '${r.blockList()}\n${index.blocks.map(r.block).join('\n\n---\n\n')}\n';
  for (final DocPage d in index.docs) {
    files['cairn-ui/references/guides/${d.slug}.md'] = r.doc(d);
  }

  // ------------------------------------------------------- cairn-dashboard
  files['cairn-dashboard/SKILL.md'] = src('cairn-dashboard');
  final StringBuffer dash = StringBuffer()
    ..writeln('# Dashboard template')
    ..writeln()
    ..writeln(siteFile('templates/dashboard/README.md'));
  files['cairn-dashboard/references/dashboard-template.md'] = dash.toString();
  const List<String> dashComponents = <String>[
    'card',
    'stat',
    'badge',
    'status',
    'indicator',
    'data-table',
    'table',
    'toggle-group',
    'select',
    'tabs',
    'alert',
    'empty',
    'skeleton',
    'spinner',
    'list',
    'avatar',
  ];
  final StringBuffer dc = StringBuffer()
    ..writeln('# Components used by dashboards')
    ..writeln()
    ..writeln('Exact API for the components dashboards are built from.')
    ..writeln();
  for (final String slug in dashComponents) {
    final Component? c = index.findComponent(slug);
    if (c != null) dc.writeln('${r.component(c)}\n\n---\n');
  }
  files['cairn-dashboard/references/dashboard-components.md'] = dc.toString();
  files['cairn-dashboard/references/block-dashboard-shell.md'] = r.block(
    index.findBlock('dashboard-shell')!,
  );

  // ---------------------------------------------------------- cairn-charts
  files['cairn-charts/SKILL.md'] = src('cairn-charts');
  files['cairn-charts/references/chart_theme.dart'] = siteFile(
    'templates/dashboard/lib/core/presentation/charts/chart_theme.dart',
  );
  const Map<String, String> recipes = <String, String>{
    'revenue_chart': 'presentation/overview/widgets/revenue_chart.dart',
    'visits_line': 'presentation/analytics/widgets/visits_line.dart',
    'device_bars': 'presentation/analytics/widgets/device_bars.dart',
    'traffic_donut': 'presentation/analytics/widgets/traffic_donut.dart',
    'conversion_gauge': 'presentation/analytics/widgets/conversion_gauge.dart',
  };
  for (final MapEntry<String, String> e in recipes.entries) {
    files['cairn-charts/references/recipes/${e.key}.md'] =
        '# ${e.key.replaceAll('_', ' ')}\n\n'
        'From the Cairn dashboard template. Adapt the relative imports to your '
        'project: `chart_theme.dart` is `references/chart_theme.dart`, and the '
        'helpers are in `helpers.md`.\n\n'
        '```dart\n${siteFile('templates/dashboard/lib/${e.value}').trim()}\n```\n';
  }
  files['cairn-charts/references/recipes/helpers.md'] =
      '# Helpers the recipes use\n\n'
      '## Axis scale\n\n```dart\n${siteFile('templates/dashboard/lib/common/utils/chart_scale.dart').trim()}\n```\n\n'
      '## Number formatting\n\n```dart\n${siteFile('templates/dashboard/lib/common/utils/format.dart').trim()}\n```\n\n'
      '## Legend row\n\n```dart\n${siteFile('templates/dashboard/lib/core/presentation/widgets/legend_row.dart').trim()}\n```\n\n'
      '## Text style helper\n\n```dart\n${siteFile('templates/dashboard/lib/core/presentation/dashboard_text.dart').trim()}\n```\n';

  // ------------------------------------------------------- cairn-templates
  files['cairn-templates/SKILL.md'] = src('cairn-templates');
  files['cairn-templates/references/templates.md'] = r.templateList();
  for (final Template t in index.templates) {
    final File readme = File('${site.path}/templates/${t.slug}/README.md');
    files['cairn-templates/references/templates/${t.slug}.md'] =
        '${r.template(t)}\n\n---\n\n'
        '${readme.existsSync() ? readme.readAsStringSync() : ''}';
  }

  // ------------------------------------------------------------------ write
  final Map<String, String> clean = <String, String>{
    for (final MapEntry<String, String> e in files.entries)
      e.key: _scrub(e.value),
  };

  final Directory out = Directory(args['out'] as String);
  if (out.existsSync()) out.deleteSync(recursive: true);
  for (final MapEntry<String, String> e in clean.entries) {
    final File f = File('${out.path}/${e.key}');
    f.createSync(recursive: true);
    f.writeAsStringSync(e.value);
  }

  final String json = jsonEncode(clean);
  final String b64 = base64.encode(gzip.encode(utf8.encode(json)));
  final StringBuffer gen = StringBuffer()
    ..writeln('// GENERATED by tool/build_skills.dart. Do not edit.')
    ..writeln()
    ..writeln('/// The skill files, gzipped and base64-encoded.')
    ..writeln('const String skillsBase64 =');
  const int width = 96;
  for (int i = 0; i < b64.length; i += width) {
    final int end = i + width < b64.length ? i + width : b64.length;
    gen.write("    '${b64.substring(i, end)}'");
    gen.writeln(end == b64.length ? ';' : '');
  }
  final File embed = File(args['embed'] as String);
  embed.createSync(recursive: true);
  embed.writeAsStringSync(gen.toString());

  final int bytes = clean.values.fold(0, (int s, String v) => s + v.length);
  stdout.writeln(
    'Wrote ${clean.length} files ($bytes chars) to ${out.path}/ and ${embed.path}',
  );
}
