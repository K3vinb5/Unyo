import 'dart:async';
import 'dart:convert';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/video/m_video_player.dart';
import 'package:unyo/widgets/widgets.dart';
// import 'package:video_player/video_player.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.source,
    required this.streamData,
    required this.updateEntry,
    required this.title,
    required this.mqqtKey,
    required this.episode,
    required this.timestamps,
  });

  final int source;
  final StreamData streamData;
  final void Function() updateEntry;
  final String title;
  final String mqqtKey;
  final int episode;
  final Map<String, double> timestamps;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late MixedController _mixedController;
  Timer? _hideControlsTimer;
  Timer? isVideoPlaying;
  bool _showControls = true;
  bool paused = false;
  String? captions;
  final FocusNode _screenFocusNode = FocusNode();
  final double captionsBorder = 2;
  bool keyDelay = false;
  bool hasTimestamps = false;

  @override
  void initState() {
    super.initState();
    _mixedController = MixedController(
      key: widget.mqqtKey,
      context: context,
      setState: setState,
      streamData: widget.streamData,
      source: widget.source,
      episode: widget.episode,
      updateEntry: widget.updateEntry,
      cancelTimers: cancelTimers,
      resetHideControlsTimer: _resetHideControlsTimer,
      controlsOverlayOnTap: controlsOverlayOnTap,
    );
    _mixedController.init();
    setIsvideoPlayingTimer();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
    hasTimestamps =
        widget.timestamps["start"] != -1 && widget.timestamps["end"] != -1;
  }

  @override
  void dispose() {
    super.dispose();
    _hideControlsTimer?.cancel();
    isVideoPlaying?.cancel();
    _mixedController.dispose();
  }

  void cancelTimers() {
    _hideControlsTimer?.cancel();
    isVideoPlaying?.cancel();
  }

  String getUtf8Text(String text) {
    List<int> bytes = text.codeUnits;
    return utf8.decode(bytes);
  }

  void controlsOverlayOnTap() {
    _hideControlsTimer?.cancel();
    paused = !paused;
    if (paused) {
      _showControls = true;
    } else {
      _resetHideControlsTimer();
    }
  }

  void interactScreen(bool keepOn) async {
    await DesktopKeepScreenOn.setPreventSleep(keepOn);
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _showControls = true;
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      setState(() {
        if (!paused) {
          _showControls = false;
        }
      });
    });
  }

  void setIsvideoPlayingTimer() {
    if (!_mixedController.isInitialized) {
      isVideoPlaying = Timer(Duration.zero, () {});
      return;
    }
    isVideoPlaying = Timer(const Duration(seconds: 5), () {
      if (_mixedController.videoController.value.duration.inSeconds == 0) {
        showErrorDialog(
          context,
          exception:
              "An error occured, try using another source or server/quality",
          onPressedAfterPop: () {
            _mixedController.canDispose = true;
            _hideControlsTimer?.cancel();
            isVideoPlaying?.cancel();
            _mixedController.dispose();
            Window.exitFullscreen();
            interactScreen(false);
            Navigator.pop(context);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: KeyboardListener(
        focusNode: _screenFocusNode,
        onKeyEvent: (keyEnvent) {
          if (keyDelay) {
            return;
          }
          keyDelay = true;
          Timer(
            const Duration(milliseconds: 200),
            () {
              keyDelay = false;
            },
          );
          _mixedController.mqqtController.onReceivedKeys(keyEnvent.logicalKey);
        },
        child: Center(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              MouseRegion(
                onHover: (event) {
                  // print("hover");
                  _resetHideControlsTimer();
                },
                cursor: _showControls
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.none,
                child: _mixedController.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child:
                                VideoPlayer(_mixedController.videoController),
                          ),
                          VideoSubtitles(mixedController: _mixedController),
                          //Overlay controls, and slider
                          StyledVideoPlaybackControls(
                            controlsOverlayOnTap: controlsOverlayOnTap,
                            showControls: _showControls,
                            paused: paused,
                            source: widget.source,
                            mixedController: _mixedController,
                            hasTimestamps: hasTimestamps,
                            timestamps: widget.timestamps,
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.inkDrop(
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              context.tr("video_loading"),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ),
              //Video Header (top)
              VideoOverlayHeaderWidget(
                  showControls: _showControls,
                  title: widget.title,
                  mixedController: _mixedController,
                  cancelTimers: cancelTimers,
                  updateEntry: widget.updateEntry),
              !fullScreen
                  ? const WindowBarButtons(startIgnoreWidth: 70)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
