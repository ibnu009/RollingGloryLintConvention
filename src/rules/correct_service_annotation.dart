// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc =
    r'RestApi Annotation is required to be declared for retrofit pattern';

const _details =
    '''
RestApi Annotation is required to be declared on top of service class for retrofit pattern.
When adding the service end point it is better to create it in separated file instead of
directly write it inside of retrofit methods.
**NOTE:** always add CancelRequest() to cancel previous retrofit request inside of
each service

**DO:**
```dart
@RestApi() //RestApi Annotation is added
abstract class ProductServices {
  factory ProductServices(Dio dio) = _ProductServices;

  @GET(ProductServiceConstant.listProducts) // endpoint created in separated file
  Future<Model> listProducts(
      @CancelRequest() CancelToken cancelToken, //CancelRequest in added
  );
}
```

**DON'T:**
```dart
//Forget to add RestApi Annotation
abstract class ProductServices {
  factory ProductServices(Dio dio) = _ProductServices;

  @GET("api/products") // endpoint provided with string
  Future<Model> listProducts(
      //Forget to add CancelRequest
  );
}
```

''';

class CorrectServiceAnnotation extends LintRule {
  static const LintCode code = LintCode(
      'rest_api_annotation_is_required_for_service',
      "RestApi Annotation is required to declare service for retrofit pattern.",
      correctionMessage:
          "You have to add '@RestApi()' on top of your service class");

  CorrectServiceAnnotation()
      : super(
            name: 'rest_api_annotation_is_required_for_service',
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

      if (!fileName.isPathServices()) {
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
            if (evaluatedAnnotation.contains('RestApi')) {
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
