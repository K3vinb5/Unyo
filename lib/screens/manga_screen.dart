import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
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

  @override
  void initState() {
    super.initState();
    pageScrollController.addListener(setScrollListener);
    initPage();
    initMangaList();
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

    List<MangaModel> newPageBannerMangaList =
        List.from(newSeasonPopularList);

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
                  SingleChildScrollView(
                    controller: pageScrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              goTo(1);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16.0, top: 32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Home Screen  ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: totalHeight * 0.3,
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
                              builder: (context) => const MediaSearchScreen(type: "MANGA",),
                            ));
                          },
                          width: adjustedWidth,
                          height: adjustedHeight,
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
