import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen(
      {super.key,
      required this.stream,
      required this.updateEntry,
      this.captions});

  final String stream;
  final String? captions;
  final void Function() updateEntry;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool paused = false;
  String? captions;
  bool soundIsHovered = false;
  final FocusNode _screenFocusNode = FocusNode();
  bool keyDelay = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.stream),
      closedCaptionFile:
          widget.captions != null ? loadCaptions(widget.captions!) : null,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
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
  
  void controlsOverlayOnTap(){
  _hideControlsTimer?.cancel();
  paused = !paused;
  if (paused) {
  _showControls = true;
  } else {
  _resetHideControlsTimer();
  }
}
  
  void onEnterSound() {
    setState(() {
      soundIsHovered = true;
    });
  }

  void onExitSound() {
    Timer(
      const Duration(seconds: 2),
      () {
        setState(() {
          soundIsHovered = false;
        });
      },
    );
  }

  void interactScreen(bool keepOn) async {
    await DesktopKeepScreenOn.setPreventSleep(keepOn);
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

  Future<ClosedCaptionFile> loadCaptions(String url) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String content = String.fromCharCodes(bytes);
      return WebVTTCaptionFile(formatCaptions(content));
    } catch (error) {
      print("Error downloading captions");
    }
    print("Empty");
    return WebVTTCaptionFile("");
  }

  void _resetHideControlsTimer() {
    if (!paused) {
      _hideControlsTimer?.cancel();
      _showControls = true;
      _hideControlsTimer = Timer(const Duration(seconds: 4), () {
        setState(() {
          _showControls = false;
        });
      });
    }
  }

  double calculatePercentage() {
    return (_controller.value.position.inMilliseconds /
        _controller.value.duration.inMilliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: KeyboardListener(
        focusNode: _screenFocusNode,
        onKeyEvent: (keyEnvent) {
          if(keyDelay){
            return;
          }
          keyDelay = true;
          Timer(const Duration(milliseconds: 200), () {
            keyDelay = false;
          },);
          //print("Logical: ${keyEnvent.logicalKey}");
          switch(keyEnvent.logicalKey){
            case LogicalKeyboardKey.space:
              if (!_controller.value.isPlaying) {
                controlsOverlayOnTap();
                _controller.play();
              }else{
                controlsOverlayOnTap();
                _controller.pause();
              }
              break;
            case LogicalKeyboardKey.arrowLeft:
              _controller.seekTo(
                Duration(
                    milliseconds: _controller
                        .value.position.inMilliseconds -
                        5000),
              );

              break;
            case LogicalKeyboardKey.arrowRight:
              _controller.seekTo(
                Duration(
                    milliseconds: _controller
                        .value.position.inMilliseconds +
                        5000),
              );
              break;
            case LogicalKeyboardKey.arrowUp:
              _controller.setVolume(min(_controller.value.volume + 0.1 ,1));
              break;
            case LogicalKeyboardKey.arrowDown:
              _controller.setVolume(max(_controller.value.volume - 0.1 ,0));
              break;
            case LogicalKeyboardKey.keyL:
              _controller.seekTo(
                Duration(
                    milliseconds: _controller
                        .value.position.inMilliseconds +
                        15000),
              );
              break;
            case LogicalKeyboardKey.keyJ:
              _controller.seekTo(
                Duration(
                    milliseconds: _controller
                        .value.position.inMilliseconds -
                        15000),
              );
              break;
            case LogicalKeyboardKey.keyK:
              if (!_controller.value.isPlaying) {
                controlsOverlayOnTap();
                _controller.play();
              }else{
                controlsOverlayOnTap();
                _controller.pause();
              }
              break;
            case LogicalKeyboardKey.escape:
              _controller.dispose();
              interactScreen(false);
              print(calculatePercentage());
              if (calculatePercentage() > 0.8) {
                widget.updateEntry();
              }
              Navigator.pop(context);
              break;
            default:
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  MouseRegion(
                    onHover: (event) {
                      _resetHideControlsTimer();
                    },
                    cursor: _showControls
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.none,
                    child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(_controller)),
                  ),
                  ClosedCaption(
                    text: _controller.value.caption.text,
                  ),
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        _ControlsOverlay(
                          controller: _controller,
                          onTap: controlsOverlayOnTap,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width - 140,
                              bottom: 35),
                          child: SizedBox(
                            height: 100,
                            child: AnimatedOpacity(
                              opacity: soundIsHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Visibility(
                                visible: soundIsHovered,
                                maintainSize: false,
                                maintainState: true,
                                maintainAnimation: true,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Slider(
                                    activeColor: Colors.white,
                                    min: 0,
                                    max: 1,
                                    value: _controller.value.volume,
                                    onChanged: (value) =>
                                        _controller.setVolume(value),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SmoothVideoProgress(
                          controller: _controller,
                          builder: (context, progress, duration, child) {
                            return _VideoProgressSlider(
                              controller: _controller,
                              height: 40,
                              switchFullScreen: () {
                                setState(
                                  () {
                                    fullScreen = !fullScreen;
                                  },
                                );
                              },
                              position: progress,
                              duration: duration,
                              swatch: Colors.red,
                              onEnter: onEnterSound,
                              onExit: onExitSound,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedOpacity(
                opacity: !fullScreen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: FocusScope(
                  canRequestFocus: false,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (!fullScreen) {
                        _controller.dispose();
                        interactScreen(false);
                        print(calculatePercentage());
                        if (calculatePercentage() > 0.8) {
                          widget.updateEntry();
                        }
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
      ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller, required this.onTap});

  final VideoPlayerController controller;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              onTap();
              controller.pause();
            }
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 800),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (!controller.value.isPlaying) {
                              controller.seekTo(
                                Duration(
                                    milliseconds: controller
                                            .value.position.inMilliseconds -
                                        15000),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.fast_rewind_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            if (!controller.value.isPlaying) {
                              onTap();
                              controller.play();
                            }
                          },
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 100.0,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            if (!controller.value.isPlaying) {
                              controller.seekTo(
                                Duration(
                                    milliseconds: controller
                                            .value.position.inMilliseconds +
                                        15000),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.fast_forward_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _VideoProgressSlider extends StatelessWidget {
  const _VideoProgressSlider({
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
    required this.height,
    required this.switchFullScreen,
    required this.onEnter,
    required this.onExit,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;
  final double height;
  final void Function() switchFullScreen;
  final void Function() onEnter;
  final void Function() onExit;

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: swatch),
        useMaterial3: true,
      ),
      child: SizedBox(
        height: height, // Adjust this value as needed
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return Text(
                  controller.value.position.toString().substring(0, 7),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                );
              },
              valueListenable: controller,
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: max,
                value: value,
                onChanged: (value) =>
                    controller.seekTo(Duration(milliseconds: value.toInt())),
                onChangeStart: (_) => controller.pause(),
                onChangeEnd: (_) => controller.play(),
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                onEnter();
              },
              onExit: (_) {
                onExit();
              },
              child: IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                onPressed: () {
                  //TODO mute / unmute
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  fullScreen = !fullScreen;
                  if (fullScreen) {
                    WindowManager.instance.setFullScreen(true);
                  } else {
                    WindowManager.instance.setFullScreen(false);
                  }
                },
                icon: const Icon(Icons.fullscreen),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
