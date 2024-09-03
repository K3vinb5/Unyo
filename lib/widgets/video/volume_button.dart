import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

class VolumeButton extends StatefulWidget {
  final MixedController controller;

  const VolumeButton({
    super.key,
    required this.controller,
  });

  @override
  CustomMaterialDesktopVolumeButtonState createState() =>
      CustomMaterialDesktopVolumeButtonState();
}

class CustomMaterialDesktopVolumeButtonState extends State<VolumeButton>
    with SingleTickerProviderStateMixin {
  bool hover = false;

  bool mute = false;
  double _volume = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    double volume = widget.controller.audioController.value.volume;
    return MouseRegion(
      onEnter: (e) {
        setState(() {
          hover = true;
        });
      },
      onExit: (e) {
        setState(() {
          hover = false;
        });
      },
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            if (event.scrollDelta.dy < 0) {
              widget.controller.setVolume(
                (volume + 0.1).clamp(0.0, 1.0),
              );
            }
            if (event.scrollDelta.dy > 0) {
              widget.controller.setVolume(
                (volume - 0.1).clamp(0.0, 1.0),
              );
            }
          }
        },
        child: Row(
          children: [
            const SizedBox(width: 4.0),
            IconButton(
              onPressed: () async {
                if (mute) {
                  /*await*/ widget.controller.setVolume(_volume);
                  mute = !mute;
                }
                // https://github.com/media-kit/media-kit/pull/250#issuecomment-1605588306
                else if (volume == 0.0) {
                  _volume = 1.0;
                  /*await*/ widget.controller.setVolume(1.0);
                  mute = false;
                } else {
                  _volume = volume;
                  /*await*/ widget.controller.setVolume(0.0);
                  mute = !mute;
                }

                setState(() {});
              },
              iconSize: 25,
              color: Colors.white,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: volume == 0.0
                    ? const Icon(
                        Icons.volume_off,
                        key: ValueKey(Icons.volume_off_rounded),
                      )
                    : volume < 0.5
                        ? const Icon(
                            Icons.volume_down,
                            key: ValueKey(Icons.volume_down_rounded),
                          )
                        : const Icon(
                            Icons.volume_up,
                            key: ValueKey(Icons.volume_up_rounded),
                          ),
              ),
            ),
            AnimatedOpacity(
              opacity: hover ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: AnimatedContainer(
                width: hover ? (12.0 + 52.0 + 18.0) : 12.0,
                duration: const Duration(milliseconds: 150),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      SizedBox(
                        width: 50.0,
                        child: SliderTheme(
                          data: SliderThemeData(
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            trackHeight: 1.2,
                            inactiveTrackColor: const Color(0x3DFFFFFF),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                              elevation: 0.0,
                              pressedElevation: 0.0,
                            ),
                            trackShape: _CustomTrackShape(),
                            overlayColor: const Color(0x00000000),
                          ),
                          child: Slider(
                              activeColor: Colors.white,
                              min: 0,
                              max: 1,
                              value: widget
                                  .controller.audioController.value.volume,
                              label:
                                  "${(widget.controller.audioController.value.volume * 100).toInt().toString()}%",
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  mute = false;
                                  widget.controller.setVolume(value);
                                });
                              }),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight;
    final left = offset.dx;
    final top = offset.dy + (parentBox.size.height - height!) / 2;
    final width = parentBox.size.width;
    return Rect.fromLTWH(
      left,
      top,
      width,
      height,
    );
  }
}
