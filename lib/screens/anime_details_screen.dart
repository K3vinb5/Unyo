import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nime/api/anilist_api.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/video_screen.dart';
import 'package:flutter_nime/widgets/widgets.dart';
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
  List<String> statuses = ["PLANNING", "CURRENT", "COMPLETED", "REPEATING", "PAUSED", "DROPPED"];

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
    UserAnimeModel newUserAnimeModel = await getUserAnimeInfo(widget.currentAnime.id);
    setState(() {
      userAnimeModel = newUserAnimeModel;
    });
    progress = userAnimeModel?.progress?.toDouble() ?? 0.0;
    statuses.removeWhere((element) => element == userAnimeModel?.status);
    statuses = [userAnimeModel?.status ?? "",...statuses];
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

  void openVideo(String consumetId, int animeEpisode) async {
    late String consumetStream;
    if (currentSource == 0) {
      consumetStream = await getAnimeConsumetGogoAnimeStream(
          consumetId, animeEpisode, context);
      videoScreen = VideoScreen(
        stream: consumetStream,
      );
    } else if (currentSource == 1) {
      List<String> streamCaption =
          await getAnimeConsumetZoroStream(consumetId, animeEpisode, context);

      consumetStream = streamCaption[0];
      videoScreen = VideoScreen(
        stream: consumetStream,
        captions: streamCaption[1],
      );
    } else {
      consumetStream = await getAnimeConsumetGogoAnimeStream(
          consumetId, animeEpisode, context);
      videoScreen = VideoScreen(
        stream: consumetStream,
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => videoScreen),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Title"),
          actions: [
            Column(
              children: [
                const Text("Please select new title"),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenu(
                      onSelected: (value) {
                        currentSearch = value!;
                      },
                      dropdownMenuEntries: [
                        ...searches.mapIndexed(
                          (index, title) {
                            return DropdownMenuEntry(
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
  }

  void openAnimeInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("List Editor", style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status", style: TextStyle(color: Colors.white),),
                    StyledDropDown(
                      items: [
                        ...statuses.map((status) => Text(status)),
                      ],
                      horizontalPadding: 10,
                      onTap: (index) {},
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    const SizedBox(height: 40,),
                    const Text("Progress", style: TextStyle(color: Colors.white),),
                    Row(
                      children: [
                        Text(progress.toInt().toString(), style: TextStyle(color: Colors.white),),
                        Expanded(
                          child: Slider(
                            activeColor: Colors.grey,
                            min: 0,
                            max: widget.currentAnime.episodes?.toDouble() ?? currentEpisode.toDouble(),
                            value: progress,
                            onChanged: (value) {
                              setState(() {
                                progress = value; // Update the progress variable when slider value changes
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    const Text("Score", style: TextStyle(color: Colors.white),),
                    StyledDropDown(
                      items: const [],
                      horizontalPadding: 10,
                      onTap: (index) {},
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    const SizedBox(height: 40,),
                    const Text("Start/End Date", style: TextStyle(color: Colors.white),),
                    Row(
                      children: [
                        StyledDropDown(
                          items: const [],
                          horizontalPadding: 10,
                          onTap: (index) {},
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        const SizedBox(width: 20,),
                        StyledDropDown(
                          items: const [],
                          horizontalPadding: 10,
                          onTap: (index) {},
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
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
      child: Stack(
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
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
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
                  width: MediaQuery.of(context).size.width,
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
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height * 0.63,
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
                                  openDialog(context);
                                },
                                child: const Text("Wrong Title?"),
                              ),
                              const SizedBox(width: 16.0,),
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
                      height: MediaQuery.of(context).size.height * 0.22,
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
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height * 0.63,
                      child: ListView.builder(
                        itemCount:
                            widget.currentAnime.episodes ?? currentEpisode,
                        itemBuilder: (context, index) {
                          return EpisodeButton(
                            episodeNumber: index + 1,
                            latestEpisode: currentEpisode,
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
      ),
    );
  }
}
