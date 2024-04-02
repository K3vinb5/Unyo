import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nime/api/anilist_api.dart';
import 'package:flutter_nime/models/anime_model.dart';
import 'package:flutter_nime/widgets/widgets.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({super.key});

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen>{
  List<AnimeModel> recentlyReleased = [];
  List<AnimeModel> trendingAnimeList = [];
  List<AnimeModel> seasonPopularAnimeList = [];
  List<AnimeModel> pageBannerAnimeList = [];
  List<AnimeModel> searchAnimeList = [];
  List<String> sortBy = [
    "Select Sorting",
    "Score",
    "Popular",
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

  void initPage() {
    pageTimer = Timer.periodic(
      const Duration(seconds: 7),
      (Timer timer) {
        if (pageLeftToRight){
          if (currentPage < seasonPopularAnimeList.length) {
            currentPage++;
          } else {
            pageLeftToRight = false;
            currentPage--;
          }
        }else{
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
    var newRecentlyReleaseList = await getAnimeModelListRecentlyReleased(1, 20, 0);
    List<AnimeModel> newPageBannerAnimeList = List.from(newSeasonPopularList);
    newPageBannerAnimeList.removeWhere((animeModel) => animeModel.bannerImage == null);
    setState(() {
      recentlyReleased = newRecentlyReleaseList;
      trendingAnimeList = newTrendingList;
      seasonPopularAnimeList = newSeasonPopularList;
      pageBannerAnimeList = newPageBannerAnimeList;
    });
  }

  void initYearsList() {
    years = ["Select Year"];
    for (int i = DateTime.now().year; i >= 1970; i--) {
      years.add(i.toString());
    }
  }

  void resetSearchTimer(String search) {
    searchTimer.cancel();
    searchTimer = Timer(const Duration(seconds: 8), () async {
      var newSearchAnimeList = await getAnimeModelListSearch(
          search, currentSortBy, currentSeason, currentFormat, currentYear, 40);
      setState(() {
        searchAnimeList = newSearchAnimeList;
      });
    });
  }

  List<Widget> formattedSearchResults(List<AnimeModel> searchAnimeList){
    List<Widget> returnList = [];
    for (int i = 0; i < searchAnimeList.length; i+=2){

     if (i + 1 == searchAnimeList.length){
       returnList.add(Row(
         children: [
           AnimeListComponentWidget(
             tag: "search-list-$i",
             verticalPadding: 10.0,
             horizontalPadding: 16.0,
             animeModel: searchAnimeList[i],
             width: MediaQuery.of(context)
                 .size
                 .width *
                 0.32,
             height: MediaQuery.of(context)
                 .size
                 .height *
                 0.22,
           ),
         ],
       )
       );
     }else{
       returnList.add(
           Row(
             children: [
               AnimeListComponentWidget(
                 tag: "search-list-$i",
                 verticalPadding: 10.0,
                 horizontalPadding: 16.0,
                 animeModel: searchAnimeList[i],
                 width: MediaQuery.of(context)
                     .size
                     .width *
                     0.32,
                 height: MediaQuery.of(context)
                     .size
                     .height *
                     0.22,
               ),
               AnimeListComponentWidget(
                 tag: "search-list-${(i+1)}",
                 verticalPadding: 10.0,
                 horizontalPadding: 16.0,
                 animeModel: searchAnimeList[i + 1],
                 width: MediaQuery.of(context)
                     .size
                     .width *
                     0.32,
                 height: MediaQuery.of(context)
                     .size
                     .height *
                     0.22,
               )
             ],
           )
       );
     }
    }
    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          seasonPopularAnimeList.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
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
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.35,
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
                    opacity: seasonPopularAnimeList.isEmpty ? 1 : !bannerInfoVisible ? 1.0 : 0.0,
                    duration: !bannerInfoVisible
                        ? const Duration(milliseconds: 300)
                        : const Duration(milliseconds: 1500),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 34, 33, 34),
                        border: Border.all(
                          color: const Color.fromARGB(255, 34, 33, 34),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
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
                          Navigator.pop(context);
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
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    AnimeWidgetList(
                      tag: "anime-details-list1",
                      title: "Recently Released",
                      animeList: recentlyReleased,
                      textColor: Colors.white,
                      loadMore: true,
                      loadMoreFunction: getAnimeModelListRecentlyReleased,
                    ),
                    AnimeWidgetList(
                      tag: "anime-details-list2",
                      title: "Trending",
                      animeList: trendingAnimeList,
                      textColor: Colors.white,
                      loadMore: true,
                      loadMoreFunction: getAnimeModelListTrending,
                    ),
                    AnimeWidgetList(
                      tag: "anime-details-list3",
                      title: "Season Popular",
                      animeList: seasonPopularAnimeList,
                      textColor: Colors.white,
                      loadMore: true,
                      loadMoreFunction: (int page, int n, int attempt) {
                        return getAnimeModelListSeasonPopular(
                            page, n, DateTime.now().year, getCurrentSeason(), attempt);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Filters",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 70,
                                      child: Text(
                                        "Sort By",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    StyledDropDown(
                                      onTap: (index) {
                                        currentSortBy = sortBy[index];
                                        resetSearchTimer(textFieldController.text);
                                      },
                                      width: 130,
                                      horizontalPadding: 22,
                                      items: const [
                                        Text("Select Sorting"),
                                        Text("Score"),
                                        Text("Popular"),
                                        Text("Trending"),
                                        Text("A-Z"),
                                        Text("Z-A"),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 70,
                                      child: Text(
                                        "Format",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    StyledDropDown(
                                      width: 130,
                                      onTap: (index) {
                                        currentFormat = format[index];
                                        resetSearchTimer(textFieldController.text);
                                      },
                                      horizontalPadding: 22,
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 70,
                                      child: Text(
                                        "Season",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    StyledDropDown(
                                      width: 130,
                                      onTap: (index) {
                                        currentSeason = season[index];
                                        resetSearchTimer(textFieldController.text);
                                      },
                                      horizontalPadding: 22,
                                      items: const [
                                        Text("Select Season"),
                                        Text("Winter"),
                                        Text("Spring"),
                                        Text("Summer"),
                                        Text("Fall"),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 70,
                                      child: Text(
                                        "Year",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    StyledDropDown(
                                      width: 130,
                                      onTap: (index) {
                                        currentYear = years[index];
                                        resetSearchTimer(textFieldController.text);
                                      },
                                      horizontalPadding: 22,
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
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 15, top: 10),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextField(
                                      controller: textFieldController,
                                      onChanged: (text) {
                                        resetSearchTimer(text);
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        hintText: "Search for Anime",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: ListView(
                                  children: [
                                    if (searchAnimeList.isNotEmpty || textFieldController.text != "") ...formattedSearchResults(searchAnimeList) else ...formattedSearchResults(seasonPopularAnimeList),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
