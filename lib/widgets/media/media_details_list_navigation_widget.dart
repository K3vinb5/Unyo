import 'dart:math';

import 'package:flutter/material.dart';

class MediaDetailsListNavigationWidget extends StatelessWidget {
  const MediaDetailsListNavigationWidget(
      {super.key,
      required this.totalWidth,
      required this.currentEpisodeGroup,
      required this.currentEpisode,
      required this.totalEpisodes,
      required this.episodeGroupBack,
      required this.episodeGroupForward});

  final double totalWidth;
  final int currentEpisodeGroup;
  final int currentEpisode;
  final int? totalEpisodes;
  final void Function() episodeGroupBack;
  final void Function() episodeGroupForward;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth * 0.45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (currentEpisodeGroup < 1) return;
              episodeGroupBack();
            },
            icon: const Icon(
              Icons.navigate_before_rounded,
              color: Colors.white,
            ),
          ),
          Text(
            "${currentEpisodeGroup * 30 + 1} - ${min((30 * (currentEpisodeGroup + 1)), (totalEpisodes ?? currentEpisode))}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          IconButton(
            onPressed: () {
              if ((currentEpisodeGroup + 1) * 30 >
                  (totalEpisodes ?? currentEpisode)) return;
              episodeGroupForward();
            },
            icon: const Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
