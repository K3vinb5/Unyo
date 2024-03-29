import 'package:flutter/material.dart';

class AnimeWidget extends StatelessWidget {
  const AnimeWidget({
    super.key,
    required this.title,
    required this.score,
    required this.coverImage,
    required this.onTap,
    required this.textColor,
    this.width,
    this.height,
  });

  final String? title;
  final int? score;
  final String? coverImage;
  final void Function() onTap;
  final String uknown =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/542px-Unknown_person.jpg";
  final Color textColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: width ?? MediaQuery.of(context).size.width * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height:
                          height ?? MediaQuery.of(context).size.height * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                              coverImage == null ? uknown : coverImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    score != null
                        ? Opacity(
                            opacity: 0.8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(50)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      score == null ? "" : "  ${(score! / 10)}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
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
