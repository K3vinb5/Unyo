import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

const String consumetEndPoint = "http://kevin-is-awesome.mooo.com:3000";

Future<String> getAnimeConsumetGogoAnimeId(String query) async {
  //print("$consumetEndPoint/anime/gogoanime/${Uri.parse(query)}?page=1");
  var url = Uri.parse("$consumetEndPoint/anime/gogoanime/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return "";
  }

  List<dynamic> results = jsonDecode(response.body)["results"];
  Map<String, dynamic> first = results[0];

  return first["id"];
}

Future<List<String>> getAnimeConsumetGogoAnimeIds(String query) async{
  List<String> returnList = [];
  var url = Uri.parse("$consumetEndPoint/anime/gogoanime/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return returnList;
  }

  List<dynamic> results = jsonDecode(response.body)["results"];

  for(int i = 0; i < results.length ; i++){
    returnList.add(results[i]["title"]);
  }
  return returnList;
}

//ZORO
Future<String> getAnimeConsumetZoroId(String query) async {
  //print("$consumetEndPoint/anime/gogoanime/${Uri.parse(query)}?page=1");
  var url = Uri.parse("$consumetEndPoint/anime/zoro/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return "";
  }

  List<dynamic> results = jsonDecode(response.body)["results"];
  Map<String, dynamic> first = results[0];

  return first["id"];
}

Future<List<String>> getAnimeConsumetZoroIds(String query) async{
  List<String> returnList = [];
  var url = Uri.parse("$consumetEndPoint/anime/zoro/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("ERROR CONSUMET_ID: ${response.body}");
    return returnList;
  }

  List<dynamic> results = jsonDecode(response.body)["results"];

  for(int i = 0; i < results.length ; i++){
    returnList.add(results[i]["title"]);
  }
  return returnList;
}


//STREAMS
Future<List<String>> getAnimeConsumetZoroStream(String animeTitle, int episode, BuildContext context) async{
  final Completer<String> completer = Completer<String>();
  String consumetId =
  await getAnimeConsumetZoroId(animeTitle.toLowerCase());

  var infoUrl = Uri.parse(
      "$consumetEndPoint/anime/zoro/info?id=$consumetId");
  print(infoUrl);
  var infoResponse = await http.get(infoUrl);

  if (infoResponse.statusCode != 200) {
    print("ERROR CONSUMET_STREAM:\n${infoResponse.body}");
    //TODO dialog
  }

  String episodeId = jsonDecode(infoResponse.body)["episodes"][episode]["id"];

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

Future<String> getAnimeConsumetGogoAnimeStream(
    String animeTitle, int episode, BuildContext context) async {
  final Completer<String> completer = Completer<String>();
  String consumetId =
      await getAnimeConsumetGogoAnimeId(animeTitle.toLowerCase());

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
        title: const Text("1080p stream not found!"),
        actions: [
          Column(
            children: [
              const Text("Please select a new stream quality"),
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
                    dropdownMenuEntries: [
                      ...urls.mapIndexed(
                        (index, json) {
                          return DropdownMenuEntry(
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
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
