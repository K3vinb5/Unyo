import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';

class PageBannerWidget extends StatelessWidget {
  const PageBannerWidget(
      {super.key, required this.animeModel, required this.width});

  final AnimeModel animeModel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        ImageGradient.linear(
          image: Image.network(
            animeModel.bannerImage ?? animeModel.coverImage!,
            width: width,
            fit: animeModel.bannerImage != null ? BoxFit.fill : BoxFit.cover,
          ),
          colors: const [Colors.white, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimeWidget(
                title: "",
                score: null,
                coverImage: animeModel.coverImage!,
                onTap: () {},
                textColor: Colors.white,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animeModel.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    animeModel.status!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
