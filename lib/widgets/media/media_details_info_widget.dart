import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
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
      this.animeSources,
      required this.adjustedWidth,
      required this.adjustedHeight,
      required this.updateSource,
      required this.context,
      required this.setState,
      required this.openWrongTitleDialog,
      required this.openMediaInfoDialog,
      this.currentAnime,
      required this.currentEpisode,
      this.currentManga,
      this.mangaSources});

  final double totalWidth;
  final double totalHeight;
  final double adjustedWidth;
  final double adjustedHeight;
  final int? currentSource;
  final int currentEpisode;
  final AnimeModel? currentAnime;
  final MangaModel? currentManga;
  final Map<int, AnimeSource>? animeSources;
  final Map<int, MangaSource>? mangaSources;
  final void Function(int, BuildContext) updateSource;
  final BuildContext context;
  final void Function(void Function()) setState;
  final void Function(
          BuildContext, double, double, void Function(void Function()))
      openWrongTitleDialog;
  final void Function(BuildContext) openMediaInfoDialog;

  List<DropdownMenuItem> getSources() {
    if (currentAnime != null) {
      return animeSources!.entries.mapIndexed((index, entry) {
        return DropdownMenuItem(
          value: index,
          onTap: () {
            updateSource(index, context);
          },
          child: Text(
            entry.value.getSourceName(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }).toList();
    } else {
      return mangaSources!.entries.mapIndexed((index, entry) {
        return DropdownMenuItem(
          value: index,
          onTap: () {
            updateSource(index, context);
          },
          child: Text(
            entry.value.getSourceName(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int? episodes =
        currentAnime != null ? currentAnime!.episodes : currentManga!.chapters;
    int? averageScore = currentAnime != null
        ? currentAnime!.averageScore
        : currentManga!.averageScore;
    String? format =
        currentAnime != null ? currentAnime!.format : currentManga!.format;
    String? status =
        currentAnime != null ? currentAnime!.status : currentManga!.status;
    String? title =
        currentAnime != null ? currentAnime!.getDefaultTitle() : currentManga!.getDefaultTitle();
    String? description = currentAnime != null
        ? currentAnime!.description
        : currentManga!.description;

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
                    items: [...getSources()],
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
                    text: context.tr("wrong_no_title"),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  StyledButton(
                    onPressed: () {
                      openMediaInfoDialog(context);
                    },
                    text: context.tr("update_entry"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  title ?? "",
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
                      " ${averageScore ?? "~"} %",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 229, 166, 57)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MediaStatusIconWidget(status: status ?? ""),
                    MediaStatusTextWidget(status: status ?? ""),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      currentAnime != null ? Icons.tv : Icons.book,
                      color: Colors.grey,
                    ),
                    Text(
                      " $format",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      currentAnime != null ? Icons.movie : Icons.bookmark,
                      color: Colors.grey,
                    ),
                    Text(
                      " ${(episodes ?? currentEpisode)} ${currentAnime != null ? context.tr("episodes") : context.tr("chapters")}",
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
                  description
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
