import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unyo/api/anilist_api.dart';
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
  List<AnimeModel> searchAnimeList = [];
  List<String> sortBy = [
    "Select Sorting",
    "Score",
    "Popularity",
    "Trending",
    "A-Z",
    "Z-A"
  ];
  List<String> format = [
    "Select Format",
    "Tv",
    "Tv Short",
    "Movie",
    "Special",
    "Ova",
    "Ona",
    "Music"
  ];
  List<String> season = ["Select Season", "Winter", "Spring", "Summer", "Fall"];
  late List<String> years;
  String currentSortBy = "Select Sorting";
  String currentFormat = "Select Format";
  String currentSeason = "Select Season";
  String currentYear = "Select Year";
  TextEditingController textFieldController = TextEditingController();
  Timer searchTimer = Timer(const Duration(milliseconds: 500), () {});
  String? randomAnimeBanner;
  final PageController pageController = PageController();
  int currentPage = 0;
  bool pageLeftToRight = true;
  late Timer pageTimer;
  ScrollController scrollController = ScrollController();
  bool bannerInfoVisible = true;
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  ScrollPhysics searchScrollPhysics = const NeverScrollableScrollPhysics();
  ScrollController searchScrollController = ScrollController();
  ScrollPhysics pageScrollPhysics = const NeverScrollableScrollPhysics();
  ScrollController pageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(setScrollListener);
    initPage();
    initAnimeList();
    initYearsList();
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
    searchScrollController.addListener(() {
      if (searchScrollController.offset == 0){
        searchScrollPhysics = const NeverScrollableScrollPhysics();
        pageScrollPhysics = const AlwaysScrollableScrollPhysics();
      }
    });

    pageScrollController.addListener((){
      print(pageScrollController.offset);
      if (pageScrollController.offset == 1){
        searchScrollPhysics = const AlwaysScrollableScrollPhysics();
        pageScrollPhysics = const NeverScrollableScrollPhysics();
      }
    });
  }

  void setScrollListener() {
    if (scrollController.offset > 200 && bannerInfoVisible) {
      setState(() {
        bannerInfoVisible = false;
      });
    } else if (scrollController.offset <= 200 && !bannerInfoVisible) {
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
    resetSearchTimer("");
  }

  void initYearsList() {
    years = ["Select Year"];
    for (int i = DateTime.now().year; i >= 1970; i--) {
      years.add(i.toString());
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

  void resetSearchTimer(String search) {
    searchTimer.cancel();
    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      var newSearchAnimeList = await getAnimeModelListSearch(
          search, currentSortBy, currentSeason, currentFormat, currentYear, 50);
      setState(() {
        searchAnimeList = newSearchAnimeList;
      });
    });
  }

  int _calculateCrossAxisCount(BuildContext context, double receivedWidth) {
    double widgetWidth = 16.0 + (receivedWidth > minimumWidth ? receivedWidth : minimumWidth);
    double screenWidth = totalWidth - 40;
    int crossAxisCount = (screenWidth / widgetWidth).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1; // Minimum 1 column
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
                    controller: scrollController,
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
                              padding: EdgeInsets.all(16.0),
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
                        SizedBox(
                          height: totalHeight,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Search new Animes!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                              const Divider(
                                height: 15,
                                thickness: 2,
                                indent: 70,
                                endIndent: 70,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  StyledTextField(
                                    width: totalWidth * 0.22,
                                    controller: textFieldController,
                                    onChanged: (text) {
                                      resetSearchTimer(text);
                                    },
                                    color: Colors.white,
                                    hintColor: Colors.grey,
                                    hint: "Search...",
                                  ),
                                  StyledDropDown(
                                    width: totalWidth * 0.22,
                                    onTap: (index) {
                                      currentFormat = format[index];
                                      resetSearchTimer(
                                          textFieldController.text);
                                    },
                                    horizontalPadding: 0,
                                    items: const [
                                      Text("Select Format"),
                                      Text("Tv"),
                                      Text("Tv Short"),
                                      Text("Movie"),
                                      Text("Special"),
                                      Text("Ova"),
                                      Text("Ona"),
                                      Text("Music"),
                                    ],
                                  ),
                                  SizedBox(
                                    width: totalWidth * 0.26,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StyledDropDown(
                                          width: totalWidth * 0.12,
                                          onTap: (index) {
                                            currentSeason = season[index];
                                            resetSearchTimer(
                                                textFieldController.text);
                                          },
                                          horizontalPadding: 0,
                                          items: const [
                                            Text("Select Season"),
                                            Text("Winter"),
                                            Text("Spring"),
                                            Text("Summer"),
                                            Text("Fall"),
                                          ],
                                        ),
                                        StyledDropDown(
                                          width: totalWidth * 0.12,
                                          onTap: (index) {
                                            currentYear = years[index];
                                            resetSearchTimer(
                                                textFieldController.text);
                                          },
                                          horizontalPadding: 0,
                                          items: [
                                            ...years.map(
                                                  (year) {
                                                return Text("$year");
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  StyledDropDown(
                                    onTap: (index) {
                                      currentSortBy = sortBy[index];
                                      resetSearchTimer(
                                          textFieldController.text);
                                    },
                                    width: totalWidth * 0.22,
                                    horizontalPadding: 0,
                                    items: const [
                                      Text("Select Sorting"),
                                      Text("Score"),
                                      Text("Popularity"),
                                      Text("Trending"),
                                      Text("A-Z"),
                                      Text("Z-A"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SingleChildScrollView(
                                physics: searchScrollPhysics,
                                controller: searchScrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal : 20.0),
                                  child: SizedBox(
                                    width: totalWidth,
                                    height: totalHeight - 172,
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _calculateCrossAxisCount(context, adjustedWidth * 0.1),
                                        mainAxisExtent: totalHeight * 0.36,
                                      ),
                                      //padding: const EdgeInsets.all(10.0),
                                      shrinkWrap: false,

                                      itemCount: searchAnimeList.length, // Replace it with your actual list length
                                      itemBuilder: (BuildContext context, int index) {
                                        var animeModel = searchAnimeList[index];
                                        double calculatedWidth = adjustedWidth * 0.1;
                                        double calculatedHeight = adjustedHeight * 0.28;
                                        return Hero(
                                          tag: "${"grid-view"}-$index",
                                          child: AnimeWidget(
                                            title: animeModel.title,
                                            score: animeModel.averageScore,
                                            coverImage: animeModel.coverImage,
                                            onTap: () {
                                              openAnime(animeModel, "${"grid-view"}-$index");
                                            },
                                            textColor: Colors.white,
                                            height: calculatedHeight > minimumHeight ? calculatedHeight : minimumHeight,
                                            width: calculatedWidth > minimumWidth ? calculatedWidth : minimumWidth,
                                            year: animeModel.startDate,
                                            format: animeModel.format,
                                            status: animeModel.status,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
