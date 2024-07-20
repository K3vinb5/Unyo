import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/util/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class MixedController {
  MixedController({
    required this.controlsOverlayOnTap,
    required this.resetHideControlsTimer,
    required this.updateEntry,
    required this.context,
    required this.setState,
    required this.streamData,
    required this.source,
    required this.key,
  });
  final BuildContext context;
  final StreamData streamData;
  final int source;
  final String key;
  final void Function() controlsOverlayOnTap;
  final void Function() resetHideControlsTimer;
  final void Function() updateEntry;
  final void Function(void Function()) setState;

  late Timer syncTimer;
  late MqqtClientController mqqtController;
  late VideoPlayerController videoController;
  late VideoPlayerController audioController;
  late bool audioSeparate;

  bool isPlaying = true;
  bool firstInit = true;

  void init() {
    initControllers();
    audioSeparate = streamData.tracks != null /* && widget.audioStream != "" */;
    sync();
    mqqtController = MqqtClientController(
      context: context,
      key: key,
      controlsOverlayOnTap: controlsOverlayOnTap,
      resetHideControlsTimer: resetHideControlsTimer,
      updateEntry: updateEntry,
      mixedController: this,
    );
    mqqtController.init();
  }

  void initControllers() {
    Future<ClosedCaptionFile>? closedCaptionFile = streamData.captions != null
        ? loadCaptions(streamData.captions![source][0].file)
        : null;
    if (streamData.getHeaders(source) != null) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(streamData.streams[source]),
        httpHeaders: streamData.getHeaders(source)!,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(streamData.streams[source]),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }
    if (streamData.tracks != null /*&& audioStream != ""*/) {
      if (streamData.getHeaders(source) != null) {
        audioController = VideoPlayerController.networkUrl(
          Uri.parse(streamData.tracks![source][0].file),
          httpHeaders: streamData.getHeaders(source)!,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } else {
        audioController = VideoPlayerController.networkUrl(
          Uri.parse(streamData.tracks![source][0].file),
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }
    } else {
      audioController = videoController;
    }
    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(false);
    try {
      videoController.initialize().then((_) => setState(() {}));
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    videoController.play();

    if (streamData.tracks != null /*&& audioStream != ""*/) {
      audioController.addListener(() {
        setState(() {});
      });
      audioController.setLooping(false);
      audioController.initialize().then((_) => setState(() {}));
      audioController.play();
    }
  }

  Future<ClosedCaptionFile> loadCaptions(String url) async {
    var response =
        await http.get(Uri.parse(url), headers: streamData.getHeaders(source));
    if (response.statusCode != 200) {
      if (context.mounted) {
        showErrorDialog(context, null);
      }
      return WebVTTCaptionFile("");
    }
    var bytes = response.bodyBytes;
    String content = String.fromCharCodes(bytes);
    return WebVTTCaptionFile(formatCaptions(content));
  }

  String formatCaptions(String captions) {
    // Split the captions into pieces based on empty lines
    List<String> pieces = captions.split('\n\n');
    List<String> formattedPieces = [];
    for (int i = 0; i < pieces.length; i++) {
      formattedPieces.add(replaceSecond(pieces[i], "\n", " "));
    }
    // Join the formatted pieces back together with empty lines
    String formattedCaptions = formattedPieces.join('\n\n');

    return formattedCaptions;
  }

  String replaceSecond(String original, String pattern, String replacement) {
    int firstIndex = original.indexOf(pattern);
    if (firstIndex != -1) {
      int secondIndex = original.indexOf(pattern, firstIndex + 1);
      if (secondIndex != -1) {
        return original.replaceFirst(pattern, replacement, secondIndex);
      }
    }
    return original;
  }

  void changeCaption(int pos) {
    Future<ClosedCaptionFile>? newClosedCaptionFile =
        streamData.captions != null
            ? loadCaptions(streamData.captions![source][pos].file)
            : null;
    videoController.setClosedCaptionFile(newClosedCaptionFile);
  }

  void play({bool? sendCommand}) {
    isPlaying = true;
    if (audioSeparate) {
      audioController.play();
    }
    videoController.play();
    if (sendCommand != null && sendCommand) {
      mqqtController.sendOrder("play");
    }
  }

  void pause({bool? sendCommand}) {
    isPlaying = false;
    if (audioSeparate) {
      audioController.pause();
    }
    videoController.pause();
    if (sendCommand != null && sendCommand) {
      mqqtController.sendOrder("pause");
    }
  }

  void seekTo(Duration duration, {bool? sendCommand, double? time}) {
    if (audioSeparate) {
      audioController.seekTo(duration);
      sync();
    }
    videoController.seekTo(duration);
    if (sendCommand != null && time != null && sendCommand) {
      mqqtController.sendOrder("seekTo:$time");
    }
  }

  void setVolume(double n) {
    if (audioSeparate) {
      audioController.setVolume(n);
      return;
    }
    videoController.setVolume(n);
  }

  void dispose() {
    if (audioSeparate) {
      syncTimer.cancel();
      audioController.dispose();
    }
    videoController.dispose();
    if (mqqtController.connected) {
      mqqtController.client.disconnect();
    }
  }

  void sync() {
    if (!audioSeparate) return;
    if (!firstInit) {
      syncTimer.cancel();
    } else {
      firstInit = false;
    }
    syncTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (videoController.value.isPlaying) {
        syncControllers();
      }
    });
  }

  void syncControllers() async {
    int difference = (videoController.value.position.inMilliseconds -
        audioController.value.position.inMilliseconds);

    if (difference.abs() < 200 && difference != 0) {
      syncTimer.cancel();
      return;
    }

    if (difference > 0) {
      //video waits (audio forward)
      videoController.pause();
      await Future.delayed(Duration(milliseconds: difference.abs() + 100));
      videoController.play();
    } else {
      //audio waits (audio backwards)
      audioController.pause();
      await Future.delayed(Duration(milliseconds: difference.abs() + 100));
      audioController.play();
    }
  }
}
