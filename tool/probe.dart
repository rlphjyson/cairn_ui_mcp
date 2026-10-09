import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

void main() {
  final src = File('C:/Users/USER/projects/cairn_ui/lib/src/components/button/button.dart').readAsStringSync();
  final unit = parseString(content: src, throwIfDiagnostics: false).unit;
  for (final d in unit.declarations) {
    if (d is ClassDeclaration) {
      print('class ${d.namePart.typeName.lexeme} doc=${d.documentationComment?.tokens.length}');
      for (final m in d.members) {
        if (m is ConstructorDeclaration) print('  ctor ${m.name?.lexeme} params=${m.parameters.parameters.map((p) => p.name?.lexeme).toList()}');
      }
    } else if (d is EnumDeclaration) {
      print('enum ${d.namePart.typeName.lexeme}');
    }
  }
}
