import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

void Function()? onEnterSound;
void Function()? onExitSound;

class AudioSliderWidget extends StatefulWidget {
  const AudioSliderWidget({super.key, required this.mixedController});

  final MixedController mixedController;

  @override
  State<AudioSliderWidget> createState() => _AudioSliderWidgetState();
}

class _AudioSliderWidgetState extends State<AudioSliderWidget> {
  Timer soundIsHoveredTimer = Timer(
    Duration.zero,
    () {},
  );
  bool soundIsHovered = false;

  @override
  void initState() {
    super.initState();
    onEnterSound = () {
      setState(() {
        soundIsHovered = true;
      });
    };
    onExitSound = () {
      soundIsHoveredTimer = Timer(
        const Duration(milliseconds: 500),
        () {
          setState(() {
            soundIsHovered = false;
          });
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width - 140, bottom: 35),
      child: SizedBox(
        height: 100,
        child: AnimatedOpacity(
          opacity: soundIsHovered ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: MouseRegion(
            onEnter: (_) {
              soundIsHoveredTimer.cancel();
              soundIsHovered = true;
            },
            onExit: (_) {
              soundIsHoveredTimer = Timer(
                const Duration(milliseconds: 500),
                () {
                  setState(() {
                    soundIsHovered = false;
                  });
                },
              );
            },
            child: Visibility(
              visible: soundIsHovered,
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              child: RotatedBox(
                quarterTurns: 3,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors
                          .black, // Changes the text color inside the label
                    ),
                  ),
                  child: Slider(
                    activeColor: Colors.white,
                    min: 0,
                    max: 1,
                    value: widget.mixedController.audioController.value.volume,
                    label: "${(widget.mixedController.audioController.value.volume * 100)
                        .toInt().toString()}%",
                    divisions: 100,
                    onChanged: (value) =>
                        widget.mixedController.setVolume(value),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
