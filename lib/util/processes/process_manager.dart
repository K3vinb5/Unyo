import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unyo/sources/sources.dart';

class ProcessManager {
  Process? _process;
  String? _jarPath;
  final List<String> outputHistory = [];
  int _totalCharacters = 0;
  final int _maxCharacters = 5000; // Maximum character limit

  Future<void> _extractJar() async {
    final byteData = await rootBundle.load('assets/extensions.jar');
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/extensions.jar');
    await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    _jarPath = file.path;
    // final tempDir = await getTemporaryDirectory();
    // final jarFile = File('${tempDir.path}/extensions.jar');
    //
    // if (!await jarFile.exists()) {
    //   final byteData = await rootBundle.load('assets/extensions.jar');
    //   final buffer = byteData.buffer;
    //   await jarFile.writeAsBytes(
    //       buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // }
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
        'java',
        ['-jar', _jarPath!],
        mode: ProcessStartMode.normal
      );

      _process?.stdout.transform(utf8.decoder).listen((data) {
        // print(data);
        _addOutput(data);
      });

      _process?.stderr.transform(utf8.decoder).listen((data) {
        // print('ERROR: $data');
        _addOutput('ERROR: $data');
      });

      _process?.exitCode.then((exitCode) {
        _addOutput('Process exited with code $exitCode');
        _process = null;
      });
      
      addEmbeddedAniyomiExtensions();
    } catch (e) {
      print('Failed to start process: $e');
    }
  }

  void stopProcess() {
    if (_process != null) {
      print("Killed process");
      _process!.kill();
      _process = null;
    }
  }

  void _addOutput(String data) {
    // Add new data to the output history
    outputHistory.add(data);
    _totalCharacters += data.length;

    // Ensure the total characters do not exceed the limit
    while (_totalCharacters > _maxCharacters) {
      final removedData = outputHistory.removeAt(0);
      _totalCharacters -= removedData.length;
    }
  }
}
