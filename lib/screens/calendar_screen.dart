import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_anime.dart';

void Function(void Function()) refreshCalendarScreenState = (func) {};

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  Map<String, List<AnimeModel>> calendarLists = {};
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double maximumWidth = 0;
  double maximumHeight = 0;

  @override
  void initState() {
    super.initState();
    refreshCalendarScreenState = setState;
    Future.delayed(Duration.zero, () {
      initCalendarListMap();
    });
    //TODO find this value with totalHeight and totalWidth in the future
    maximumWidth = minimumWidth * 1.4;
    maximumHeight = minimumHeight * 1.4;
  }

  //horizontalPadding must be given as half of its real value as to avoid multiple divisions
  List<Widget> generateAnimeWidgetRows(
      double totalWidth,
      double horizontalPadding,
      String title,
      double calculatedWidth,
      double calculatedHeight,
      List<AnimeModel> animeList) {
    List<Widget> rowsList = [];
    int rowWidgetNum = totalWidth ~/
            (min(max(calculatedWidth, minimumWidth), maximumWidth) +
                2 * horizontalPadding) -
        1;
    for (int i = 0; i < animeList.length; i++) {
      int actualIndex = i * rowWidgetNum;
      //NOTE there is at least x more elements
      if (actualIndex < animeList.length - rowWidgetNum) {
        rowsList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: getAnimeRowWidgets(actualIndex, rowWidgetNum, title,
              animeList, calculatedWidth, calculatedHeight, horizontalPadding),
        ));
      } else {
        rowsList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: getAnimeRowWidgets(
              actualIndex,
              animeList.length - actualIndex,
              title,
              animeList,
              calculatedWidth,
              calculatedHeight,
              horizontalPadding),
        ));
        break;
      }
    }
    return rowsList;
  }

  List<Widget> getAnimeRowWidgets(
      int currentIndex,
      int rowWidgetNum,
      String title,
      List<AnimeModel> animeList,
      double calculatedWidth,
      double calculatedHeight,
      double padding) {
    List<Widget> rowWidgets = [];
    //NOTE goes ahead and adds those x elements to the row
    for (int j = currentIndex; j < currentIndex + rowWidgetNum; j++) {
      rowWidgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Hero(
          tag: "${"user-anime-list-$title-view"}-$j",
          child: AnimeWidget(
            title: animeList[j].getDefaultTitle(),
            score: animeList[j].averageScore,
            coverImage: animeList[j].coverImage,
            onTap: () {
              openAnime(
                context,
                animeList[j],
                "${"user-anime-list-$title-view"}-$j",
              );
            },
            textColor: Colors.white,
            height: min(max(calculatedHeight, minimumHeight), maximumHeight),
            width: min(max(calculatedWidth, minimumWidth), maximumWidth),
            year: animeList[j].startDate,
            format: animeList[j].format,
            status: animeList[j].status,
          ),
        ),
      ));
    }
    return rowWidgets;
  }

  void initCalendarListMap() async {
    var newCalendarLists = await getCalendar(
        context.locale.toLanguageTag(),
        {},
        1,
        ((DateTime.now().millisecondsSinceEpoch / 1000) - (1 * 60 * 60))
            .round(),
        ((DateTime.now().millisecondsSinceEpoch / 1000) + (6 * 24 * 60 * 60))
            .round(),
        0);
    setState(() {
      calendarLists = newCalendarLists;
    });
  }

  @override
  Widget build(BuildContext context) {

    TabController tabContrller =
        TabController(length: calendarLists.entries.length, vsync: this);
    //sizes calculations
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double adjustedWidth = getAdjustedWidth(totalWidth, context);
    double adjustedHeight = getAdjustedHeight(totalHeight, context);
    double calculatedWidth = adjustedWidth * 0.1;
    double calculatedHeight = adjustedHeight * 0.28;

    return Material(
      color: const Color.fromARGB(255, 37, 37, 37),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    StyledScreenMenuWidget(
                      isRow: true,
                      onMenuPress: buttonsLayout,
                      onBackPress: () {
                        goTo(1);
                      },
                      onRefreshPress: () {
                        initCalendarListMap();
                        AnimatedSnackBar.material(
                          "Refreshing Page",
                          type: AnimatedSnackBarType.info,
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topCenter,
                        ).show(context);
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          context.tr("calendar"),
                          style: TextStyle(
                            color: veryLightBorderColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const WindowBarButtons(startIgnoreWidth: 70),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TabBar(
              labelColor: Colors.white,
              dividerColor: veryLightBorderColor.withOpacity(0.5),
              indicatorColor: lightBorderColor,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              controller: tabContrller,
              tabs: [
                ...calendarLists.entries.map((entry) {
                  String title = entry.key;
                  return SizedBox(
                    width: 180,
                    child: Tab(
                      text: title,
                    ),
                  );
                }),
              ],
            ),
          ),
          calendarLists.isNotEmpty
              ? SizedBox(
                  width: totalWidth,
                  height: totalHeight - 100,
                  child: TabBarView(
                    controller: tabContrller,
                    children: [
                      ...calendarLists.entries.map(
                        (entry) {
                          String title = entry.key;
                          List<AnimeModel> animeList = entry.value;
                          List<Widget> rowsList = generateAnimeWidgetRows(
                              totalWidth,
                              2,
                              title,
                              calculatedWidth,
                              calculatedHeight,
                              animeList);
                          return SizedBox(
                            width: totalWidth,
                            height: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: SizedBox(
                                width: totalWidth,
                                height: totalHeight,
                                child: Center(
                                  child: SmoothListView.builder(
                                    duration: const Duration(milliseconds: 200),
                                    itemCount: rowsList.length,
                                    itemBuilder: (context, index) {
                                      return rowsList[index];
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: (totalHeight / 4) + 100),
                  child: Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white, size: 30),
                  ),
                ),
        ],
      ),
    );
  }
}
