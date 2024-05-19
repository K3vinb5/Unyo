import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

import '../screens/video_screen.dart';

class VideoProgressSlider extends StatelessWidget {
  VideoProgressSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
    required this.height,
    required this.switchFullScreen,
    required this.onEnter,
    required this.onExit,
    required this.connectToPeer,
    required this.seekToPeer,
    required this.topic,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;
  final double height;
  final void Function() switchFullScreen;
  final void Function() onEnter;
  final void Function() onExit;

  final String topic;
  final void Function(String) connectToPeer;
  final void Function(double) seekToPeer;
  final TextEditingController textFieldcontroller = TextEditingController();

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
                onChanged: (value) {
                  controller.seekTo(Duration(milliseconds: value.toInt()));
                },
                onChangeEnd: (_) {
                  seekToPeer(
                      controller.value.position.inMilliseconds.toDouble());
                },
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.people,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Watch 2gether",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText("Your Id:\n$topic",
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Please paste your buddys peerId",
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: textFieldcontroller,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor:
                                          MaterialStatePropertyAll(
                                            Color.fromARGB(255, 37, 37, 37),
                                          ),
                                          foregroundColor:
                                          MaterialStatePropertyAll(
                                            Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          connectToPeer(
                                              textFieldcontroller.text);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Confirm",
                                            style:
                                            TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor:
                                          MaterialStatePropertyAll(
                                            Color.fromARGB(255, 37, 37, 37),
                                          ),
                                          foregroundColor:
                                          MaterialStatePropertyAll(
                                            Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel",
                                            style:
                                            TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
