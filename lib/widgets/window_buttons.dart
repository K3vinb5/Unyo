import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.grey,
            normal: Colors.transparent,
            mouseOver: const Color.fromARGB(60, 0, 0, 0),
            mouseDown: const Color.fromARGB(90, 0, 0, 0),
          ),
        ),
        MaximizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.grey,
            normal: Colors.transparent,
            mouseOver: const Color.fromARGB(60, 0, 0, 0),
            mouseDown: const Color.fromARGB(90, 0, 0, 0),
          ),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.grey,
            normal: Colors.transparent,
            mouseOver: const Color.fromARGB(60, 0, 0, 0),
            mouseDown: const Color.fromARGB(90, 0, 0, 0),
          ),
        ),
      ],
    );
  }
}
