import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nime/api/anilist_api.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/video_screen.dart';
import 'package:flutter_nime/widgets/episode_button.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';

import '../api/consumet_api.dart';

class AnimeDetailsScreen extends StatefulWidget {
  const AnimeDetailsScreen(
      {super.key, required this.currentAnime, required this.tag});

  final AnimeModel currentAnime;
  final String tag;

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  late VideoScreen videoScreen;
  UserAnimeModel? userAnimeModel;

  @override
  void initState() {
    super.initState();
    setUserAnimeModel();
  }

  void setUserAnimeModel() async {
    UserAnimeModel newUserAnimeModel =
        await getUserAnimeInfo(widget.currentAnime.id);
    setState(() {
      userAnimeModel = newUserAnimeModel;
    });
  }

  void openVideo(String animeTitle, int animeEpisode) async {
    String consumetId = await getAnimeConsumetId(animeTitle);
    if (consumetId == "") return; //case error
    String consumetStream = await getAnimeConsumetStream(consumetId, animeEpisode);
    videoScreen = VideoScreen(stream: consumetStream);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => videoScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              widget.currentAnime.bannerImage != null
                  ? Stack(
                      children: [
                        ImageGradient.linear(
                          image: Image.network(
                            widget.currentAnime.bannerImage!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
                            fit: BoxFit.fill,
                          ),
                          colors: const [Colors.white, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        widget.currentAnime.coverImage != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 16.0),
                                    child: Hero(
                                      tag:
                                          "${widget.tag}-${widget.currentAnime.id}",
                                      child: AnimeWidget(
                                        title: widget.currentAnime.title,
                                        coverImage:
                                            widget.currentAnime.coverImage,
                                        score: null,
                                        onTap: () {},
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, right: 16.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Go Back",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Text(
                            widget.currentAnime.title ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              widget.currentAnime.description
                                      ?.replaceAll("<br>", "\n").replaceAll("<i>", "").replaceAll("</i>", "") ??
                                  "",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height * 0.63,
                      child: ListView.builder(
                        itemCount: widget.currentAnime.episodes,
                        itemBuilder: (context, index) {
                          return EpisodeButton(
                            number: index + 1,
                            onTap: () {
                              openVideo(widget.currentAnime.title!, index + 1);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
