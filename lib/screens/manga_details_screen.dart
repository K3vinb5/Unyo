import 'dart:async';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/api/anilist_api_manga.dart';

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
  int currentEpisode = 0;
  late Map<int, /* Future<List<List<String>>> Function(String) */ MangaSource>
      mangaSources;
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
  Timer wrongTitleSearchTimer = Timer(const Duration(milliseconds: 0), () {});
  Timer updateSearchTimer = Timer(const Duration(milliseconds: 0), () {});
  void Function() wrongTitleSearchFunction = () {};
  TextEditingController wrongTitleSearchController = TextEditingController();
  int currentEpisodes = 0;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    mangaSources = {
      0: MangaHereSource(),
    };
    updateSource(0);
    setUserMangaModel();
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
      // newSearches = searches;
      // newSearchesIds = searchesId;
    });
    wrongTitleSearchController.removeListener(wrongTitleSearchFunction);
    wrongTitleSearchFunction = () {
      wrongTitleSearchTimer.cancel();
      wrongTitleSearchTimer = Timer(const Duration(milliseconds: 1000), () {
        //TODO generalize search
        if (wrongTitleSearchController.text != oldWrongTitleSearch &&
            wrongTitleSearchController.text != "") {
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
    UserMediaModel newUserMangaModel =
        await getUserMangaInfo(widget.currentManga.id, 0);
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

  void updateSource(int newSource) async {
    setState(() {
      currentSource = newSource;
      currentSearch = 0;
      currentSearchString = "";
      setSearches(mangaSources[currentSource]!.getMangaTitlesAndIds);
    });
  }

  void updateSearch(int currentSearch) async {
    // print("Update Search called, lenght is: ${searchesId.length}");
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
                    deleteUserManga(widget.currentManga.id);
                    Navigator.of(context).pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 37, 37, 37),
                    ),
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
      setUserMangaInfo(widget.currentManga.id, query);
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(
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
            return AlertDialog(
              title: const Text("Select Title",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 44, 44, 44),
              //NOTE Must be container
              content: Container(
                width: width * 0.5,
                height: height * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    opacity: 0.1,
                    image: NetworkImage("https://i.imgur.com/fUX8AXq.png"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ),
                        const Text("Please select new title or search for one",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownMenu(
                              width: width * 0.4,
                              textStyle: const TextStyle(color: Colors.white),
                              menuStyle: const MenuStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 44, 44, 44),
                                ),
                              ),
                              controller: wrongTitleSearchController,
                              onSelected: (value) {
                                currentSearchString = searches[value];
                                currentSearch = value!;
                              },
                              initialSelection: 0,
                              dropdownMenuEntries: wrongTitleEntries,
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
                            foregroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            //NOTE dirty fix for a bug
                            updateSearchTimer = Timer.periodic(
                                const Duration(seconds: 1), (timer) {
                              if (searchesId.isEmpty) {
                                updateSearch(currentSearch);
                              } else {
                                updateSearch(currentSearch);
                                timer.cancel();
                              }
                            });
                            AnimatedSnackBar.material(
                              "Updating Title, don't close...",
                              type: AnimatedSnackBarType.warning,
                              desktopSnackBarPosition:
                                  DesktopSnackBarPosition.topCenter,
                            ).show(context);
                            await Future.delayed(const Duration(seconds: 1));
                            currentSearch =
                                searches.indexOf(currentSearchString);
                            AnimatedSnackBar.material(
                              "Title Updated",
                              type: AnimatedSnackBarType.success,
                              desktopSnackBarPosition:
                                  DesktopSnackBarPosition.topCenter,
                            ).show(context);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Confirm"),
                        ),
                      ],
                    ),
                  ],
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
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: totalWidth * 0.5,
                height: totalHeight * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            max: chaptersId.length.toDouble(),
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
                                  foregroundColor: MaterialStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setUserMangaInfo(
                                      widget.currentManga.id, query);
                                  Timer(
                                    const Duration(milliseconds: 1500),
                                    () {
                                      setUserMangaModel();
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
                          widget.currentManga.bannerImage ??
                              widget.currentManga.coverImage!,
                          width: totalWidth,
                          height: totalHeight * 0.35,
                          fit: /*widget.currentManga.bannerImage != null
                              ? BoxFit.fill
                              :*/
                              BoxFit.cover,
                        ),
                        colors: const [Colors.white, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      widget.currentManga.coverImage != null
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
                                            widget.currentManga.coverImage,
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
                                        status: widget.currentManga.status,
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
                                  setUserMangaModel();
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
                              Wrap(
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
                                      ...mangaSources.entries.mapIndexed(
                                        (index, entry) {
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
                                        },
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
                                      openMangaInfoDialog(context);
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
                                  widget.currentManga.title ?? "",
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
                                      " ${widget.currentManga.averageScore} %",
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 229, 166, 57)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      widget.currentManga.status != "RELEASING"
                                          ? Icons.check
                                          : Icons.circle,
                                      color: widget.currentManga.status !=
                                              "RELEASING"
                                          ? Colors.grey
                                          : Colors.green,
                                    ),
                                    Text(
                                      widget.currentManga.status != "RELEASING"
                                          ? " Finished"
                                          : " Releasing",
                                      style: TextStyle(
                                        color: widget.currentManga.status !=
                                                "RELEASING"
                                            ? Colors.grey
                                            : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.book,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      " ${widget.currentManga.format}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.bookmark,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      " ${chaptersId.length} Chapters",
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
                                  widget.currentManga.description
                                          ?.replaceAll("<br>", "\n")
                                          .replaceAll("<i>", "")
                                          .replaceAll("</i>", "")
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
                                "${currentEpisodes * 30 + 1} - ${min((30 * (currentEpisodes + 1)), chaptersId.length)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  if ((currentEpisodes + 1) * 30 >
                                      chaptersId.length) return;
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
                            itemCount: chaptersId.length < 30
                                ? chaptersId.length
                                : min((30 * (currentEpisodes + 1)),
                                        chaptersId.length) -
                                    (currentEpisodes * 30 + 1) +
                                    1,
                            itemBuilder: (context, index) {
                              return ChapterButton(
                                chapterNum: index + 1 + currentEpisodes * 30,
                                progress: userMangaModel?.progress != null
                                    ? userMangaModel!.progress as int
                                    : 0,
                                onTap: () {
                                  openManga(
                                      chaptersId[index],
                                      index + 1 + currentEpisodes * 30,
                                      widget.currentManga.title ?? "");
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
