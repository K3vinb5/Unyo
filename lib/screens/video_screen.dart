import 'dart:async';
import 'dart:convert';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:flutter/material.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.source,
    required this.streamData,
    required this.updateEntry,
    required this.title,
  });

  final int source;
  final StreamData streamData;
  final void Function() updateEntry;
  final String title;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late MixedController _mixedController;
  Timer? _hideControlsTimer;
  late Timer isVideoPlaying;
  bool _showControls = true;
  bool paused = false;
  bool delayedPaused = false;
  String? captions;
  final FocusNode _screenFocusNode = FocusNode();
  final double captionsBorder = 2;
  bool keyDelay = false;

  @override
  void initState() {
    super.initState();
    _mixedController = MixedController(
      key: widget.title,
      context: context,
      setState: setState,
      streamData: widget.streamData,
      source: widget.source,
      updateEntry: widget.updateEntry,
      resetHideControlsTimer: _resetHideControlsTimer,
      controlsOverlayOnTap: controlsOverlayOnTap,
    );
    _mixedController.init();
    setIsvideoPlayingTimer();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _mixedController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  String getUtf8Text(String text) {
    List<int> bytes = text.codeUnits;
    return utf8.decode(bytes);
  }

  void controlsOverlayOnTap() {
    _hideControlsTimer?.cancel();
    paused = !paused;
    Timer(const Duration(milliseconds: 300),
        () => delayedPaused = !delayedPaused);
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
    isVideoPlaying = Timer(const Duration(seconds: 5), () {
      if (_mixedController.videoController.value.duration.inSeconds == 0) {
        showErrorDialog(
          context,
          exception:
              "An error occured, try using another source or server/quality",
          onPressedAfterPop: () {
            _mixedController.dispose();
            WindowManager.instance.setFullScreen(false);
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
                  _resetHideControlsTimer();
                },
                cursor: _showControls
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.none,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.streamData.tracks != null)
                      VideoPlayer(_mixedController.audioController),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(_mixedController.videoController),
                    ),
                    VideoSubtitles(mixedController: _mixedController),
                    //Overlay controls, and slider
                    StyledVideoPlaybackControls(
                      controlsOverlayOnTap: controlsOverlayOnTap,
                      showControls: _showControls,
                      paused: paused,
                      source: widget.source,
                      delayedPaused: delayedPaused,
                      mixedController: _mixedController,
                    ),
                  ],
                ),
              ),
              //Video Header (top)
              VideoOverlayHeaderWidget(
                  showControls: _showControls,
                  title: widget.title,
                  mixedController: _mixedController,
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
