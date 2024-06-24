import 'dart:convert';
import 'package:unyo/sources/sources.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

const animesGamesEndpoint = "https://animesgames.cc/";

class AnimesGamesSource implements AnimeSource {
  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    print(id);
    var url = Uri.parse(id);
    var response =
        await http.get(url, headers: {"Referer": animesGamesEndpoint});
    if (response.statusCode != 200) {
      //TODO shwoDialog

      return [];
    }
    String htmlContent = response.body;
    var document = parse(htmlContent);
    var elements = document.querySelectorAll(".episodioItem");
    String videoPageUrl =
        elements[episode - 1].querySelector('a')?.attributes['href'] ?? "error";
    if (videoPageUrl == "error") return [];
    print(videoPageUrl);
    url = Uri.parse(videoPageUrl);
    response = await http.get(url, headers: {"Referer": animesGamesEndpoint});
    if (response.statusCode != 200) return [];

    htmlContent = response.body;
    document = parse(htmlContent);
    String embedUrl = document
            .querySelector('#player')
            ?.querySelector('link')
            ?.attributes['href'] ??
        "error";
    if (embedUrl == "error") return [];
    print(embedUrl);
    url = Uri.parse(embedUrl);
    response = await http.get(url, headers: {"Referer": animesGamesEndpoint});
    if (response.statusCode != 200) return [];
    htmlContent = response.body;
    String streamingUrl = getStream(htmlContent);
    print("$streamingUrl");
    return [[streamingUrl], null, ["Referer"], [animesGamesEndpoint]];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    //TODO search the html for the ids instead of assuming them
    final String titlesAndIdsEndPoint =
        "${animesGamesEndpoint}wp-json/animesonline/search/?keyword=$query&nonce=1e8d73f99e";
    var url = Uri.parse(titlesAndIdsEndPoint);
    var response =
        await http.get(url, headers: {"Referer": animesGamesEndpoint});
    if (response.statusCode != 200) {
      //TODO Dialog

      // print(response.body);
      return [];
    }

    List<List<String>> titlesAndIds = [[], []];
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<MapEntry<String, dynamic>> entries = jsonResponse.entries.toList();
    try {
      for (int i = 0; i < entries.length; i++) {
        //ids
        titlesAndIds[1].add(entries[i].value["url"].toString());
        //titles
        titlesAndIds[0].add(entries[i].value["title"].toString());
      }
    } catch (e) {
      return [[], []];
    }

    return titlesAndIds;
  }

  @override
  String getSourceName() {
    return "AnimesGame (Pt-Br)";
  }

  String getStream(String htmlContent) {
    int startIndex = htmlContent.indexOf('{"file":"');
    if (startIndex == -1) return "error";
    int endIndex = htmlContent.indexOf('",', startIndex);
    if (endIndex == -1) return "error";
    String streamingUrl = htmlContent
        .substring(startIndex, endIndex + 1)
        .replaceAll("\\", "")
        .replaceAll('{"file":"', '')
        .replaceAll('"', '')
        .trim();
    return streamingUrl;
  }
}
