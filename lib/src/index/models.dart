/// Typed views over the generated knowledge index.
library;

typedef Json = Map<String, Object?>;

List<T> _list<T>(Object? v, T Function(Json) f) => <T>[
  for (final Object? e in (v as List<Object?>? ?? const <Object?>[]))
    f(e! as Json),
];

String _s(Object? v) => (v as String?) ?? '';

/// One constructor or function parameter.
class ApiParam {
  ApiParam(Json j)
    : name = _s(j['name']),
      type = _s(j['type']),
      required = j['required'] == true,
      named = j['named'] == true,
      defaultValue = j['default'] as String?,
      doc = _s(j['doc']);

  final String name;
  final String type;
  final bool required;
  final bool named;
  final String? defaultValue;
  final String doc;

  /// `required Widget child`, `VoidCallback? onPressed`, `size = md`.
  String get signature {
    final StringBuffer b = StringBuffer();
    if (required && named) b.write('required ');
    b.write('$type $name');
    if (defaultValue != null) b.write(' = $defaultValue');
    return b.toString();
  }
}

/// A constructor.
class ApiConstructor {
  ApiConstructor(Json j)
    : name = _s(j['name']),
      isFactory = j['factory'] == true,
      doc = _s(j['doc']),
      params = _list(j['params'], ApiParam.new);

  final String name;
  final bool isFactory;
  final String doc;
  final List<ApiParam> params;
}

/// A static member or documented method.
class ApiMember {
  ApiMember(Json j)
    : name = _s(j['name']),
      kind = _s(j['kind']),
      type = _s(j['type']),
      doc = _s(j['doc']),
      value = j['value'] as String?,
      signature = j['signature'] as String?;

  final String name;
  final String kind;
  final String type;
  final String doc;
  final String? value;
  final String? signature;
}

/// A public class: a widget, a token table, a theme.
class ApiClass {
  ApiClass(Json j)
    : name = _s(j['name']),
      kind = _s(j['kind']),
      extendsName = _s(j['extends']),
      doc = _s(j['doc']),
      constructors = _list(j['constructors'], ApiConstructor.new),
      statics = _list(j['statics'], ApiMember.new),
      members = _list(j['members'], ApiMember.new),
      fields = _list(j['fields'], ApiParam.new);

  final String name;

  /// `widget` or `class`.
  final String kind;
  final String extendsName;
  final String doc;
  final List<ApiConstructor> constructors;
  final List<ApiMember> statics;
  final List<ApiMember> members;
  final List<ApiParam> fields;

  bool get isWidget => kind == 'widget';
}

/// An enum value.
class EnumValue {
  EnumValue(Json j) : name = _s(j['name']), doc = _s(j['doc']);
  final String name;
  final String doc;
}

/// A public enum.
class ApiEnum {
  ApiEnum(Json j)
    : name = _s(j['name']),
      doc = _s(j['doc']),
      values = _list(j['values'], EnumValue.new);
  final String name;
  final String doc;
  final List<EnumValue> values;
}

/// A public top-level function such as `showCairnDialog`.
class ApiFunction {
  ApiFunction(Json j)
    : name = _s(j['name']),
      doc = _s(j['doc']),
      returns = _s(j['returns']),
      params = _list(j['params'], ApiParam.new);
  final String name;
  final String doc;
  final String returns;
  final List<ApiParam> params;
}

/// One directory under `lib/src/components`.
class ApiModule {
  ApiModule(Json j)
    : name = _s(j['module']),
      classes = _list(j['classes'], ApiClass.new),
      enums = _list(j['enums'], ApiEnum.new),
      functions = _list(j['functions'], ApiFunction.new);
  final String name;
  final List<ApiClass> classes;
  final List<ApiEnum> enums;
  final List<ApiFunction> functions;
}

/// A copy-pasteable example.
class Variant {
  Variant(Json j) : label = _s(j['label']), code = _s(j['code']);
  final String label;
  final String code;
}

/// A component as the site catalogue describes it, joined to its API.
class Component {
  Component(Json j, this.module)
    : slug = _s(j['slug']),
      name = _s(j['name']),
      category = _s(j['category']),
      description = _s(j['description']),
      note = j['note'] as String?,
      alsoExports = <String>[
        for (final Object? e
            in (j['alsoExports'] as List<Object?>? ?? const <Object?>[]))
          e! as String,
      ],
      livesIn = j['livesIn'] as String?,
      quickStart = _s(j['quickStart']),
      variants = _list(j['variants'], Variant.new);

  final String slug;
  final String name;
  final String category;
  final String description;
  final String? note;
  final List<String> alsoExports;
  final String? livesIn;
  final String quickStart;
  final List<Variant> variants;

  /// The cairn_ui module that implements it, when it could be matched.
  final ApiModule? module;

  /// `Forms`, `Display`, ...
  String get categoryLabel => switch (category) {
    'forms' => 'Forms',
    'display' => 'Display',
    'overlays' => 'Overlays',
    'navigation' => 'Navigation',
    'data' => 'Data & feedback',
    _ => category,
  };

  /// Every public widget class name this component involves.
  List<String> get widgetNames => <String>[
    if (module != null)
      for (final ApiClass c in module!.classes)
        if (c.isWidget) c.name,
    ...alsoExports,
  ];
}

/// A documentation page.
class DocPage {
  DocPage(Json j)
    : slug = _s(j['slug']),
      title = _s(j['title']),
      group = _s(j['group']),
      summary = _s(j['summary']),
      markdown = _s(j['markdown']);
  final String slug;
  final String title;
  final String group;
  final String summary;
  final String markdown;
}

/// A composed screen.
class Block {
  Block(Json j)
    : slug = _s(j['slug']),
      name = _s(j['name']),
      description = _s(j['description']),
      uses = <String>[
        for (final Object? e
            in (j['uses'] as List<Object?>? ?? const <Object?>[]))
          e! as String,
      ],
      code = _s(j['code']);
  final String slug;
  final String name;
  final String description;
  final List<String> uses;
  final String code;
}

/// A whole-app template.
class Template {
  Template(Json j)
    : slug = _s(j['slug']),
      name = _s(j['name']),
      kind = _s(j['kind']),
      summary = _s(j['summary']),
      description = _s(j['description']),
      screens = <(String, String)>[
        for (final Object? e
            in (j['screens'] as List<Object?>? ?? const <Object?>[]))
          (_s((e! as Json)['name']), _s((e as Json)['what'])),
      ],
      uses = <String>[
        for (final Object? e
            in (j['uses'] as List<Object?>? ?? const <Object?>[]))
          e! as String,
      ];
  final String slug;
  final String name;
  final String kind;
  final String summary;
  final String description;
  final List<(String, String)> screens;
  final List<String> uses;
}
