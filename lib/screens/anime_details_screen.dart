import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:collection/collection.dart';
import 'package:unyo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/anime/util/embedded_extensions.dart';

class AnimeDetailsScreen extends StatefulWidget {
  const AnimeDetailsScreen(
      {super.key, required this.currentAnime, required this.tag});

  final AnimeModel currentAnime;
  final String tag;

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  UserMediaModel? userAnimeModel;
  List<String> searches = [];
  List<String> searchesId = [];
  String currentSearchString = "";
  late int currentSearch;
  int currentSource = 0;
  int currentEpisode = 0;
  late Map<int, AnimeSource> animeSources;
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
  bool isShiftKeyPressed = false;
  List<DropdownMenuEntry> wrongTitleEntries = [];
  String oldWrongTitleSearch = "";
  Timer wrongTitleSearchTimer = Timer(const Duration(milliseconds: 500), () {});
  void Function() wrongTitleSearchFunction = () {};
  TextEditingController wrongTitleSearchController = TextEditingController();
  int currentEpisodes = 0;
  late MediaContentModel mediaContentModel;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    animeSources = globalAnimesSources;
    mediaContentModel = MediaContentModel(anilistId: widget.currentAnime.id);
    mediaContentModel.init();
    updateSource(0);
    setUserAnimeModel();
  }

  @override
  void dispose() {
    super.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      setState(() {
        isShiftKeyPressed = true;
      });
      return true;
    } else if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      setState(() {
        isShiftKeyPressed = false;
      });
      return true;
    }
    return false;
  }

  void setWrongTitleSearch(void Function(void Function()) setDialogState) {
    //reset listener
    setDialogState(() {
      wrongTitleEntries = [
        ...searches.mapIndexed(
          (index, title) {
            return DropdownMenuEntry(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              value: index,
              label: title,
            );
          },
        ),
      ];
    });
    wrongTitleSearchController.removeListener(wrongTitleSearchFunction);
    wrongTitleSearchFunction = () {
      wrongTitleSearchTimer.cancel();
      wrongTitleSearchTimer = Timer(const Duration(milliseconds: 1000), () {
        if (wrongTitleSearchController.text != oldWrongTitleSearch &&
            wrongTitleSearchController.text != "") {
          setSearches(animeSources[currentSource]!.getAnimeTitlesAndIds,
              query: wrongTitleSearchController.text,
              setDialogState: setDialogState);
        }
        oldWrongTitleSearch = wrongTitleSearchController.text;
      });
    };
    wrongTitleSearchController.addListener(wrongTitleSearchFunction);
  }

  void setUserAnimeModel() async {
    UserMediaModel newUserAnimeModel =
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

  void setSearches(Future<List<List<String>>> Function(String) getIds,
      {String? query, void Function(void Function())? setDialogState}) async {
    List<List<String>> newSearchesAndIds =
        await getIds(query ?? widget.currentAnime.title!);
    int newCurrentEpisode = widget.currentAnime.status == "RELEASING"
        ? await getAnimeCurrentEpisode(widget.currentAnime.id)
        : widget.currentAnime.episodes!;
    if (setDialogState != null) {
      setState(() {
        currentEpisode = newCurrentEpisode;
        searches = newSearchesAndIds[0]
            .sublist(0, min(10, newSearchesAndIds[0].length));
        searchesId = newSearchesAndIds[1]
            .sublist(0, min(10, newSearchesAndIds[1].length));
      });
      setDialogState(() {
        wrongTitleEntries = [
          ...searches.mapIndexed(
            (index, title) {
              return DropdownMenuEntry(
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                value: index,
                label: title,
              );
            },
          ),
        ];
      });
    } else {
      setState(() {
        currentEpisode = newCurrentEpisode;
        searches = newSearchesAndIds[0];
        searchesId = newSearchesAndIds[1];
      });
      if (!mounted) return;
      if (searches.isNotEmpty) {
        AnimatedSnackBar.material(
          "Found \"${searches[0]}\"! :D",
          type: AnimatedSnackBarType.success,
          desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
        ).show(context);
      } else {
        AnimatedSnackBar.material(
          "No Title was Found!! D:",
          type: AnimatedSnackBarType.error,
          desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
        ).show(context);
      }
    }
  }

  void updateSource(int newSource) {
    setState(() {
      currentSource = newSource;
      currentSearch = 0;
      currentSearchString = "";
      setSearches(animeSources[currentSource]!.getAnimeTitlesAndIds);
    });
  }

//TODO temp, this is a mess
  Future<String> getSourceNameAndLangAsync(String source) async {
    var urlStream = Uri.parse(
        "https://kevin-is-awesome.mooo.com/api/unyo/sources/name?source=$source");
    var response = await http.get(urlStream);

    if (response.statusCode != 200) {
      return "";
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse["name"] ?? "";
  }

  double getAdjustedHeight(double value) {
    if (MediaQuery.of(context).size.aspectRatio > 1.77777777778) {
      return value;
    } else {
      return value *
          ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
    }
  }

  double getAdjustedWidth(double value) {
    if (MediaQuery.of(context).size.aspectRatio < 1.77777777778) {
      return value;
    } else {
      return value *
          ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
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
          content: DeleteUserMediaDialog(
            totalHeight: totalHeight,
            totalWidth: totalWidth,
            currentAnime: widget.currentAnime,
            deleteUserAnime: deleteUserAnime,
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

  void openVideo(String consumetId, int animeEpisode, String animeName) async {
    // int source = 0;
    late List<List<String?>?> streamAndCaptions;
    streamAndCaptions = await animeSources[currentSource]!
        .getAnimeStreamAndCaptions(consumetId, animeEpisode, context);

    // Map<String, String>? headers;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select quality",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          content: VideoQualityDialog(
            adjustedWidth: adjustedWidth,
            adjustedHeight: adjustedHeight,
            streamAndCaptions: streamAndCaptions,
            updateEntry: updateEntry,
            animeEpisode: animeEpisode,
            animeName: animeName,
          ),
        );
      },
    );
  }

  void openWrongTitleDialog(BuildContext context, double width, double height,
      void Function(void Function()) updateOutsideState) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            setWrongTitleSearch(setState);
            return AlertDialog(
              title: const Text("Select Title",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 44, 44, 44),
              content: WrongTitleDialog(
                width: width,
                height: height,
                wrongTitleSearchController: wrongTitleSearchController,
                wrongTitleEntries: wrongTitleEntries,
                onPressed: () async {
                  //NOTE dirty fix for a bug
                  if (!mounted) return;
                  AnimatedSnackBar.material(
                    "Updating Title, don't close...",
                    type: AnimatedSnackBarType.warning,
                    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
                  ).show(context);
                  await Future.delayed(const Duration(seconds: 1));
                  currentSearch = searches.indexOf(currentSearchString);
                  AnimatedSnackBar.material(
                    "Title Updated",
                    type: AnimatedSnackBarType.success,
                    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
                  ).show(context);
                  Navigator.of(context).pop();
                },
                onSelected: (value) {
                  currentSearchString = searches[value];
                  currentSearch = value!;
                },
              ),
            );
          },
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
          content: AnimeInfoDialog(
            totalWidth: totalWidth,
            totalHeight: totalHeight,
            statuses: statuses,
            query: query,
            currentAnime: widget.currentAnime,
            progress: progress,
            currentEpisode: currentEpisode,
            score: score,
            setUserAnimeModel: setUserAnimeModel,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          adjustedWidth = getAdjustedWidth(MediaQuery.of(context).size.width);
          totalWidth = MediaQuery.of(context).size.width;
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height);
          totalHeight = MediaQuery.of(context).size.height;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ImageGradient.linear(
                        image: Image.network(
                          widget.currentAnime.bannerImage ??
                              widget.currentAnime.coverImage!,
                          width: totalWidth,
                          height: totalHeight * 0.35,
                          fit: /*widget.currentAnime.bannerImage != null
                              ? BoxFit.fill
                              :*/
                              BoxFit.cover,
                        ),
                        colors: const [Colors.white, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      widget.currentAnime.coverImage != null
                          ? SizedBox(
                              height: totalHeight * 0.35,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 50.0),
                                    child: Hero(
                                      tag: widget.tag,
                                      child: AnimeWidget(
                                        title: "",
                                        coverImage:
                                            widget.currentAnime.coverImage,
                                        score: null,
                                        onTap: null,
                                        textColor: Colors.white,
                                        height: (adjustedHeight * 0.28) >
                                                minimumHeight
                                            ? (adjustedHeight * 0.28)
                                            : minimumHeight,
                                        width:
                                            (adjustedWidth * 0.1) > minimumWidth
                                                ? (adjustedWidth * 0.1)
                                                : minimumWidth,
                                        status: widget.currentAnime.status,
                                        year: null,
                                        format: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 4.0, bottom: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, left: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  updateSource(0);
                                  setUserAnimeModel();

                                  AnimatedSnackBar.material(
                                    "Refreshing Page",
                                    type: AnimatedSnackBarType.info,
                                    desktopSnackBarPosition:
                                        DesktopSnackBarPosition.topCenter,
                                  ).show(context);
                                },
                                icon: const Icon(Icons.refresh),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: totalWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: totalHeight * 0.1),
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
                          child: SmoothListView(
                            duration: const Duration(milliseconds: 200),
                            shouldScroll: !isShiftKeyPressed,
                            children: [
                              Row(
                                children: [
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
                                      ...animeSources.entries
                                          .mapIndexed((index, entry) {
                                        return DropdownMenuItem(
                                          value: index,
                                          onTap: () {
                                            updateSource(index);
                                          },
                                          child: Text(
                                            entry.value.getSourceName(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }),
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
                                      // setWrongTitleSearch();
                                      openWrongTitleDialog(
                                          context,
                                          adjustedWidth,
                                          adjustedHeight,
                                          setState);
                                    },
                                    child: const Text("Wrong/No Title?"),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 229, 166, 57),
                                    ),
                                    Text(
                                      " ${widget.currentAnime.averageScore} %",
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 229, 166, 57)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      widget.currentAnime.status != "RELEASING"
                                          ? Icons.check
                                          : Icons.circle,
                                      color: widget.currentAnime.status !=
                                              "RELEASING"
                                          ? Colors.grey
                                          : Colors.green,
                                    ),
                                    Text(
                                      widget.currentAnime.status != "RELEASING"
                                          ? " Finished"
                                          : " Releasing",
                                      style: TextStyle(
                                        color: widget.currentAnime.status !=
                                                "RELEASING"
                                            ? Colors.grey
                                            : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.tv,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      " ${widget.currentAnime.format}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.movie,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      " ${(widget.currentAnime.episodes ?? currentEpisode)} Episodes",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  widget.currentAnime.description
                                          ?.replaceAll("<br>", "\n")
                                          .replaceAll("<i>", "")
                                          .replaceAll("<b>", "")
                                          .replaceAll("</b>", "") ??
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: totalHeight * 0.22,
                        ),
                        SizedBox(
                          width: totalWidth * 0.45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (currentEpisodes < 1) return;
                                  setState(() {
                                    currentEpisodes--;
                                  });
                                },
                                icon: const Icon(
                                  Icons.navigate_before_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${currentEpisodes * 30 + 1} - ${min((30 * (currentEpisodes + 1)), (widget.currentAnime.episodes ?? currentEpisode))}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                              IconButton(
                                onPressed: () {
                                  if ((currentEpisodes + 1) * 30 >
                                      (widget.currentAnime.episodes ??
                                          currentEpisode)) return;
                                  setState(() {
                                    currentEpisodes++;
                                  });
                                },
                                icon: const Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: totalHeight * 0.06,
                        ),
                        SizedBox(
                          width: totalWidth / 2,
                          height: totalHeight * 0.57,
                          child: SmoothListView.builder(
                            duration: const Duration(milliseconds: 200),
                            itemCount: (widget.currentAnime.episodes ??
                                        currentEpisode) <
                                    30
                                ? (widget.currentAnime.episodes ??
                                    currentEpisode)
                                : min(
                                        (30 * (currentEpisodes + 1)),
                                        (widget.currentAnime.episodes ??
                                            currentEpisode)) -
                                    (currentEpisodes * 30 + 1) +
                                    1,
                            // widget.currentAnime.episodes ?? currentEpisode,
                            itemBuilder: (context, index) {
                              return EpisodeButton(
                                episodeNumber:
                                    (index + 1 + currentEpisodes * 30),
                                latestEpisode: currentEpisode,
                                latestEpisodeWatched:
                                    userAnimeModel?.progress ?? 1,
                                onTap: () {
                                  openVideo(
                                      searchesId[currentSearch],
                                      // index + 1,
                                      (index + 1 + currentEpisodes * 30),
                                      widget.currentAnime.title ?? "");
                                },
                                episodeTitle: mediaContentModel
                                    .titles?[(index + currentEpisodes * 30)],
                                episodeImageUrl: mediaContentModel
                                    .imageUrls?[(index + currentEpisodes * 30)],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WindowTitleBarBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      child: MoveWindow(),
                    ),
                    const WindowButtons(),
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
