// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
// import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
// import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:cli_util/cli_logging.dart';
// import 'package:analyzer/dart/analysis/analysis_context.dart';
// import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';

// import 'package:analyzer_plugin/plugin/plugin.dart';
// import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:linter/src/cli.dart';
import 'package:linter/src/analyzer.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;

import '../helper/string_extention.dart';
import 'assist.dart';

class AnalyzerPlugin extends ServerPlugin {
  Logger logger = Logger.standard();

  AnalysisContextCollection? _contextCollection;

  @override
  String get contactInfo => '-';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'dart_code_metrics';

  @override
  String get version => '5.7.1-dev.1';

  AnalyzerPlugin({
    required super.resourceProvider,
  });

  @override
  Future<void> afterNewContextCollection(
      {required AnalysisContextCollection contextCollection}) async {
    _contextCollection = contextCollection;

    contextCollection.contexts.length;
    final filtered = contextCollection.contexts
        .where((context) {
          final rootPath = context.contextRoot.root.path;
          final file = context.contextRoot.optionsFile;
          return file != null && file.path.endsWith('main.dart');
        })
        .map((e) => File(e.contextRoot.optionsFile!.path))
        .toList();
    ;

    final errors = await scanning(filtered);

    for (final error in errors) {
      channel.sendNotification(
        plugin.AnalysisErrorsParams(
          error.location.file,
          [error],
        ).toNotification(),
      );
    }
    return super
        .afterNewContextCollection(contextCollection: contextCollection);
  }

  @override
  Future<void> analyzeFile(
      {required AnalysisContext analysisContext, required String path}) async {
    final isAnalyzed = analysisContext.contextRoot.isAnalyzed(path);
    if (!isAnalyzed) {
      return;
    }

    final rootPath = analysisContext.contextRoot.root.path;

    if (!path.isFileAllowedToBeObserved()) {
      return;
    }

    try {
      final resolvedUnit =
          await analysisContext.currentSession.getResolvedUnit(path);

      if (resolvedUnit is ResolvedUnitResult) {
        channel.sendNotification(
          plugin.AnalysisErrorsParams(
            path,
            await scanning([File(path)]),
          ).toNotification(),
        );
      } else {
        channel.sendNotification(
          plugin.AnalysisErrorsParams(path, []).toNotification(),
        );
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }
  }

  @override
  Future<plugin.EditGetFixesResult> handleEditGetFixes(
    plugin.EditGetFixesParams parameters,
  ) async {
    try {
      final path = parameters.file;
      final analysisContext = _contextCollection?.contextFor(path);
      final resolvedUnit =
          await analysisContext?.currentSession.getResolvedUnit(path);

      if (analysisContext != null && resolvedUnit is ResolvedUnitResult) {
        final analysisErrors =
            (await scanning([File(path)])).where((analysisError) {
          final location = analysisError.location;

          return location.file == parameters.file &&
              location.offset <= parameters.offset &&
              parameters.offset <= location.offset + location.length;
        }).toList();
        return plugin.EditGetFixesResult(
            analysisErrors.map((e) => plugin.AnalysisErrorFixes(e)).toList());
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }

    return plugin.EditGetFixesResult([]);
  }
}
