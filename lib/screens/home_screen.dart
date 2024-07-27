import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'dart:io';
import 'package:image_gradient/image_gradient.dart';
import 'package:unyo/dialogs/update_dialog.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/api/anilist_api_manga.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/utils.dart';

void Function()? updateHomeScreenLists;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> /*with WidgetsBindingObserver*/ {
  String? avatarImageUrl;
  String? userName;
  int? userId;
  late HttpServer server;
  List<AnimeModel>? watchingList;
  List<MangaModel>? readingList;
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  Map<String, Map<String, double>>? userStats;
  int? episodesWatched;
  int? minutesWatched;

  Future<void> _startServer() async {
    handler(shelf.Request request) async {
      // Extract access token from request URL
      if (!receivedValid) {
        receivedValid = true;
        accessCode = request.requestedUri.queryParameters['code'];
        //print('Access Code: $accessCode');
        List<String> codes = await getUserAccessToken(accessCode!);
        accessToken = codes[0];
        refreshToken = codes[1];
        //print("AccessToken: $accessToken");
        getUserInfo();
        await prefs.setString("accessCode", accessCode!);
        await prefs.setString("refreshToken", refreshToken!);
        await prefs.setString("accessToken", accessToken!);
      } else {
        //TODO showDialog
      }
      // Return a response to close the connection
      return shelf.Response.ok(
          'Authorization successful. You can close this window.');
    }

    // Start the local web server
    server = await shelfio.serve(handler, 'localhost', 9999);
    // print('Local server running on port ${server.port}');
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    startExtensions();
    if (prefs.getString("accessToken") == null) {
      _startServer();
      goToLogin();
    } else {
      accessToken = prefs.getString("accessToken");
      userName = prefs.getString("userName");
      userId = prefs.getInt("userId");
      getUserInfo();
    }
  }

  void goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          updateUserInfo: getUserInfo,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
    updateHomeScreenLists = () {
      updateUserLists();
    };
  }

  void startExtensions() {
    if (prefs.getBool("remote_endpoint") ?? false) {
      processManager.startProcess();
    }
    addEmbeddedAniyomiExtensions();
  }

  void getUserInfo() async {
    if (userName == null || userId == null) {
      List<String> userNameAndId = await getUserNameAndId(accessToken!);
      userName = userNameAndId[0];
      userId = int.parse(userNameAndId[1]);
      await prefs.setString("userName", userName!);
      await prefs.setInt("userId", userId!);
    }
    initThemes(prefs.getInt("theme") ?? 0, setState);
    String newavatarUrl = await getUserAvatarImageUrl(userName!, 0);
    List<AnimeModel> newWatchingAnimeList =
        await getUserAnimeLists(userId!, "Watching", 0);
    List<MangaModel> newReadingMangaList =
        await getUserMangaLists(userId!, "Reading", 0);
    Map<String, Map<String, double>> newUserStats =
        await getUserStatsMaps(userName!, 0);
    episodesWatched =
        newUserStats["watchedStatistics"]?["episodesWatched"]?.toInt() ?? -1;
    minutesWatched =
        newUserStats["watchedStatistics"]?["minutesWatched"]?.toInt() ?? -1;
    newUserStats.remove("watchedStatistics");
    setState(() {
      avatarImageUrl = newavatarUrl;
      watchingList = newWatchingAnimeList;
      readingList = newReadingMangaList;
      userStats = newUserStats;
    });
    if (!mounted) return;
    showUpdateDialog(context);
  }

  void updateUserLists() async {
    List<AnimeModel> newWatchingAnimeList =
        await getUserAnimeLists(userId!, "Watching", 0);
    List<MangaModel> newReadingMangaList =
        await getUserMangaLists(userId!, "Reading", 0);
    setState(() {
      watchingList = newWatchingAnimeList;
      readingList = newReadingMangaList;
    });
  }

  List<Widget> getUserCharts() {
    if (colorList.isNotEmpty) {
      // colorList = colorList.reversed.toList();
    }
    return [
      ...userStats!.entries.map(
        (entry) {
          Map<String, double> entryMap = entry.key != "formats"
              ? {
                  "Planning": 0.0,
                  "Current": 0.0,
                  "Completed": 0.0,
                  "Repeating": 0.0,
                  "Paused": 0.0,
                  "Dropped": 0.0
                }
              : {
                  "Tv": 0.0,
                  "Tv short": 0.0,
                  "Movie": 0.0,
                  "Special": 0.0,
                  "Ova": 0.0,
                  "Ona": 0.0,
                  "Music": 0.0
                };
          if (entry.value.entries.isNotEmpty) {
            entryMap = entry.value;
          }
          return PieChart(
            dataMap: entryMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: adjustedWidth * 0.15,
            colorList: colorList.isNotEmpty ? colorList : [Colors.purpleAccent],
            initialAngleInDegree: 0,
            chartType: ChartType.disc,
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: entry.key != "formats"
                  ? LegendPosition.right
                  : LegendPosition.left,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          );
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          adjustedWidth =
              getAdjustedWidth(MediaQuery.of(context).size.width, context);
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height, context);
          totalHeight = MediaQuery.of(context).size.height;
          totalWidth = MediaQuery.of(context).size.width;
          //print("$adjustedWidth / $adjustedHeight");
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  (bannerImageUrl != null && watchingList != null)
                      ? Stack(
                          children: [
                            ImageGradient.linear(
                              image: Image.network(
                                bannerImageUrl!,
                                width: totalWidth,
                                height: totalHeight * 0.35,
                                fit: BoxFit.cover,
                              ),
                              colors: const [Colors.white, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Container(
                      width: totalWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border.all(
                          color: const Color.fromARGB(255, 34, 33, 34),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              watchingList == null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/logo.png",
                            scale: 0.75,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.topCenter,
                          child: WindowBarButtons(startIgnoreWidth: 30),
                        ),
                      ],
                    )
                  : SmoothListView(
                      scrollDirection: Axis.vertical,
                      duration: const Duration(milliseconds: 200),
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                StyledScreenMenuWidget(
                                  onBackPress: null,
                                  onMenuPress: buttonsLayout,
                                  onRefreshPress: () {},
                                ),
                                avatarImageUrl != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, left: 60, top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Image.network(
                                                    avatarImageUrl!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      userName!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    //settings screen
                                                    Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SettingsScreen(),
                                                      ),
                                                    )
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.settings_rounded,
                                                      color: Colors.white),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Do you wanna log out?",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  44, 44, 44),
                                                          content: SizedBox(
                                                            width:
                                                                adjustedWidth *
                                                                    0.15,
                                                            height:
                                                                adjustedHeight *
                                                                    0.15,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "Are you sure you want to log out?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    StyledButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          "Cancel",
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    StyledButton(
                                                                      onPressed:
                                                                          () {
                                                                        prefs
                                                                            .clear();
                                                                        setState(
                                                                            () {
                                                                          //TODO updateLists on logout, maybe extract method
                                                                          bannerImageUrl =
                                                                              null;
                                                                          avatarImageUrl =
                                                                              null;
                                                                          watchingList =
                                                                              null;
                                                                          readingList =
                                                                              null;
                                                                          userName =
                                                                              null;
                                                                          userId =
                                                                              null;
                                                                          accessToken =
                                                                              null;
                                                                          refreshToken =
                                                                              null;
                                                                        });
                                                                        setSharedPreferences();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          "Confirm",
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        !buttonsLayout
                            ? SizedBox(height: totalHeight * 0.12)
                            : SizedBox(
                                height: totalHeight * 0.09,
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AnimeButton(
                                  text: "Animes",
                                  onTap: () {
                                    goTo(0);
                                  },
                                  width: adjustedWidth,
                                  height: adjustedHeight,
                                  horizontalAllignment: true,
                                ),
                                AnimeButton(
                                  text: "Mangas",
                                  onTap: () {
                                    goTo(2);
                                  },
                                  width: adjustedWidth,
                                  height: adjustedHeight,
                                  horizontalAllignment: true,
                                ),
                              ],
                            ),
                            //NOTE pageStart
                            // FloattingMenu(
                            // height: totalHeight * 0.1,
                            // ),
                            const SizedBox(
                              height: 30,
                            ),
                            watchingList != null
                                ? AnimeWidgetList(
                                    tag: "home-details-list1",
                                    title: context.tr("continue_watching"),
                                    animeList: watchingList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    totalWidth: totalWidth,
                                    height: adjustedHeight,
                                    verticalPadding: 30,
                                  )
                                : const SizedBox(),
                            readingList != null
                                ? MangaWidgetList(
                                    tag: "home-details-list2",
                                    title: context.tr("continue_reading"),
                                    mangaList: readingList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    totalWidth: totalWidth,
                                    height: adjustedHeight,
                                    verticalPadding: 30,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 30,
                            ),
                            HomeScreenBottomButtonsWidget(
                              adjustedHeight: adjustedHeight,
                              adjustedWidth: adjustedWidth,
                              episodesWatched: episodesWatched,
                              userStatsNull: userStats != null,
                              getUserCharts: getUserCharts,
                              minutesWatched: minutesWatched,
                            ),
                            const SizedBox(
                              height: 55,
                            ),
                            //NOTE pageEnd
                          ],
                        ),
                      ],
                    ),
              const WindowBarButtons(startIgnoreWidth: 0),
            ],
          );
        },
      ),
    );
  }
}
