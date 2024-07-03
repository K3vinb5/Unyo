import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/screens/screens.dart';

class VideoQualityDialog extends StatelessWidget {
  const VideoQualityDialog({super.key, required this.adjustedWidth, required this.adjustedHeight, required this.streamAndCaptions, required this.updateEntry, required this.animeEpisode, required this.animeName});

  final double adjustedWidth;
  final double adjustedHeight;
  final int animeEpisode;
  final String animeName;
  final List<List<String?>?> streamAndCaptions;
  final void Function(int) updateEntry; 

  @override
  Widget build(BuildContext context) {
int source = 0;
Map<String, String>? headers;
VideoScreen videoScreen;

    return SizedBox(
            width: adjustedWidth * 0.4,
            height: adjustedHeight * 0.7,
            child: SmoothListView(
              duration: const Duration(milliseconds: 200),
              children: [
                ...streamAndCaptions[4]!.mapIndexed(
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
                          if (streamAndCaptions[2] != null &&
                              streamAndCaptions[2]!.isNotEmpty) {
                            headers = {};
                            List<String> values =
                                streamAndCaptions[3]![source]!.split("@");
                            List<String> keys =
                                streamAndCaptions[2]![source]!.split("@");
                            for (int i = 0; i < values.length; i++) {
                              headers!.addAll({
                                keys[i][0].toUpperCase() + keys[i].substring(1):
                                    values[i]
                              });
                            }
                          }

                          String? captions;

                          if (streamAndCaptions[1] != null &&
                              streamAndCaptions[1]!.isNotEmpty) {
                            List<String> availableCaptions =
                                streamAndCaptions[1]![source]!.split("@");
                            for (var s in availableCaptions) {
                              if (s.contains("English")) {
                                captions = s.split(";")[0];
                              }
                            }
                          }
                          String? subtracks;

                          List<String>? availableSubtracks;
                          if (streamAndCaptions[5] != null &&
                              streamAndCaptions[5]!.isNotEmpty) {
                            if (streamAndCaptions[5]![source]!.contains("@")) {
                              availableSubtracks =
                                  streamAndCaptions[5]![source]!.split("@");
                              for (var s in availableSubtracks) {
                                if (s.contains("English")) {
                                  subtracks = s.split(";")[0];
                                }
                              }
                            } else {
                              subtracks =
                                  streamAndCaptions[5]![0]!.split(";")[0];
                            }
                          }

                          print("subtracks: $subtracks");
                          Navigator.of(context).pop();
                          videoScreen = VideoScreen(
                            stream: streamAndCaptions[0]![source] ?? "",
                            audioStream: subtracks,
                            captions: captions,
                            headers: headers,
                            updateEntry: () {
                              updateEntry(animeEpisode);
                            },
                            title: "$animeName, Episode $animeEpisode",
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
            ),
          );
  }
}
