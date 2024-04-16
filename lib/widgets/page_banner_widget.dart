import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/widgets/widgets.dart';
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
            width: width,
            height: height,
            fit: animeModel.bannerImage != null ? BoxFit.fill : BoxFit.cover,
          ),
          colors: const [Colors.white, Colors.black87],
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
                    bottom: (height - ((adjustedHeight * 0.28) > minimumHeight
                        ? (adjustedHeight * 0.28)
                        : minimumHeight)),
                    left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animeModel.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                    Text(
                      animeModel.status!.replaceAll("_", " "),
                      style: const TextStyle(
                        color: Colors.white,
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
