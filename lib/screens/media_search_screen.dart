import 'dart:async';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/api/anilist_api_manga.dart';

class MediaSearchScreen extends StatefulWidget {
  const MediaSearchScreen({super.key, required this.type});

  final String type;

  @override
  State<MediaSearchScreen> createState() => _MediaSearchScreenState();
}

class _MediaSearchScreenState extends State<MediaSearchScreen> {
  double adjustedHeight = 0;
  double adjustedWidth = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  List<dynamic> searchMediaList = [];
  Timer searchTimer = Timer(const Duration(milliseconds: 500), () {});
  List<String> sortBy = [
    "Select Sorting",
    "Score",
    "Popularity",
    "Trending",
    "A-Z",
    "Z-A"
  ];
  List<String> format = [
    "Select Format",
    "Tv",
    "Tv Short",
    "Movie",
    "Special",
    "Ova",
    "Ona",
    "Music"
  ];
  List<String> season = ["Select Season", "Winter", "Spring", "Summer", "Fall"];
  late List<String> years;
  String currentSortBy = "Select Sorting";
  String currentFormat = "Select Format";
  String currentSeason = "Select Season";
  String currentYear = "Select Year";
  TextEditingController textFieldController = TextEditingController();
  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double maximumWidth = 0;
  double maximumHeight = 0;

  @override
  void initState() {
    super.initState();
    initYearsList();
    resetSearchTimer("");
    maximumWidth = minimumWidth * 1.4;
    maximumHeight = minimumHeight * 1.4;
  }

  void initYearsList() {
    years = ["Select Year"];
    for (int i = DateTime.now().year; i >= 1970; i--) {
      years.add(i.toString());
    }
  }

  void resetSearchTimer(String search) {
    searchTimer.cancel();
    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      //Calls anilist anilist api
      if (widget.type == "ANIME") {
        var newSearchMediaList = await getAnimeModelListSearch(search,
            currentSortBy, currentSeason, currentFormat, currentYear, 50);
        setState(() {
          searchMediaList = newSearchMediaList;
        });
      } else {
        var newSearchMediaList = await getMangaModelListSearch(search,
            currentSortBy, currentSeason, currentFormat, currentYear, 50);
        setState(() {
          searchMediaList = newSearchMediaList;
        });
      }
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

  void openMangaDetails(MangaModel currentManga, String tag) {
    var mangaScreen = MangaDetailsScreen(
      currentManga: currentManga,
      tag: tag,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => mangaScreen),
    )/*.then((_) {
      if (widget.updateHomeScreenLists != null){
        widget.updateHomeScreenLists!();
      }
    })*/;
  }



  void openAnime(AnimeModel currentAnime, String tag) {
    var animeScreen = AnimeDetailsScreen(
      currentAnime: currentAnime,
      tag: tag,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => animeScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    adjustedHeight = getAdjustedHeight(MediaQuery.of(context).size.height);
    adjustedWidth = getAdjustedWidth(MediaQuery.of(context).size.width);
    totalWidth = MediaQuery.of(context).size.width;
    totalHeight = MediaQuery.of(context).size.height;
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ),
                const WindowButtons(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Advanced Search",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const Divider(
                height: 15,
                thickness: 2,
                indent: 70,
                endIndent: 70,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StyledTextField(
                    width: totalWidth * 0.22,
                    controller: textFieldController,
                    onChanged: (text) {
                      resetSearchTimer(text);
                    },
                    color: Colors.white,
                    hintColor: Colors.grey,
                    hint: "Search...",
                  ),
                  StyledDropDown(
                    width: totalWidth * 0.22,
                    onTap: (index) {
                      currentFormat = format[index];
                      resetSearchTimer(textFieldController.text);
                    },
                    horizontalPadding: 0,
                    items: const [
                      Text("Select Format"),
                      Text("Tv"),
                      Text("Tv Short"),
                      Text("Movie"),
                      Text("Special"),
                      Text("Ova"),
                      Text("Ona"),
                      Text("Music"),
                    ],
                  ),
                  SizedBox(
                    width: totalWidth * 0.26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledDropDown(
                          width: totalWidth * 0.12,
                          onTap: (index) {
                            currentSeason = season[index];
                            resetSearchTimer(textFieldController.text);
                          },
                          horizontalPadding: 0,
                          items: const [
                            Text("Select Season"),
                            Text("Winter"),
                            Text("Spring"),
                            Text("Summer"),
                            Text("Fall"),
                          ],
                        ),
                        StyledDropDown(
                          width: totalWidth * 0.12,
                          onTap: (index) {
                            currentYear = years[index];
                            resetSearchTimer(textFieldController.text);
                          },
                          horizontalPadding: 0,
                          items: [
                            ...years.map(
                              (year) {
                                return Text(year);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StyledDropDown(
                    onTap: (index) {
                      currentSortBy = sortBy[index];
                      resetSearchTimer(textFieldController.text);
                    },
                    width: totalWidth * 0.22,
                    horizontalPadding: 0,
                    items: const [
                      Text("Select Sorting"),
                      Text("Score"),
                      Text("Popularity"),
                      Text("Trending"),
                      Text("A-Z"),
                      Text("Z-A"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: totalWidth,
                height: totalHeight - 172,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    runSpacing: -(totalWidth * 0.1),
                    alignment: WrapAlignment.center,
                    children: [
                      ...searchMediaList.mapIndexed((index, mediaModel) {
                        double calculatedWidth = adjustedWidth * 0.1;
                        double calculatedHeight = adjustedHeight * 0.28;
                        return Hero(
                          tag: "${"grid-view"}-$index",
                          child: AnimeWidget(
                            title: mediaModel.title,
                            score: mediaModel.averageScore,
                            coverImage: mediaModel.coverImage,
                            onTap: () {
                              if (widget.type == "ANIME"){
                                openAnime(mediaModel, "grid-view-$index");
                              }else{
                                openMangaDetails(mediaModel, "grid-view-$index");
                              }
                            },
                            textColor: Colors.white,
                            height: min(max(calculatedHeight, minimumHeight),
                                maximumHeight),
                            width: min(max(calculatedWidth, minimumWidth),
                                maximumWidth),
                            year: mediaModel.startDate,
                            format: mediaModel.format,
                            status: mediaModel.status,
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
