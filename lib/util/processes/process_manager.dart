import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unyo/sources/sources.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:unyo/util/constants.dart';

class ProcessManager {
  Process? _process;
  String? _jarPath;
  bool _extensionsDirPath = false;
  late Directory supportDirectoryPath;
  final List<Map<bool, String>> outputHistory = [];
  int _totalWords = 0;
  final int _maxCharacters = 100; // Maximum character limit

  Future<void> _extractJar({bool ignore = false}) async {
    supportDirectoryPath = await getApplicationSupportDirectory();
    final jarFile = File(p.join(supportDirectoryPath.path, "extensions.jar"));

    if (await jarFile.exists() && !ignore) {
      _jarPath = jarFile.path;
      return;
    }

    // NOTE, even for windows, the slash must be forawd on this one
    final byteData = await rootBundle.load("assets/extensions.jar");
    final buffer = byteData.buffer;
    final file = File(p.join(supportDirectoryPath.path, "extensions.jar"));
    await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    _jarPath = file.path;
  }

  Future<void> _initExtensionsDirectories() async {
    supportDirectoryPath = await getApplicationSupportDirectory();
    final animeExtensionsDir =
        Directory(p.join(supportDirectoryPath.path, "extensions", "anime"));
    final mangaExtensionsDir =
        Directory(p.join(supportDirectoryPath.path, "extensions", "manga"));

    if (!(await animeExtensionsDir.exists())) {
      animeExtensionsDir.create(recursive: true);
    }
    if (!(await mangaExtensionsDir.exists())) {
      mangaExtensionsDir.create(recursive: true);
    }
    _extensionsDirPath = true;
  }

  Future<void> downloadNewCore() async {
    if (_process != null) {
      stopProcess();
      await _extractJar(ignore: true);
      startProcess();
    } else {
      await _extractJar(ignore: true);
    }
  }

  Future<void> startProcess() async {
    if (_process != null) {
      return;
    }

    if (!_extensionsDirPath) {
      await _initExtensionsDirectories();
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
        _addOutput(/*'ERROR: $data'*/data, /*true*/false);
      });

      _process?.exitCode.then((exitCode) {
        _addOutput('Process exited with code $exitCode', true);
        _process = null;
      });

      addEmbeddedAniyomiExtensions();
      addEmbeddedTachiyomiExtensions();
    } catch (e) {
      _addOutput('Failed to start process: $e', true);
    }
  }

  void stopProcess() {
    if (_process != null) {
      _addOutput("Killed process Successfully", false);
      _process!.kill();
      http.get(Uri.parse("${getEndpoint()}/unyo/kill"));
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
