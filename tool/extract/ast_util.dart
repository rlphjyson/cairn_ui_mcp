// ignore_for_file: experimental_member_use
import 'package:analyzer/dart/ast/ast.dart';

/// Strips the `///` markers from a declaration's doc comment.
String docOf(AnnotatedNode node) {
  final Comment? c = node.documentationComment;
  if (c == null) return '';
  return c.tokens
      .map((t) => t.lexeme.replaceFirst(RegExp(r'^///\s?'), ''))
      .join('\n')
      .trim();
}

/// The text of a string expression: plain, adjacent or interpolated. For an
/// interpolation the `${...}` source is kept verbatim.
String? stringValue(Expression? e) {
  if (e == null) return null;
  if (e is SimpleStringLiteral) return e.value;
  if (e is AdjacentStrings) {
    final StringBuffer b = StringBuffer();
    for (final StringLiteral s in e.strings) {
      final String? v = stringValue(s);
      if (v == null) return null;
      b.write(v);
    }
    return b.toString();
  }
  if (e is StringInterpolation) {
    final StringBuffer b = StringBuffer();
    for (final InterpolationElement el in e.elements) {
      if (el is InterpolationString) {
        b.write(el.value);
      } else if (el is InterpolationExpression) {
        b.write('\${${el.expression.toSource()}}');
      }
    }
    return b.toString();
  }
  if (e is ParenthesizedExpression) return stringValue(e.expression);
  if (e is BinaryExpression && e.operator.lexeme == '+') {
    final String? l = stringValue(e.leftOperand);
    final String? r = stringValue(e.rightOperand);
    return l == null || r == null ? null : l + r;
  }
  return null;
}

/// The named argument [name] of a call, or `null`.
Expression? namedArg(ArgumentList args, String name) {
  for (final Argument a in args.arguments) {
    if (a is NamedArgument && a.name.lexeme == name) {
      return a.argumentExpression2;
    }
  }
  return null;
}

/// The positional arguments of a call.
List<Expression> positionalArgs(ArgumentList args) => <Expression>[
  for (final Argument a in args.arguments)
    if (a is Expression) a,
];

/// The strings in a list literal like `<String>['a', 'b']`.
List<String> stringList(Expression? e) {
  if (e is! ListLiteral) return const <String>[];
  return <String>[
    for (final CollectionElement el in e.elements)
      if (el is Expression)
        if (stringValue(el) case final String s) s,
  ];
}

/// The right-hand identifier of `Foo.bar`, or the identifier itself.
String? tailName(Expression? e) {
  if (e == null) return null;
  return e.toSource().split('.').last;
}
