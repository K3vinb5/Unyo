import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class MediaResumeFromWidget extends StatelessWidget {
  const MediaResumeFromWidget(
      {super.key,
      required this.totalWidth,
      required this.text,
      required this.onPressed});

  final double totalWidth;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth * 0.45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StyledButton(
            onPressed: onPressed,
            child: SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
