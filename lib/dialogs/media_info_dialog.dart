import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/widgets/widgets.dart';

class MediaInfoDialog extends StatefulWidget {
  const MediaInfoDialog(
      {super.key,
      required this.totalWidth,
      required this.totalHeight,
      required this.statuses,
      required this.query,
      required this.episodes,
      required this.progress,
      required this.currentEpisode,
      required this.score,
      required this.setUserAnimeModel,
      required this.startDate,
      required this.endDate,
      required this.id,
     });

  final double totalWidth;
  final double totalHeight;
  final List<String> statuses;
  final Map<String, String> query;
  final int? episodes;
  final int id;
  final double progress;
  final int currentEpisode;
  final double score;
  final String startDate;
  final String endDate;
  final void Function() setUserAnimeModel;

  @override
  State<MediaInfoDialog> createState() => _MediaInfoDialogState();
}

class _MediaInfoDialogState extends State<MediaInfoDialog> {
  late Map<String, String> query;
  late double progress;
  late int currentEpisode;
  late String startDate;
  late String endDate;
  late double score;

  @override
  void initState() {
    super.initState();
    query = widget.query;
    progress = widget.progress;
    currentEpisode = widget.currentEpisode;
    startDate = widget.startDate;
    endDate = widget.endDate;
    score = widget.score;
  }

  @override
  void didUpdateWidget(covariant MediaInfoDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      query = widget.query;
    } else if (oldWidget.progress != widget.progress) {
      progress = widget.progress;
    } else if (oldWidget.currentEpisode != widget.currentEpisode) {
      currentEpisode = widget.currentEpisode;
    } else if (oldWidget.score != widget.score) {
      score = widget.score;
    } else if (oldWidget.startDate != widget.startDate) {
      startDate = widget.startDate;
    } else if (oldWidget.endDate != widget.endDate) {
      endDate = widget.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: widget.totalWidth * 0.5,
          height: widget.totalHeight * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "status".tr(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              StyledDropDown(
                items: [
                  ...widget.statuses.map((status) => Text(status)),
                ],
                horizontalPadding: 10,
                onTap: (index) {
                  String newCurrentStatus = widget.statuses[index];
                  widget.statuses.removeAt(index);
                  widget.statuses.insert(0, newCurrentStatus);
                  query.remove("status");
                  query.addAll({"status": newCurrentStatus});
                },
                color: Colors.white,
                width: widget.totalWidth * 0.4,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "progress".tr(),
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    progress.toInt().toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.grey,
                      min: 0,
                      max: widget.episodes?.toDouble() ??
                          currentEpisode.toDouble(),
                      value: progress,
                      onChanged: (value) {
                        setState(() {
                          progress =
                              value; // Update the progress variable when slider value changes
                        });
                      },
                      onChangeEnd: (value) {
                        query.remove("progress");
                        // print(progress.toInt().toString());
                        query.addAll({"progress": progress.toInt().toString()});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                context.tr("score"),
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    score.toInt().toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.grey,
                      min: 0,
                      max: 10,
                      value: score,
                      onChanged: (value) {
                        setState(() {
                          score =
                              value; // Update the progress variable when slider value changes
                        });
                      },
                      onChangeEnd: (value) {
                        query.remove("score");
                        query.addAll({"score": score.toString()});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "start_end_data".tr(),
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      DateTime? chosenDateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1970, 1, 1),
                        lastDate: DateTime.now(),
                      );
                      if (chosenDateTime != null) {
                        setState(() {
                          startDate =
                              "${chosenDateTime.day}/${chosenDateTime.month}/${chosenDateTime.year}";
                        });
                        query.remove("startDateDay");
                        query.addAll(
                            {"startDateDay": chosenDateTime.day.toString()});
                        query.remove("startDateMonth");
                        query.addAll({
                          "startDateMonth": chosenDateTime.month.toString()
                        });
                        query.remove("startDateYear");
                        query.addAll(
                            {"startDateYear": chosenDateTime.year.toString()});
                      }
                    },
                    icon: const Icon(Icons.calendar_month, color: Colors.grey),
                  ),
                  Text(
                    startDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    endDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () async {
                      DateTime? chosenDateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1970, 1, 1),
                        lastDate: DateTime.now(),
                      );
                      if (chosenDateTime != null) {
                        setState(() {
                          endDate =
                              "${chosenDateTime.day}/${chosenDateTime.month}/${chosenDateTime.year}";
                        });
                        query.remove("endDateDay");
                        query.addAll(
                            {"endDateDay": chosenDateTime.day.toString()});
                        query.remove("endDateMonth");
                        query.addAll(
                            {"endDateMonth": chosenDateTime.month.toString()});
                        query.remove("endDateYear");
                        query.addAll(
                            {"endDateYear": chosenDateTime.year.toString()});
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 37, 37, 37),
                            ),
                            foregroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setUserAnimeInfo(widget.id, query);
                            Timer(
                              const Duration(milliseconds: 1500),
                              () {
                                widget.setUserAnimeModel();
                              },
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text("confirm".tr()),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 37, 37, 37),
                            ),
                            foregroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("cancel".tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
