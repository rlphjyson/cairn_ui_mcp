import 'dart:io';

import 'package:args/args.dart';
import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';
import 'package:dart_mcp/stdio.dart';

const String _usage =
    '''
cairn_ui_mcp $serverVersion

A Model Context Protocol server for Cairn UI. Add it to your AI assistant and it
can look up components, tokens, themes, blocks and templates.

Usage: cairn_ui_mcp [options]

By default it speaks MCP over stdio, which is what editors expect.
''';

Future<void> main(List<String> argv) async {
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
    );

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

  if (args['help'] as bool) {
    stdout
      ..writeln(_usage)
      ..writeln(parser.usage);
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
      '${index.blocks.length} blocks, ${index.templates.length} templates.',
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
