import 'dart:async';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/util/constants.dart';
import 'package:unyo/util/utils.dart';
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

  // Filters
  List<String> sortBy = [
    "Select Sorting",
    "Score",
    "Popularity",
    "Trending",
    "A-Z",
    "Z-A"
  ];
  List<String> animeFormat = [
    "Select Format",
    "Tv",
    "Tv Short",
    "Movie",
    "Special",
    "Ova",
    "Ona",
    "Music"
  ];
  List<String> mangaFormat = [
    "Select Format",
    "Manga",
    "Novel",
    "One shot",
  ];
  List<String> publishingStatus = [
    "Select Status",
    "Releasing",
    "Finished",
    "Not yet released",
    "Hiatus",
    "Cancelled"
  ];
  List<String> animeStatus = [
    "Select Status",
    "Releasing",
    "Finished",
    "Not yet released",
    "Cancelled"
  ];
  List<String> countryOfOrigin = [
    "Select Country",
    "Japan",
    "South Korea",
    "China",
    "Taiwan",
  ];
  List<String> genre = [
    "Select Genre",
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Hentai",
    "Horror",
    "Mahou Shoujo",
    "Mecha",
    "Music",
    "Mystery",
    "Psychological",
    "Romance",
    "Sci-Fi",
    "Slice of Life",
    "Sports",
    "Supernatural",
    "Thriller"
  ];
  List<String> season = ["Select Season", "Winter", "Spring", "Summer", "Fall"];

  late List<String> years;

  String currentSortBy = "Select Sorting";
  String currentFormat = "Select Format";
  String currentGenre = "Select Genre";
  String currentStatus = "Select Status";
  String currentSeason = "Select Season";
  String currentCountry = "Select Country";
  String currentYear = "Select Year";

  TextEditingController textFieldController = TextEditingController();

  final double minimumWidth = 124.08;
  final double minimumHeight = 195.44;
  double maximumWidth = 0;
  double maximumHeight = 0;
  bool isShiftKeyPressed = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    initYearsList();
    resetSearchTimer("");
    maximumWidth = minimumWidth * 1.4;
    maximumHeight = minimumHeight * 1.4;
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

  void initYearsList() {
    years = ["Select Year"];
    for (int i = DateTime.now().year; i >= 1970; i--) {
      years.add(i.toString());
    }
  }

  void resetSearchTimer(String search) {
    searchTimer.cancel();
    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      if (widget.type == "ANIME") {
        var newList = await getAnimeModelListSearch(
          search,
          currentGenre,
          currentSortBy,
          currentSeason,
          currentStatus,
          currentFormat,
          currentYear,
          50,
        );
        setState(() => searchMediaList = newList);
      } else {
        var newList = await getMangaModelListSearch(
          search,
          currentSortBy,
          currentFormat,
          currentStatus,
          currentCountry,
          currentGenre,
          50,
        );
        setState(() => searchMediaList = newList);
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
              Text(
                context.tr("advanced_search"),
                style: TextStyle(
                  color: veryLightBorderColor,
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
                    width: totalWidth * 0.20,
                    controller: textFieldController,
                    onChanged: (text) {
                      resetSearchTimer(text);
                    },
                    color: veryLightBorderColor,
                    hintColor: Colors.grey,
                    hint: "search".tr(),
                  ),
                  StyledDropDown(
                    horizontalPadding: 8,
                    width: widget.type == "ANIME" ? totalWidth * 0.11 : totalWidth * 0.15,
                    onTap: (index) {
                      currentGenre = genre[index];
                      resetSearchTimer(textFieldController.text);
                    },
                    items: genre.map((e) => Text(e)).toList(),
                  ),
                  StyledDropDown(
                    horizontalPadding: 8,
                    width: widget.type == "ANIME" ? totalWidth * 0.09 : totalWidth * 0.12,
                    onTap: (index) {
                      currentFormat = widget.type == "MANGA"
                          ? mangaFormat[index]
                          : animeFormat[index];
                      resetSearchTimer(textFieldController.text);
                    },
                    items: (widget.type == "MANGA"
                        ? mangaFormat
                        : animeFormat)
                        .map((e) => Text(e))
                        .toList(),
                  ),
                  if (widget.type == "ANIME") ...[
                    StyledDropDown(
                      horizontalPadding: 8,
                      width: totalWidth * 0.09,
                      onTap: (index) {
                        currentSeason = season[index];
                        resetSearchTimer(textFieldController.text);
                      },
                      items: season.map((e) => Text(e)).toList(),
                    ),
                    StyledDropDown(
                      horizontalPadding: 8,
                      width: totalWidth * 0.09,
                      onTap: (index) {
                        currentYear = years[index];
                        resetSearchTimer(textFieldController.text);
                      },
                      items: years.map((e) => Text(e)).toList(),
                    ),
                    StyledDropDown(
                      horizontalPadding: 8,
                      width: totalWidth * 0.11,
                      onTap: (index) {
                        currentStatus = animeStatus[index];
                        resetSearchTimer(textFieldController.text);
                      },
                      items: animeStatus.map((e) => Text(e)).toList(),
                    ),
                  ],
                  if (widget.type == "MANGA") ...[
                    StyledDropDown(
                      horizontalPadding: 8,
                      width: totalWidth * 0.12,
                      onTap: (index) {
                        currentStatus = publishingStatus[index];
                        resetSearchTimer(textFieldController.text);
                      },
                      items: publishingStatus.map((e) => Text(e)).toList(),
                    ),
                    StyledDropDown(
                      horizontalPadding: 8,
                      width: totalWidth * 0.12,
                      onTap: (index) {
                        currentCountry = countryOfOrigin[index];
                        resetSearchTimer(textFieldController.text);
                      },
                      items: countryOfOrigin.map((e) => Text(e)).toList(),
                    ),
                  ],
                  StyledDropDown(
                    horizontalPadding: 8,
                    width: widget.type == "ANIME" ? totalWidth * 0.09 : totalWidth * 0.12,
                    onTap: (index) {
                      currentSortBy = sortBy[index];
                      resetSearchTimer(textFieldController.text);
                    },
                    items: sortBy.map((e) => Text(e)).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: totalWidth,
                height: totalHeight - 172,
                child: SmoothListView(
                  scrollDirection: Axis.vertical,
                  duration: const Duration(milliseconds: 200),
                  shouldScroll: !isShiftKeyPressed,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: searchMediaList.mapIndexed((index, mediaModel) {
                        double w = adjustedWidth * 0.1;
                        double h = adjustedHeight * 0.28;
                        final widgetWidth  = min(max(w, minimumWidth),  maximumWidth);
                        final widgetHeight = min(max(h, minimumHeight), maximumHeight);
                        
                        final mediaTile = widget.type == "ANIME"
                          ? AnimeWidget(
                              title: mediaModel.getDefaultTitle(),
                              score: mediaModel.averageScore,
                              coverImage: mediaModel.coverImage,
                              onTap: () => openAnime(context, mediaModel, "grid-view-$index"),
                              textColor: Colors.white,
                              width: widgetWidth,
                              height: widgetHeight,
                              year: mediaModel.startDate,
                              format: mediaModel.format,
                              status: mediaModel.status,
                            )
                          : MangaWidget(
                              title: mediaModel.getDefaultTitle(),
                              score: mediaModel.averageScore,
                              coverImage: mediaModel.coverImage,
                              onTap: () => openMangaDetails(context, mediaModel, "grid-view-$index"),
                              textColor: Colors.white,
                              width: widgetWidth,
                              height: widgetHeight,
                              year: mediaModel.startDate,
                              format: mediaModel.format,
                              status: mediaModel.status,
                            );

                        return Hero(
                          tag: "grid-view-$index",
                          child: mediaTile,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
