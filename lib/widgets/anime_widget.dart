import 'package:flutter/material.dart';

class AnimeWidget extends StatelessWidget {
  const AnimeWidget({
    super.key,
    required this.title,
    required this.score,
    required this.coverImage,
    required this.onTap,
    required this.textColor,
  });

  final String? title;
  final int? score;
  final String? coverImage;
  final void Function() onTap;
  final String uknown =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/542px-Unknown_person.jpg";
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 8.0),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                              coverImage == null ? uknown : coverImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, right: 8.0),
                        child: score != null
                            ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            score == null ? "" : score!.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        )
                            : const SizedBox(),
                    ),
                  ],
                ),
                Text(
                  title == null ? "" : title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
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
