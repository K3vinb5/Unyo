import 'dart:async';
import 'package:unyo/api/consumet_api.dart';
import 'package:unyo/api/anilist_api_manga.dart';
import 'package:flutter/material.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/models/models.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

class _MangaScreenState extends State<MangaScreen> {
  List<AnimeModel> recentlyReleased = [];
  List<AnimeModel> trendingMangaList = [];
  List<AnimeModel> seasonPopularMangaList = [];
  List<AnimeModel> pageBannerMangaList = [];
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
    List<AnimeModel> newSeasonPopularList = []/*await getMangaModelListSeasonPopular(
        1, 20, DateTime.now().year, getCurrentSeason(), 0)*/;
    var newRecentlyReleaseList =
    await getAnimeModelListRecentlyReleased(1, 20, 0);
    List<AnimeModel> newPageBannerAnimeList = List.from(newSeasonPopularList);
    newPageBannerAnimeList
        .removeWhere((animeModel) => animeModel.bannerImage == null);
    setState(() {
      recentlyReleased = newRecentlyReleaseList;
      trendingMangaList = newTrendingList;
      seasonPopularMangaList = newSeasonPopularList;
      pageBannerMangaList = newPageBannerAnimeList;
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
    return const Placeholder();
  }
}
