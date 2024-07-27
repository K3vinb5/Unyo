import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class HomeScreenBottomButtonsWidget extends StatelessWidget {
  const HomeScreenBottomButtonsWidget(
      {super.key,
      required this.adjustedHeight,
      required this.adjustedWidth,
      required this.episodesWatched,
      this.minutesWatched,
      required this.userStatsNull,
      required this.getUserCharts});

  final double adjustedWidth;
  final double adjustedHeight;
  final int? episodesWatched;
  final int? minutesWatched;
  final bool userStatsNull;
  final List<Widget> Function() getUserCharts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: !buttonsLayout
              ? const EdgeInsets.only(left: 16.0)
              : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimeButton(
                text: context.tr("anime_list"),
                onTap: () {
                  //animeListScreen
                  goTo(3);
                },
                width: adjustedWidth,
                height: adjustedHeight,
                horizontalAllignment: false,
              ),
              const SizedBox(
                height: 30,
              ),
              AnimeButton(
                text: context.tr("manga_list"),
                onTap: () {
                  //mangaListScreen
                  goTo(4);
                },
                width: adjustedWidth,
                height: adjustedHeight,
                horizontalAllignment: false,
              ),
              const SizedBox(
                height: 30,
              ),
              AnimeButton(
                text: context.tr("calendar"),
                onTap: () {
                  //calendarScreen
                  goTo(5);
                },
                width: adjustedWidth,
                height: adjustedHeight,
                horizontalAllignment: false,
              ),
              const SizedBox(
                height: 30,
              ),
              AnimeButton(
                text: context.tr("extensions"),
                onTap: () {
                  //calendarScreen
                  goTo(6);
                },
                width: adjustedWidth,
                height: adjustedHeight,
                horizontalAllignment: false,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: adjustedWidth * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: adjustedWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${context.tr("episodes_watched")}: ${episodesWatched ?? -1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${context.tr("hours_watched")}: ${(minutesWatched! ~/ 60)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                userStatsNull
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [...getUserCharts()],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
