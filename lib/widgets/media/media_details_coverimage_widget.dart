import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unyo/widgets/widgets.dart';

class MediaDetailsCoverImageWidget extends StatelessWidget {
  const MediaDetailsCoverImageWidget(
      {super.key,
      required this.coverImage,
      required this.totalHeight,
      required this.tag,
      required this.adjustedHeight,
      required this.adjustedWidth,
      required this.status});

  final double totalHeight;
  final double adjustedHeight;
  final double adjustedWidth;
  final String tag;
  final String? coverImage;
  final String? status;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;

  @override
  Widget build(BuildContext context) {
    return coverImage != null
        ? SizedBox(
          height: totalHeight * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 50.0),
                child: Hero(
                  tag: tag,
                  child: AnimeWidget(
                    title: "",
                    coverImage: coverImage,
                    score: null,
                    onTap: null,
                    textColor: Colors.white,
                    height: (adjustedHeight * 0.28) > minimumHeight
                        ? (adjustedHeight * 0.28)
                        : minimumHeight,
                    width: (adjustedWidth * 0.1) > minimumWidth
                        ? (adjustedWidth * 0.1)
                        : minimumWidth,
                    status: status,
                    year: null,
                    format: null,
                  ),
                ),
              ),
            ],
          ),
        )
        : const SizedBox();
  }
}
