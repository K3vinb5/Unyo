import 'package:flutter/material.dart';

class EpisodeButton extends StatelessWidget {
  const EpisodeButton({
    super.key,
    required this.episodeNumber,
    required this.onTap,
    required this.latestEpisode,
    required this.latestEpisodeWatched,
    required this.episodeImageUrl,
    required this.episodeTitle,
  });

  final num episodeNumber;
  final int latestEpisode;
  final num latestEpisodeWatched;
  final String? episodeImageUrl;
  final String? episodeTitle;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: latestEpisode >= episodeNumber ? onTap : null,
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
            child: SizedBox(
              height: totalWidth * 0.06,
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
                              ? Image.network(episodeImageUrl!)
                              : const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: totalWidth * 0.25,
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Episode $episodeNumber",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              episodeTitle != null ? "$episodeTitle" : "",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis
                              ),
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
                            ? "Released"
                            : "Not yet released",
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
