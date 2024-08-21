import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:collection/collection.dart';

class AnimeWidgetList extends StatefulWidget {
  const AnimeWidgetList({
    super.key,
    required this.title,
    required this.animeList,
    required this.textColor,
    required this.loadMore,
    required this.tag,
    required this.width,
    required this.height,
    this.updateHomeScreenLists,
    this.loadMoreFunction,
    this.verticalPadding,
    this.horizontalPadding,
    required this.totalWidth,
  });

  final String title;
  final List<AnimeModel> animeList;
  final Color textColor;
  final bool loadMore;
  final Future<List<AnimeModel>> Function(int, int, int)? loadMoreFunction;
  final String tag;
  final void Function()? updateHomeScreenLists;
  final double width;
  final double totalWidth;
  final double height;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  final double minimumListHeight = 244.3;
  final double? verticalPadding;
  final double? horizontalPadding;

  @override
  State<AnimeWidgetList> createState() => _AnimeWidgetListState();
}

class _AnimeWidgetListState extends State<AnimeWidgetList> {
  late List<AnimeModel> animeList;
  late AnimeDetailsScreen animeScreen;
  ScrollController controller = ScrollController();
  int currentPage = 2;
  double calculatedWidth = 0;
  double calculatedHeight = 0;
  double calculatedListHeight = 0;
  double maximumWidth = 0;
  double maximumHeight = 0;
  double maximumListHeight = 0;

  @override
  void initState() {
    super.initState();
    animeList = widget.animeList;
    maximumListHeight = widget.minimumListHeight * 1.4;
    maximumHeight = widget.minimumHeight * 1.4;
    maximumWidth = widget.minimumWidth * 1.4;
  }

  @override
  void didUpdateWidget(covariant AnimeWidgetList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animeList != widget.animeList) {
      setState(() {
        animeList = widget.animeList;
      });
    }
  }

  void openAnime(AnimeModel currentAnime, String tag) {
    animeScreen = AnimeDetailsScreen(
      currentAnime: currentAnime,
      tag: tag,
    );
    pauseAnimePageTimer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => animeScreen),
    ).then((_) {
      if (widget.updateHomeScreenLists != null) {
        widget.updateHomeScreenLists!();
      }
      resumeAnimePageTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          calculatedWidth = widget.width * 0.1;
          calculatedHeight = widget.height * 0.28;
          calculatedListHeight = widget.height * 0.35;

          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? 50,
                horizontal: widget.horizontalPadding ?? 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: widget.totalWidth - 40,
                        child: Row(
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: veryLightBorderColor,
                              ),
                            ),
                            Text(
                              "  ${animeList.length.toString()} ${context.tr("entries")}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                            MediaListArrowsWidget(
                              controller: controller,
                              visible: animeList.length > 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: min(
                      max(calculatedListHeight, widget.minimumListHeight),
                      maximumListHeight),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    // duration: const Duration(milliseconds: 150),
                    children: [
                      ...animeList.mapIndexed((index, animeModel) {
                        return Hero(
                          tag: "${widget.tag}-$index",
                          child: AnimeWidget(
                            title: animeModel.getDefaultTitle(),
                            score: animeModel.averageScore,
                            coverImage: animeModel.coverImage,
                            onTap: () {
                              openAnime(animeModel, "${widget.tag}-$index");
                            },
                            textColor: widget.textColor,
                            height: min(
                                max(calculatedHeight, widget.minimumHeight),
                                maximumHeight),
                            width: min(
                                max(calculatedWidth, widget.minimumWidth),
                                maximumWidth),
                            year: animeModel.startDate,
                            format: animeModel.format,
                            status: animeModel.status,
                          ),
                        );
                      }),
                      //load More
                      widget.loadMore
                          ? AnimeWidget(
                              title: "",
                              score: null,
                              coverImage: "https://i.ibb.co/Kj8CQZH/cross.png",
                              onTap: () async {
                                var newTrendingList = await widget
                                    .loadMoreFunction!(currentPage++, 20, 0);
                                setState(() {
                                  animeList += newTrendingList;
                                });
                              },
                              textColor: widget.textColor,
                              height: min(
                                  max(calculatedHeight, widget.minimumHeight),
                                  maximumHeight),
                              width: min(
                                  max(calculatedWidth, widget.minimumWidth),
                                  maximumWidth),
                              status: null,
                              format: null,
                              year: null,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
