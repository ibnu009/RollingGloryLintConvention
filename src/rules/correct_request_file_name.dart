// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Response file must always end with "_request". ';

const _details =
    '''
Response file must always end with "_request"  and should always use snake case for file naming.

**DO:**
```dart
  gift_request.dart
  product_request.dart
```

**DON'T:**
```dart
  product_service.dart
  ProductRequest.dart
```

''';

class CorrectRequestFileName extends LintRule {
  static const LintCode code = LintCode('correct_request_file_name',
      "The file name '{0}' isn't a correct name for request file.",
      correctionMessage: 'Try changing the name that ends with "_request".');

  CorrectRequestFileName()
      : super(
            name: 'correct_request_file_name',
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

        if (path.isPathRequest()) {
          if (!path.isCorrectFileRequestName()) {
            rule.reportLintForOffset(offset, length, arguments: [fileName]);
          }
        }
      }
    }
  }
}
