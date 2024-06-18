import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/widgets/widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double maximumWidth = 0;
  double maximumHeight = 0;
  final List<String> weekDays = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];
  Map<String, List<AnimeModel>> calendarMap = {};

  @override
  void initState() {
    super.initState();
    //TODO find this value with totalHeight and totalWidth in the future
    maximumWidth = minimumWidth * 1.4;
    maximumHeight = minimumHeight * 1.4;
    //TODO temp
    initCalendarMap();
  }

  void initCalendarMap() async {
    for (int i = 0; i < weekDays.length; i++) {
      List<int> malIds = await getMALIdListFromDay(weekDays[i], 0);
      List<AnimeModel> animeList =
          await getAnimeListFromMALIds(malIds, weekDays[i], 0);
      setState(() {
        calendarMap.addAll({weekDays[i]: animeList});
      });
    }
  }

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
            title: animeList[j].title,
            score: animeList[j].averageScore,
            coverImage: animeList[j].coverImage,
            onTap: () {
              openAnime(
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

  double getAdjustedHeight(double value) {
    if (MediaQuery.of(context).size.aspectRatio > 1.77777777778) {
      return value;
    } else {
      return value *
          ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
    }
  }

  double getAdjustedWidth(double value) {
    if (MediaQuery.of(context).size.aspectRatio < 1.77777777778) {
      return value;
    } else {
      return value *
          ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
    }
  }

  void openAnime(AnimeModel currentAnime, String tag) {
    var animeScreen = AnimeDetailsScreen(
      currentAnime: currentAnime,
      tag: tag,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => animeScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO must calculate both adjustedHeight and adjustedWidth in the future so it doesn't depend on 16/9 aspect ratio

    TabController tabContrller = TabController(length: 7, vsync: this);
    //sizes calculations
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double adjustedWidth = getAdjustedWidth(totalWidth);
    double adjustedHeight = getAdjustedHeight(totalHeight);
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        goTo(1);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        initCalendarMap();
                        AnimatedSnackBar.material(
                          "Refreshing Page",
                          type: AnimatedSnackBarType.info,
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topCenter,
                        ).show(context);
                      },
                      icon: const Icon(Icons.refresh),
                      color: Colors.white,
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Animes Calendar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WindowTitleBarBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      child: MoveWindow(),
                    ),
                    const WindowButtons(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              controller: tabContrller,
              tabs: const [
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Monday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Tuesday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Wednesday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Thursday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Friday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Saturday",
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Tab(
                    text: "Sunday",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: totalWidth,
            height: totalHeight - 100,
            child: TabBarView(
              controller: tabContrller,
              children: [
                ...calendarMap.entries.map(
                  (entry) {
                    String weekDay = entry.key;
                    List<AnimeModel> animeList = entry.value;
                    List<Widget> rowsList = generateAnimeWidgetRows(
                        totalWidth,
                        2,
                        weekDay,
                        calculatedWidth,
                        calculatedHeight,
                        animeList);
                    return SizedBox(
                      width: totalWidth,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: SizedBox(
                            width: totalWidth,
                            height: totalHeight,
                            child: Center(
                              child: ListView.builder(
                                itemCount: rowsList.length,
                                itemBuilder: (context, index) {
                                  return rowsList[index];
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
