import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class WindowBarButtons extends StatelessWidget {
  const WindowBarButtons({super.key, required this.startIgnoreWidth});

  final double startIgnoreWidth;

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          SizedBox(
            width: startIgnoreWidth,
          ),
          Expanded(
            child: MoveWindow(),
          ),
          const WindowButtons(),
        ],
      ),
    );
  }
}
