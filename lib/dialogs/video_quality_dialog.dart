import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/sources/sources.dart';

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
  List<List<String?>?>? streamInfo;

  @override
  void initState() {
    super.initState();
    getStreamInfo();
  }

  void getStreamInfo() async {
    streamInfo = await widget.currentAnimeSource.getAnimeStreamAndCaptions(
        widget.consumetId, widget.animeEpisode, context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int source = 0;
    Map<String, String>? headers;
    VideoScreen videoScreen;

    return SizedBox(
      width: widget.adjustedWidth * 0.4,
      height: widget.adjustedHeight * 0.7,
      child: streamInfo != null
          ? SmoothListView(
              duration: const Duration(milliseconds: 200),
              children: [
                ...streamInfo![4]!.mapIndexed(
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
                          source = index;
                          if (streamInfo![2] != null &&
                              streamInfo![2]!.isNotEmpty) {
                            headers = {};
                            List<String> values =
                                streamInfo![3]![source]!.split("@");
                            List<String> keys =
                                streamInfo![2]![source]!.split("@");
                            for (int i = 0; i < values.length; i++) {
                              headers!.addAll({
                                keys[i][0].toUpperCase() + keys[i].substring(1):
                                    values[i]
                              });
                            }
                          }

                          String? captions;

                          if (streamInfo![1] != null &&
                              streamInfo![1]!.isNotEmpty) {
                            List<String> availableCaptions =
                                streamInfo![1]![source]!.split("@");
                            for (var s in availableCaptions) {
                              if (s.contains("English")) {
                                captions = s.split(";")[0];
                              }
                            }
                          }
                          String? subtracks;

                          List<String>? availableSubtracks;
                          if (streamInfo![5] != null &&
                              streamInfo![5]!.isNotEmpty) {
                            if (streamInfo![5]![source]!.contains("@")) {
                              availableSubtracks =
                                  streamInfo![5]![source]!.split("@");
                              for (var s in availableSubtracks) {
                                if (s.contains("English")) {
                                  subtracks = s.split(";")[0];
                                }
                              }
                            } else {
                              subtracks = streamInfo![5]![0]!.split(";")[0];
                            }
                          }

                          print("subtracks: $subtracks");
                          Navigator.of(context).pop();
                          videoScreen = VideoScreen(
                            stream: streamInfo![0]![source] ?? "",
                            audioStream: subtracks,
                            captions: captions,
                            headers: headers,
                            updateEntry: () {
                              widget.updateEntry(widget.animeEpisode);
                            },
                            title:
                                "${widget.animeName}, Episode ${widget.animeEpisode}",
                          );
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => videoScreen),
                          );
                        },
                        child: Text(text ?? "empty"),
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
