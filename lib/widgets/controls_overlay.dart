import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({super.key, 
    required this.controller,
    required this.onTap,
    required this.pausePeer,
    required this.playPeer,
    required this.peerPlus,
    required this.peerMinus,
    required this.paused,
    required this.delayedPaused,
  });

  final VideoPlayerController controller;
  final void Function() onTap;
  final void Function() pausePeer;
  final void Function() playPeer;
  final void Function() peerPlus;
  final void Function() peerMinus;
  final bool paused;
  final bool delayedPaused;

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
            if (widget.controller.value.isPlaying) {
              widget.onTap();
              widget.pausePeer();
              widget.controller.pause();
            }
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: widget.controller.value.isPlaying ? 0 : 1,
            child: Container(
              color: Colors.black26,
              child: Center(
                child: IgnorePointer(
                  ignoring: widget.controller.value.isPlaying,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (!widget.controller.value.isPlaying) {
                            widget.peerMinus();
                            widget.controller.seekTo(
                              Duration(
                                  milliseconds: widget.controller.value.position
                                          .inMilliseconds -
                                      15000),
                            );
                            widget.onTap();
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
                          if (!widget.controller.value.isPlaying) {
                            widget.onTap();
                            widget.playPeer();
                            widget.controller.play();
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
                          if (!widget.controller.value.isPlaying) {
                            widget.peerPlus();
                            widget.controller.seekTo(
                              Duration(
                                  milliseconds: widget.controller.value.position
                                          .inMilliseconds +
                                      15000),
                            );
                            widget.onTap();
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
