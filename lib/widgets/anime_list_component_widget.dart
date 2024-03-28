import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nime/models/anime_model.dart';
import 'package:image_gradient/image_gradient.dart';

class AnimeListComponentWidget extends StatelessWidget {
  const AnimeListComponentWidget(
      {super.key,
      required this.animeModel,
      required this.width,
      required this.height,
      required this.horizontalPadding,
      required this.verticalPadding,
      });

  final double width;
  final double height;
  final AnimeModel animeModel;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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
            onTap: (){
              //TODO finish onTap
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        child: Text(
                          animeModel.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            overflow: TextOverflow.fade,
                          ),
                        ),
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
