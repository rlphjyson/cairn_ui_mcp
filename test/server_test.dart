import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';
import 'package:dart_mcp/client.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// Talks to the server the way an editor does: over an MCP connection.
void main() {
  late MCPClient client;
  late ServerConnection server;
  late CairnServer cairn;

  setUp(() async {
    final StreamChannelController<String> controller =
        StreamChannelController<String>(sync: true);
    cairn = CairnServer(controller.local);
    client = MCPClient(Implementation(name: 'test client', version: '1.0.0'));
    server = client.connectServer(controller.foreign);
    final InitializeResult init = await server.initialize(
      InitializeRequest(
        protocolVersion: ProtocolVersion.latestSupported,
        capabilities: client.capabilities,
        clientInfo: client.implementation,
      ),
    );
    expect(init.serverInfo.name, 'cairn-ui');
    expect(init.capabilities.tools, isNotNull);
    expect(init.capabilities.resources, isNotNull);
    expect(init.capabilities.prompts, isNotNull);
    expect(init.instructions, contains('Cairn UI'));
    server.notifyInitialized();
  });

  tearDown(() async {
    await client.shutdown();
  });

  Future<CallToolResult> callRaw(String tool, Map<String, Object?> args) =>
      server.callTool(CallToolRequest(name: tool, arguments: args));

  Future<String> call(
    String tool, [
    Map<String, Object?> args = const <String, Object?>{},
  ]) async {
    final CallToolResult r = await callRaw(tool, args);
    return r.content
        .whereType<TextContent>()
        .map((TextContent t) => t.text)
        .join('\n');
  }

  group('tools', () {
    test('lists every tool with a description and a read-only hint', () async {
      final ListToolsResult r = await server.listTools(ListToolsRequest());
      final List<String> names = r.tools.map((Tool t) => t.name).toList();
      expect(
        names,
        containsAll(<String>[
          'cairn_overview',
          'list_components',
          'search_components',
          'get_component',
          'get_tokens',
          'get_theme',
          'list_blocks',
          'get_block',
          'list_templates',
          'get_template',
          'get_docs',
        ]),
      );
      for (final Tool t in r.tools) {
        expect(t.description, isNotEmpty, reason: t.name);
        expect(
          (((t as Map<String, Object?>)['annotations']!)
              as Map<String, Object?>)['readOnlyHint'],
          isTrue,
          reason: t.name,
        );
      }
    });

    test('cairn_overview orients the assistant', () async {
      final String md = await call('cairn_overview');
      expect(md, contains('# Cairn UI 0.2.0'));
      expect(md, contains('cairn_ui: ^0.2.0'));
      expect(md, contains('get_component'));
    });

    test('list_components filters by category', () async {
      final String all = await call('list_components');
      final String overlays = await call('list_components', <String, Object?>{
        'category': 'overlays',
      });
      expect(all, contains('`CairnButton`'));
      expect(overlays, contains('Dialog'));
      expect(overlays, isNot(contains('`CairnButton`')));
      expect(overlays.length, lessThan(all.length));
    });

    test('search_components finds a component from plain words', () async {
      final String md = await call('search_components', <String, Object?>{
        'query': 'confirm before deleting',
      });
      expect(md, contains('Alert Dialog'));
      expect(md, contains('```dart'));
    });

    test('search_components says so when nothing matches', () async {
      final String md = await call('search_components', <String, Object?>{
        'query': 'zzzzqqq',
      });
      expect(md, contains('No component matches'));
    });

    test('get_component returns the exact API', () async {
      final String md = await call('get_component', <String, Object?>{
        'name': 'Button',
      });
      expect(md, contains('CairnButton'));
      expect(md, contains('CairnButtonVariant'));
      expect(md, contains('semanticLabel'));
    });

    test('get_component honours sections', () async {
      final String md = await call('get_component', <String, Object?>{
        'name': 'card',
        'sections': <String>['quick_start'],
      });
      expect(md, contains('## Quick start'));
      expect(md, isNot(contains('## API')));
    });

    test('get_component reports an unknown name', () async {
      final CallToolResult r = await callRaw('get_component', <String, Object?>{
        'name': 'Buton',
      });
      expect(r.isError, isTrue);
      expect(
        (r.content.first as TextContent).text,
        contains('No component named'),
      );
    });

    test('get_tokens by group and for everything', () async {
      expect(
        await call('get_tokens', <String, Object?>{'group': 'radius'}),
        contains('CairnRadius'),
      );
      expect(
        await call('get_tokens', <String, Object?>{'group': 'spacing'}),
        contains('s4'),
      );
      final String all = await call('get_tokens');
      expect(all, contains('CairnColors'));
      expect(all, contains('CairnTypography'));
      expect(
        await call('get_tokens', <String, Object?>{'group': 'bogus'}),
        contains('No token group'),
      );
    });

    test('get_theme explains CairnTheme', () async {
      final String md = await call('get_theme');
      expect(md, contains('CairnTheme'));
      expect(md, contains('copyWith'));
    });

    test('blocks, templates and docs', () async {
      expect(await call('list_blocks'), contains('Login'));
      expect(
        await call('get_block', <String, Object?>{'name': 'login'}),
        contains('CairnCard'),
      );
      expect(await call('list_templates'), contains('E-commerce'));
      expect(
        await call('get_template', <String, Object?>{'name': 'blog'}),
        contains('BlogApp()'),
      );
      expect(await call('get_docs'), contains('theming'));
      expect(
        await call('get_docs', <String, Object?>{'page': 'theming'}),
        contains('CairnTheme'),
      );
      expect(
        (await callRaw('get_block', <String, Object?>{'name': 'zzz'})).isError,
        isTrue,
      );
      expect(
        (await callRaw('get_template', <String, Object?>{
          'name': 'zzz',
        })).isError,
        isTrue,
      );
      expect(
        (await callRaw('get_docs', <String, Object?>{'page': 'zzz'})).isError,
        isTrue,
      );
    });

    test('missing required arguments are errors, not crashes', () async {
      expect(
        (await callRaw('get_component', <String, Object?>{})).isError,
        isTrue,
      );
      expect(
        (await callRaw('search_components', <String, Object?>{})).isError,
        isTrue,
      );
    });
  });

  group('resources', () {
    Future<String> read(String uri) async {
      final ReadResourceResult r = await server.readResource(
        ReadResourceRequest(uri: uri),
      );
      return (r.contents.first as TextResourceContents).text;
    }

    test('lists the fixed resources and the templates', () async {
      final ListResourcesResult r = await server.listResources(
        ListResourcesRequest(),
      );
      expect(
        r.resources.map((Resource x) => x.uri),
        containsAll(<String>[
          'cairn://overview',
          'cairn://components',
          'cairn://tokens',
          'cairn://theme',
          'cairn://docs',
          'cairn://llms.txt',
          'cairn://llms-full.txt',
        ]),
      );
      final ListResourceTemplatesResult t = await server.listResourceTemplates(
        ListResourceTemplatesRequest(),
      );
      expect(
        t.resourceTemplates.map((ResourceTemplate x) => x.uriTemplate),
        contains('cairn://components/{slug}'),
      );
    });

    test('reads fixed and templated resources', () async {
      expect(await read('cairn://overview'), contains('# Cairn UI'));
      expect(await read('cairn://components/button'), contains('CairnButton'));
      expect(
        await read('cairn://components/Alert%20Dialog'),
        contains('Alert Dialog'),
      );
      expect(await read('cairn://tokens/radius'), contains('CairnRadius'));
      expect(await read('cairn://docs/theming'), contains('CairnTheme'));
      expect(await read('cairn://blocks/login'), contains('CairnCard'));
      expect(await read('cairn://templates/shop'), contains('ShopApp()'));
      expect(await read('cairn://llms.txt'), startsWith('# Cairn UI'));
    });
  });

  group('prompts', () {
    test('lists the prompts and fills their arguments', () async {
      final ListPromptsResult r = await server.listPrompts(
        ListPromptsRequest(),
      );
      expect(
        r.prompts.map((Prompt p) => p.name),
        containsAll(<String>[
          'build_screen',
          'migrate_to_cairn',
          'review_cairn_usage',
        ]),
      );
      final GetPromptResult g = await server.getPrompt(
        GetPromptRequest(
          name: 'build_screen',
          arguments: <String, Object?>{'description': 'a settings page'},
        ),
      );
      final String text = (g.messages.single.content as TextContent).text;
      expect(text, contains('a settings page'));
      expect(text, contains('get_component'));

      final GetPromptResult m = await server.getPrompt(
        GetPromptRequest(
          name: 'migrate_to_cairn',
          arguments: <String, Object?>{
            'code': 'ElevatedButton(onPressed: f, child: Text("x"))',
          },
        ),
      );
      expect(
        (m.messages.single.content as TextContent).text,
        contains('ElevatedButton'),
      );
    });
  });

  test('the server exposes its index', () {
    expect(cairn.index.components, isNotEmpty);
  });
}
