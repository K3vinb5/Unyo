import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/util/utils.dart';

class VideoQualityDialog extends StatefulWidget {
  const VideoQualityDialog({
    super.key,
    required this.adjustedWidth,
    required this.adjustedHeight,
    required this.updateEntry,
    required this.animeEpisode,
    required this.animeName,
    required this.currentAnimeSource,
    required this.consumetId,
  });

  final double adjustedWidth;
  final double adjustedHeight;
  final int animeEpisode;
  final String animeName;
  final void Function(int) updateEntry;
  final AnimeSource currentAnimeSource;
  final String consumetId;

  @override
  State<VideoQualityDialog> createState() => _VideoQualityDialogState();
}

class _VideoQualityDialogState extends State<VideoQualityDialog> {
  StreamData? streamData;
  int source = 0;
  VideoScreen? videoScreen;

  @override
  void initState() {
    super.initState();
    getStreamInfo();
  }

  void getStreamInfo() async {
    streamData = await widget.currentAnimeSource.getAnimeStreamAndCaptions(
        widget.consumetId, widget.animeEpisode, context);
    setState(() {});
  }

  void onStreamSelected(int selected) {
    source = selected;
    Navigator.of(context).pop();
    videoScreen = VideoScreen(
      source: source,
      streamData: streamData!,
      updateEntry: () {
        widget.updateEntry(widget.animeEpisode);
      },
      title: "${widget.animeName}, Episode ${widget.animeEpisode}",
    );
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => videoScreen!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.adjustedWidth * 0.4,
      height: widget.adjustedHeight * 0.7,
      child: streamData != null
          ? SmoothListView(
              duration: const Duration(milliseconds: 200),
              children: [
                ...streamData!.qualities.mapIndexed(
                  (index, text) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 37, 37, 37),
                          ),
                          foregroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          onStreamSelected(index);
                        },
                        child: Text(text),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Please wait, this can take some seconds...",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
    );
  }
}
