import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/anime_details_screen.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import '../api/anilist_api.dart';

class AnimeWidgetList extends StatefulWidget {
  const AnimeWidgetList(
      {super.key,
      required this.title,
      required this.animeList,
      required this.textColor,
      required this.loadMore,
      required this.tag,
      this.loadMoreFunction});

  final String title;
  final List<AnimeModel> animeList;
  final Color textColor;
  final bool loadMore;
  final Future<List<AnimeModel>> Function(int, int)? loadMoreFunction;
  final String tag;

  @override
  State<AnimeWidgetList> createState() => _AnimeWidgetListState();
}

class _AnimeWidgetListState extends State<AnimeWidgetList> {
  late List<AnimeModel> animeList;
  late AnimeDetailsScreen animeScreen;
  int currentPage = 2;

  @override
  void initState() {
    super.initState();
    animeList = widget.animeList;
  }

  @override
  void didUpdateWidget(covariant AnimeWidgetList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animeList != widget.animeList) {
      setState(() {
        animeList = widget.animeList;
      });
    }
  }

  void openAnime(AnimeModel currentAnime) {
    animeScreen = AnimeDetailsScreen(
      currentAnime: currentAnime,
      tag: widget.tag,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => animeScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
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
                  return Hero(
                    tag: "${widget.tag}-${animeModel.id}",
                    child: AnimeWidget(
                      title: animeModel.title,
                      score: animeModel.averageScore,
                      coverImage: animeModel.coverImage,
                      onTap: () {
                        openAnime(animeModel);
                      },
                      textColor: widget.textColor,
                    ),
                  );
                }),
                //load More
                widget.loadMore
                    ? AnimeWidget(
                        title: "Load More",
                        score: -1,
                        coverImage: "https://i.ibb.co/Kj8CQZH/cross.png",
                        onTap: () async {
                          var newTrendingList =
                              await widget.loadMoreFunction!(currentPage++, 20);
                          setState(() {
                            animeList += newTrendingList;
                          });
                        },
                        textColor: widget.textColor,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
