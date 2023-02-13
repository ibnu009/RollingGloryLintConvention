// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

const _desc = r'Name source files using `lowercase_with_underscores`.';

const _details = r'''
''';

class PreferSingleClassInOneFile extends LintRule {
  static const LintCode code = LintCode('prefer_single_class_in_one_file',
      "Only one public class allowed per file. Move one of the classes into another file!",
      correctionMessage: 'Move one of the classes into another file!".');

  PreferSingleClassInOneFile()
      : super(
            name: 'prefer_single_class_in_one_file',
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

      if (classess.length > 1) {
        for (var classInstance in classess) {
          var offset = classInstance.nameOffset;
          var length = classInstance.nameLength;

          rule.reportLintForOffset(offset, length, arguments: [fileName]);
        }
      }
    }
  }
}
