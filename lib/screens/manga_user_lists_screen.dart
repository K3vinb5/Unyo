import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_manga.dart';

class MangaUserListsScreen extends StatefulWidget {
  const MangaUserListsScreen({super.key});

  @override
  State<MangaUserListsScreen> createState() => _MangaUserListsScreenState();
}

class _MangaUserListsScreenState extends State<MangaUserListsScreen>
    with TickerProviderStateMixin {
  Map<String, List<MangaModel>> userMangaLists = {};
  String? userName;
  int? userId;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double maximumWidth = 0;
  double maximumHeight = 0;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
    // initUserMangaListsMap();
    //TODO find this value with totalHeight and totalWidth in the future
    maximumWidth = minimumWidth * 1.4;
    maximumHeight = minimumHeight * 1.4;
  }

  //horizontalPadding must be given as half of its real value as to avoid multiple divisions
  List<Widget> generateMangaWidgetRows(
      double totalWidth,
      double horizontalPadding,
      String title,
      double calculatedWidth,
      double calculatedHeight,
      List<MangaModel> mangaList) {
    List<Widget> rowsList = [];
    //TODO There might be a mistake in the - 2
    int rowWidgetNum = totalWidth ~/
            (min(max(calculatedWidth, minimumWidth), maximumWidth) +
                2 * horizontalPadding) -
        2;
    for (int i = 0; i < mangaList.length; i++) {
      int actualIndex = i * rowWidgetNum;
      //NOTE there is at least x more elements
      if (actualIndex < mangaList.length - rowWidgetNum - 1) {
        rowsList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: getMangaRowWidgets(actualIndex, rowWidgetNum, title,
              mangaList, calculatedWidth, calculatedHeight, horizontalPadding),
        ));
      } else {
        rowsList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: getMangaRowWidgets(
              actualIndex,
              mangaList.length - actualIndex,
              title,
              mangaList,
              calculatedWidth,
              calculatedHeight,
              horizontalPadding),
        ));
        break;
      }
    }
    return rowsList;
  }

  List<Widget> getMangaRowWidgets(
      int currentIndex,
      int rowWidgetNum,
      String title,
      List<MangaModel> mangaList,
      double calculatedWidth,
      double calculatedHeight,
      double padding) {
    List<Widget> rowWidgets = [];
    //NOTE goes ahead and adds those x elements to the row
    for (int j = currentIndex; j < currentIndex + rowWidgetNum; j++) {
      rowWidgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Hero(
          tag: "${"user-manga-list-$title-view"}-$j",
          child: MangaWidget(
            title: mangaList[j].title,
            score: mangaList[j].averageScore,
            coverImage: mangaList[j].coverImage,
            onTap: () {
              // openManga(
              //   mangaList[j],
              //   "${"user-manga-list-$title-view"}-$j",
              // );
            },
            textColor: Colors.white,
            height: min(max(calculatedHeight, minimumHeight), maximumHeight),
            width: min(max(calculatedWidth, minimumWidth), maximumWidth),
            year: mangaList[j].startDate,
            format: mangaList[j].format,
            status: mangaList[j].status,
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

  void initUserMangaListsMap() async {
    var newUserMangaLists = await getAllUserMangaLists(userId!, 0);
    setState(() {
      userMangaLists = newUserMangaLists;
    });
  }

  void setSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("accessToken") == null) {
      // _startServer();
      // goToLogin();
      return;
    } else {
      // accessToken = prefs.getString("accessToken");
      userName = prefs.getString("userName");
      userId = prefs.getInt("userId");
      initUserMangaListsMap();
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO must calculate both adjustedHeight and adjustedWidth in the future so it doesn't depend on 16/9 aspect ratio

    TabController tabContrller =
        TabController(length: userMangaLists.entries.length, vsync: this);
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
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: WindowTitleBarBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: MoveWindow(),
                            ),
                            const WindowButtons(),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        goTo(1);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${userName ?? ""} Manga List",
                      style: const TextStyle(
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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              controller: tabContrller,
              tabs: [
                ...userMangaLists.entries.map((entry) {
                  String title = entry.key;
                  return SizedBox(
                    width: 150,
                    child: Tab(
                      text: title,
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(
            width: totalWidth,
            height: totalHeight - 100,
            child: TabBarView(
              controller: tabContrller,
              children: [
                //TODO temp, must use wrap in the future
                ...userMangaLists.entries.map(
                  (entry) {
                    String title = entry.key;
                    List<MangaModel> mangaList = entry.value;
                    List<Widget> rowsList = generateMangaWidgetRows(totalWidth,
                        2, title, calculatedWidth, calculatedHeight, mangaList);
                    return SizedBox(
                      width: totalWidth,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          // child: Wrap(
                          //   runSpacing: -(totalWidth * 0.1),
                          //   alignment: WrapAlignment.center,
                          //   children: [
                          //     ...mangaList.mapIndexed(
                          //       (index, mediaModel) {
                          //         return Hero(
                          //           tag:
                          //               "${"user-manga-list-$title-view"}-$index",
                          //           child: MangaWidget(
                          //             title: mediaModel.title,
                          //             score: mediaModel.averageScore,
                          //             coverImage: mediaModel.coverImage,
                          //             onTap: () {
                          //               openManga(
                          //                 mediaModel,
                          //                 "${"user-manga-list-$title-view"}-$index",
                          //               );
                          //             },
                          //             textColor: Colors.white,
                          //             height: min(
                          //                 max(calculatedHeight, minimumHeight),
                          //                 maximumHeight),
                          //             width: min(
                          //                 max(calculatedWidth, minimumWidth),
                          //                 maximumWidth),
                          //             year: mediaModel.startDate,
                          //             format: mediaModel.format,
                          //             status: mediaModel.status,
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
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
