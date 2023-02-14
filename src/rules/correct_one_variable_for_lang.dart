// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';


const _desc = r' ';

const _details = r'''
**DO** ...

**BAD:**
```dart

```

**GOOD:**
```dart

```

''';

class CorrectOneVariableForLang extends LintRule {
  static const LintCode code = LintCode('correct_one_variable_for_lang',
      'Only one variable is allowed for lang file',
      correctionMessage: 'Try to remove unnecessary variables');

  CorrectOneVariableForLang()
      : super(
            name: 'correct_one_variable_for_lang',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this, context);
    registry.addCompilationUnit(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  final LinterContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    var declaredElement = node.declaredElement;
    if (declaredElement != null) {
      var path = declaredElement.source.uri.path;
      if (path.isCorrectFileLang() && path.isPathLang()) {
        var variables = declaredElement.topLevelVariables;
        if (variables.length > 1) {
          for (int i = 1; i < variables.length; i++) {
            rule.reportLintForOffset(
              variables[i].nameOffset,
              variables[i].nameLength,
            );
          }
        }
      }
    }
  }
}
