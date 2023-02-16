// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'The file name for enums must end with _model.dart';

const _details = r'''
**CAUTION** ...
The file name for models must end with _model.dart

**DO:**
```dart
product_model.dart
```

**DON'T:**
```dart
product.dart
productmodel.dart
```

''';

class CorrectModelFileName extends LintRule {
  static const LintCode code = LintCode('correct_model_file_name',
      "The file name '{0}' isn't a correct name for model file. Try changing the name that ends with '_model'.",
      correctionMessage: 'Try changing the file name that ends with "_model".');

  CorrectModelFileName()
      : super(
            name: 'correct_model_file_name',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addCompilationUnit(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    var declaredElement = node.declaredElement;
    if (declaredElement != null) {
      var fileName = declaredElement.source.shortName;
      var path = declaredElement.source.uri.path;
      var classess = declaredElement.classes;

      for (var classInstance in classess) {
        var offset = classInstance.nameOffset;
        var length = classInstance.nameLength;

        if (path.isPathModel()) {
          if (!path.isCorrectFileModelName()) {
            rule.reportLintForOffset(offset, length, arguments: [fileName]);
          }
        }
      }
    }
  }
}
