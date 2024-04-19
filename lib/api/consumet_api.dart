import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

const String consumetEndPoint = "https://kevin-is-awesome.mooo.com/consumet";

Future<List<List<String>>> getAnimeConsumetGogoAnimeIds(String query) async{
  List<String> titles = [];
  List<String> ids = [];
  var url = Uri.parse("$consumetEndPoint/anime/gogoanime/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return [];
  }

  List<dynamic> results = jsonDecode(response.body)["results"];

  for(int i = 0; i < results.length ; i++){
    titles.add(results[i]["title"]);
    ids.add(results[i]["id"]); //TODO verify
  }
  return [titles, ids];
}

Future<List<List<String>>> getAnimeConsumetZoroIds(String query) async{
  List<String> titles = [];
  List<String> ids = [];
  var url = Uri.parse("$consumetEndPoint/anime/zoro/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return [];
  }

  List<dynamic> results = jsonDecode(response.body)["results"];

  for(int i = 0; i < results.length ; i++){
    titles.add(results[i]["title"]);
    ids.add(results[i]["id"]);
  }
  return [titles, ids];
}


//STREAMS
Future<List<String>> getAnimeConsumetZoroStream(String consumetId, int episode, BuildContext context) async{

  var infoUrl = Uri.parse(
      "$consumetEndPoint/anime/zoro/info?id=$consumetId");
  print(infoUrl);
  var infoResponse = await http.get(infoUrl);

  if (infoResponse.statusCode != 200) {
    print("ERROR CONSUMET_STREAM:\n${infoResponse.body}");
    //TODO dialog
  }

  String episodeId = jsonDecode(infoResponse.body)["episodes"][episode - 1]["id"];

  var streamUrl = Uri.parse(
      "$consumetEndPoint/anime/zoro/watch?episodeId=$episodeId");
  print(streamUrl);
  var streamResponse = await http.get(streamUrl);

  if (streamResponse.statusCode != 200) {
    print("ERROR CONSUMET_STREAM:\n${infoResponse.body}");
    //TODO dialog
  }
  List<dynamic> urls = jsonDecode(streamResponse.body)["sources"];
  List<dynamic> captions = jsonDecode(streamResponse.body)["subtitles"];
  int englishCaptions = 0;
  for (int i = 0; i < captions.length; i++){
    if (captions[i]["lang"] == "English"){
      englishCaptions = i;
    }
  }
  return [urls[0]["url"], captions[englishCaptions]["url"]];
}
//
Future<String> getAnimeConsumetGogoAnimeStream(
    String consumetId, int episode, BuildContext context) async {
  final Completer<String> completer = Completer<String>();

  var urlStream = Uri.parse(
      "$consumetEndPoint/anime/gogoanime/watch/$consumetId-episode-$episode");
  print(urlStream);
  var response = await http.get(urlStream);

  if (response.statusCode != 200) {
    print("ERROR CONSUMET_STREAM:\n${response.body}");
    //TODO dialog
  }

  List<dynamic> urls = jsonDecode(response.body)["sources"];

  for (int i = 0; i < urls.length; i++) {
    if (urls[i]["quality"] == "1080p") {
      return urls[i]["url"];
    }
  }
  int? chosenValue;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("1080p stream not found!", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        actions: [
          Column(
            children: [
              const Text("Please select a new stream quality", style: TextStyle(color: Colors.white),),
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
                              foregroundColor: MaterialStatePropertyAll(Colors.white),
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
  //TODO make user choose
  return completer.future; //default
}
