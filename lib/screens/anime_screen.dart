import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/models/anime_model.dart';
import 'package:unyo/router/custom_page_route.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({super.key});

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

void Function() resumeAnimePageTimer = () {};
void Function() pauseAnimePageTimer = () {};
void Function(void Function()) refreshAnimeScreenState = (func) {};

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
  bool pageTimerStarted = false;
  final ValueNotifier<bool> bannerInfoVisible = ValueNotifier(true);
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
    resumeAnimePageTimer = initPage;
    initPage();
    pauseAnimePageTimer = () {
      pageTimer.cancel();
    };
    refreshAnimeScreenState = setState;
    initAnimeList();
  }

  void getBanner() async {
    String? newUrl;
    newUrl = await getRandomAnimeBanner(0);
    setState(() {
      randomAnimeBanner = newUrl;
    });
  }

  void initPage() {
    if (pageTimerStarted) {
      pageTimer.cancel();
    } else {
      pageTimerStarted = true;
    }
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
    final offset = pageScrollController.offset;
    if (offset > 200 && bannerInfoVisible.value) {
      bannerInfoVisible.value = false;
    } else if (offset < 200 && !bannerInfoVisible.value) {
      bannerInfoVisible.value = true;
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
      // color: const Color.fromARGB(255, 34, 33, 34),
      child: LayoutBuilder(
        builder: (context, constraints) {
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height, context);
          adjustedWidth =
              getAdjustedWidth(MediaQuery.of(context).size.width, context);
          totalWidth = MediaQuery.of(context).size.width;
          totalHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              seasonPopularAnimeList.isNotEmpty
                  ? SizedBox(
                      height: totalHeight * 0.35,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: bannerInfoVisible,
                        builder: (context, value, child) => AnimatedOpacity(
                          opacity: value ? 1.0 : 0.0,
                          duration: !value
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
                      ),
                    )
                  : const SizedBox(),
              Stack(
                children: [
                  Column(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: bannerInfoVisible,
                        builder: (context, value, child) => AnimatedOpacity(
                          opacity: seasonPopularAnimeList.isEmpty
                              ? 1
                              : !value
                                  ? 1.0
                                  : 0.0,
                          duration: !value
                              ? const Duration(milliseconds: 300)
                              : const Duration(milliseconds: 1500),
                          child: Container(
                            height: totalHeight * 0.34,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 33, 34),
                              border: Border.all(
                                color: const Color.fromARGB(255, 34, 33, 34),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: totalHeight * 0.66,
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
                                    StyledScreenMenuWidget(
                                      onMenuPress: buttonsLayout,
                                      onBackPress: () {
                                        goTo(1);
                                      },
                                      onRefreshPress: () {
                                        initAnimeList();
                                        AnimatedSnackBar.material(
                                          "Refreshing Page",
                                          type: AnimatedSnackBarType.info,
                                          desktopSnackBarPosition:
                                              DesktopSnackBarPosition.topCenter,
                                        ).show(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: totalHeight * 0.37,
                              ),
                            ],
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: bannerInfoVisible,
                            builder: (context, value, child) => AnimatedOpacity(
                              opacity: value ? 1.0 : 0.0,
                              duration: !value
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
                                    label: context.tr("search"),
                                    labelColor: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimeWidgetList(
                            tag: "anime-details-list1",
                            title: context.tr("recently_released"),
                            animeList: recentlyReleased,
                            textColor: Colors.white,
                            loadMore: true,
                            loadMoreFunction: getAnimeModelListRecentlyReleased,
                            width: adjustedWidth,
                            totalWidth: totalWidth,
                            height: adjustedHeight,
                          ),
                          AnimeWidgetList(
                            tag: "anime-details-list2",
                            title: context.tr("trending"),
                            animeList: trendingAnimeList,
                            textColor: Colors.white,
                            loadMore: true,
                            loadMoreFunction: getAnimeModelListTrending,
                            width: adjustedWidth,
                            totalWidth: totalWidth,
                            height: adjustedHeight,
                          ),
                          AnimeWidgetList(
                            tag: "anime-details-list3",
                            title: context.tr("season_popular"),
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
                            totalWidth: totalWidth,
                            height: adjustedHeight,
                          ),
                          const SizedBox(height: 20),
                          AnimeButton(
                            text: context.tr("advanced_search"),
                            dontHide: true,
                            onTap: () {
                              // pageTimer.cancel();
                              Navigator.of(context).push(
                                customPageRouter(
                                  const AnimeSearchScreen(),
                                ),
                              );
                            },
                            width: adjustedWidth,
                            height: adjustedHeight,
                            horizontalAllignment: true,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const WindowBarButtons(startIgnoreWidth: 70),
            ],
          );
        },
      ),
    );
  }
}
