import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nime/models/anime_model.dart';
import 'package:flutter_nime/widgets/anime_widget.dart';
import 'package:flutter_nime/screens/screens.dart';

class AnimeListComponentWidget extends StatelessWidget {
  AnimeListComponentWidget({
    super.key,
    required this.animeModel,
    required this.width,
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.tag,
  });

  final double width;
  final double height;
  final AnimeModel animeModel;
  final double horizontalPadding;
  final double verticalPadding;
  late AnimeDetailsScreen animeScreen;
  final String tag;

  void openAnime(AnimeModel currentAnime, String tag, BuildContext context) {
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
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            image: DecorationImage(
              opacity: 0.35,
              image: NetworkImage(
                animeModel.bannerImage ?? animeModel.coverImage!,
              ),
              fit: animeModel.bannerImage != null ? BoxFit.fill : BoxFit.cover,
            ),
          ),
          child: InkWell(
            onTap: () {
              openAnime(animeModel, tag, context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: tag,
                  child: AnimeWidget(
                    title: "",
                    score: animeModel.averageScore,
                    coverImage: animeModel.coverImage!,
                    onTap: (){},
                    textColor: Colors.white,
                    width: height * 0.55,
                    height: height * 0.8,
                    status: animeModel.status,
                    year: null,
                    format: null,
                  ),
                ),
                Expanded(
                  child: Text(
                    animeModel.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
