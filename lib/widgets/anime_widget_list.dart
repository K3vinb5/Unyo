import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/anime_details_screen.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import '../api/anilist_api.dart';
import 'package:collection/collection.dart';

class AnimeWidgetList extends StatefulWidget {
  const AnimeWidgetList(
      {super.key,
      required this.title,
      required this.animeList,
      required this.textColor,
      required this.loadMore,
      required this.tag,
      this.loadMoreFunction,
      });

  final String title;
  final List<AnimeModel> animeList;
  final Color textColor;
  final bool loadMore;
  final Future<List<AnimeModel>> Function(int, int, int)? loadMoreFunction;
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

  void openAnime(AnimeModel currentAnime, String tag) {
    animeScreen = AnimeDetailsScreen(
      currentAnime: currentAnime,
      tag: tag,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...animeList.mapIndexed((index, animeModel) {
                    return Hero(
                      tag: "${widget.tag}-$index",
                      child: AnimeWidget(
                        title: animeModel.title,
                        score: animeModel.averageScore,
                        coverImage: animeModel.coverImage,
                        onTap: () {
                          openAnime(animeModel, "${widget.tag}-$index");
                        },
                        textColor: widget.textColor,
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width * 0.1,
                        year: animeModel.startDate,
                        format: animeModel.format,
                        status: animeModel.status,
                      ),
                    );
                  }),
                  //load More
                  widget.loadMore
                      ? AnimeWidget(
                          title: "",
                          score: null,
                          coverImage: "https://i.ibb.co/Kj8CQZH/cross.png",
                          onTap: () async {
                            var newTrendingList =
                                await widget.loadMoreFunction!(currentPage++, 20, 0);
                            setState(() {
                              animeList += newTrendingList;
                            });
                          },
                          textColor: widget.textColor,
                          height: MediaQuery.of(context).size.height * 0.28,
                          width: MediaQuery.of(context).size.width * 0.1,
                          status: null,
                          format: null,
                          year: null,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
