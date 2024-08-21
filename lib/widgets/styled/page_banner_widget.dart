import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';

class PageBannerWidget extends StatelessWidget {
  const PageBannerWidget(
      {super.key,
      required this.animeModel,
      required this.width,
      required this.height,
      required this.adjustedWidth,
      required this.adjustedHeight});

  final AnimeModel animeModel;
  final double width;
  final double height;
  final double adjustedWidth;
  final double adjustedHeight;
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        ImageGradient.linear(
          image: Image.network(
            animeModel.bannerImage ?? animeModel.coverImage!,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image is fully loaded, start fading in
                // return AnimatedOpacity(
                //   opacity: 1.0,
                //   duration: const Duration(milliseconds: 200),
                //   curve: Curves.easeIn,
                //   child: child,
                // );
                return Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 34, 33, 34),
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                    child: child,
                  ),
                );
              } else {
                // Keep the image transparent while loading
                return Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 34, 33, 34),
                  child: AnimatedOpacity(
                    opacity: 0.0,
                    duration: const Duration(milliseconds: 0),
                    child: child,
                  ),
                );
              }
            },
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          colors: const [
            Colors.white,
            Colors.black87 /* Color.fromARGB(255, 34, 33, 34) */
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimeWidget(
                title: "",
                score: null,
                coverImage: animeModel.coverImage!,
                onTap: null,
                textColor: Colors.white,
                height: (adjustedHeight * 0.28) > minimumHeight
                    ? (adjustedHeight * 0.28)
                    : minimumHeight,
                width: (adjustedWidth * 0.1) > minimumWidth
                    ? (adjustedWidth * 0.1)
                    : minimumWidth,
                format: null,
                year: null,
                status: null,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: (height -
                        ((adjustedHeight * 0.28) > minimumHeight
                            ? (adjustedHeight * 0.28)
                            : minimumHeight)),
                    left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animeModel.getDefaultTitle(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                    Text(
                      animeModel.status!.replaceAll("_", " "),
                      style: TextStyle(
                        color: lightBorderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
