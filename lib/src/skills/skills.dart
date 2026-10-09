import 'dart:convert';
import 'dart:io';

import 'skills.g.dart';

/// The agent skills bundled with the package: `skill-name/SKILL.md` plus
/// `skill-name/references/**`.
class Skills {
  Skills._(this.files);

  /// Decodes the skills compiled into the package.
  factory Skills.bundled() => Skills._(
    (jsonDecode(utf8.decode(gzip.decode(base64.decode(skillsBase64))))
            as Map<String, Object?>)
        .map(
          (String k, Object? v) => MapEntry<String, String>(k, v! as String),
        ),
  );

  /// Builds a set from explicit files (used by tests).
  factory Skills.fromFiles(Map<String, String> files) => Skills._(files);

  /// Every file, keyed by path relative to the skills directory.
  final Map<String, String> files;

  /// The skill names, sorted.
  List<String> get names =>
      <String>{for (final String p in files.keys) p.split('/').first}.toList()
        ..sort();

  /// The `description` from a skill's front matter.
  String descriptionOf(String name) {
    final String text = files['$name/SKILL.md'] ?? '';
    final RegExpMatch? m = RegExp(
      r'^description:\s*(.+)$',
      multiLine: true,
    ).firstMatch(text);
    return m?.group(1)?.trim() ?? '';
  }

  /// The files of one skill.
  Map<String, String> filesOf(String name) => <String, String>{
    for (final MapEntry<String, String> e in files.entries)
      if (e.key.startsWith('$name/')) e.key: e.value,
  };
}

/// Where an agent looks for skills.
enum SkillTarget {
  /// `~/.claude/skills`, available in every project.
  claude('claude', 'Claude Code, every project (~/.claude/skills)'),

  /// `./.claude/skills`, for this project only.
  project('project', 'Claude Code, this project only (./.claude/skills)'),

  /// `~/.codex/skills`.
  codex('codex', 'Codex (~/.codex/skills)');

  const SkillTarget(this.id, this.description);

  /// The value of `--target`.
  final String id;

  /// A sentence for `--help`.
  final String description;

  /// The directory for this target.
  Directory directory() {
    final String home =
        Platform.environment['USERPROFILE'] ??
        Platform.environment['HOME'] ??
        '.';
    return switch (this) {
      SkillTarget.claude => Directory('$home/.claude/skills'),
      SkillTarget.project => Directory('.claude/skills'),
      SkillTarget.codex => Directory('$home/.codex/skills'),
    };
  }
}

/// What [installSkills] did with one skill.
class InstalledSkill {
  /// Creates a result.
  InstalledSkill(this.name, this.directory, this.files, this.updated);

  /// The skill name.
  final String name;

  /// Where it was written.
  final Directory directory;

  /// How many files.
  final int files;

  /// Whether an earlier install was replaced.
  final bool updated;
}

/// Marks a skill folder this package wrote, so a later install can replace it
/// without ever touching a skill the user wrote themselves.
const String skillMarker = '.cairn-ui-mcp';

/// Writes the bundled skills under [root].
///
/// A folder that already exists is replaced only if it carries
/// [skillMarker] (this tool wrote it) or [force] is set; otherwise a
/// [FileSystemException] explains how to proceed. Nothing is written if any
/// skill would be refused.
List<InstalledSkill> installSkills(
  Directory root, {
  Set<String>? only,
  bool force = false,
  Skills? skills,
}) {
  final Skills s = skills ?? Skills.bundled();
  final Set<String> unknown = <String>{...?only}..removeAll(s.names);
  if (unknown.isNotEmpty) {
    throw ArgumentError(
      'Unknown skill: ${unknown.join(', ')}. Available: ${s.names.join(', ')}.',
    );
  }
  final List<String> names = <String>[
    for (final String n in s.names)
      if (only == null || only.isEmpty || only.contains(n)) n,
  ];

  for (final String n in names) {
    final Directory d = Directory('${root.path}/$n');
    if (d.existsSync() &&
        !force &&
        !File('${d.path}/$skillMarker').existsSync()) {
      throw FileSystemException(
        'A skill named "$n" already exists and was not installed by '
        'cairn_ui_mcp. Move it, or pass --force to replace it.',
        d.path,
      );
    }
  }

  final List<InstalledSkill> done = <InstalledSkill>[];
  for (final String n in names) {
    final Directory d = Directory('${root.path}/$n');
    final bool existed = d.existsSync();
    if (existed) d.deleteSync(recursive: true);
    final Map<String, String> files = s.filesOf(n);
    for (final MapEntry<String, String> e in files.entries) {
      final File f = File('${root.path}/${e.key}');
      f.createSync(recursive: true);
      f.writeAsStringSync(e.value);
    }
    File('${d.path}/$skillMarker').writeAsStringSync(
      'Installed by cairn_ui_mcp. Reinstall with `cairn_ui_mcp install-skills`.\n',
    );
    done.add(InstalledSkill(n, d, files.length, existed));
  }
  return done;
}
