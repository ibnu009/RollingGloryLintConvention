// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/declared_variables.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';
import 'package:cli_util/cli_logging.dart';

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

class PreferNullableForModels extends LintRule {
  static const LintCode code = LintCode(
      'prefer_nullable_for_models', 'Implement nullable attributes for models',
      correctionMessage: 'add nullable <ex:String?> to models\'s attributes');

  PreferNullableForModels()
      : super(
      name: 'prefer_nullable_for_models',
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
      if (path.isCorrectFileModelName() && path.isPathModel()) {
        for (var element in declaredElement.classes) {
          for (var field in element.fields) {
            if (!field.toString().isCorrectVariableNullable()) {
              rule.reportLintForOffset(field.nameOffset, field.nameLength);
            }
          }
        }
      }
    }
  }
}
