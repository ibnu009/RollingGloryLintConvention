// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/lint/linter.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';

import '../../helper/string_extention.dart';

const _desc = r'Name source files using `lowercase_with_underscores`.';

const _details = r'''
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
