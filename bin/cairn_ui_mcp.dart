import 'dart:io';

import 'package:args/args.dart';
import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';
import 'package:dart_mcp/stdio.dart';

const String _usage =
    '''
cairn_ui_mcp $serverVersion

A Model Context Protocol server for Cairn UI, plus agent skills. Add the server
to your AI assistant and it can look up components, tokens, themes, blocks and
templates.

Usage:
  cairn_ui_mcp [options]              run the MCP server over stdio (default)
  cairn_ui_mcp install-skills [...]   install the Cairn agent skills
''';

ArgParser _installParser() => ArgParser()
  ..addOption(
    'target',
    abbr: 't',
    allowed: <String>[for (final SkillTarget t in SkillTarget.values) t.id],
    allowedHelp: <String, String>{
      for (final SkillTarget t in SkillTarget.values) t.id: t.description,
    },
    defaultsTo: 'claude',
    help: 'Where to install.',
  )
  ..addOption('dir', abbr: 'd', help: 'Install into this directory instead.')
  ..addMultiOption(
    'skill',
    abbr: 's',
    help: 'Install only these skills (default: all).',
  )
  ..addFlag('list', negatable: false, help: 'List the skills and exit.')
  ..addFlag(
    'force',
    negatable: false,
    help: 'Replace a skill with the same name that this tool did not install.',
  );

Future<void> main(List<String> argv) async {
  final ArgParser install = _installParser();
  final ArgParser parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.')
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the version.',
    )
    ..addFlag(
      'info',
      negatable: false,
      help: 'Print what the server knows and exit.',
    )
    ..addFlag('llms', negatable: false, help: 'Print llms.txt and exit.')
    ..addFlag(
      'llms-full',
      negatable: false,
      help: 'Print llms-full.txt and exit.',
    )
    ..addCommand('install-skills', install);

  final ArgResults args;
  try {
    args = parser.parse(argv);
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }

  if (args.command?.name == 'install-skills') {
    exitCode = _runInstall(args.command!);
    return;
  }
  if (args['help'] as bool) {
    stdout
      ..writeln(_usage)
      ..writeln(parser.usage)
      ..writeln('\ninstall-skills options:')
      ..writeln(install.usage);
    return;
  }
  if (args['version'] as bool) {
    stdout.writeln(serverVersion);
    return;
  }

  final CairnIndex index = CairnIndex.bundled();
  final Renderer renderer = Renderer(index);
  if (args['info'] as bool) {
    stdout.writeln(
      'cairn_ui_mcp $serverVersion: cairn_ui ${index.cairnUiVersion}, '
      '${index.components.length} components, ${index.docs.length} guides, '
      '${index.blocks.length} blocks, ${index.templates.length} templates, '
      '${Skills.bundled().names.length} skills.',
    );
    return;
  }
  if (args['llms'] as bool) {
    stdout.write(renderer.llmsTxt());
    return;
  }
  if (args['llms-full'] as bool) {
    stdout.write(renderer.llmsFull());
    return;
  }

  // Diagnostics go to stderr: stdout carries the protocol.
  CairnServer(
    stdioChannel(input: stdin, output: stdout),
    index: index,
  );
}

int _runInstall(ArgResults r) {
  final Skills skills = Skills.bundled();
  if (r['list'] as bool) {
    for (final String n in skills.names) {
      stdout.writeln('$n\n  ${skills.descriptionOf(n)}\n');
    }
    return 0;
  }
  final Directory root = r['dir'] != null
      ? Directory(r['dir'] as String)
      : SkillTarget.values
            .firstWhere((SkillTarget t) => t.id == r['target'])
            .directory();
  try {
    final List<InstalledSkill> done = installSkills(
      root,
      only: (r['skill'] as List<String>).toSet(),
      force: r['force'] as bool,
      skills: skills,
    );
    for (final InstalledSkill s in done) {
      stdout.writeln(
        '${s.updated ? 'Updated' : 'Installed'} ${s.name} (${s.files} files) '
        'in ${s.directory.path}',
      );
    }
    stdout.writeln(
      '\nRestart your agent if it was running, then ask it to '
      '"use the cairn-ui skill".',
    );
    return 0;
  } on ArgumentError catch (e) {
    stderr.writeln(e.message);
    return 64;
  } on FileSystemException catch (e) {
    stderr.writeln(e.message);
    return 73;
  }
}
