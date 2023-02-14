// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
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

class CorrectBaseListResponseImport extends LintRule {
  static const LintCode code = LintCode('correct_base_list_response_import',
      'The BaseListResponse must be imported from rollingglory_codebase',
      correctionMessage: 'Try to correct the source of BaseListResponse');

  CorrectBaseListResponseImport()
      : super(
            name: 'correct_base_list_response_import',
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
      if (path.isPathServices()) {
        var imports = node.directives;
        for (var import in imports) {
          if (import.toString().isCorrectFileBaseResponse()) {
            if(!path.isPathRGBCodeBase()){
              rule.reportLintForOffset(import.offset, import.length);
            }
          }
        }
      }
    }
  }
}
