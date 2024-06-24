import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:unyo/sources/anime/anime_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimesOnlineSource implements AnimeSource {
  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    final String animePageEndpoint =
        "${id.replaceFirst("/anime/", "/episodio/")}-episodio-${episode > 9 ? episode : "0$episode"}";

    var url = Uri.parse(animePageEndpoint);
    var response = await http
        .get(url, headers: {"Referer": "https://animesonline.cloud/"});

    final String dataId = getDataId(response, animePageEndpoint);
    print("Id -> $dataId");
    String animeStreamEndpoint =
        "https://animesonline.cloud/wp-json/dooplayer/v2/$dataId/tv/1";

    url = Uri.parse(animeStreamEndpoint);
    response = await http
        .get(url, headers: {"Referer": "https://animesonline.cloud/"});

    Map<String, dynamic> jsonResponse = json.decode(response.body);
    late String mp4Endpoint;

    try {
      mp4Endpoint = jsonResponse["embed_url"];
    } catch (e) {
      print("Json: $jsonResponse \n Id: $dataId");
      mp4Endpoint = "";
    }

    if (!mp4Endpoint.contains("mangas.cloud")) {
      animeStreamEndpoint =
          "https://animesonline.cloud/wp-json/dooplayer/v2/$dataId/tv/2";

      url = Uri.parse(animeStreamEndpoint);
      response = await http
          .get(url, headers: {"Referer": "https://animesonline.cloud/"});

      jsonResponse = json.decode(response.body);
      try {
        mp4Endpoint = jsonResponse["embed_url"];
      } catch (e) {
        mp4Endpoint = "";
      }
      if (!mp4Endpoint.contains("mangas.cloud")) {
        animeStreamEndpoint =
            "https://animesonline.cloud/wp-json/dooplayer/v2/$dataId/tv/3";

        url = Uri.parse(animeStreamEndpoint);
        response = await http
            .get(url, headers: {"Referer": "https://animesonline.cloud/"});

        jsonResponse = json.decode(response.body);
        try {
          mp4Endpoint = jsonResponse["embed_url"];
        } catch (e) {
          return [];
        }
      }
    }

    mp4Endpoint = mp4Endpoint.replaceFirst(
        "https://animesonline.cloud/jwplayer?source=", "");
    mp4Endpoint = mp4Endpoint.replaceFirst("&id=$dataId&type=mp4", "");
    mp4Endpoint = Uri.decodeFull(mp4Endpoint);
    return [[mp4Endpoint], null, null, null];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    //TODO search the html for the ids instead of assuming them
    final String titlesAndIdsEndPoint =
        "https://animesonline.cloud/wp-json/dooplay/search/?keyword=$query&nonce=2cf7e710c5";
    var url = Uri.parse(titlesAndIdsEndPoint);
    var response = await http
        .get(url, headers: {"Referer": "https://animesonline.cloud/"});
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
    return "Animes Online (Pt-Br)";
  }

  String getDataId(http.Response response, String url) {
    String htmlContent = response.body;

    var document = parse(htmlContent);
    var elements = document.querySelectorAll('a[data-id]');

    for (var element in elements) {
      if (element.attributes['data-id'] == null) continue;
      return element.attributes['data-id']!;
    }
    //If something goes wrong
    int startIndex = htmlContent.indexOf('data-id="');
    print("startIndex->$startIndex");
    if (startIndex != -1) {
      startIndex += 'data-id="'.length;
      int endIndex = htmlContent.indexOf('"', startIndex);
      return "$startIndex-$endIndex";
    } else {
      print(url);
    }

    return "error";
  }
}
