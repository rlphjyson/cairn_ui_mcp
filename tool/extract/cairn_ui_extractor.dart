import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'ast_util.dart';

/// Reads the public API of a cairn_ui checkout straight from its source, so the
/// MCP server never describes a parameter that does not exist.
class CairnUiExtractor {
  CairnUiExtractor(this.root);

  /// The cairn_ui package root.
  final Directory root;

  CompilationUnit _parse(File f) => parseString(
    content: f.readAsStringSync(),
    throwIfDiagnostics: false,
  ).unit;

  /// The pubspec version.
  String version() {
    final String pubspec = File('${root.path}/pubspec.yaml').readAsStringSync();
    return RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1)!;
  }

  /// Names the barrel `lib/cairn_ui.dart` makes public. A name that is not in
  /// here is an implementation detail and is left out.
  Set<String> exportedNames() {
    final CompilationUnit unit = _parse(File('${root.path}/lib/cairn_ui.dart'));
    final Set<String> shown = <String>{};
    final Set<String> files = <String>{};
    for (final Directive d in unit.directives) {
      if (d is ExportDirective) {
        final String uri = d.uri.stringValue ?? '';
        files.add(uri);
        for (final Combinator c in d.combinators) {
          if (c is ShowCombinator) {
            shown.addAll(c.shownNames.map((n) => n.name));
          }
        }
      }
    }
    return <String>{...shown, ...files.map((f) => '@$f')};
  }

  /// Every `lib/src/components/<module>` as JSON.
  List<Map<String, Object?>> components() {
    final Directory dir = Directory('${root.path}/lib/src/components');
    final List<Directory> modules =
        dir.listSync().whereType<Directory>().toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    return <Map<String, Object?>>[
      for (final Directory m in modules) _module(m),
    ];
  }

  Map<String, Object?> _module(Directory dir) {
    final String name = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final List<Map<String, Object?>> classes = <Map<String, Object?>>[];
    final List<Map<String, Object?>> enums = <Map<String, Object?>>[];
    final List<Map<String, Object?>> functions = <Map<String, Object?>>[];
    final List<File> files =
        dir
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final File f in files) {
      final CompilationUnit unit = _parse(f);
      for (final CompilationUnitMember d in unit.declarations) {
        if (d is ClassDeclaration &&
            !d.namePart.typeName.lexeme.startsWith('_')) {
          classes.add(_class(d));
        } else if (d is EnumDeclaration &&
            !d.namePart.typeName.lexeme.startsWith('_')) {
          enums.add(_enum(d));
        } else if (d is FunctionDeclaration && !d.name.lexeme.startsWith('_')) {
          functions.add(_function(d));
        } else if (d is FunctionTypeAlias || d is GenericTypeAlias) {
          // Typedefs are described by the members that use them.
        }
      }
    }
    return <String, Object?>{
      'module': name,
      'classes': classes,
      'enums': enums,
      'functions': functions,
    };
  }

  Map<String, Object?> _class(ClassDeclaration d) {
    final String name = d.namePart.typeName.lexeme;
    final BlockClassBody? body = d.body is BlockClassBody
        ? d.body as BlockClassBody
        : null;
    final List<ClassMember> members = body?.members ?? const <ClassMember>[];

    final Map<String, ({String type, String doc})> fields =
        <String, ({String type, String doc})>{};
    final List<Map<String, Object?>> statics = <Map<String, Object?>>[];
    for (final ClassMember m in members) {
      if (m is FieldDeclaration) {
        final String type = m.fields.type?.toSource() ?? 'dynamic';
        for (final VariableDeclaration v in m.fields.variables) {
          final String n = v.name.lexeme;
          if (n.startsWith('_')) continue;
          if (m.isStatic) {
            statics.add(<String, Object?>{
              'name': n,
              'kind': m.fields.isConst ? 'const' : 'field',
              'type': type,
              'doc': docOf(m),
              'value': _short(v.initializer?.toSource()),
            });
          } else {
            fields[n] = (type: type, doc: docOf(m));
          }
        }
      }
    }

    final List<Map<String, Object?>> constructors = <Map<String, Object?>>[];
    final List<Map<String, Object?>> methods = <Map<String, Object?>>[];
    for (final ClassMember m in members) {
      if (m is ConstructorDeclaration) {
        final String? ctorName = m.name?.lexeme;
        if (ctorName != null && ctorName.startsWith('_')) continue;
        constructors.add(<String, Object?>{
          'name': ctorName ?? '',
          'factory': m.factoryKeyword != null,
          'doc': docOf(m),
          'params': <Map<String, Object?>>[
            for (final FormalParameter p in m.parameters.parameters)
              if (p.name?.lexeme != 'key') _param(p, fields),
          ],
        });
      } else if (m is MethodDeclaration) {
        final String n = m.name.lexeme;
        if (n.startsWith('_') || m.isOperator) continue;
        if (m.isStatic) {
          statics.add(<String, Object?>{
            'name': n,
            'kind': m.isGetter ? 'getter' : 'method',
            'type': m.returnType?.toSource() ?? 'dynamic',
            'doc': docOf(m),
            'signature': _methodSignature(m),
          });
        } else if (m.isGetter && docOf(m).isNotEmpty) {
          methods.add(<String, Object?>{
            'name': n,
            'kind': 'getter',
            'type': m.returnType?.toSource() ?? 'dynamic',
            'doc': docOf(m),
          });
        } else if (!m.isGetter &&
            !m.isSetter &&
            docOf(m).isNotEmpty &&
            n != 'build' &&
            n != 'createState') {
          methods.add(<String, Object?>{
            'name': n,
            'kind': 'method',
            'type': m.returnType?.toSource() ?? 'dynamic',
            'doc': docOf(m),
            'signature': _methodSignature(m),
          });
        }
      }
    }

    final String extendsName = d.extendsClause?.superclass.toSource() ?? '';
    final bool widget = <String>[
      'StatelessWidget',
      'StatefulWidget',
      'InheritedWidget',
      'InheritedNotifier',
      'ThemeExtension',
    ].any(extendsName.startsWith);
    return <String, Object?>{
      'name': name,
      'kind': widget ? 'widget' : 'class',
      'extends': extendsName,
      'doc': docOf(d),
      'constructors': constructors,
      'statics': statics,
      'members': methods,
      'fields': <Map<String, Object?>>[
        for (final MapEntry<String, ({String type, String doc})> e
            in fields.entries)
          if (e.value.doc.isNotEmpty || true)
            <String, Object?>{
              'name': e.key,
              'type': e.value.type,
              'doc': e.value.doc,
            },
      ],
    };
  }

  Map<String, Object?> _param(
    FormalParameter p,
    Map<String, ({String type, String doc})> fields,
  ) {
    final String name = p.name?.lexeme ?? '';
    String type = 'dynamic';
    if (p is FieldFormalParameter) {
      type = p.type?.toSource() ?? fields[name]?.type ?? 'dynamic';
    } else if (p is SuperFormalParameter) {
      type = p.type?.toSource() ?? 'dynamic';
    } else if (p is RegularFormalParameter) {
      type = p.type?.toSource() ?? 'dynamic';
    } else {
      type = p.toSource();
    }
    return <String, Object?>{
      'name': name,
      'type': type,
      'required': p.isRequiredNamed || p.isRequiredPositional,
      'named': p.isNamed,
      'default': _short(p.defaultClause?.value.toSource()),
      'doc': fields[name]?.doc ?? '',
    };
  }

  Map<String, Object?> _enum(EnumDeclaration d) => <String, Object?>{
    'name': d.namePart.typeName.lexeme,
    'doc': docOf(d),
    'values': <Map<String, Object?>>[
      for (final EnumConstantDeclaration c in d.body.constants)
        <String, Object?>{'name': c.name.lexeme, 'doc': docOf(c)},
    ],
  };

  Map<String, Object?> _function(FunctionDeclaration d) {
    final FunctionExpression fe = d.functionExpression;
    return <String, Object?>{
      'name': d.name.lexeme,
      'doc': docOf(d),
      'returns': d.returnType?.toSource() ?? 'dynamic',
      'params': <Map<String, Object?>>[
        for (final FormalParameter p
            in fe.parameters?.parameters ?? const <FormalParameter>[])
          _param(p, const <String, ({String type, String doc})>{}),
      ],
    };
  }

  String _methodSignature(MethodDeclaration m) {
    final String params = m.parameters?.toSource() ?? '';
    return '${m.returnType?.toSource() ?? 'dynamic'} ${m.name.lexeme}$params';
  }

  String? _short(String? s) {
    if (s == null) return null;
    final String one = s.replaceAll(RegExp(r'\s+'), ' ');
    return one.length > 160 ? '${one.substring(0, 157)}...' : one;
  }

  /// The token files and the theme, as classes with their constants.
  Map<String, List<Map<String, Object?>>> tokens() {
    final Map<String, List<Map<String, Object?>>> out =
        <String, List<Map<String, Object?>>>{};
    final List<File> files =
        <File>[
            ...Directory(
              '${root.path}/lib/src/tokens',
            ).listSync().whereType<File>(),
            ...Directory(
              '${root.path}/lib/src/theme',
            ).listSync().whereType<File>(),
          ].where((f) => f.path.endsWith('.dart')).toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final File f in files) {
      final String stem = f.uri.pathSegments.last.replaceAll('.dart', '');
      final CompilationUnit unit = _parse(f);
      final List<Map<String, Object?>> decls = <Map<String, Object?>>[];
      for (final CompilationUnitMember d in unit.declarations) {
        if (d is ClassDeclaration &&
            !d.namePart.typeName.lexeme.startsWith('_')) {
          decls.add(_class(d));
        } else if (d is EnumDeclaration &&
            !d.namePart.typeName.lexeme.startsWith('_')) {
          decls.add(<String, Object?>{'kind': 'enum', ..._enum(d)});
        }
      }
      out[stem] = decls;
    }
    return out;
  }
}
