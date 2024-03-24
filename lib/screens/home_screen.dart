import 'package:flutter/material.dart';
import 'package:flutter_nime/api/anilist_api.dart';
import 'package:flutter_nime/api/consumet_api.dart';
import 'package:flutter_nime/models/anime_model.dart';
import 'package:flutter_nime/screens/video_screen.dart';
import 'package:flutter_nime/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<AnimeModel> trendingAnimeList = [];
  late VideoScreen videoScreen;

  @override
  void initState() {
    super.initState();
    initAnimeList();
  }

  void initAnimeList() async {
    var newTrendingList = await getAnimeModelListTrending(1, 50);
    setState(() {
      trendingAnimeList = newTrendingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimeWidgetList(title: "Trending", animeList: trendingAnimeList),
      ],
    );
  }
}
