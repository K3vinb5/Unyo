import 'dart:async';

import 'package:video_player/video_player.dart';

class MixedControllers {
  MixedControllers(this.audio,
      {required this.videoController, required this.audioController});
  final VideoPlayerController videoController;
  final VideoPlayerController audioController;
  final bool audio;
  late Timer syncTimer;
  bool firstInit = true;

  void init() {
    if (!audio) return;
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

  void play() {
    videoController.play();
    if (audio) {
      audioController.play();
    }
  }

  void pause() {
    videoController.pause();
    if (audio) {
      audioController.pause();
    }
  }

  void seekTo(Duration duration) {
    videoController.seekTo(duration);
    if (audio) {
      audioController.seekTo(duration);
      init();
    }
  }

  void setVolume(double n) {
    videoController.setVolume(n);
    if (audio) {
      audioController.setVolume(n);
    }
  }

  void dispose() {
    if (audio) {
      syncTimer.cancel();
    }
  }

  void syncControllers() async {
    int difference = (videoController.value.position.inMilliseconds -
        audioController.value.position.inMilliseconds);

    print("Difference: ${difference.abs()}");

    if (difference.abs() < 200 && difference != 0) {
      syncTimer.cancel();
      return;
    }

    // audioCotrller.seekTo(Duration(milliseconds: audioCotrller.value.position.inMilliseconds + difference));
    // videoController.seekTo(Duration(milliseconds: videoController.value.position.inMilliseconds - difference));
    if (difference > 0) {
      //video waits (audio forward)
      videoController.pause();
      await Future.delayed(Duration(milliseconds: difference.abs() + 100));
      // audioController.seekTo(Duration(
      //     milliseconds:
      //         audioController.value.position.inMilliseconds + difference));
      videoController.play();

      // print("wait video");
    } else {
      //audio waits (audio backwards)
      audioController.pause();
      await Future.delayed(Duration(milliseconds: difference.abs() + 100));
      // videoController.seekTo(Duration(
      //     milliseconds:
      //         audioController.value.position.inMilliseconds + difference));
      audioController.play();

      // print("audio waits");
    }
  }
}
