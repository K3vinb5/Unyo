import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/screens/screens.dart';

class StyledDropDownMenu extends StatefulWidget {
  const StyledDropDownMenu({
    super.key,
    required this.width,
    required this.controller,
    required this.color,
    required this.hintColor,
    this.label,
    this.labelColor,
  });

  final double width;
  final TextEditingController controller;
  final Color color;
  final Color hintColor;
  final String? label;
  final Color? labelColor;

  @override
  State<StyledDropDownMenu> createState() => _StyledDropDownMenuState();
}

class _StyledDropDownMenuState extends State<StyledDropDownMenu> {
  Timer searchTimer = Timer(const Duration(milliseconds: 500), () {});
  List<AnimeModel> listAnimeModels = [];
  List<DropdownMenuEntry<AnimeModel>> listEntries = [
    // const DropdownMenuEntry(value: SizedBox.shrink(), label: "Nothing"),
  ];

  //There have no use, they just serve the search funtion and since I don't have filters here these are just the required default values
  String currentSortBy = "Select Sorting";
  String currentFormat = "Select Format";
  String currentSeason = "Select Season";
  String currentYear = "Select Year";

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      onChanged(widget.controller.text);
    });
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

  void onChanged(String text) {
    // print(text);
    searchTimer.cancel();
    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      List<AnimeModel> newSearchMediaList = await getAnimeModelListSearch(
          text, currentSortBy, currentSeason, currentFormat, currentYear, 10);
      setState(() {
        listAnimeModels = newSearchMediaList;
        listEntries = [
          ...newSearchMediaList.map((animeModel) {
            return DropdownMenuEntry(
              style: const ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(
                    color: Color.fromARGB(255, 44, 43, 44),
                  ),
                ),
                overlayColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 33, 34, 33),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 39, 38, 39),
                ),
                textStyle: MaterialStatePropertyAll(
                  TextStyle(color: Colors.white),
                ),
              ),
              leadingIcon: Image.network(
                animeModel.coverImage ?? "",
                fit: BoxFit.fill,
                height: 95,
              ),
              labelWidget: Text(
                animeModel.title ?? "",
                style: const TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
              label: "",
              value: animeModel,
            );
          }),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      menuStyle: const MenuStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10.0)),
        side: MaterialStatePropertyAll(
          BorderSide(
            color: Color.fromARGB(255, 39, 38, 39),
            width: 5.0,
          ),
        ),
      ),
      width: widget.width,
      menuHeight: 350,
      controller: widget.controller,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: widget.color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: widget.color),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: widget.color),
          // TextStyle(color: Colors.white),
        ),
      ),
      textStyle: TextStyle(color: widget.color),
      label: Text(
        widget.label ?? "",
        style: TextStyle(color: widget.labelColor ?? Colors.white),
      ),
      dropdownMenuEntries: listEntries,
      onSelected: (value) {
        if (value == null) {
          return;
        }
        openAnime(value, "search-${listAnimeModels.indexOf(value)}");
      },
    );
  }
}
