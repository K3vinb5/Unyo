import 'package:flutter/material.dart';
import 'package:unyo/sources/anime/anime_source.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class GogoAnimeSource implements AnimeSource {
  
  final String consumetEndPoint = "https://kevin-is-awesome.mooo.com/consumet";

  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    final Completer<String> completer = Completer<String>();

    var urlStream = Uri.parse(
        "$consumetEndPoint/anime/gogoanime/watch/$id-episode-$episode");
    // print(urlStream);
    var response = await http.get(urlStream);

    if (response.statusCode != 200) {
      // print("ERROR CONSUMET_STREAM:\n${response.body}");
      //TODO dialog
    }

    List<dynamic> urls = jsonDecode(response.body)["sources"];

    for (int i = 0; i < urls.length; i++) {
      if (urls[i]["quality"] == "1080p") {
        return [urls[i]["url"], null];
      }
    }
    int? chosenValue;
    if (!context.mounted) return [[""], null, null, null];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "1080p stream not found!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          actions: [
            Column(
              children: [
                const Text(
                  "Please select a new stream quality",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenu(
                      onSelected: (value) {
                        chosenValue = value!;
                      },
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 44, 44, 44),
                        ),
                      ),
                      dropdownMenuEntries: [
                        ...urls.mapIndexed(
                          (index, json) {
                            return DropdownMenuEntry(
                              style: const ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              value: index,
                              label: json["quality"],
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
                        foregroundColor: MaterialStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
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
                        completer.complete(urls[chosenValue!]["url"]);
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
    return [[await completer.future], null, [""], [""], ["Goyabu - 1080p"], [""]];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    List<String> titles = [];
    List<String> ids = [];
    var url = Uri.parse("$consumetEndPoint/anime/gogoanime/$query?page=1");
    // print(url);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      // print("ERROR CONSUMET_ID: ${response.body}");
      return [];
    }

    List<dynamic> results = jsonDecode(response.body)["results"];

    for (int i = 0; i < results.length; i++) {
      titles.add(results[i]["title"]);
      ids.add(results[i]["id"]);
    }
    return [titles, ids];
  }

  @override
  String getSourceName() {
    return "GogoAnime";
  }
}
