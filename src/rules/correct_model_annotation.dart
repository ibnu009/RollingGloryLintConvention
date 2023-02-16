// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'The @JsonSerializable() must be applied in model file';

const _details = r'''
**CAUTION** ...
Retrofit is a Dio client that makes consuming Rest APIs easier for us, since we use retrofit in the development, 
don't forget to add @JsonSerializable() to above your class name.

**DO:**
```dart

@JsonSerializable()
class ProductModel {
  int? id;
}
```

**DON'T:**
```dart

class ProductModel {
  int? id;
}
@JsonSerializable()
```

''';

class CorrectModelAnnotation extends LintRule {
  static const LintCode code = LintCode(
      'json_serializable_annotation_is_required',
      "JsonSerializable Annotation is required to declare service for retrofit pattern.",
      correctionMessage:
          "You have to add '@JsonSerializable()' on top of your model class");

  CorrectModelAnnotation()
      : super(
            name: 'json_serializable_annotation_is_required',
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
      bool isLintSatisfied = false;
      var fileName = declaredElement.source.uri.path;
      var classess = declaredElement.classes;

      if (!fileName.isPathModel()) {
        return;
      }

      if (node.declarations.isEmpty) {
        isLintSatisfied = false;
        return;
      }

      for (var declaration in node.declarations) {
        if (declaration is ClassDeclaration) {
          final classAnnotations = declaration.metadata;
          for (var annotation in classAnnotations) {
            final evaluatedAnnotation = annotation.name.name;
            if (evaluatedAnnotation.contains('JsonSerializable')) {
              isLintSatisfied = true;
            } else {
              isLintSatisfied = false;
            }
          }
        }
      }

      if (classess.isEmpty) {
        return;
      }

      if (isLintSatisfied == true) {
        return;
      }

      ClassElement classInstance = classess.first;
      var offset = classInstance.nameOffset;
      var length = classInstance.nameLength;

      rule.reportLintForOffset(offset, length, arguments: [fileName]);
    }
  }
}
