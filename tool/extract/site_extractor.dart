// ignore_for_file: experimental_member_use
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'ast_util.dart';

/// A call like `Foo(...)`, whether the parser saw it as a method call (no
/// `const`/`new`, unresolved) or as an instance creation.
class _Call {
  _Call(this.name, this.args);
  final String name;
  final ArgumentList args;
}

_Call? _asCall(AstNode n) {
  if (n is InstanceCreationExpression) {
    return _Call(n.constructorName.type.name.lexeme, n.argumentList);
  }
  if (n is MethodInvocation && n.target == null) {
    return _Call(n.methodName.name, n.argumentList);
  }
  return null;
}

class _CallCollector extends RecursiveAstVisitor<void> {
  _CallCollector(this.names);
  final Set<String> names;
  final List<_Call> calls = <_Call>[];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final _Call? c = _asCall(node);
    if (c != null && names.contains(c.name)) calls.add(c);
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final _Call? c = _asCall(node);
    if (c != null && names.contains(c.name)) calls.add(c);
    super.visitMethodInvocation(node);
  }
}

List<_Call> _callsIn(AstNode node, Set<String> names) {
  final _CallCollector v = _CallCollector(names);
  node.accept(v);
  return v.calls;
}

/// Reads the Cairn site's catalogues: component quick starts and variant
/// snippets, documentation pages, blocks and templates.
class SiteExtractor {
  SiteExtractor(this.root);

  /// The cairn_site checkout.
  final Directory root;

  CompilationUnit _parse(String relative) => parseString(
    content: File('${root.path}/$relative').readAsStringSync(),
    throwIfDiagnostics: false,
  ).unit;

  /// `Previews.xxx` and `ExtendedPreviews.xxx` -> their variant snippets.
  Map<String, List<Map<String, Object?>>> _previewSamples() {
    final Map<String, List<Map<String, Object?>>> out =
        <String, List<Map<String, Object?>>>{};
    for (final (String file, String cls) in <(String, String)>[
      ('lib/src/data/component_previews.dart', 'Previews'),
      ('lib/src/data/extended_previews.dart', 'ExtendedPreviews'),
    ]) {
      final CompilationUnit unit = _parse(file);
      for (final CompilationUnitMember d in unit.declarations) {
        if (d is! ClassDeclaration || d.namePart.typeName.lexeme != cls) {
          continue;
        }
        final ClassBody body = d.body;
        if (body is! BlockClassBody) continue;
        for (final ClassMember m in body.members) {
          if (m is! MethodDeclaration || !m.isStatic) continue;
          final List<Map<String, Object?>> samples = <Map<String, Object?>>[];
          for (final _Call c in _callsIn(m, <String>{'VariantSample'})) {
            final String? label = stringValue(namedArg(c.args, 'label'));
            final String? code = stringValue(namedArg(c.args, 'code'));
            if (label == null || code == null) continue;
            // Samples generated in a loop carry `${...}`; they are not a
            // single copyable snippet, so they are left out.
            if (label.contains(r'${') || code.contains(r'${effect')) continue;
            samples.add(<String, Object?>{'label': label, 'code': code});
          }
          out['$cls.${m.name.lexeme}'] = samples;
        }
      }
    }
    return out;
  }

  /// Every component card.
  List<Map<String, Object?>> componentEntries() {
    final Map<String, List<Map<String, Object?>>> previews = _previewSamples();
    final CompilationUnit unit = _parse('lib/src/data/components_catalog.dart');
    final List<Map<String, Object?>> out = <Map<String, Object?>>[];
    for (final _Call c in _callsIn(unit, <String>{'ComponentEntry'})) {
      final String? slug = stringValue(namedArg(c.args, 'slug'));
      if (slug == null) continue;
      final Expression? preview = namedArg(c.args, 'preview');
      final String? previewKey = preview?.toSource();
      out.add(<String, Object?>{
        'slug': slug,
        'name': stringValue(namedArg(c.args, 'name')),
        'category': tailName(namedArg(c.args, 'category')),
        'description': stringValue(namedArg(c.args, 'description')),
        'note': stringValue(namedArg(c.args, 'note')),
        'alsoExports': stringList(namedArg(c.args, 'alsoExports')),
        'livesIn': stringValue(namedArg(c.args, 'livesIn')),
        'quickStart': stringValue(namedArg(c.args, 'code')),
        'variants': previews[previewKey] ?? const <Object?>[],
      });
    }
    return out;
  }

  /// Documentation pages, as Markdown.
  List<Map<String, Object?>> docPages() {
    final CompilationUnit unit = _parse('lib/src/data/docs_catalog.dart');
    final List<Map<String, Object?>> out = <Map<String, Object?>>[];
    for (final _Call page in _callsIn(unit, <String>{'DocPage'})) {
      final String? slug = stringValue(namedArg(page.args, 'slug'));
      final Expression? nodes = namedArg(page.args, 'nodes');
      if (slug == null || nodes is! ListLiteral) continue;
      final StringBuffer md = StringBuffer();
      for (final CollectionElement el in nodes.elements) {
        if (el is! Expression) continue;
        final _Call? n = _asCall(el);
        if (n == null) continue;
        final List<Expression> pos = positionalArgs(n.args);
        switch (n.name) {
          case 'DocHeading':
            final String t = stringValue(pos.first) ?? '';
            final Expression? lv = namedArg(n.args, 'level');
            final int level = lv is IntegerLiteral ? lv.value ?? 2 : 2;
            md.writeln('\n${'#' * (level + 1)} $t\n');
          case 'DocParagraph':
            md.writeln('${stringValue(pos.first) ?? ''}\n');
          case 'DocCode':
            final String code = stringValue(pos.first) ?? '';
            final String lang =
                tailName(namedArg(n.args, 'language')) ?? 'dart';
            final String? file = stringValue(namedArg(n.args, 'filename'));
            if (file != null) md.writeln('`$file`');
            md.writeln('```$lang\n$code\n```\n');
          case 'DocList':
            final Expression? ord = namedArg(n.args, 'ordered');
            final bool ordered = ord is BooleanLiteral && ord.value;
            final List<String> items = stringList(pos.first);
            for (int i = 0; i < items.length; i++) {
              md.writeln('${ordered ? '${i + 1}.' : '-'} ${items[i]}');
            }
            md.writeln();
          case 'DocCallout':
            md.writeln(
              '> **${stringValue(namedArg(n.args, 'title')) ?? ''}** '
              '${stringValue(namedArg(n.args, 'body')) ?? ''}\n',
            );
          case 'DocTable':
            final List<String> headers = stringList(
              namedArg(n.args, 'headers'),
            );
            final Expression? rows = namedArg(n.args, 'rows');
            md.writeln('| ${headers.join(' | ')} |');
            md.writeln('| ${headers.map((_) => '---').join(' | ')} |');
            if (rows is ListLiteral) {
              for (final CollectionElement r in rows.elements) {
                if (r is Expression) {
                  md.writeln(
                    '| ${stringList(r).map((c) => c.replaceAll('|', r'\|')).join(' | ')} |',
                  );
                }
              }
            }
            md.writeln();
        }
      }
      out.add(<String, Object?>{
        'slug': slug,
        'title': stringValue(namedArg(page.args, 'title')),
        'group': stringValue(namedArg(page.args, 'group')),
        'summary': stringValue(namedArg(page.args, 'summary')),
        'markdown': md.toString().trim(),
      });
    }
    return out;
  }

  /// Composed screens.
  List<Map<String, Object?>> blocks() {
    final CompilationUnit unit = _parse('lib/src/data/blocks_catalog.dart');
    return <Map<String, Object?>>[
      for (final _Call c in _callsIn(unit, <String>{'BlockEntry'}))
        if (stringValue(namedArg(c.args, 'slug')) != null)
          <String, Object?>{
            'slug': stringValue(namedArg(c.args, 'slug')),
            'name': stringValue(namedArg(c.args, 'name')),
            'description': stringValue(namedArg(c.args, 'description')),
            'uses': stringList(namedArg(c.args, 'uses')),
            'code': stringValue(namedArg(c.args, 'code')),
          },
    ];
  }

  /// Whole-app templates.
  List<Map<String, Object?>> templates() {
    final CompilationUnit unit = _parse('lib/src/data/templates_catalog.dart');
    final List<Map<String, Object?>> out = <Map<String, Object?>>[];
    for (final _Call c in _callsIn(unit, <String>{'TemplateEntry'})) {
      final String? slug = stringValue(namedArg(c.args, 'slug'));
      if (slug == null) continue;
      final Expression? screens = namedArg(c.args, 'screens');
      final List<Map<String, String>> screenList = <Map<String, String>>[];
      if (screens is ListLiteral) {
        for (final CollectionElement el in screens.elements) {
          if (el is RecordLiteral && el.fields.length == 2) {
            screenList.add(<String, String>{
              'name': stringValue(el.fields[0].fieldExpression2) ?? '',
              'what': stringValue(el.fields[1].fieldExpression2) ?? '',
            });
          }
        }
      }
      out.add(<String, Object?>{
        'slug': slug,
        'name': stringValue(namedArg(c.args, 'name')),
        'kind': tailName(namedArg(c.args, 'kind')),
        'summary': stringValue(namedArg(c.args, 'summary')),
        'description': stringValue(namedArg(c.args, 'description')),
        'screens': screenList,
        'uses': stringList(namedArg(c.args, 'uses')),
      });
    }
    return out;
  }
}
