// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Name source files using `lowercase_with_underscores`.';

const _details =
    r'''
**DO** name source files using `lowercase_with_underscores`.

Some file systems are not case-sensitive, so many projects require filenames to
be all lowercase. Using a separating character allows names to still be readable
in that form. Using underscores as the separator ensures that the name is still
a valid Dart identifier, which may be helpful if the language later supports
symbolic imports.

**BAD:**

* `SliderMenu.dart`
* `filesystem.dart`
* `file-system.dart`

**GOOD:**

* `slider_menu.dart`
* `file_system.dart`

Files without a strict `.dart` extension are ignored.  For example:

**OK:**

* `file-system.g.dart`
* `SliderMenu.css.dart`

The lint `library_names` can be used to enforce the same kind of naming on the
library.

''';

class PreferCamelCase extends LintRule {
  static const LintCode code = LintCode(
      'prefer_camel_case', "The type name '{0}' isn't an CamelCase identifier.",
      correctionMessage:
          'Try changing the name to follow the CamelCase style. example: camelCase for variable/function and CamelCase for class');

  PreferCamelCase()
      : super(
            name: 'prefer_camel_case',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addGenericTypeAlias(this, visitor);
    registry.addClassDeclaration(this, visitor);
    registry.addClassTypeAlias(this, visitor);
    registry.addFunctionTypeAlias(this, visitor);
    registry.addEnumDeclaration(this, visitor);
    registry.addDeclaredVariablePattern(this, visitor);
    registry.addVariableDeclarationList(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  void check(Token name) {
    var lexeme = name.lexeme;
    if (!lexeme.isCamelCase()) {
      rule.reportLintForToken(name, arguments: [lexeme]);
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    check(node.name);
  }

  @override
  void visitClassTypeAlias(ClassTypeAlias node) {
    check(node.name);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    check(node.name);
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    check(node.name);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    check(node.name);
  }

  @override
  void visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    check(node.name);
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    var variables = node.variables;
    for (var variable in variables) {
      if (!variable.isConst) {
        check(variable.name);
      }
    }
  }
}
