import 'package:flutter/material.dart';

class ChapterButton extends StatelessWidget {
  const ChapterButton({super.key, required this.onTap, required this.chapterNum, required this.progress});
  
  final void Function() onTap;
  final int chapterNum;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03, vertical: 20),
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
                    progress >= chapterNum ?
                    const Icon(
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
