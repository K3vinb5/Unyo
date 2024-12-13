import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:fvp/mdk.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/util/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/widgets/video/m_video_player_controller.dart' as my;

class MixedController {
  MixedController({
    required this.controlsOverlayOnTap,
    required this.resetHideControlsTimer,
    required this.updateEntry,
    required this.cancelTimers,
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
  final void Function() cancelTimers;
  final void Function(void Function()) setState;

  late Timer syncTimer;
  late MqqtClientController mqqtController;
  late my.VideoPlayerController videoController;
  late bool audioSeparate;

  bool isPlaying = true;
  bool firstInit = true;
  bool isInitialized = false;
  bool canDispose = false;
  bool disposed = false;
  Future<ClosedCaptionFile>? closedCaptionFile;

  void init() {
    initControllers();
    audioSeparate = streamData.tracks != null;
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
    loadCaptions(streamData.captions[source][0].file);
    if (streamData.getHeaders(source) != null) {
      videoController = my.VideoPlayerController.networkUrl(
        videoUrl,
        httpHeaders: streamData.getHeaders(source)!,
        closedCaptionFile: await closedCaptionFile,
      );
    } else {
      videoController = my.VideoPlayerController.networkUrl(
        videoUrl,
        closedCaptionFile: await closedCaptionFile,
      );
    }
    isInitialized = true;
    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(false);
    try {
      videoController.initialize().then((_) => setState(() {}));
    } catch (e) {
      if (!context.mounted) return;
      showErrorDialog(context, exception: e.toString());
    }
    videoController.play();

    if (streamData.tracks != null) {
      videoController.setVolume(0);
      changeSubTrack(0);
    }
    initEmbeddedCaptionsAndSubtracks();
  }

  Future<void> initEmbeddedCaptionsAndSubtracks() async {
    if (canDispose) return; // Check if we can dispose

    if (videoController.value.position.inMilliseconds == 0) {
      await Future.delayed(const Duration(seconds: 2));
      if (canDispose) return; // Check again after delay
      initEmbeddedCaptionsAndSubtracks();
      return;
    }

    if (videoController.player.mediaInfo.subtitle != null &&
        videoController.player.mediaInfo.subtitle!.isNotEmpty) {
      for (int j = 0;
          j < videoController.player.mediaInfo.subtitle!.length;
          j++) {
        if (canDispose) return; // Check if we can dispose
        for (List<CaptionData> listCaptions in streamData.captions) {
          if (canDispose) return; // Check if we can dispose
          SubtitleStreamInfo subtitle =
              videoController.player.mediaInfo.subtitle![j];
          listCaptions.add(CaptionData(
            file: "",
            lang:
                "${subtitle.metadata["title"] ?? ""} (${subtitle.metadata["language"]} - Embedded)",
            embedded: true,
            index: j,
          ));
        }
      }
    }

    if (videoController.player.mediaInfo.audio != null &&
        videoController.player.mediaInfo.audio!.length > 1) {
      streamData.tracks ??= [];
      for (int i = 0; i < streamData.captions.length; i++) {
        if (canDispose) return; // Check if we can dispose
        List<TrackData> newAudios = [];
        for (int j = 0;
            j < videoController.player.mediaInfo.audio!.length;
            j++) {
          if (canDispose) return; // Check if we can dispose
          AudioStreamInfo audio = videoController.player.mediaInfo.audio![j];
          newAudios.add(TrackData(
            file: "",
            lang:
                "${audio.metadata["title"] ?? ""} (${audio.metadata["language"]} - Embedded)",
            embedded: true,
            index: j,
          ));
        }
        streamData.tracks!.add(newAudios);
      }
    }
    canDispose = true; // Set canDispose to true when done
  }

  Future<String> getMagnetUrls(String magnet) async {
    List<String?> urls = await torrentServer.getTorrentPlaylist(magnet, null);
    if (urls.length > 1) {
      return urls[episode - 1] ?? "";
    } else {
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

  void changeCaption(int pos) async {
    if (streamData.captions[source][pos].embedded != null &&
        streamData.captions[source][pos].embedded!) {
      videoController.player.activeSubtitleTracks = [
        streamData.captions[source][pos].index!
      ];
      print(streamData.captions[source][pos].index!);
      videoController.setClosedCaptionFile(null);
      return;
    }
    videoController.player.activeSubtitleTracks = [-1];
    Future<ClosedCaptionFile>? newClosedCaptionFile =
        loadCaptions(streamData.captions[source][pos].file);
    videoController.setClosedCaptionFile(await newClosedCaptionFile);
  }

  void changeSubTrack(int pos) async {
    // pause();
    if (streamData.tracks![source][pos].embedded != null &&
        streamData.tracks![source][pos].embedded!) {
      videoController.player.activeAudioTracks = [
        streamData.tracks![source][pos].index!
      ];
      return;
    }

    if (!audioSeparate) return;
    videoController.player
        .setMedia(streamData.tracks![source][pos].file, MediaType.audio);
    play();
  }

  void setPlaybackSpeed(double newSpeed) {
    videoController.setPlaybackSpeed(newSpeed);
  }

  void play({bool? sendCommand}) {
    isPlaying = true;
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
    videoController.pause();
    if (sendCommand != null && sendCommand) {
      mqqtController.sendOrder("pause");
    }
  }

  void seekTo(Duration duration, {bool? sendCommand, double? time}) {
    videoController.seekTo(duration);
    if (sendCommand != null && time != null && sendCommand) {
      mqqtController.sendOrder("seekTo:$time");
    }
  }

  void setVolume(double n) {
    videoController.setVolume(n);
  }

  void dispose() {
    if (disposed) return;
    videoController.removeListener(() {
      setState(() {});
    });
    videoController.dispose();
    if (mqqtController.connected) {
      mqqtController.client.disconnect();
    }
    disposed = true;
  }
}
