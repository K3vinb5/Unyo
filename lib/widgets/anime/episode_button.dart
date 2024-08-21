import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:unyo/models/models.dart';

class EpisodeButton extends StatelessWidget {
  const EpisodeButton({
    super.key,
    required this.index,
    required this.currentEpisodeGroup,
    required this.userAnimeModel,
    required this.mediaContentModel,
    required this.videoQualities,
    required this.latestEpisode,
    required this.latestEpisodeWatched,
    required this.currentSearchId,
    required this.currentAnime,
  });
  final int index;
  final int currentEpisodeGroup;
  final UserMediaModel? userAnimeModel;
  final MediaContentModel mediaContentModel;
  final int latestEpisode;
  final num latestEpisodeWatched;
  final String? currentSearchId;
  final AnimeModel currentAnime;
  final void Function(String, int, String, String) videoQualities;

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    int episodeNumber = (index + 1 + currentEpisodeGroup * 30);
    String? episodeTitle = mediaContentModel.titles != null
        ? (mediaContentModel.titles!.length > index
            ? mediaContentModel.titles![(index + currentEpisodeGroup * 30)]
            : "")
        : "";
    String? episodeImageUrl = mediaContentModel.imageUrls != null
        ? (mediaContentModel.imageUrls!.length > index &&
                index < latestEpisode &&
                mediaContentModel
                        .imageUrls![(index + currentEpisodeGroup * 30)] !=
                    null
            ? mediaContentModel.imageUrls![(index + currentEpisodeGroup * 30)]
            : mediaContentModel.fanart)
        : mediaContentModel.fanart;

    return InkWell(
      onTap: latestEpisode >= episodeNumber
          ? () {
              if (currentSearchId == null) return;
              videoQualities(
                currentSearchId!,
                (index + 1 + currentEpisodeGroup * 30),
                currentAnime.userPreferedTitle ?? "",
                (currentAnime.idMal ?? -1).toString()
              );
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 2,
            color: const Color.fromARGB(255, 34, 33, 34),
            endIndent: totalWidth * 0.05,
            indent: totalWidth * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: totalWidth * 0.03, vertical: 20),
            child: HoverAnimatedContainer(
              duration: const Duration(milliseconds: 150),
              hoverHeight: totalWidth * 0.062,
              height: totalWidth * 0.06,
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: episodeImageUrl != null
                              ? Image.network(episodeImageUrl)
                              : const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: totalWidth * 0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${context.tr("episode")} $episodeNumber",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              // ignore: unnecessary_string_interpolations
                              episodeTitle != null ? "$episodeTitle" : "",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      latestEpisodeWatched >= episodeNumber
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.grey,
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        latestEpisode >= episodeNumber
                            ? context.tr("released")
                            : context.tr("not_yet_released"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: latestEpisode >= episodeNumber
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
