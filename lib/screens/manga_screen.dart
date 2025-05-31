import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/anilist_api_manga.dart';
import 'package:flutter/material.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/router/custom_page_route.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

void Function() resumeMangaPageTimer = () {};
void Function() pauseMangaPageTimer = () {};
void Function(void Function()) refreshMangaScreenState = (func) {};

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
    resumeMangaPageTimer = initPage;
    initPage();
    pauseMangaPageTimer = () {
      pageTimer.cancel();
    };
    refreshMangaScreenState = setState;
    initMangaList();
  }

  void setScrollListener() {
    final offset = pageScrollController.offset;
    if (offset > 200 && bannerInfoVisible.value) {
      bannerInfoVisible.value = false;
    } else if (offset < 200 && !bannerInfoVisible.value) {
      bannerInfoVisible.value = true;
    }
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
              seasonPopularMangaList.isNotEmpty
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
                              ...pageBannerMangaList.map(
                                (mangaModel) {
                                  return PageBannerWidget(
                                    animeModel: AnimeModel(
                                        id: mangaModel.id,
                                        userPreferedTitle:
                                            mangaModel.getDefaultTitle(),
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
                                        genres: mangaModel.genres,
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
                          opacity: seasonPopularMangaList.isEmpty
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
                                        if (updateHomeScreenLists != null) {
                                          updateHomeScreenLists!();
                                        }
                                        pageTimer.cancel();
                                        goTo(1);
                                      },
                                      onRefreshPress: () {
                                        initMangaList();
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
                                  SearchingMangaMenu(
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
                          MangaWidgetList(
                            tag: "manga-details-list2",
                            title: context.tr("trending"),
                            mangaList: trendingMangaList,
                            textColor: Colors.white,
                            loadMore: true,
                            loadMoreFunction: getMangaModelListTrending,
                            width: adjustedWidth,
                            totalWidth: totalWidth,
                            height: adjustedHeight,
                          ),
                          MangaWidgetList(
                            tag: "manga-details-list3",
                            title: context.tr("yearly_popular"),
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
                            totalWidth: totalWidth,
                            height: adjustedHeight,
                          ),
                          const SizedBox(height: 20),
                          AnimeButton(
                            dontHide: true,
                            text: context.tr("advanced_search"),
                            onTap: () {
                              Navigator.of(context).push(
                                customPageRouter(
                                  const MangaSearchScreen(),
                                ),
                              );
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
              const WindowBarButtons(startIgnoreWidth: 70),
            ],
          );
        },
      ),
    );
  }
}
