// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r"Please declare variable as static const.";

const _details = r'''
''';

class PreferStaticConstLangVariable extends LintRule {
  static const LintCode code = LintCode('prefer_static_const_lang_variable',
      'It is better to use static const variables.',
      correctionMessage: 'Try add static const to the variable.');

  PreferStaticConstLangVariable()
      : super(
            name: 'prefer_static_const_lang_variable',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addVariableDeclarationList(this, visitor);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    var variables = node.variables;
    String sourceCode = node.toSource();
    if (sourceCode.isPathLang()) {
      for (var variable in variables) {
        if (!variable.isConst) {
          rule.reportLintForToken(variable.name);
        }
      }
    }
  }
}

// class _Visitor extends SimpleAstVisitor {
//   final LintRule rule;

//   _Visitor(this.rule);

//   @override
//   void visitVariableDeclarationList(VariableDeclarationList node) {
//     var variables = node.variables;
//     for (var variable in variables) {
//       if (!variable.isConst) {
//         var secondVariable = variables[1];
//         rule.reportLintForToken(secondVariable.name);
//       }
//     }
//   }
// }
