import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class StyledVideoPlaybackControls extends StatelessWidget {
  const StyledVideoPlaybackControls({
    super.key,
    required this.controlsOverlayOnTap,
    required this.showControls,
    required this.paused,
    required this.mixedController,
    required this.source,
    required this.hasTimestamps,
    required this.timestamps,
  });

  /// Called when either the overlay or slider is tapped.
  final VoidCallback controlsOverlayOnTap;

  /// Whether to fade in (true) or fade out (false) the controls.
  final bool showControls;

  /// Whether playback is paused (true) or playing (false).
  final bool paused;

  /// The controller that holds both video and volume logic.
  final MixedController mixedController;

  /// Source identifier (e.g. local vs remote).
  final int source;

  /// If true, show markers on the progress slider.
  final bool hasTimestamps;

  /// Map of label→position (in seconds) for those markers.
  final Map<String, double> timestamps;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The big play/pause/replay overlay:
          ControlsOverlay(
            mixedControllers: mixedController,
            paused: paused,
            onTap: controlsOverlayOnTap,
          ),

          // The progress slider at the bottom:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: VideoProgressSlider(
              mixedController: mixedController,
              source: source,
              position: mixedController.videoController.value.position,
              duration: mixedController.videoController.value.duration,
              onTap: controlsOverlayOnTap,
              hasTimeStamps: hasTimestamps,
              timestamps: timestamps,
            ),
          ),
        ],
      ),
    );
  }
}
