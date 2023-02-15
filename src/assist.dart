import 'package:analyzer/error/error.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:cli_util/cli_logging.dart';
// import 'package:analyzer/file_system/physical_file_system.dart';
// import 'package:import_lint/analyzer_plugin/rules/testing_checks.dart';
import 'package:linter/src/cli.dart';
import 'package:linter/src/analyzer.dart';
import 'package:linter/src/formatter.dart' as formatter;
import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/src/lint/io.dart';
import 'package:analyzer/src/services/lint.dart' as lint_service;
import 'dart:io';
import 'package:analyzer_plugin/protocol/protocol_common.dart'
    as protocolCommon;
import 'package:analyzer_plugin/protocol/protocol_generated.dart'
    as protocolGenerated;

import 'rules/correct_constant_class_name.dart';
import 'rules/correct_constant_file_name.dart';
import 'rules/correct_enum_class_name.dart';
import 'rules/correct_enum_file_name.dart';
import 'rules/correct_model_annotation.dart';
import 'rules/correct_model_class_name.dart';
import 'rules/correct_model_file_name.dart';
import 'rules/correct_request_class_name.dart';
import 'rules/correct_request_file_name.dart';
import 'rules/correct_response_class_name.dart';
import 'rules/correct_response_file_name.dart';
import 'rules/correct_service_annotation.dart';
import 'rules/correct_service_class_name.dart';
import 'rules/correct_service_file_name.dart';
import 'rules/prefer_lower_camel_case.dart';
import 'rules/prefer_single_class_in_one_file.dart';
import 'rules/prefer_single_quotes.dart';
import 'rules/prefer_static_const_lang_variable.dart';
import 'rules/prefer_upper_camel_case.dart';

Future<List<protocolCommon.AnalysisError>> scanning(List<File> files) async {
  List<protocolCommon.AnalysisError> result = [];
  Logger logger = Logger.standard();

  logger.progress("Analyzing..");
  Registry.ruleRegistry.register(PreferSingleQuotes());
  Registry.ruleRegistry.register(PreferSingleClassInOneFile());

  Registry.ruleRegistry.register(CorrectServiceFileName());
  Registry.ruleRegistry.register(CorrectServiceAnnotation());
  Registry.ruleRegistry.register(CorrectServiceClassName());

  Registry.ruleRegistry.register(CorrectModelFileName());
  Registry.ruleRegistry.register(CorrectModelAnnotation());
  Registry.ruleRegistry.register(CorrectModelClassName());

  Registry.ruleRegistry.register(CorrectConstantFileName());
  Registry.ruleRegistry.register(CorrectConstantClassName());

  Registry.ruleRegistry.register(CorrectEnumFileName());
  Registry.ruleRegistry.register(CorrectEnumClassName());

  Registry.ruleRegistry.register(CorrectRequestFileName());
  Registry.ruleRegistry.register(CorrectRequestClassName());

  Registry.ruleRegistry.register(CorrectResponseFileName());
  Registry.ruleRegistry.register(CorrectResponseClassName());

  Registry.ruleRegistry.register(PreferUpperCamelCase());
  Registry.ruleRegistry.register(PreferLowerCamelCase());

  Registry.ruleRegistry.register(PreferStaticConstLangVariable());

  lint_service.linterVersion = "0.0.0-alpha.0";

  final rulesConfig = [
    "testing_checks",
    "prefer_single_class_in_one_file",
    "prefer_single_quotes",
    "correct_service_file_name",
    "correct_service_class_name",
    "rest_api_annotation_is_required_for_service",
    "correct_model_file_name",
    "json_serializable_annotation_is_required",
    "correct_model_class_name",
    "correct_constant_class_name",
    "correct_constant_file_name",
    "correct_enum_class_name",
    "correct_enum_file_name",
    "correct_response_class_name",
    "correct_response_file_name",
    "correct_request_class_name",
    "correct_request_file_name",
    "prefer_upper_camel_case",
    "prefer_lower_camel_case",
    "prefer_static_const_lang_variable"
  ];
  var rules = <LintRule>[];
  for (var config in rulesConfig) {
    var rule = Registry.ruleRegistry[config];
    if (rule != null) {
      rules.add(rule);
    }
  }
  var lintOptions = LinterOptions();
  lintOptions.enabledLints = rules;
  lintOptions..resourceProvider = PhysicalResourceProvider.INSTANCE;

  collectFiles("");

  final filesNormalized =
      files.map((file) => File(_absoluteNormalizedPath(file.path))).toList();
  var dartLinter = DartLinter(lintOptions);
  dartLinter.numSourcesAnalyzed = 0;

  var errors = await lintFiles(dartLinter, filesNormalized);
  for (AnalysisError analysisError in dartLinter.errors) {
    logger.progress("AnalysisError1.. ${analysisError.message}");
  }
  for (AnalysisErrorInfo analysisError in errors) {
    for (AnalysisError item in analysisError.errors) {
      var offset = item.offset;
      var location = analysisError.lineInfo.getLocation(offset);
      var line = location.lineNumber;
      var column = location.columnNumber;

      protocolCommon.AnalysisError pCAnalysisError =
          protocolCommon.AnalysisError(
              protocolCommon.AnalysisErrorSeverity.WARNING,
              protocolCommon.AnalysisErrorType.LINT,
              hasFix: true,
              protocolCommon.Location(
                  item.source.fullName, item.offset, item.length, line, column),
              item.message,
              item.errorCode.name);

      protocolGenerated.AnalysisErrorFixes(pCAnalysisError);
      result.add(pCAnalysisError);
      logger.progress(
          "AnalysisError2.. ${item.message}  ${item.errorCode.name} ${formatter.getLineContents(line, item)}");
    }
    logger.progress("AnalysisErrorInfo.. ${analysisError.lineInfo.toString()}");
  }

  return result;
}

String _absoluteNormalizedPath(String path) {
  var pathContext = PhysicalResourceProvider.INSTANCE.pathContext;
  return pathContext.normalize(
    pathContext.absolute(path),
  );
}
