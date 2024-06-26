import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/anilist_api_manga.dart';
import 'package:flutter/material.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/widgets/widgets.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

void Function() resumeMangaPageTimer = () {};

class _MangaScreenState extends State<MangaScreen> {
  List<MangaModel> recentlyReleased = [];
  List<MangaModel> trendingMangaList = [];
  List<MangaModel> seasonPopularMangaList = [];
  List<MangaModel> pageBannerMangaList = [];
  String? randomMangaBanner;
  final PageController pageController = PageController();
  int currentPage = 0;
  bool pageLeftToRight = true;
  late Timer pageTimer;
  bool bannerInfoVisible = true;
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  ScrollController pageScrollController = ScrollController();
  TextEditingController quickSearchController = TextEditingController();
  bool isShiftKeyPressed = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    pageScrollController.addListener(setScrollListener);
    resumeMangaPageTimer = initPage;
    initPage();
    initMangaList();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      setState(() {
        isShiftKeyPressed = true;
      });
      return true;
    } else if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      setState(() {
        isShiftKeyPressed = false;
      });
      return true;
    }
    return false;
  }

  void setScrollListener() {
    if (pageScrollController.offset > 200 && bannerInfoVisible) {
      setState(() {
        bannerInfoVisible = false;
      });
    } else if (pageScrollController.offset <= 200 && !bannerInfoVisible) {
      setState(() {
        bannerInfoVisible = true;
      });
    }
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

  void initPage() {
    pageTimer = Timer.periodic(
      const Duration(seconds: 7),
      (Timer timer) {
        if (pageLeftToRight) {
          if (currentPage < seasonPopularMangaList.length) {
            currentPage++;
          } else {
            pageLeftToRight = false;
            currentPage--;
          }
        } else {
          if (currentPage > 0) {
            currentPage--;
          } else {
            pageLeftToRight = true;
            currentPage++;
          }
        }

        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeIn,
        );
      },
    );
  }

  void initMangaList() async {
    var newTrendingList = await getMangaModelListTrending(1, 20, 0);

    List<MangaModel> newSeasonPopularList =
        await getMangaModelListYearlyPopular(1, DateTime.now().year, 0, 20);

    // var newRecentlyReleaseList = await getMangaModelListRecentlyReleased(1, 20, 0);

    List<MangaModel> newPageBannerMangaList = List.from(newSeasonPopularList);

    newPageBannerMangaList
        .removeWhere((mangaModel) => mangaModel.bannerImage == null);
    setState(() {
      trendingMangaList = newTrendingList;
      seasonPopularMangaList = newSeasonPopularList;
      pageBannerMangaList = newPageBannerMangaList;
      // recentlyReleased = newRecentlyReleaseList;
    });
  }

  String getCurrentSeason() {
    int month = DateTime.now().month;

    switch (month) {
      case 1:
      case 2:
      case 3:
        return 'WINTER';
      case 4:
      case 5:
      case 6:
        return 'SPRING';
      case 7:
      case 8:
      case 9:
        return 'SUMMER';
      case 10:
      case 11:
      case 12:
        return 'FALL';
      default:
        return 'WINTER';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height);
          adjustedWidth = getAdjustedWidth(MediaQuery.of(context).size.width);
          totalWidth = MediaQuery.of(context).size.width;
          totalHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              seasonPopularMangaList.isNotEmpty
                  ? SizedBox(
                      height: totalHeight * 0.35,
                      child: AnimatedOpacity(
                        opacity: bannerInfoVisible ? 1.0 : 0.0,
                        duration: !bannerInfoVisible
                            ? const Duration(milliseconds: 1500)
                            : const Duration(milliseconds: 300),
                        child: PageView(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...pageBannerMangaList.map(
                              (mangaModel) {
                                return PageBannerWidget(
                                  animeModel: AnimeModel(
                                      id: mangaModel.id,
                                      title: mangaModel.title,
                                      coverImage: mangaModel.coverImage,
                                      bannerImage: mangaModel.bannerImage,
                                      startDate: mangaModel.startDate,
                                      endDate: mangaModel.endDate,
                                      type: mangaModel.type,
                                      status: mangaModel.status,
                                      averageScore: mangaModel.averageScore,
                                      episodes: mangaModel.chapters,
                                      duration: mangaModel.duration,
                                      description: mangaModel.description,
                                      format: mangaModel.format),
                                  width: totalWidth,
                                  height: totalHeight * 0.35,
                                  adjustedWidth: adjustedWidth,
                                  adjustedHeight: adjustedHeight,
                                );
                              },
                            ),
                          ],
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
              Stack(
                children: [
                  Column(
                    children: [
                      AnimatedOpacity(
                        opacity: seasonPopularMangaList.isEmpty
                            ? 1
                            : !bannerInfoVisible
                                ? 1.0
                                : 0.0,
                        duration: !bannerInfoVisible
                            ? const Duration(milliseconds: 300)
                            : const Duration(milliseconds: 1500),
                        child: Container(
                          height: totalHeight * 0.35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 34, 33, 34),
                            border: Border.all(
                              color: const Color.fromARGB(255, 34, 33, 34),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: totalHeight * 0.65,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 34, 33, 34),
                          ),
                          color: const Color.fromARGB(255, 34, 33, 34),
                        ),
                      ),
                    ],
                  ),
                  SmoothListView(
                    controller: pageScrollController,
                    duration: const Duration(milliseconds: 200),
                    shouldScroll: !isShiftKeyPressed,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 4.0, bottom: 4.0),
                                      child: IconButton(
                                        onPressed: () {
                                          if (updateHomeScreenLists != null) {
                                            updateHomeScreenLists!();
                                          }
                                          pageTimer.cancel();
                                          goTo(1);
                                        },
                                        icon: const Icon(Icons.arrow_back),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 4.0),
                                      child: IconButton(
                                        onPressed: () {
                                          initMangaList();
                                          AnimatedSnackBar.material(
                                            "Refreshing Page",
                                            type: AnimatedSnackBarType.info,
                                            desktopSnackBarPosition:
                                                DesktopSnackBarPosition
                                                    .topCenter,
                                          ).show(context);
                                        },
                                        icon: const Icon(Icons.refresh),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: totalHeight * 0.37,
                              ),
                            ],
                          ),
                          AnimatedOpacity(
                            opacity: bannerInfoVisible ? 1.0 : 0.0,
                            duration: !bannerInfoVisible
                                ? const Duration(milliseconds: 300)
                                : const Duration(milliseconds: 1500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SearchingMangaMenu(
                                  width: 400,
                                  controller: quickSearchController,
                                  color: Colors.white,
                                  hintColor: Colors.grey,
                                  label: "Search...",
                                  labelColor: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),

                          /*MangaWidgetList(
                          tag: "manga-details-list1",
                          title: "Recently Released",
                          animeList: recentlyReleased,
                          textColor: Colors.white,
                          loadMore: true,
                          loadMoreFunction: getAnimeModelListRecentlyReleased,
                          width: adjustedWidth,
                          height: adjustedHeight,
                        ),*/
                          MangaWidgetList(
                            tag: "manga-details-list2",
                            title: "Trending",
                            mangaList: trendingMangaList,
                            textColor: Colors.white,
                            loadMore: true,
                            loadMoreFunction: getMangaModelListTrending,
                            width: adjustedWidth,
                            height: adjustedHeight,
                          ),
                          MangaWidgetList(
                            tag: "manga-details-list3",
                            title: "Yearly Popular",
                            mangaList: seasonPopularMangaList,
                            textColor: Colors.white,
                            loadMore: true,
                            loadMoreFunction: (int page, int n, int attempt) {
                              return getMangaModelListYearlyPopular(
                                  page,
                                  n,
                                  DateTime.now().year,
                                  // getCurrentSeason(),
                                  attempt);
                            },
                            width: adjustedWidth,
                            height: adjustedHeight,
                          ),
                          const SizedBox(height: 20),
                          AnimeButton(
                            text: "Advanced Search",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MediaSearchScreen(
                                  type: "MANGA",
                                ),
                              ));
                            },
                            width: adjustedWidth,
                            height: adjustedHeight,
                            horizontalAllignment: false,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ],
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
          );
        },
      ),
    );
  }
}
