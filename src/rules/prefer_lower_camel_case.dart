// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Use lowerCamelCase for naming';

const _details = '''
variable must always use lowerCamelCase. 
variable should lowercase the first letter of each word (includingthe first word), and use no separators.

**DO:**
```dart
  String userPassword;
  static const genericErrorMessage;
  final int userAge;
```

**DON'T:**
```dart
  String user_password;
  static const GENERIC_ERROR_MESSAGE;
  final int UserAge;
```

''';

class PreferLowerCamelCase extends LintRule {
  static const LintCode code = LintCode('prefer_lower_camel_case',
      "The type name '{0}' isn't an lowerCamelCase identifier.",
      correctionMessage:
          'Try changing the name to follow the lowerCamelCase style. example: userPassword');

  PreferLowerCamelCase()
      : super(
            name: 'prefer_lower_camel_case',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addDeclaredVariablePattern(this, visitor);
    registry.addVariableDeclarationList(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  void check(Token name) {
    var lexeme = name.lexeme;
    if (!lexeme.isLowerCamelCase()) {
      rule.reportLintForToken(name, arguments: [lexeme]);
    }
  }

  @override
  void visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    check(node.name);
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    var variables = node.variables;
    for (var variable in variables) {
      if (!variable.isConst) {
        check(variable.name);
      }
    }
  }
}
