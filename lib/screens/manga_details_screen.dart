import 'dart:async';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class MangaDetailsScreen extends StatefulWidget {
  const MangaDetailsScreen(
      {super.key, required this.currentManga, required this.tag});

  final MangaModel currentManga;
  final String tag;

  @override
  State<MangaDetailsScreen> createState() => _MangaDetailsScreenState();
}

class _MangaDetailsScreenState extends State<MangaDetailsScreen> {
  late VideoScreen videoScreen;
  UserMediaModel? userMangaModel;
  List<String> searches = [];
  List<String> searchesId = [];
  List<String> chaptersId = [];
  String currentSearchString = "";
  late int currentSearch;
  int currentSource = 0;
  int latestReleasedChapter = 0;
  late Map<int, MangaSource> mangaSources;
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
  bool startedWrongTitleDialog = true;
  List<DropdownMenuEntry> wrongTitleEntries = [];
  String oldWrongTitleSearch = "";
  Timer wrongTitleSearchTimer = Timer(const Duration(milliseconds: 0), () {});
  Timer updateSearchTimer = Timer(const Duration(milliseconds: 0), () {});
  void Function() wrongTitleSearchFunction = () {};
  TextEditingController wrongTitleSearchController = TextEditingController();
  int currentChapterGroup = 0;

  @override
  void initState() {
    super.initState();
    mangaSources = globalMangasSources;
    Future.delayed(Duration.zero, () {
      updateSource(0, context);
    });
    setUserMangaModel();
  }

  void setWrongTitleSearch(void Function(void Function()) setDialogState) {
    if (startedWrongTitleDialog) {
      oldWrongTitleSearch = searches.isNotEmpty ? searches[0] : "";
      startedWrongTitleDialog = false;
    }
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
        //TODO generalize search
        if (wrongTitleSearchController.text != oldWrongTitleSearch &&
            wrongTitleSearchController.text != "") {
          print("updated");
          setSearches(mangaSources[currentSource]!.getMangaTitlesAndIds,
              query: wrongTitleSearchController.text,
              setDialogState: setDialogState);
        }
        oldWrongTitleSearch = wrongTitleSearchController.text;
      });
    };
    wrongTitleSearchController.addListener(wrongTitleSearchFunction);
  }

  void setUserMangaModel() async {
    UserMediaModel? newUserMangaModel =
        await loggedUserModel.getUserMangaInfo(widget.currentManga.id);
    setState(() {
      userMangaModel = newUserMangaModel;
    });
    progress = userMangaModel?.progress?.toDouble() ?? 0.0;
    score = userMangaModel?.score?.toDouble() ?? 0.0;
    endDate = userMangaModel?.endDate?.replaceAll("null", "~") ?? "~/~/~";
    startDate = userMangaModel?.startDate?.replaceAll("null", "~") ?? "~/~/~";
    statuses.removeWhere((element) => element == userMangaModel?.status);
    query["score"] = score.toString();
    query["progress"] = progress.toInt().toString();
    statuses = [
      userMangaModel?.status == "" ? "NOT SET" : userMangaModel?.status ?? "",
      ...statuses
    ];
  }

  void setSearches(Future<List<List<String>>> Function(String) getIds,
      {String? query, void Function(void Function())? setDialogState}) async {
    List<List<String>> newSearches = await getIds(widget.currentManga.title!);
    List<List<String>> newSearchesAndIds =
        await getIds(query ?? widget.currentManga.title!);
    int newCurrentEpisode = widget.currentManga.status == "RELEASING"
        ? chaptersId.length
        : widget.currentManga.chapters!;
    if (setDialogState != null) {
      setState(() {
        latestReleasedChapter = newCurrentEpisode;
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
        latestReleasedChapter = newCurrentEpisode;
        searches = newSearches[0];
        searchesId = newSearches[1];
      });
      if (!mounted) return;
      if (searches.isNotEmpty) {
        updateSearchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (searchesId.isEmpty) {
            updateSearch(currentSearch);
          } else {
            updateSearch(currentSearch);
            timer.cancel();
          }
        });
        currentSearchString = searches[0];
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

  void updateSource(int newSource, BuildContext context) async {
    setState(() {
      currentSource = newSource;
      currentSearch = 0;
      currentSearchString = "";
      setSearches(mangaSources[currentSource]!.getMangaTitlesAndIds);
    });
  }

  void updateSearch(int currentSearch) async {
    if (searchesId.isEmpty) {
      updateSearchTimer.cancel();
      return;
    }
    List<String> newChaptersId = await mangaSources[currentSource]!
        .getMangaChapterIds(searchesId[currentSearch]);
    setState(() {
      chaptersId = newChaptersId;
    });
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
            currentMediaId: widget.currentManga.id,
            deleteUserAnime: loggedUserModel.deleteUserManga,
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
      widget.currentManga.status = "CURRENT";
      statuses.swap(0, statuses.indexOf("CURRENT"));
    }
    if (statuses[0] == "CURRENT" || statuses[0] == "REPEATING") {
      progress = newProgress.toDouble();
      query.remove("progress");
      query.addAll({"progress": progress.toInt().toString()});
      loggedUserModel.setUserMangaInfo(widget.currentManga.id, query, mangaModel: widget.currentManga);
      //waits a bit because anilist database may take a but to update, for now waiting one second could be tweaked later
      Timer(
        const Duration(milliseconds: 1000),
        () {
          setUserMangaModel();
        },
      );
    }
  }

  void openManga(String chapterId, int chapterNum, String mangaName) async {
    if (searches.isEmpty) {
      showErrorDialog(context, exception: context.tr("no_title_found_dialog"));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(
          currentChapter: chapterNum,
          chaptersId: chaptersId,
          updateEntry: (){updateEntry(chapterNum);},
          chapterId: chapterId,
          getMangaChapterPages:
              mangaSources[currentSource]!.getMangaChapterPages,
        ),
      ),
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
            return PopScope(
              onPopInvoked: (didPop) {
                if (didPop) {
                  wrongTitleSearchTimer.cancel();
                }
              },
              canPop: true,
              child: AlertDialog(
                title: const Text("Select Title",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                content: WrongTitleDialog(
                  width: width,
                  height: height,
                  wrongTitleSearchController: wrongTitleSearchController,
                  wrongTitleEntries: wrongTitleEntries,
                  manualSelection: null,
                  currentSearchString: currentSearchString,
                  onPressed: () async {
                    wrongTitleSearchTimer.cancel();
                    //NOTE dirty fix for a bug
                    if (!mounted) return;
                    AnimatedSnackBar.material(
                      "Updating Title, don't close...",
                      type: AnimatedSnackBarType.warning,
                      desktopSnackBarPosition:
                          DesktopSnackBarPosition.topCenter,
                    ).show(context);
                    await Future.delayed(const Duration(seconds: 1));
                    currentSearch = searches.indexOf(currentSearchString);
                    updateSearch(currentSearch);
                    AnimatedSnackBar.material(
                      "Title Updated",
                      type: AnimatedSnackBarType.success,
                      desktopSnackBarPosition:
                          DesktopSnackBarPosition.topCenter,
                    ).show(context);
                    Navigator.of(context).pop();
                  },
                  onSelected: (value) {
                    currentSearchString = searches[value];
                    currentSearch = value!;
                  },
                ),
              ),
            );
          },
        );
      },
    );
    Timer(
      const Duration(milliseconds: 500),
      () {
        setUserMangaModel();
      },
    );
  }

  void openMangaInfoDialog(BuildContext context) {
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
            id: widget.currentManga.id,
            episodes: chaptersId.length,
            totalWidth: totalWidth,
            totalHeight: totalHeight,
            statuses: statuses,
            query: query,
            progress: progress,
            currentEpisode: latestReleasedChapter,
            score: score,
            setUserAnimeModel: setUserMangaModel,
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
      color: (widget.currentManga.bannerImage != null &&
              widget.currentManga.coverImage != null)
          ? Colors.black
          : Colors.white,
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
                          widget.currentManga.bannerImage ??
                              widget.currentManga.coverImage!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded, start fading in
                              return AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                child: child,
                              );
                            } else {
                              // Keep the image transparent while loading
                              return AnimatedOpacity(
                                opacity: 0.0,
                                duration: const Duration(milliseconds: 0),
                                child: child,
                              );
                            }
                          },
                          width: totalWidth,
                          height: totalHeight * 0.35,
                          fit: BoxFit.cover,
                        ),
                        colors: const [Colors.white, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      MediaDetailsCoverImageWidget(
                          coverImage: widget.currentManga.coverImage,
                          totalHeight: totalHeight,
                          tag: widget.tag,
                          adjustedHeight: adjustedHeight,
                          adjustedWidth: adjustedWidth,
                          status: widget.currentManga.status),
                      StyledScreenMenuWidget(
                        onBackPress: () {
                          Navigator.of(context).pop();
                        },
                        onRefreshPress: () {
                          updateSource(0, context);
                          setUserMangaModel();
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MediaDetailsInfoWidget(
                          totalWidth: totalWidth,
                          totalHeight: totalHeight,
                          currentSource: currentSource,
                          mangaSources: mangaSources,
                          adjustedWidth: adjustedWidth,
                          adjustedHeight: adjustedHeight,
                          updateSource: updateSource,
                          context: context,
                          setState: setState,
                          openWrongTitleDialog: openWrongTitleDialog,
                          openMediaInfoDialog: openMangaInfoDialog,
                          currentManga: widget.currentManga,
                          currentEpisode: chaptersId.length,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MediaResumeFromWidget(
                          totalWidth: totalWidth,
                          text:
                              "${context.tr("resume_from")} Ch.${((userMangaModel?.progress ?? 0) + 1)}",
                          onPressed: () {
                            int chapterNum =
                                ((userMangaModel?.progress ?? 0) + 1).toInt();
                            if (searches.isEmpty /*||
                                (latestReleasedChapter + 1) <= chapterNum*/) {
                              return;
                            }
                            ((userMangaModel?.progress ?? 0) + 1).toInt();
                            openManga(chaptersId[chapterNum - 1], chapterNum,
                                widget.currentManga.title ?? "");
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MediaDetailsListNavigationWidget(
                          totalWidth: totalWidth,
                          currentEpisodeGroup: currentChapterGroup,
                          currentEpisode: latestReleasedChapter,
                          totalEpisodes: chaptersId.length,
                          episodeGroupBack: () {
                            setState(() {
                              currentChapterGroup--;
                            });
                          },
                          episodeGroupForward: () {
                            setState(() {
                              currentChapterGroup++;
                            });
                          },
                        ),
                        MediaDetailsListViewWidget(
                          totalWidth: totalWidth,
                          totalHeight: totalHeight,
                          totalEpisodes: chaptersId.length,
                          currentEpisodeGroup: currentChapterGroup,
                          currentEpisode: latestReleasedChapter,
                          itemBuilder: (context, index) {
                            return ChapterButton(
                              index: index,
                              userProgress: userMangaModel?.progress,
                              currentChapterGroup: currentChapterGroup,
                              chaptersId: chaptersId,
                              chapterTitle: widget.currentManga.title,
                              openManga: openManga,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const WindowBarButtons(startIgnoreWidth: 70),
            ],
          );
        },
      ),
    );
  }
}
