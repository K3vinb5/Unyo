import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';

class MediaDetailsListViewWidget extends StatelessWidget {
  const MediaDetailsListViewWidget({super.key, required this.totalWidth, required this.totalHeight, required this.totalEpisodes, required this.currentEpisodeGroup, required this.currentEpisode, required this.itemBuilder});

  final double totalWidth;
  final double totalHeight;
  final int? totalEpisodes;
  final int currentEpisodeGroup;
  final int currentEpisode;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth * 0.5,
      height: totalHeight * 0.62,
      child: SmoothListView.builder(
        duration: const Duration(milliseconds: 200),
        itemCount: (totalEpisodes ?? currentEpisode) < 30
            ? (totalEpisodes ?? currentEpisode)
            : min((30 * (currentEpisodeGroup + 1)),
                    (totalEpisodes ?? currentEpisode)) -
                (currentEpisodeGroup * 30 + 1) +
                1,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
