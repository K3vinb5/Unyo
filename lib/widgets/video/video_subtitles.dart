import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

class VideoSubtitles extends StatelessWidget {
  const VideoSubtitles({super.key, required this.mixedController});

  final double captionsBorder = 2;
  final MixedController mixedController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80, left: 50, right: 50),
        child: Text(
          mixedController.videoController.value.caption.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(-captionsBorder, -captionsBorder),
                blurRadius: 0.2,
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(captionsBorder, -captionsBorder),
                blurRadius: 0.2,
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(captionsBorder, captionsBorder),
                blurRadius: 0.2,
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(-captionsBorder, captionsBorder),
                blurRadius: 0.2,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
