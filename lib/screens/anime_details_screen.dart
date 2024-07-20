import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:collection/collection.dart';
import 'package:unyo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/anime/util/embedded_extensions.dart';
import 'package:unyo/util/constants.dart';

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
  int currentEpisodeGroup = 0;
  late MediaContentModel mediaContentModel;

  @override
  void initState() {
    super.initState();
    animeSources = globalAnimesSources;
    mediaContentModel = MediaContentModel(anilistId: widget.currentAnime.id);
    mediaContentModel.init();
    updateSource(0);
    setUserAnimeModel();
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
      wrongTitleSearchTimer = Timer(const Duration(milliseconds: 500), () {
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
            currentMediaId: widget.currentAnime.id,
            deleteUserAnime: deleteUserAnime,
          ),
        );
      },
    );
  }

  void updateEntry(int newProgress) {
    // print("Status: ${statuses[0]}");
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

  void openVideoQualities(
      String consumetId, int animeEpisode, String animeName) async {
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
            updateEntry: updateEntry,
            animeEpisode: animeEpisode,
            animeName: animeName,
            consumetId: consumetId,
            currentAnimeSource: animeSources[currentSource]!,
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
                  wrongTitleSearchTimer.cancel();
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
          content: MediaInfoDialog(
            id: widget.currentAnime.id,
            episodes: widget.currentAnime.episodes,
            totalWidth: totalWidth,
            totalHeight: totalHeight,
            statuses: statuses,
            query: query,
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
          adjustedWidth =
              getAdjustedWidth(MediaQuery.of(context).size.width, context);
          totalWidth = MediaQuery.of(context).size.width;
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height, context);
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
                          fit: BoxFit.cover,
                        ),
                        colors: const [Colors.white, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      MediaDetailsCoverImageWidget(
                          coverImage: widget.currentAnime.coverImage,
                          totalHeight: totalHeight,
                          tag: widget.tag,
                          adjustedHeight: adjustedHeight,
                          adjustedWidth: adjustedWidth,
                          status: widget.currentAnime.status),
                      StyledScreenMenuWidget(
                        onBackPress: () {
                          Navigator.of(context).pop();
                        },
                        onRefreshPress: () {
                          updateSource(0);
                          setUserAnimeModel();

                          AnimatedSnackBar.material(
                            "Refreshing Page",
                            type: AnimatedSnackBarType.info,
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topCenter,
                          ).show(context);
                        },
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
                    MediaDetailsInfoWidget(
                      totalWidth: totalWidth,
                      totalHeight: totalHeight,
                      currentSource: currentSource,
                      animeSources: animeSources,
                      adjustedWidth: adjustedWidth,
                      adjustedHeight: adjustedHeight,
                      updateSource: updateSource,
                      setState: setState,
                      openWrongTitleDialog: openWrongTitleDialog,
                      openMediaInfoDialog: openAnimeInfoDialog,
                      currentAnime: widget.currentAnime,
                      currentEpisode: currentEpisode,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: totalHeight * 0.22,
                        ),
                        MediaDetailsListNavigationWidget(
                          totalWidth: totalWidth,
                          currentEpisodeGroup: currentEpisodeGroup,
                          currentEpisode: currentEpisode,
                          totalEpisodes: widget.currentAnime.episodes,
                          episodeGroupBack: () {
                            setState(() {
                              currentEpisodeGroup--;
                            });
                          },
                          episodeGroupForward: () {
                            setState(() {
                              currentEpisodeGroup++;
                            });
                          },
                        ),
                        MediaDetailsListViewWidget(
                          totalWidth: totalWidth,
                          totalHeight: totalHeight,
                          currentEpisodeGroup: currentEpisodeGroup,
                          currentEpisode: currentEpisode,
                          totalEpisodes: widget.currentAnime.episodes,
                          itemBuilder: (context, index) {
                            return EpisodeButton(
                              index: index,
                              currentEpisodeGroup: currentEpisodeGroup,
                              currentAnime: widget.currentAnime,
                              userAnimeModel: userAnimeModel,
                              mediaContentModel: mediaContentModel,
                              latestEpisode: currentEpisode,
                              latestEpisodeWatched:
                                  userAnimeModel?.progress ?? 1,
                              videoQualities: openVideoQualities,
                              currentSearchId: currentSearch < searchesId.length
                                  ? searchesId[currentSearch]
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const WindowBarButtons(startIgnoreWidth: 70)
            ],
          );
        },
      ),
    );
  }
}
