import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
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
    required this.episode,
    required this.key,
  });
  final BuildContext context;
  final StreamData streamData;
  final int source;
  final int episode;
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
  bool isInitialized = false;
  Future<ClosedCaptionFile>? closedCaptionFile;

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

  void initControllers() async {
    String videoUrl = streamData.streams[source];
    if (videoUrl.contains("magnet")) {
      videoUrl = await getMagnetUrls(videoUrl);
    }
    closedCaptionFile = streamData.captions != null
        ? loadCaptions(streamData.captions![source][0].file)
        : null;
    if (streamData.getHeaders(source) != null) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: streamData.getHeaders(source)!,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
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
    isInitialized = true;
    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(false);
    try {
      videoController.initialize().then((_) => setState(() {}));
    } catch (e) {
      showErrorDialog(context, exception: e.toString());
    }
    videoController.play();

    if (streamData.tracks != null /*&& audioStream != ""*/) {
      audioController.addListener(() {
        setState(() {});
      });
      videoController.setVolume(0);
      audioController.setLooping(false);
      audioController.initialize().then((_) => setState(() {}));
      audioController.play();
    }
  }

 

  Future<String> getMagnetUrls(String magnet) async {
    List<String?> urls = await torrentServer.getTorrentPlaylist(magnet, null);
    if (urls.length > 1){
      return urls[episode - 1] ?? ""; 
    }else{
      return urls[0] ?? "";
    }
  }

  Future<ClosedCaptionFile> loadCaptions(String url) async {
    if (url == "-1") {
      return WebVTTCaptionFile("");
    }
    if (!url.contains("opensubtitles")) {
      //anime website subtitles
      var response = await http.get(Uri.parse(url),
          headers: streamData.getHeaders(source));
      if (response.statusCode != 200) {
        if (context.mounted) {
          showErrorDialog(context, exception: null);
        }
        return WebVTTCaptionFile("");
      }
      var bytes = response.bodyBytes;
      String content = String.fromCharCodes(bytes);
      return WebVTTCaptionFile(formatCaptions(getUtf8Text(content)));
    } else {
      //opensubtitlesorg subtitles
      String content = await downloadExtractAndReadSrt(url) ?? "";
      return SubRipCaptionFile(content
          .replaceAll("<i>", "")
          .replaceAll("</i>", "")
          .replaceAll("{\\an8}", ""));
    }
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

  String getUtf8Text(String text) {
    List<int> bytes = text.codeUnits;
    return utf8.decode(bytes);
  }

  Future<String?> downloadExtractAndReadSrt(String url) async {
    var client = HttpClient();

    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.followRedirects = true;
    request.maxRedirects = 100;
    HttpClientResponse response = await request.close();
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print("error, code: ${response.statusCode}");
      return null;
    }
    // final archive = ZipDecoder().decodeBytes(response.bodyBytes);
    final archive = ZipDecoder()
        .decodeBytes(await consolidateHttpClientResponseBytes(response));

    for (final file in archive) {
      if (file.isFile && file.name.endsWith('.srt')) {
        Uint8List bytes = file.content as Uint8List;
        final srtContent =
            const Utf8Decoder(allowMalformed: false).convert(bytes);
        return srtContent;
      }
    }
    return null;
  }

  Future<Uint8List> consolidateHttpClientResponseBytes(
      HttpClientResponse response) async {
    final Completer<Uint8List> completer = Completer<Uint8List>();
    final List<List<int>> chunks = <List<int>>[];
    int contentLength = 0;

    response.listen(
      (List<int> chunk) {
        chunks.add(chunk);
        contentLength += chunk.length;
      },
      onDone: () {
        final Uint8List bytes = Uint8List(contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        completer.complete(bytes);
      },
      onError: completer.completeError,
      cancelOnError: true,
    );

    return completer.future;
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

  void changeSubTrack(int pos) async {
    // pause();
    if (!audioSeparate) return;
    audioController.dispose();
    if (streamData.getHeaders(source) != null) {
      audioController = VideoPlayerController.networkUrl(
        Uri.parse(streamData.tracks![source][pos].file),
        httpHeaders: streamData.getHeaders(source)!,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      audioController = VideoPlayerController.networkUrl(
        Uri.parse(streamData.tracks![source][pos].file),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }
    audioController.addListener(() {
      setState(() {});
    });
    audioController.setLooping(false);
    audioController.initialize().then((_) => setState(() {}));
    play();
    sync();
  }

  void setPlaybackSpeed(double newSpeed) {
    if (audioSeparate) {
      audioController.setPlaybackSpeed(newSpeed);
    }
    videoController.setPlaybackSpeed(newSpeed);
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

  void setCaptionsOffset(int duration) {
    videoController.setCaptionOffset(Duration(milliseconds: duration));
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

    if (difference.abs() > 2500 && difference != 0) {
      if (difference > 0) {
        //video waits (audio forward)
        audioController.seekTo(Duration(
            milliseconds: videoController.value.position.inMilliseconds));
        // videoController.pause();
        // await Future.delayed(Duration(milliseconds: difference.abs() + 100));
        // videoController.play();
      } else {
        //audio waits (audio backwards)
        videoController.seekTo(Duration(
            milliseconds: audioController.value.position.inMilliseconds));

        // audioController.pause();
        // await Future.delayed(Duration(milliseconds: difference.abs() + 100));
        // audioController.play();
      }
      return;
    }

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
