import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/aniskip_api.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/router/custom_page_route.dart';
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
    required this.animeModel,
    required this.currentAnimeSource,
    required this.id,
    required this.idMal,
  });

  final double adjustedWidth;
  final double adjustedHeight;
  final int animeEpisode;
  final AnimeModel animeModel;
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
    logger.i("Getting stream info for ${widget.animeModel.getDefaultTitle()} episode ${widget.animeEpisode}");
    streamData = await widget.currentAnimeSource.getAnimeStreamAndCaptions(
        widget.id,
        widget.animeModel.englishTitle ?? "",
        widget.animeEpisode,
        context);
    setState(() {});
  }

  void onStreamSelected(int selected, Map<String, double> timestamps) {
    logger.i("Selected stream $selected for ${widget.animeModel.getDefaultTitle()} episode ${widget.animeEpisode}");
    source = selected;
    Navigator.of(context).pop();
    videoScreen = VideoScreen(
      source: source,
      streamData: streamData!,
      updateEntry: () {
        widget.updateEntry(widget.animeEpisode);
      },
      title:
          "${widget.animeModel.getDefaultTitle()}, ${"episode".tr()} ${widget.animeEpisode}",
      mqqtKey:
      "${widget.animeModel.userPreferedTitle}-ep${widget.animeEpisode}",
      episode: widget.animeEpisode,
      timestamps: timestamps,
    );
    logger.i("Opening video screen for ${widget.animeModel.getDefaultTitle()} episode ${widget.animeEpisode}");
    if (!context.mounted) return;
    Navigator.push(
      context,
      customPageRouter(videoScreen!),
    );
  }

  String getUtf8Text(String text) {
    List<int> bytes = text.codeUnits;
    try {
      return utf8.decode(bytes);
    } catch (e) {
      logger.e("Error decoding text: $text", error: e.toString());
    }
    return text;
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
              (index, text) =>
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                child: SizedBox(
                  // height: 60,
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
                      await getOpeningSkipTimeStamps(widget.idMal,
                          widget.animeEpisode.toString());
                      onStreamSelected(index, timestamps);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 3.0),
                      child: Text(getUtf8Text(text)),
                    ),
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
}}
