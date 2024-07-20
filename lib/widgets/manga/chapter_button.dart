import 'package:flutter/material.dart';

class ChapterButton extends StatelessWidget {
  const ChapterButton(
      {super.key,
      required this.openManga,
      required this.userProgress,
      required this.index,
      required this.currentChapterGroup,
      required this.chapterTitle,
      required this.chaptersId});

  final void Function(String, int, String) openManga;
  final int index;
  final int currentChapterGroup;
  final List<String> chaptersId;
  final num? userProgress;
  final String? chapterTitle;

  @override
  Widget build(BuildContext context) {
    int chapterNum = index + 1 + currentChapterGroup * 30;
    int progress = userProgress != null ? userProgress as int : 0;

    return InkWell(
      onTap: () {
        openManga(chaptersId[index + currentChapterGroup * 30],
            index + 1 + currentChapterGroup * 30, chapterTitle ?? "");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 2,
            color: const Color.fromARGB(255, 34, 33, 34),
            endIndent: MediaQuery.of(context).size.width * 0.05,
            indent: MediaQuery.of(context).size.width * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Chapter $chapterNum",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    progress >= chapterNum
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.grey,
                          )
                        : const SizedBox.shrink(),
                    // const SizedBox(width: 20,),
                    // Text(
                    //   latestEpisode >= episodeNumber ? "Released" : "Not yet released" ,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontWeight: latestEpisode >= episodeNumber ? FontWeight.bold : FontWeight.normal,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
