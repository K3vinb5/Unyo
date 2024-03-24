import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/anime_screen.dart';
import 'package:flutter_nime/widgets/widgets.dart';

class AnimeWidgetList extends StatefulWidget {
  const AnimeWidgetList({super.key, required this.title, required this.animeList});

  final String title;
  final List<AnimeModel> animeList;

  @override
  State<AnimeWidgetList> createState() => _AnimeWidgetListState();
}

class _AnimeWidgetListState extends State<AnimeWidgetList> {

  late List<AnimeModel> animeList;
  late AnimeScreen animeScreen;

  @override
  void initState() {
    super.initState();
    animeList = widget.animeList;
  }

  @override
  void didUpdateWidget(covariant AnimeWidgetList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animeList != widget.animeList){
      setState(() {
        animeList = widget.animeList;
      });
    }
  }

  void openAnime(AnimeModel currentAnime){
    animeScreen = AnimeScreen(currentAnime: currentAnime);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => animeScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 350,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...animeList.map((animeModel) {
                return AnimeWidget(
                  title: animeModel.title,
                  score: animeModel.averageScore,
                  coverImage: animeModel.coverImage,
                  onTap: () {
                    openAnime(animeModel);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

