// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Use UpperCamelCase for naming';

const _details = '''
Class, Enum, Widget, typedefs and Extension must always use UpperCamelCase. 
Class, Enum, Widget, typedefs and Extension should capitalize the first letter of each word (including
the first word), and use no separators.

**DO:**
```dart
  class GiftService{}
  enum CategoryType{}
  class IconCalculatorButton extends StatelessWidget{}
  extension StringExtension on String {}
```

**DON'T:**
```dart
  class gift{}
  enum category_type{}
  class Icon-Calculator-Button extends StatelessWidget{}
  extension StringExtension on String {}
```

''';

class PreferUpperCamelCase extends LintRule {
  static const LintCode code = LintCode('prefer_upper_camel_case',
      "The type name '{0}' isn't an UpperCamelCase identifier.",
      correctionMessage:
          'Try changing the name to follow the UpperCamelCase style. example: GiftService');

  PreferUpperCamelCase()
      : super(
            name: 'prefer_upper_camel_case',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addGenericTypeAlias(this, visitor);
    registry.addClassDeclaration(this, visitor);
    registry.addClassTypeAlias(this, visitor);
    registry.addFunctionTypeAlias(this, visitor);
    registry.addEnumDeclaration(this, visitor);
    registry.addExtensionDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  void check(Token name) {
    var lexeme = name.lexeme;
    if (!lexeme.isUpperCamelCase()) {
      rule.reportLintForToken(name, arguments: [lexeme]);
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    check(node.name);
  }

  @override
  void visitClassTypeAlias(ClassTypeAlias node) {
    check(node.name);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    check(node.name);
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    check(node.name);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    check(node.name);
  }

  @override
  void visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    check(node.name);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    var name = node.name;
    if (name != null) {
      check(name);
    }
  }
}
