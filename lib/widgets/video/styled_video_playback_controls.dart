import 'package:flutter/material.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:unyo/screens/video_screen.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class StyledVideoPlaybackControls extends StatefulWidget {
  const StyledVideoPlaybackControls(
      {super.key,
      required this.controlsOverlayOnTap,
      required this.showControls,
      required this.paused,
      required this.delayedPaused,
      required this.mixedController, 
      required this.streamData,
      required this.source,
      });

  final void Function() controlsOverlayOnTap;
  final StreamData streamData;
  final int source;
  final MixedController mixedController;
  final bool showControls;
  final bool paused;
  final bool delayedPaused;

  @override
  State<StyledVideoPlaybackControls> createState() =>
      _StyledVideoPlaybackControlsState();
}

class _StyledVideoPlaybackControlsState
    extends State<StyledVideoPlaybackControls> {
  late bool showControls;
  late bool paused;
  late bool delayedPaused;

  @override
  void initState() {
    super.initState();
    showControls = widget.showControls;
    paused = widget.paused;
    delayedPaused = widget.delayedPaused;
  }

  @override
  void didUpdateWidget(covariant StyledVideoPlaybackControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showControls != widget.showControls) {
      showControls = widget.showControls;
    } else if (oldWidget.paused != widget.paused) {
      paused = widget.paused;
    } else if (oldWidget.delayedPaused != widget.delayedPaused) {
      delayedPaused = widget.delayedPaused;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ControlsOverlay(
            mixedControllers: widget.mixedController,
            paused: paused,
            delayedPaused: delayedPaused,
            onTap: widget.controlsOverlayOnTap,
          ),
          AudioSliderWidget(mixedController: widget.mixedController),
          SmoothVideoProgress(
            controller: widget.mixedController.videoController,
            builder: (context, progress, duration, child) {
              return VideoProgressSlider(
                mixedController: widget.mixedController,
                switchFullScreen: () {
                  setState(
                    () {
                      fullScreen = !fullScreen;
                    },
                  );
                },
                streamData: widget.streamData,
                source: widget.source,
                position: progress,
                duration: duration,
                onTap: widget.controlsOverlayOnTap,
              );
            },
          ),
        ],
      ),
    );
  }
}
