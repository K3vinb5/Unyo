import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/aniskip_api.dart';
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
    required this.id,
    required this.idMal,
  });

  final double adjustedWidth;
  final double adjustedHeight;
  final int animeEpisode;
  final String animeName;
  final void Function(int) updateEntry;
  final AnimeSource currentAnimeSource;
  final String id;
  final String idMal;

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
        widget.id, widget.animeEpisode, context);
    setState(() {});
  }

  void onStreamSelected(int selected, Map<String, double> timestamps) {
    source = selected;
    Navigator.of(context).pop();
    videoScreen = VideoScreen(
      source: source,
      streamData: streamData!,
      updateEntry: () {
        widget.updateEntry(widget.animeEpisode);
      },
      title: "${widget.animeName}, ${"episode".tr()} ${widget.animeEpisode}",
      timestamps: timestamps,
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
          ? streamData!.qualities.isNotEmpty
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
                            onPressed: () async {
                              Map<String, double> timestamps =
                                  await getOpeningSkipTimeStamps(
                                      widget.idMal, widget.animeEpisode.toString());
                              onStreamSelected(index, timestamps);
                            },
                            child: Text(text),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    "quality_no_results".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
                Text(
                  "please_wait_text".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
    );
  }
}
