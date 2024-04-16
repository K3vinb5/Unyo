import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unyo/api/anilist_api.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/screens/video_screen.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:collection/collection.dart';

import '../api/consumet_api.dart';

class AnimeDetailsScreen extends StatefulWidget {
  const AnimeDetailsScreen(
      {super.key, required this.currentAnime, required this.tag});

  final AnimeModel currentAnime;
  final String tag;

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  late VideoScreen videoScreen;
  UserAnimeModel? userAnimeModel;
  List<String> searches = [];
  List<String> searchesId = [];
  late int currentSearch;
  int currentSource = 0;
  int currentEpisode = 0;
  late Map<int, Function> setDropDowns;
  late double progress;
  late double score;
  late String startDate;
  late String endDate;
  List<String> statuses = [
    "PLANNING",
    "CURRENT",
    "COMPLETED",
    "REPEATING",
    "PAUSED",
    "DROPPED"
  ];
  Map<String, String> query = {};
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;

  @override
  void initState() {
    super.initState();
    setDropDowns = {
      0: () {
        //gogoanime
        setSearches(getAnimeConsumetGogoAnimeIds);
      },
      1: () {
        //zoro
        setSearches(getAnimeConsumetZoroIds);
      },
      2: () {
        //animepahe
      },
    };
    updateSource(0);
    setUserAnimeModel();
  }

  void setUserAnimeModel() async {
    UserAnimeModel newUserAnimeModel =
        await getUserAnimeInfo(widget.currentAnime.id, 0);
    setState(() {
      userAnimeModel = newUserAnimeModel;
    });
    progress = userAnimeModel?.progress?.toDouble() ?? 0.0;
    score = userAnimeModel?.score?.toDouble() ?? 0.0;
    endDate = userAnimeModel?.endDate?.replaceAll("null", "~") ?? "~/~/~";
    startDate = userAnimeModel?.startDate?.replaceAll("null", "~") ?? "~/~/~";
    statuses.removeWhere((element) => element == userAnimeModel?.status);
    query["score"] = score.toString();
    query["progress"] = progress.toInt().toString();
    statuses = [
      userAnimeModel?.status == "" ? "NOT SET" : userAnimeModel?.status ?? "",
      ...statuses
    ];
  }

  void setSearches(Future<List<List<String>>> Function(String) getIds) async {
    List<List<String>> newSearches = await getIds(widget.currentAnime.title!);
    int newCurrentEpisode = widget.currentAnime.status == "RELEASING"
        ? await getAnimeCurrentEpisode(widget.currentAnime.id)
        : widget.currentAnime.episodes!;
    setState(() {
      currentEpisode = newCurrentEpisode;
      searches = newSearches[0];
      searchesId = newSearches[1];
    });
  }

  void updateSource(int newSource) {
    setState(() {
      currentSource = newSource;
      currentSearch = 0;
      setDropDowns[newSource]!();
    });
  }

  double getAdjustedHeight(double value){
    if (MediaQuery.of(context).size.aspectRatio > 1.77777777778){
      return value;
    }else{
      return value * ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
    }
  }

  double getAdjustedWidth(double value){
    if (MediaQuery.of(context).size.aspectRatio < 1.77777777778){
      return value;
    }else{
      return value * ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
    }
  }

  void askForDeleteUserMedia() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you wish to delete this media entry",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          content: SizedBox(
            height: totalHeight * 0.2,
            width: totalWidth * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: () {
                    deleteUserAnime(widget.currentAnime.id);
                    Navigator.of(context).pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 37, 37, 37),
                    ),
                    minimumSize: MaterialStatePropertyAll(
                        Magnifier.kDefaultMagnifierSize),
                    foregroundColor: MaterialStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  child: const Text("Confirm"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 37, 37, 37),
                    ),
                    minimumSize: MaterialStatePropertyAll(
                        Magnifier.kDefaultMagnifierSize),
                    foregroundColor: MaterialStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateEntry(int newProgress) {
    print("Status: ${statuses[0]}");
    if (statuses[0] != "COMPLETED") {
      query.remove("status");
      query.addAll({"status": "CURRENT"});
      widget.currentAnime.status = "CURRENT";
      statuses.swap(0, statuses.indexOf("CURRENT"));
    }
    if (statuses[0] == "CURRENT" || statuses[0] == "REPEATING") {
      progress = newProgress.toDouble();
      query.remove("progress");
      query.addAll({"progress": progress.toInt().toString()});
      setUserAnimeInfo(widget.currentAnime.id, query);
      //waits a bit because anilist database may take a but to update, for now waiting one second could be tweaked later
      Timer(
        const Duration(milliseconds: 1000),
        () {
          setUserAnimeModel();
        },
      );
    }
  }

  void openVideo(String consumetId, int animeEpisode) async {
    late String consumetStream;
    if (currentSource == 0) {
      consumetStream = await getAnimeConsumetGogoAnimeStream(
          consumetId, animeEpisode, context);
      videoScreen = VideoScreen(
        stream: consumetStream,
        updateEntry: () {
          updateEntry(animeEpisode);
        },
      );
    } else if (currentSource == 1) {
      List<String> streamCaption =
          await getAnimeConsumetZoroStream(consumetId, animeEpisode, context);

      consumetStream = streamCaption[0];
      videoScreen = VideoScreen(
        stream: consumetStream,
        captions: streamCaption[1],
        updateEntry: () {
          updateEntry(animeEpisode);
        },
      );
    } else {
      consumetStream = await getAnimeConsumetGogoAnimeStream(
          consumetId, animeEpisode, context);
      videoScreen = VideoScreen(
        stream: consumetStream,
        updateEntry: () {
          updateEntry(animeEpisode);
        },
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => videoScreen),
    );
  }

  void openWrongTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text("Select Title", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          actions: [
            Column(
              children: [
                const Text("Please select new title",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenu(
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 44, 44, 44),
                        ),
                      ),
                      onSelected: (value) {
                        currentSearch = value!;
                      },
                      dropdownMenuEntries: [
                        ...searches.mapIndexed(
                          (index, title) {
                            return DropdownMenuEntry(
                              style: const ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              value: index,
                              label: title,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 37, 37, 37),
                        ),
                        minimumSize: MaterialStatePropertyAll(
                            Magnifier.kDefaultMagnifierSize),
                        foregroundColor: MaterialStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
    Timer(
      const Duration(milliseconds: 500),
      () {
        setUserAnimeModel();
      },
    );
  }

  void openAnimeInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                "List Editor",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  askForDeleteUserMedia();
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              )
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: totalWidth * 0.5,
                height: totalHeight * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledDropDown(
                      items: [
                        ...statuses.map((status) => Text(status)),
                      ],
                      horizontalPadding: 10,
                      onTap: (index) {
                        String newCurrentStatus = statuses[index];
                        statuses.removeAt(index);
                        statuses.insert(0, newCurrentStatus);
                        query.remove("status");
                        query.addAll({"status": newCurrentStatus});
                      },
                      width: totalWidth * 0.4,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Progress",
                      style: TextStyle(color: Colors.white),
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
                            max: widget.currentAnime.episodes?.toDouble() ??
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
                              print(progress.toInt().toString());
                              query.addAll(
                                  {"progress": progress.toInt().toString()});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Score",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Text(
                          score.toInt().toString(),
                          style: TextStyle(color: Colors.white),
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
                    const Text(
                      "Start / End Date",
                      style: TextStyle(color: Colors.white),
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
                              query.addAll({
                                "startDateDay": chosenDateTime.day.toString()
                              });
                              query.remove("startDateMonth");
                              query.addAll({
                                "startDateMonth":
                                    chosenDateTime.month.toString()
                              });
                              query.remove("startDateYear");
                              query.addAll({
                                "startDateYear": chosenDateTime.year.toString()
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month,
                              color: Colors.grey),
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
                              query.addAll({
                                "endDateDay": chosenDateTime.day.toString()
                              });
                              query.remove("endDateMonth");
                              query.addAll({
                                "endDateMonth": chosenDateTime.month.toString()
                              });
                              query.remove("endDateYear");
                              query.addAll({
                                "endDateYear": chosenDateTime.year.toString()
                              });
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
                                  minimumSize: MaterialStatePropertyAll(
                                      Magnifier.kDefaultMagnifierSize),
                                  foregroundColor: MaterialStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setUserAnimeInfo(
                                      widget.currentAnime.id, query);
                                  Timer(
                                    const Duration(milliseconds: 1500),
                                    () {
                                      setUserAnimeModel();
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Confirm"),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 37, 37, 37),
                                  ),
                                  minimumSize: MaterialStatePropertyAll(
                                      Magnifier.kDefaultMagnifierSize),
                                  foregroundColor: MaterialStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {

          adjustedWidth = getAdjustedWidth(MediaQuery.of(context).size.width);
          totalWidth = MediaQuery.of(context).size.width;
          adjustedHeight = getAdjustedHeight(MediaQuery.of(context).size.height);
          totalHeight = MediaQuery.of(context).size.height;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      ImageGradient.linear(
                        image: Image.network(
                          widget.currentAnime.bannerImage ??
                              widget.currentAnime.coverImage!,
                          width: totalWidth,
                          height: totalHeight * 0.35,
                          fit: widget.currentAnime.bannerImage != null
                              ? BoxFit.fill
                              : BoxFit.cover,
                        ),
                        colors: const [Colors.white, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      widget.currentAnime.coverImage != null
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Hero(
                              tag: widget.tag,
                              child: AnimeWidget(
                                title: "",
                                coverImage: widget.currentAnime.coverImage,
                                score: null,
                                onTap: null,
                                textColor: Colors.white,
                                height:
                                (adjustedHeight * 0.28) > minimumHeight ? (adjustedHeight * 0.28) : minimumHeight,
                                width:
                                (adjustedWidth * 0.1) > minimumWidth ? (adjustedWidth * 0.1) : minimumWidth,
                                status: widget.currentAnime.status,
                                year: null,
                                format: null,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "  Home Screen",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : const SizedBox(),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: totalWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border.all(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                EdgeInsets.only(top: totalHeight * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: totalHeight * 0.27,
                        ),
                        SizedBox(
                          width: totalWidth / 2,
                          height: totalHeight * 0.63,
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  //TODO dropdowns
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  DropdownButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    iconDisabledColor: Colors.white,
                                    value: currentSource,
                                    dropdownColor: Colors.black,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        onTap: () {
                                          updateSource(0);
                                        },
                                        child: const Text(
                                          "GogoAnime",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 1,
                                        onTap: () {
                                          updateSource(1);
                                        },
                                        child: const Text(
                                          "Zoro",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        onTap: () {
                                          updateSource(2);
                                        },
                                        child: const Text(
                                          "AnimePahe",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    onChanged: (index) {},
                                  ),
                                  const SizedBox(
                                    width: 16.0,
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
                                      openWrongTitleDialog(context);
                                    },
                                    child: const Text("Wrong Title?"),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
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
                                      openAnimeInfoDialog(context);
                                    },
                                    child: const Text("Update Entry"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  widget.currentAnime.title ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  widget.currentAnime.description
                                      ?.replaceAll("<br>", "\n")
                                      .replaceAll("<i>", "")
                                      .replaceAll("</i>", "") ??
                                      "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: totalHeight * 0.22,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Episodes:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: totalWidth / 2,
                          height: totalHeight * 0.63,
                          child: ListView.builder(
                            itemCount:
                            widget.currentAnime.episodes ?? currentEpisode,
                            itemBuilder: (context, index) {
                              return EpisodeButton(
                                episodeNumber: index + 1,
                                latestEpisode: currentEpisode,
                                latestEpisodeWatched: userAnimeModel?.progress ?? 1,
                                onTap: () {
                                  openVideo(searchesId[currentSearch], index + 1);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
