import 'package:flutter/material.dart';
import 'package:image_gradient/image_gradient.dart';
import '../api/anilist_api.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:flutter_nime/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? bannerImageUrl;
  String? avatarImageUrl;
  String? userName;

  List<AnimeModel>? watchingList;
  List<AnimeModel>? planningList;
  List<AnimeModel>? pausedList;

  @override
  void initState() {
    super.initState();
    getUserInfo("Kiwib5");
  }

  void getUserInfo(String user) async {
    //TODO dehardcode username
    userName = user;
    String newbannerUrl = await getUserbannerImageUrl(userName!);
    String newavatarUrl = await getUserAvatarImageUrl(userName!);
    List<AnimeModel> newWatchingAnimeList = await getUserAnimeLists(859862, "Watching");
    List<AnimeModel> newPlanningAnimeList = await getUserAnimeLists(859862, "Planning");
    List<AnimeModel> newPausedAnimeList = await getUserAnimeLists(859862, "Paused");
    setState(() {
      bannerImageUrl = newbannerUrl;
      avatarImageUrl = newavatarUrl;
      watchingList = newWatchingAnimeList;
      planningList = newPlanningAnimeList;
      pausedList = newPausedAnimeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              bannerImageUrl != null
                  ? Stack(
                      children: [
                        ImageGradient.linear(
                          image: Image.network(
                            bannerImageUrl!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
                            fit: BoxFit.fill,
                          ),
                          colors: const [Colors.white, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        avatarImageUrl != null
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      avatarImageUrl!,
                                      scale: 1,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      userName!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimeButton(
                        text: "Animes",
                        onTap: () {
                          Navigator.popAndPushNamed(context, "animeScreen");
                        },
                      ),
                      AnimeButton(
                        text: "Mangas",
                        onTap: () {
                          Navigator.popAndPushNamed(context, "mangaScreen");
                        },
                      ),
                    ],
                  ),
                  watchingList != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: AnimeWidgetList(
                            tag: "home-details",
                            title: "Continue Watching",
                            animeList: watchingList!,
                            textColor: Colors.white,
                            loadMore: false,
                          ),
                        )
                      : const SizedBox(),
                  planningList != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: AnimeWidgetList(
                            tag: "home-details",
                            title: "Why don't you see what you planned! :P",
                            animeList: planningList!,
                            textColor: Colors.white,
                            loadMore: false,
                          ),
                        )
                      : const SizedBox(),
                  pausedList != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: AnimeWidgetList(
                            tag: "home-details",
                            title: "Why don't you resume your animes!",
                            animeList: pausedList!,
                            textColor: Colors.white,
                            loadMore: false,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
