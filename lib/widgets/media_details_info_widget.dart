import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/widgets/widgets.dart';

class MediaDetailsInfoWidget extends StatelessWidget {
  const MediaDetailsInfoWidget(
      {super.key,
      required this.totalWidth,
      required this.totalHeight,
      required this.currentSource,
      required this.animeSources,
      required this.adjustedWidth,
      required this.adjustedHeight,
      required this.updateSource,
      required this.setState,
      required this.openWrongTitleDialog,
      required this.openAnimeInfoDialog,
      required this.currentAnime,
      required this.currentEpisode});

  final double totalWidth;
  final double totalHeight;
  final double adjustedWidth;
  final double adjustedHeight;
  final int? currentSource;
  final int currentEpisode;
  final AnimeModel currentAnime;
  final Map<int, AnimeSource> animeSources;
  final void Function(int) updateSource;
  final void Function(void Function()) setState;
  final void Function(
          BuildContext, double, double, void Function(void Function()))
      openWrongTitleDialog;
  final void Function(BuildContext) openAnimeInfoDialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: totalHeight * 0.27,
        ),
        SizedBox(
          width: totalWidth / 2,
          height: totalHeight * 0.63,
          child: SmoothListView(
            duration: const Duration(milliseconds: 200),
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  DropdownButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    iconDisabledColor: Colors.white,
                    value: currentSource,
                    dropdownColor: Colors.black,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    items: [
                      ...animeSources.entries.mapIndexed((index, entry) {
                        return DropdownMenuItem(
                          value: index,
                          onTap: () {
                            updateSource(index);
                          },
                          child: Text(
                            entry.value.getSourceName(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ],
                    onChanged: (index) {},
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  StyledButton(
                    onPressed: () {
                      openWrongTitleDialog(
                          context, adjustedWidth, adjustedHeight, setState);
                    },
                    text: "Wrong/No Title?",
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  StyledButton(
                    onPressed: () {
                      openAnimeInfoDialog(context);
                    },
                    text: "Update Entry",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  currentAnime.title ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 229, 166, 57),
                    ),
                    Text(
                      " ${currentAnime.averageScore ?? "~"} %",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 229, 166, 57)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MediaStatusIconWidget(status: currentAnime.status ?? ""),
                    MediaStatusTextWidget(status: currentAnime.status ?? ""),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.tv,
                      color: Colors.grey,
                    ),
                    Text(
                      " ${currentAnime.format}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.movie,
                      color: Colors.grey,
                    ),
                    Text(
                      " ${(currentAnime.episodes ?? currentEpisode)} Episodes",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  currentAnime.description
                          ?.replaceAll("<br>", "\n")
                          .replaceAll("<i>", "")
                          .replaceAll("<b>", "")
                          .replaceAll("</b>", "") ??
                      "",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
