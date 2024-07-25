import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:collection/collection.dart';

class MangaWidgetList extends StatefulWidget {
  const MangaWidgetList({
    super.key,
    required this.title,
    required this.mangaList,
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
  final List<MangaModel> mangaList;
  final Color textColor;
  final bool loadMore;
  final Future<List<MangaModel>> Function(int, int, int)? loadMoreFunction;
  final String tag;
  final void Function()? updateHomeScreenLists;
  final double width;
  final double totalWidth;
  final double height;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  final double minimumListHeight = 244.3;

  @override
  State<MangaWidgetList> createState() => _MangaWidgetListState();
}

class _MangaWidgetListState extends State<MangaWidgetList> {
  late List<MangaModel> mangaList;
  late MangaDetailsScreen mangaScreen;
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
    mangaList = widget.mangaList;
    maximumListHeight = widget.minimumListHeight * 1.4;
    maximumHeight = widget.minimumHeight * 1.4;
    maximumWidth = widget.minimumWidth * 1.4;
  }

  @override
  void didUpdateWidget(covariant MangaWidgetList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mangaList != widget.mangaList) {
      setState(() {
        mangaList = widget.mangaList;
      });
    }
  }

  void openMangaDetails(MangaModel currentManga, String tag) {
    mangaScreen = MangaDetailsScreen(
      currentManga: currentManga,
      tag: tag,
    );
    pauseMangaPageTimer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => mangaScreen),
    ).then((_) {
      if (widget.updateHomeScreenLists != null) {
        widget.updateHomeScreenLists!();
      }
      resumeMangaPageTimer();
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
                              "  ${mangaList.length.toString()} ${context.tr("entries")}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                            MediaListArrowsWidget(
                              controller: controller,
                              visible: mangaList.length > 8,
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
                    children: [
                      ...mangaList.mapIndexed((index, mangaModel) {
                        return Hero(
                          tag: "${widget.tag}-$index",
                          child: MangaWidget(
                            title: mangaModel.title,
                            score: mangaModel.averageScore,
                            coverImage: mangaModel.coverImage,
                            onTap: () {
                              openMangaDetails(
                                  mangaModel, "${widget.tag}-$index");
                            },
                            textColor: widget.textColor,
                            height: min(
                                max(calculatedHeight, widget.minimumHeight),
                                maximumHeight),
                            width: min(
                                max(calculatedWidth, widget.minimumWidth),
                                maximumWidth),
                            year: mangaModel.startDate,
                            format: mangaModel.format,
                            status: mangaModel.status,
                          ),
                        );
                      }),
                      //load More
                      widget.loadMore
                          ? MangaWidget(
                              title: "",
                              score: null,
                              coverImage: "https://i.ibb.co/Kj8CQZH/cross.png",
                              onTap: () async {
                                var newTrendingList = await widget
                                    .loadMoreFunction!(currentPage++, 20, 0);
                                setState(() {
                                  mangaList += newTrendingList;
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
