import 'package:flutter/material.dart';

class AnimeWidget extends StatelessWidget {
  const AnimeWidget(
      {super.key,
      required this.title,
      required this.score,
      required this.coverImage,
      required this.onTap});

  final String? title;
  final int? score;
  final String? coverImage;
  final void Function() onTap;
  final String uknown = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/542px-Unknown_person.jpg";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 350,
          width: 200,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(coverImage == null ? uknown : coverImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(score == null ? "null" : score!.toString()),
                    ),
                  ),
                ],
              ),
              Text(
                title == null ? "null" : title!,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
