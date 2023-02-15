// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';
import '../../helper/string_extention.dart';

const _desc = r'The BaseResponse and BaseListResponse must be implemented and imported from rollingglory_codebase';

const _details = r'''
**CAUTION** Both BaseResponse and BaseListResponse must be implemented and imported from rollingglory_codebase

When an application communicates to the backend via API calls, we usually receive two type of responses. single object and multi objects.
both types need to be implemented in service file, the service file is actually an abstract class that contains 
a set of methods which is needed in order to get data from API.

**DO**
```dart
  Future<BaseListResponse<Episode>> myMethod();
```

**DON'T:**
```dart
  Future<Episode> myMethod();
```
''';

class CorrectBaseListResponseImport extends LintRule {
  static const LintCode code = LintCode('correct_base_response_import',
      'The BaseResponse and BaseListResponse must be imported from rollingglory_codebase',
      correctionMessage: 'Try to correct the source of your base responses');

  CorrectBaseListResponseImport()
      : super(
            name: 'correct_base_response_import',
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

  static const LintCode baseNotImplementedError = LintCode(
    "correct_base_response_import",
    "This method should implement BaseResponse or BaseListResponse",
    correctionMessage: "Add BaseResponse or BaseListResponse to your method",
  );

  final LinterContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    var declaredElement = node.declaredElement;
    if (declaredElement != null) {
      var path = declaredElement.source.uri.path;

      if (path.isPathServices()) {
        var classes = declaredElement.classes;
        for (var element in classes) {
          for (var field in element.methods) {
            if (!field.toString().isCorrectUsingBaseResponse()) {
              rule.reportLintForOffset(
                field.nameOffset,
                field.nameLength,
                errorCode: baseNotImplementedError,
              );
            }
          }
        }
        var imports = node.directives;
        for (var import in imports) {
          if (import.toString().isCorrectFileBaseResponse()) {
            if (!path.isPathRGBCodeBase()) {
              rule.reportLintForOffset(
                import.offset,
                import.length,
              );
            }
          }
        }
      }

    }
  }
}
