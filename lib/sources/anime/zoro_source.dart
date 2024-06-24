import 'package:flutter/material.dart';
import 'package:unyo/sources/anime/anime_source.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ZoroSource implements AnimeSource {
  final String consumetEndPoint = "https://kevin-is-awesome.mooo.com/consumet";

  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    var infoUrl = Uri.parse("$consumetEndPoint/anime/zoro/info?id=$id");
    // print(infoUrl);
    var infoResponse = await http.get(infoUrl);

    if (infoResponse.statusCode != 200) {
      print("ER/* RO */R CONSUMET_STREAM:\n${infoResponse.body}");
      //TODO dialog
    }

    String episodeId =
        jsonDecode(infoResponse.body)["episodes"][episode - 1]["id"];

    var streamUrl =
        Uri.parse("$consumetEndPoint/anime/zoro/watch?episodeId=$episodeId");
    // print(streamUrl);
    var streamResponse = await http.get(streamUrl);

    if (streamResponse.statusCode != 200) {
      // print("ERROR CONSUMET_STREAM:\n${infoResponse.body}");
      //TODO dialog
    }
    List<dynamic> urls = jsonDecode(streamResponse.body)["sources"];
    List<dynamic> captions = jsonDecode(streamResponse.body)["subtitles"];
    int englishCaptions = 0;
    for (int i = 0; i < captions.length; i++) {
      if (captions[i]["lang"] == "English") {
        englishCaptions = i;
      }
    }
    return [[urls[0]["url"]], [captions[englishCaptions]["url"]]];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    List<String> titles = [];
    List<String> ids = [];
    var url = Uri.parse("$consumetEndPoint/anime/zoro/$query?page=1");
    // print(url);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      // print("ERROR CONSUMET_ID: ${response.body}");
      //TODO implement dialog
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
    return "Zoro";
  }
}
