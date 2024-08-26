import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/utils.dart';

void Function()? updateHomeScreenLists;
late void Function(void Function()) updateHomeScreenState;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  Map<String, Map<String, double>>? userStats;
  int? episodesWatched;
  int? minutesWatched;

  void attemptLogin() async {
    prefs = PreferencesModel();
    await prefs.init();
    if (!prefs.isUserLogged()) {
      Future.delayed(Duration.zero, () {
        // prefs.getUsers(setState);
        goToLogin();
      });
    } else {
      accessToken = prefs.getString("accessToken");
      userName = prefs.getString("userName");
      userId = prefs.getInt("userId");
      userName = prefs.userName!;
      //change function bellow for when logged already
      setUserInfo(0);
    }
  }

  void goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          setUserInfo: setUserInfo,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    attemptLogin();
    updateHomeScreenLists = () {
      updateUserLists();
    };
    updateHomeScreenState = setState;
  }

  void startExtensions() {
    if (prefs.getBool("remote_endpoint") ?? false) {
      processManager.startProcess();
    }
    addEmbeddedAniyomiExtensions();
    addEmbeddedTachiyomiExtensions();
  }

  void setUserInfo(int userModelType) async {
    switch (userModelType) {
      case 0:
        loggedUserModel = AnilistUserModel();
        break;
      case 1:
        loggedUserModel = LocalUserModel();
        break;
      default:
    }
    if (!prefs.isUserLogged()) {
      List<String> userNameAndId = await loggedUserModel.getUserNameAndId();
      userName = userNameAndId[0];
      await prefs.loginUser(userName!);
      userId = int.parse(userNameAndId[1]);
      prefs.setString("userName", userName!);
      prefs.setInt("userId", userId!);
      prefs.setString("accessToken", accessToken!);
    } else {
      if (accessToken != null) {
        await loggedUserModel.getUserNameAndId();
      }
    }
    startExtensions();
    initThemes(prefs.getInt("theme") ?? 0, setState);
    String newavatarUrl = await loggedUserModel.getUserAvatarImageUrl();
    List<AnimeModel> newWatchingAnimeList =
        await loggedUserModel.getUserAnimeLists("Watching");
    List<MangaModel> newReadingMangaList =
        await loggedUserModel.getUserMangaLists("Reading");
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
    prefs.saveUser(loggedUserModel);
    if (!mounted) return;
    showUpdateDialog(context);
  }

  void updateUserLists() async {
    List<AnimeModel> newWatchingAnimeList =
        await loggedUserModel.getUserAnimeLists("Watching");
    List<MangaModel> newReadingMangaList =
        await loggedUserModel.getUserMangaLists("Reading");
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    // Image is fully loaded, start fading in
                                    return Container(
                                      width: totalWidth,
                                      height: totalHeight * 0.35,
                                      color:
                                          const Color.fromARGB(255, 34, 33, 34),
                                      child: AnimatedOpacity(
                                        opacity: 1.0,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn,
                                        child: child,
                                      ),
                                    );
                                  } else {
                                    // Keep the image transparent while loading
                                    return Container(
                                      width: totalWidth,
                                      height: totalHeight * 0.35,
                                      color:
                                          const Color.fromARGB(255, 34, 33, 34),
                                      child: AnimatedOpacity(
                                        opacity: 0.0,
                                        duration:
                                            const Duration(milliseconds: 0),
                                        child: child,
                                      ),
                                    );
                                  }
                                },
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
                                                    showLogOutDialog(
                                                      context,
                                                      setState,
                                                      attemptLogin,
                                                      adjustedHeight,
                                                      adjustedWidth,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.logout,
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
