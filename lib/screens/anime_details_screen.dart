import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/video_screen.dart';
import 'package:flutter_nime/widgets/episode_button.dart';

import '../api/consumet_api.dart';

class AnimeDetailsScreen extends StatefulWidget {
  AnimeDetailsScreen({super.key, required this.currentAnime});

  final AnimeModel currentAnime;

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  late VideoScreen videoScreen;

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
    return Column(
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.currentAnime.bannerImage!,
                fit: BoxFit.fill,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go Back"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: widget.currentAnime.episodes!,
                  itemBuilder: (context, index) {
                    return EpisodeButton(
                        number: index,
                        onTap: () {
                          openVideo(widget.currentAnime.title!, index);
                        });
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
