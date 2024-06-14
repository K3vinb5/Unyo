import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

class MangaWidget extends StatelessWidget {
  const MangaWidget(
      {super.key,
      required this.title,
      required this.score,
      required this.coverImage,
      required this.onTap,
      required this.textColor,
      required this.width,
      required this.height,
      required this.status,
      required this.format,
      required this.year});

  final String? title;
  final int? score;
  final String? coverImage;
  final void Function()? onTap;
  final String uknown =
      "https://s4.anilist.co/file/anilistcdn/user/avatar/large/default.png";
  final Color textColor;
  final double width;
  final double height;
  final String? status;
  final String? format;
  final String? year;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: HoverAnimatedContainer(
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 170),
          hoverWidth: onTap != null ? width * 1.1 : width,
          hoverHeight: height * 1.3,
          width: width,
          height: height * 1.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: onTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: height,
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
                    status != null && status == "RELEASING"
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 4.0, left: 4.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                maxRadius: 7,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Text(
                title == null ? "" : title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              format != null && year != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 17,
                            ),
                            Text(
                              " ${year!.split("/")[2]}",
                              style: const TextStyle(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${format!.replaceAll("_", " ")} ",
                              style: TextStyle(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                                fontSize: format == "TV_SHORT" ? 10 : 14,
                              ),
                            ),
                            const Icon(
                              Icons.tv_rounded,
                              color: Colors.grey,
                              size: 17,
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
