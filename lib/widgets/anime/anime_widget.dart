import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

import '../styled/custom/hovering_animated_container.dart';

class AnimeWidget extends StatelessWidget {
  const AnimeWidget({
    super.key,
    required this.title,
    required this.score,
    required this.coverImage,
    required this.onTap,
    required this.textColor,
    required this.width,
    required this.height,
    required this.status,
    required this.year,
    required this.format,
  });

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
      child: HoverAnimatedContainer(
        margin: onTap != null
            ? EdgeInsets.symmetric(horizontal: width * 0.05)
            : const EdgeInsets.symmetric(horizontal: 0),
        hoverMargin: const EdgeInsets.symmetric(horizontal: 0),
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
                  HoverAnimatedContainer(
                    height: height,
                    width: width,
                    hoverWidth: onTap != null ? width * 1.1 : width,
                    hoverHeight: onTap != null ? height * 1.03 : height,
                    cursor: onTap != null
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    curve: Curves.easeOut,
                    hoverDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: onTap != null ? Border.all(color: Colors.white, width: 2) : null,
                      image: DecorationImage(
                        image: NetworkImage(
                            coverImage == null ? uknown : coverImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                            coverImage == null ? uknown : coverImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      children: [
                        score != null
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: lightBorderColor,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(50)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            score == null
                                                ? ""
                                                : "  ${(score! / 10)}",
                                            style: TextStyle(
                                              color: lightBorderColor
                                                          .computeLuminance() >
                                                      0.2
                                                  ? Colors.black
                                                  : Colors.white
                                                      .withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: lightBorderColor
                                                        .computeLuminance() >
                                                    0.2
                                                ? Colors.black
                                                : Colors.white.withOpacity(0.8),
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        status != null && status == "RELEASING"
                            ? SizedBox(
                                width: width,
                                child: const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.0, left: 4.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      maxRadius: 7,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width,
              child: Text(
                title == null ? "" : title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            format != null && year != null
                ? SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: veryLightBorderColor.withOpacity(0.8),
                              size: 17,
                            ),
                            Text(
                              " ${year!.split("/")[2]}",
                              style: TextStyle(
                                color: veryLightBorderColor.withOpacity(0.8),
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
                                color: veryLightBorderColor.withOpacity(0.8),
                                overflow: TextOverflow.ellipsis,
                                fontSize:
                                    format == "TV_SHORT" || format == "SPECIAL"
                                        ? 10
                                        : 14,
                              ),
                            ),
                            Icon(
                              Icons.tv_rounded,
                              color: veryLightBorderColor.withOpacity(0.8),
                              size: 17,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
