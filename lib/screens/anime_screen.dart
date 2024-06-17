import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/models/anime_model.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/widgets/widgets.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({super.key});

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  List<AnimeModel> recentlyReleased = [];
  List<AnimeModel> trendingAnimeList = [];
  List<AnimeModel> seasonPopularAnimeList = [];
  List<AnimeModel> pageBannerAnimeList = [];
  String? randomAnimeBanner;
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

  @override
  void initState() {
    super.initState();
    pageScrollController.addListener(setScrollListener);
    initPage();
    initAnimeList();
  }

  void getBanner() async {
    String? newUrl;
    newUrl = await getRandomAnimeBanner(0);
    setState(() {
      randomAnimeBanner = newUrl;
    });
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
          if (currentPage < seasonPopularAnimeList.length) {
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

  void initAnimeList() async {
    var newTrendingList = await getAnimeModelListTrending(1, 20, 0);
    var newSeasonPopularList = await getAnimeModelListSeasonPopular(
        1, 20, DateTime.now().year, getCurrentSeason(), 0);
    var newRecentlyReleaseList =
        await getAnimeModelListRecentlyReleased(1, 20, 0);
    List<AnimeModel> newPageBannerAnimeList = List.from(newSeasonPopularList);
    newPageBannerAnimeList
        .removeWhere((animeModel) => animeModel.bannerImage == null);
    setState(() {
      recentlyReleased = newRecentlyReleaseList;
      trendingAnimeList = newTrendingList;
      seasonPopularAnimeList = newSeasonPopularList;
      pageBannerAnimeList = newPageBannerAnimeList;
    });
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
              seasonPopularAnimeList.isNotEmpty
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
                            ...pageBannerAnimeList.map(
                              (animeModel) {
                                return PageBannerWidget(
                                  animeModel: animeModel,
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
                        opacity: seasonPopularAnimeList.isEmpty
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
                  SingleChildScrollView(
                    controller: pageScrollController,
                    child: Column(
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
                                        initAnimeList();
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
                              SearchingAnimeMenu(
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
                        AnimeWidgetList(
                          tag: "anime-details-list1",
                          title: "Recently Released",
                          animeList: recentlyReleased,
                          textColor: Colors.white,
                          loadMore: true,
                          loadMoreFunction: getAnimeModelListRecentlyReleased,
                          width: adjustedWidth,
                          height: adjustedHeight,
                        ),
                        AnimeWidgetList(
                          tag: "anime-details-list2",
                          title: "Trending",
                          animeList: trendingAnimeList,
                          textColor: Colors.white,
                          loadMore: true,
                          loadMoreFunction: getAnimeModelListTrending,
                          width: adjustedWidth,
                          height: adjustedHeight,
                        ),
                        AnimeWidgetList(
                          tag: "anime-details-list3",
                          title: "Season Popular",
                          animeList: seasonPopularAnimeList,
                          textColor: Colors.white,
                          loadMore: true,
                          loadMoreFunction: (int page, int n, int attempt) {
                            return getAnimeModelListSeasonPopular(
                                page,
                                n,
                                DateTime.now().year,
                                getCurrentSeason(),
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
                                type: "ANIME",
                              ),
                            ));
                          },
                          width: adjustedWidth,
                          height: adjustedHeight,
                          horizontalAllignment: true,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
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
