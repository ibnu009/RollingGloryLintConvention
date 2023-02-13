import 'dart:isolate';

import '../src/analyzer_plugin_starter.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
