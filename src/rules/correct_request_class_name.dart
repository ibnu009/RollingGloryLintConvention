// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Request class must always end with "Request". ';

const _details =
    '''
Request class must always end with "Request". 

**DO:**
```dart
  class GiftRequest{}
  class ProductRequest{}
```

**DON'T:**
```dart
  class Gift{}
  class ProductService{}
```

''';

class CorrectRequestClassName extends LintRule {
  static const LintCode code = LintCode('correct_request_class_name',
      "The class name isn't a correct name for request class. Example : 'ExampleRequest'",
      correctionMessage: 'Try changing the name that ends with "Request".');

  CorrectRequestClassName()
      : super(
            name: 'correct_request_class_name',
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
      var fileName = declaredElement.source.uri.path;
      var classess = declaredElement.classes;

      for (var classInstance in classess) {
        var offset = classInstance.nameOffset;
        var length = classInstance.nameLength;
        var name = classInstance.name;

        if (fileName.isPathRequest()) {
          if (!name.isCorrectClassRequestName()) {
            rule.reportLintForOffset(offset, length, arguments: [fileName]);
          }
        }
      }
    }
  }
}
