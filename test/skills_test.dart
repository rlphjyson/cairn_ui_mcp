import 'dart:io';

import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';
import 'package:test/test.dart';

void main() {
  final Skills skills = Skills.bundled();
  final CairnIndex index = CairnIndex.bundled();

  group('bundled skills', () {
    test('there are the four skills, each with a SKILL.md', () {
      expect(skills.names, <String>[
        'cairn-charts',
        'cairn-dashboard',
        'cairn-templates',
        'cairn-ui',
      ]);
      for (final String n in skills.names) {
        expect(skills.files, contains('$n/SKILL.md'));
      }
    });

    test('front matter has a name matching the folder and a description', () {
      for (final String n in skills.names) {
        final String text = skills.files['$n/SKILL.md']!;
        expect(text, startsWith('---\n'), reason: n);
        final RegExpMatch? name = RegExp(
          r'^name:\s*(\S+)$',
          multiLine: true,
        ).firstMatch(text);
        expect(name?.group(1), n);
        final String d = skills.descriptionOf(n);
        expect(d.length, inInclusiveRange(80, 1024), reason: '$n description');
        expect(d, contains('Use when'), reason: n);
      }
    });

    test('every referenced file exists', () {
      for (final String n in skills.names) {
        final String text = skills.files['$n/SKILL.md']!;
        for (final RegExpMatch m in RegExp(
          r'`(references/[^`\s]+)`',
        ).allMatches(text)) {
          final String path = m.group(1)!;
          if (path.endsWith('/') || path.contains('<')) continue;
          expect(skills.files, contains('$n/$path'), reason: '$n -> $path');
        }
      }
    });

    test('the API files cover every component in their category', () {
      for (final Component c in index.components) {
        final String file = 'cairn-ui/references/api-${c.category}.md';
        expect(skills.files[file], contains('# ${c.name}'), reason: c.slug);
      }
      final String text = skills.files['cairn-ui/SKILL.md']!;
      expect(text, isNot(contains('{{')));
      for (final String cat in <String>[
        'forms',
        'display',
        'overlays',
        'navigation',
        'data',
      ]) {
        expect(text, contains('references/api-$cat.md'));
      }
    });

    test('references hold the real API', () {
      final String forms = skills.files['cairn-ui/references/api-forms.md']!;
      expect(forms, contains('CairnButton'));
      expect(forms, contains('| `onPressed` |'));
      expect(
        skills.files['cairn-ui/references/tokens.md'],
        contains('CairnSpacing'),
      );
      expect(
        skills.files['cairn-ui/references/theming.md'],
        contains('copyWith'),
      );
      expect(
        skills.files,
        contains('cairn-ui/references/guides/accessibility.md'),
      );
      expect(
        skills.files['cairn-ui/references/blocks.md'],
        contains('CairnCard'),
      );
    });

    test('chart skill ships the adapter and the recipes', () {
      expect(
        skills.files['cairn-charts/references/chart_theme.dart'],
        contains('class ChartTheme'),
      );
      for (final String r in <String>[
        'revenue_chart',
        'visits_line',
        'device_bars',
        'traffic_donut',
        'conversion_gauge',
        'helpers',
      ]) {
        expect(skills.files, contains('cairn-charts/references/recipes/$r.md'));
      }
    });

    test('template skill lists every template', () {
      for (final Template t in index.templates) {
        expect(
          skills.files,
          contains('cairn-templates/references/templates/${t.slug}.md'),
        );
      }
    });

    test('no skill text names other component libraries', () {
      final RegExp foreign = RegExp(
        'sha${'dc'}n|dai${'s'}y',
        caseSensitive: false,
      );
      for (final MapEntry<String, String> e in skills.files.entries) {
        expect(foreign.hasMatch(e.value), isFalse, reason: e.key);
      }
    });

    test('the SKILL.md files are small enough to load whole', () {
      for (final String n in skills.names) {
        expect(
          skills.files['$n/SKILL.md']!.split('\n').length,
          lessThan(500),
          reason: n,
        );
      }
    });
  });

  group('installSkills', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('cairn_skills_'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('writes every skill with its references and a marker', () {
      final List<InstalledSkill> done = installSkills(dir, skills: skills);
      expect(done, hasLength(4));
      expect(File('${dir.path}/cairn-ui/SKILL.md').existsSync(), isTrue);
      expect(
        File('${dir.path}/cairn-ui/references/api-forms.md').existsSync(),
        isTrue,
      );
      expect(File('${dir.path}/cairn-ui/$skillMarker').existsSync(), isTrue);
      expect(done.every((InstalledSkill s) => !s.updated), isTrue);
    });

    test('can install a subset', () {
      installSkills(dir, skills: skills, only: <String>{'cairn-charts'});
      expect(Directory('${dir.path}/cairn-charts').existsSync(), isTrue);
      expect(Directory('${dir.path}/cairn-ui').existsSync(), isFalse);
    });

    test('rejects an unknown skill name', () {
      expect(
        () => installSkills(dir, skills: skills, only: <String>{'nope'}),
        throwsArgumentError,
      );
    });

    test('reinstalling updates our own files and removes stale ones', () {
      installSkills(dir, skills: skills);
      File('${dir.path}/cairn-ui/references/stale.md').writeAsStringSync('x');
      final List<InstalledSkill> again = installSkills(dir, skills: skills);
      expect(again.every((InstalledSkill s) => s.updated), isTrue);
      expect(
        File('${dir.path}/cairn-ui/references/stale.md').existsSync(),
        isFalse,
      );
    });

    test('never overwrites a skill the user wrote', () {
      Directory('${dir.path}/cairn-ui').createSync(recursive: true);
      File('${dir.path}/cairn-ui/SKILL.md').writeAsStringSync('mine');
      expect(
        () => installSkills(dir, skills: skills),
        throwsA(isA<FileSystemException>()),
      );
      expect(File('${dir.path}/cairn-ui/SKILL.md').readAsStringSync(), 'mine');
      // Nothing else was installed either.
      expect(Directory('${dir.path}/cairn-charts').existsSync(), isFalse);

      installSkills(dir, skills: skills, force: true);
      expect(
        File('${dir.path}/cairn-ui/SKILL.md').readAsStringSync(),
        contains('name: cairn-ui'),
      );
    });
  });
}
