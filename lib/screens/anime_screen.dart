import 'package:flutter/material.dart';
import 'package:flutter_nime/api/anilist_api.dart';
import 'package:flutter_nime/models/anime_model.dart';
import 'package:flutter_nime/widgets/widgets.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({super.key});

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  late List<AnimeModel> trendingAnimeList = [];

  @override
  void initState() {
    super.initState();
    initAnimeList();
  }

  void initAnimeList() async {
    var newTrendingList = await getAnimeModelListTrending(1, 20);
    setState(() {
      trendingAnimeList = newTrendingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimeWidgetList(
          tag: "anime-details",
          title: "Trending",
          animeList: trendingAnimeList,
          textColor: Colors.black,
          loadMore: true,
          loadMoreFunction: getAnimeModelListTrending,
        ),
      ],
    );
  }
}
