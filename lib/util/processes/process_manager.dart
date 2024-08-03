import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unyo/sources/sources.dart';

class ProcessManager {
  Process? _process;
  String? _jarPath;
  late Directory supportDirectoryPath;
  final List<Map<bool, String>> outputHistory = [];
  int _totalWords = 0;
  final int _maxCharacters = 100; // Maximum character limit

  Future<void> _extractJar() async {
    supportDirectoryPath = await getApplicationSupportDirectory();
    final jarFile = File('${supportDirectoryPath.path}//extensions.jar');
    final extensionsDir = Directory('${supportDirectoryPath.path}//extensions');

    if (await jarFile.exists()) {
      _jarPath = jarFile.path;
      return;
    }
    if (!(await extensionsDir.exists())) {
      extensionsDir.create();
    }
    final byteData = await rootBundle.load('assets//extensions.jar');
    final buffer = byteData.buffer;
    final file = File('${supportDirectoryPath.path}//extensions.jar');
    await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    _jarPath = file.path;
  }

  Future<void> startProcess() async {
    if (_process != null) {
      return;
    }

    if (_jarPath == null) {
      await _extractJar();
    }

    try {
      _process = await Process.start(
          'java', ['-jar', _jarPath!, supportDirectoryPath.path],
          mode: ProcessStartMode.normal);

      _process?.stdout.transform(utf8.decoder).listen((data) {
        _addOutput(data, false);
      });

      _process?.stderr.transform(utf8.decoder).listen((data) {
        _addOutput('ERROR: $data', true);
      });

      _process?.exitCode.then((exitCode) {
        _addOutput('Process exited with code $exitCode', true);
        _process = null;
      });

      addEmbeddedAniyomiExtensions();
    } catch (e) {
      _addOutput('Failed to start process: $e', true);
    }
  }

  void stopProcess() {
    if (_process != null) {
      _addOutput("Killed process Successfully", false);
      _process!.kill();
      _process = null;
    }
  }

  void restartProcess() async {
    if (_process == null) return;
    stopProcess();
    await Future.delayed(const Duration(seconds: 2));
    await startProcess();
  }

  void _addOutput(String data, bool isError) {
    // Add new data to the output history
    if (data.contains("Exception") || data.contains("exception")) {
      isError = true;
    }
    outputHistory.add({isError: data});
    _totalWords++;

    // Ensure the total words do not exceed the limit
    while (_totalWords > _maxCharacters) {
      outputHistory.removeAt(0);
      _totalWords--;
    }
  }
}
