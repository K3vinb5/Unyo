import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({super.key, 
    required this.mixedControllers,
    required this.onTap,
    required this.paused,
  });

  final MixedController mixedControllers;
  final void Function() onTap;
  final bool paused;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late bool isPaused;

  @override
  void initState() {
    super.initState();
    isPaused = widget.paused;
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 400), // Adjust the duration as needed
    );
    _controller.value = 0.0;
    _controller.animateTo(1.0);
  }

  @override
  void didUpdateWidget(covariant ControlsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paused != widget.paused) {
      _controller.stop();
      isPaused = !isPaused;
      print("isPaused: $isPaused");
      if (isPaused) {
        _controller.value = 1.0;
        _controller.animateTo(0.0);
      } else {
        _controller.value = 0.0;
        _controller.animateTo(1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.mixedControllers.isPlaying) {
              widget.onTap();
              widget.mixedControllers.pause(sendCommand: true);
            }
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: widget.mixedControllers.isPlaying ? 0 : 1,
            child: Container(
              color: Colors.black26,
              child: Center(
                child: IgnorePointer(
                  ignoring: widget.mixedControllers.isPlaying,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (!widget.mixedControllers.isPlaying) {
                            widget.mixedControllers.mqqtController.sendOrder("fifteenminus");
                            widget.mixedControllers.seekTo(
                              Duration(
                                  milliseconds: widget.mixedControllers.videoController.value.position
                                          .inMilliseconds -
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
                      InkWell(
                        onTap: () {
                          if (!widget.mixedControllers.isPlaying) {
                            widget.onTap();
                            widget.mixedControllers.play(sendCommand: true);
                          }
                        },
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          size: 100,
                          color: Colors.white,
                          progress: _controller,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          if (!widget.mixedControllers.isPlaying) {
                            widget.mixedControllers.mqqtController.sendOrder("fifteenplus");
                            widget.mixedControllers.seekTo(
                              Duration(
                                  milliseconds: widget.mixedControllers.videoController.value.position
                                          .inMilliseconds +
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
          ),
        ),
      ],
    );
  }
}
