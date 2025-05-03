import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/mdk.dart' as mdk;

class VideoPlayerController extends ChangeNotifier {
  VideoPlayerController(this.videoUrl,
      {this.closedCaptionFile, this.httpHeaders});

  factory VideoPlayerController.networkUrl(String url,
      {ClosedCaptionFile? closedCaptionFile,
      Map<String, String>? httpHeaders}) {
    VideoPlayerController controller = VideoPlayerController(
      url,
      closedCaptionFile: closedCaptionFile,
      httpHeaders: httpHeaders,
    );
    return controller;
  }

  final String videoUrl;
  final ClosedCaptionFile? closedCaptionFile;
  final Map<String, String>? httpHeaders;

  late final player = mdk.Player();
  late Timer timer;
  late final VideoPlayerValue value;

  Future<void> initialize() async {
    //video url
    player.media = videoUrl;
    setHttpHeaders(httpHeaders);
    //No loop
    player.loop = 0;
    //Start paused
    player.state = mdk.PlaybackState.paused;

    VideoCaptionFile caption =
        VideoCaptionFile(player: player, closedCaptionFile: closedCaptionFile);
    caption.init();
    value = VideoPlayerValue(player: player, caption: caption);
    mdk.setLogHandler(logHandler);
    _startNotifyingTimer();
  }

  void _startNotifyingTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      notifyListeners();
    });
  }

  void logHandler(mdk.LogLevel level, String message){
    if (!message.contains("unloaded media's position")) {
      print("Mdk Log: $message");
    }
  }

  void setHttpHeaders(Map<String, String>? httpHeaders) {
  if (httpHeaders != null && httpHeaders.isNotEmpty) {
    final headers = httpHeaders.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\r\n');

    player.setProperty('avio.headers', headers);
    player.setProperty('headers', headers);
    player.setProperty('avformat.extension_picky', '0');
  }
}

  void play() {
    player.state = mdk.PlaybackState.playing;
    notifyListeners();
  }

  void pause() {
    player.state = mdk.PlaybackState.paused;
    notifyListeners();
  }

  void setLooping(bool loop) {
    loop ? player.loop = -1 : player.loop = 0;
  }

  void setVolume(double volume) {
    player.volume = volume;
  }

  void setPlaybackSpeed(double newPlayBackSpeed) {
    player.playbackRate = newPlayBackSpeed;
    // notifyListeners();
  }

  void seekTo(Duration newDuration) {
    player.seek(position: newDuration.inMilliseconds);
    notifyListeners();
  }

  void setClosedCaptionFile(ClosedCaptionFile? newClosedCaptionFile) {
    value.setNewCaptionFile(newClosedCaptionFile);
  }

  void setCaptionOffset(Duration duration) {
    throw UnimplementedError("Captionoffset not yet implemented");
  }

  String get dataSource => player.media;

  @override
  void dispose() {
    try {
      Future.delayed(Duration.zero, () {
        timer.cancel();
        player.dispose();
        super.dispose();
      });
    } catch (e) {
      print("error: $e");
    }
  }
}

class VideoPlayerValue {
  final mdk.Player player;
  final VideoCaptionFile caption;

  VideoPlayerValue({required this.player, required this.caption});

  /// Preserve native video ratio from the first video track.
  double get aspectRatio {
    final streams = player.mediaInfo.video;
    if (streams != null && streams.isNotEmpty) {
      final codec = streams.first.codec;
      // codec.width and codec.height are ints
      return codec.width / codec.height;
    }
    return 16 / 9;
  }

  Duration get position => Duration(milliseconds: player.position);

  Duration get duration => Duration(milliseconds: player.mediaInfo.duration);

  double get volume => player.volume;

  bool get isPlaying => player.state == mdk.PlaybackState.playing;

  void setNewCaptionFile(ClosedCaptionFile? newClosedCaptionFile) {
    caption.setNewCaptionFile(newClosedCaptionFile);
  }
}

class VideoCaptionFile {
  final mdk.Player player;
  final ClosedCaptionFile? closedCaptionFile;
  late List<Caption> captions;

  // String text = "";

  VideoCaptionFile({required this.player, required this.closedCaptionFile});

  void init() {
    captions = closedCaptionFile?.captions ?? [];
  }

  String get text {
    int currentMilliseconds = player.position;
    for (Caption caption in captions) {
      if (caption.start.inMilliseconds <= currentMilliseconds &&
          caption.end.inMilliseconds >= currentMilliseconds) {
        return caption.text;
      }
    }
    return "";
  }

  void setNewCaptionFile(ClosedCaptionFile? newClosedCaptionFile) {
    captions = newClosedCaptionFile?.captions ?? [];
  }
}
