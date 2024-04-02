import 'package:flutter/material.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';

class PageBannerWidget extends StatelessWidget {
  const PageBannerWidget(
      {super.key, required this.animeModel, required this.width, required this.height});

  final AnimeModel animeModel;
  final double width;
  final double height;

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
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width * 0.1,
                format: null,
                year: null,
                status: null,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06, left: 25),
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
                      animeModel.status!,
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
