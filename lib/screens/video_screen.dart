import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.stream, this.captions});

  final String stream;
  final String? captions;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool paused = false;
  String? captions;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.stream,
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

  /*String replaceSecondAndGreater(String original, String pattern, String replacement) {
    int index = -1;
    int count = 0;

    while (true) {
      index = original.indexOf(pattern, index + 1);
      if (index == -1) {
        break;
      }
      count++;
      if (count >= 2) {
        original = original.replaceFirst(pattern, replacement, index);
      }
    }

    return original;
  }*/

  String formatCaptions(String captions) {
    // Split the captions into pieces based on empty lines
    List<String> pieces = captions.split('\n\n');
    List<String> formattedPieces = [];
    for(int i = 0; i < pieces.length; i++){
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

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  child: VideoPlayer(_controller),
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
                        onTap: () {
                          _hideControlsTimer?.cancel();
                          paused = !paused;
                          if (paused) {
                            _showControls = true;
                          } else {
                            _resetHideControlsTimer();
                          }
                        },
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
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (!fullScreen) {
                    _controller.dispose();
                    Navigator.pop(context);
                  }
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller, required this.onTap});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];
  final VideoPlayerController controller;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            onTap();
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
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
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;
  final double height;
  final void Function() switchFullScreen;

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
