import 'package:cairn_ui_mcp/cairn_ui_mcp.dart';
import 'package:test/test.dart';

void main() {
  final CairnIndex index = CairnIndex.bundled();
  final Renderer renderer = Renderer(index);

  group('index', () {
    test('covers every component the library ships', () {
      expect(index.cairnUiVersion, '0.2.0');
      expect(index.modules, hasLength(65));
      expect(index.components.length, greaterThanOrEqualTo(70));
      expect(index.docs, isNotEmpty);
      expect(index.blocks, hasLength(5));
      expect(index.templates, hasLength(5));
    });

    test('every component has a description, an API and a quick start', () {
      for (final Component c in index.components) {
        expect(c.description, isNotEmpty, reason: c.slug);
        expect(c.quickStart, contains('Cairn'), reason: c.slug);
        expect(c.module, isNotNull, reason: '${c.slug} matched no module');
        expect(c.widgetNames, isNotEmpty, reason: c.slug);
      }
    });

    test('finds components by name, slug and class', () {
      expect(index.findComponent('Button')?.slug, 'button');
      expect(index.findComponent('alert-dialog')?.name, 'Alert Dialog');
      expect(index.findComponent('Alert Dialog')?.slug, 'alert-dialog');
      expect(index.findComponent('CairnAlertDialog')?.slug, 'alert-dialog');
      expect(index.findComponent('cairnbutton')?.slug, 'button');
      expect(index.findComponent('Floating Action Button')?.slug, 'fab');
      expect(index.findComponent('nope'), isNull);
    });

    test('Button exposes its real constructor parameters', () {
      final Component c = index.findComponent('button')!;
      final ApiClass button = c.module!.classes.firstWhere(
        (ApiClass k) => k.name == 'CairnButton',
      );
      expect(button.isWidget, isTrue);
      final ApiConstructor ctor = button.constructors.first;
      final Map<String, ApiParam> params = <String, ApiParam>{
        for (final ApiParam p in ctor.params) p.name: p,
      };
      expect(
        params.keys,
        containsAll(<String>['child', 'onPressed', 'variant', 'size']),
      );
      expect(params['child']!.required, isTrue);
      expect(params['onPressed']!.type, 'VoidCallback?');
      expect(params['variant']!.defaultValue, contains('primary'));
      expect(params['onPressed']!.doc, isNotEmpty);
      expect(
        button.constructors.map((ApiConstructor k) => k.name),
        contains('icon'),
      );
      expect(
        c.module!.enums
            .firstWhere((ApiEnum e) => e.name == 'CairnButtonVariant')
            .values
            .map((EnumValue v) => v.name),
        containsAll(<String>['primary', 'destructive', 'outline', 'ghost']),
      );
    });

    test('helper functions are indexed', () {
      final Component d = index.findComponent('dialog')!;
      expect(
        d.module!.functions.map((ApiFunction f) => f.name),
        contains('showCairnDialog'),
      );
    });

    test('tokens come with values and docs', () {
      expect(
        index.tokenGroups,
        containsAll(<String>[
          'colors',
          'radius',
          'spacing',
          'typography',
          'theme',
        ]),
      );
      final ApiClass radius = index.tokenGroup('radius').first;
      expect(
        radius.statics.any((ApiMember m) => m.name == 'md' && m.value == '8.0'),
        isTrue,
      );
      final ApiClass colors = index.tokenGroup('colors').first;
      expect(
        colors.statics.where((ApiMember m) => m.name == 'lightBackground'),
        isNotEmpty,
      );
    });

    test('templates, blocks and docs resolve', () {
      expect(index.findTemplate('shop')?.name, 'E-commerce');
      expect(index.findTemplate('SaaS landing')?.slug, 'landing');
      expect(index.findBlock('login')?.code, contains('CairnCard'));
      expect(index.findDoc('theming')?.markdown, contains('CairnTheme'));
    });
  });

  group('search', () {
    String top(String q) => searchComponents(index, q).first.component.slug;

    test('plain-language needs find the right component', () {
      expect(
        top('confirm before deleting something'),
        anyOf('alert-dialog', 'dialog'),
      );
      expect(top('bottom navigation bar for a phone app'), 'dock');
      expect(
        top('show a loading state'),
        anyOf('spinner', 'skeleton', 'progress'),
      );
      expect(top('pick a date'), anyOf('date-picker', 'calendar'));
      expect(top('toast'), 'toast');
      expect(top('star rating'), 'rating');
      expect(top('modal'), anyOf('dialog', 'alert-dialog', 'sheet'));
      expect(top('data table with sorting'), 'data-table');
      expect(top('step indicator for checkout'), 'steps');
    });

    test('an empty or stop-word query returns nothing', () {
      expect(searchComponents(index, ''), isEmpty);
      expect(searchComponents(index, 'the a to'), isEmpty);
      expect(searchComponents(index, 'zzzzqqq'), isEmpty);
    });

    test('respects the limit', () {
      expect(
        searchComponents(index, 'button input card', limit: 3),
        hasLength(3),
      );
    });
  });

  group('rendering', () {
    test('a component page has an import, a quick start and an API', () {
      final String md = renderer.component(index.findComponent('button')!);
      expect(md, contains("import 'package:cairn_ui/cairn_ui.dart';"));
      expect(md, contains('## Quick start'));
      expect(md, contains('## Variants and examples'));
      expect(md, contains('`CairnButton`'));
      expect(md, contains('| `onPressed` |'));
      expect(md, contains('CairnButtonVariant.outline'));
    });

    test('sections can be limited', () {
      final String md = renderer.component(
        index.findComponent('button')!,
        variants: false,
        api: false,
      );
      expect(md, contains('## Quick start'));
      expect(md, isNot(contains('## API')));
      expect(md, isNot(contains('## Variants')));
    });

    test('the template page shows how to mount it', () {
      final String md = renderer.template(index.findTemplate('dashboard')!);
      expect(md, contains('cairn_template_dashboard'));
      expect(md, contains('DashboardApp()'));
    });

    test('llms.txt lists every component and guide', () {
      final String txt = renderer.llmsTxt();
      for (final Component c in index.components) {
        expect(txt, contains('/components/${c.slug}'));
      }
      expect(txt, startsWith('# Cairn UI'));
    });

    test('llms-full.txt is self-contained', () {
      final String full = renderer.llmsFull();
      expect(full, contains('# Button'));
      expect(full, contains('# Design tokens'));
      expect(full.length, greaterThan(100000));
    });
  });
}
