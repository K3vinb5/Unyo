import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/sources.dart';

class EmbeddedSource implements AnimeSource {
  const EmbeddedSource({required this.source, required this.name});

  final String source;
  final String name;
  // final String embeddedServerEndPoint = "http://127.0.0.1:8080"; will be embbeded subsituting the need for a server :), already tested and works, but need to change building scripts
  final String embeddedServerEndPoint = "https://kevin-is-awesome.mooo.com/api";

  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    var urlStream = Uri.parse("$embeddedServerEndPoint/unyo/streamAndCaptions");
    Map<String, dynamic> requestBody = {
      "source": source,
      "id": id,
      "episode": episode
    };
    var response = await http.post(urlStream,
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      return [[], null, null, null];
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    // print(response.body);
    List<dynamic> streams = jsonResponse["streams"];
    List<dynamic> qualities = jsonResponse["qualities"];
    List<dynamic>? captions =
        jsonResponse["captions"] != "null" ? jsonResponse["captions"] : null;
    List<dynamic>? headersKeys = jsonResponse["headersKeys"] != "null"
        ? jsonResponse["headersKeys"]
        : null;
    List<dynamic>? headersValues = jsonResponse["headersNames"] != "null"
        ? jsonResponse["headersNames"]
        : null;
    List<String> headersKeysProcessed = [];
    List<String> headersValuesProcessed = [];
    if (headersKeys != null) {
      for (var headersKey in headersKeys) {
        headersKeysProcessed.add((headersKey as List<dynamic>).join("@"));
      }
      for (var headersValue in headersValues!) {
        headersValuesProcessed.add((headersValue as List<dynamic>).join("@"));
      }
    }
    streams.removeWhere((element) => (element as String) == "");
    captions?.removeWhere((element) => (element as String) == "");

    print([
      streams.map((e) => e as String).toList(),
      captions?.map((e) => e as String).toList(),
      headersKeysProcessed,
      headersValuesProcessed,
      qualities.map((e) => e as String).toList(),
    ]);
    return [
      streams.map((e) => e as String).toList(),
      captions?.map((e) => e as String).toList(),
      headersKeysProcessed,
      headersValuesProcessed,
      qualities.map((e) => e as String).toList(),
    ];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    var urlStream = Uri.parse(
        "$embeddedServerEndPoint/unyo/titleAndIds?source=$source&query=$query");
    var response = await http.get(urlStream);

    if (response.statusCode != 200) {
      print(response.body);
      return [[], []];
    }

    Map<String, dynamic> jsonResponse = json.decode(response.body);

    List<dynamic> titles = jsonResponse["titles"] ?? [];
    List<dynamic> ids = jsonResponse["ids"] ?? [];
    return [
      titles.map((e) => e as String).toList(),
      ids.map((e) => e as String).toList()
    ];
  }

  @override
  String getSourceName() {
    return name;
  }

  // Future<String> getSourceNameAsync() async{
  //   var urlStream = Uri.parse("$embeddedServerEndPoint/sources/name?source=$source");
  //   var response = await http.get(urlStream);
  //
  //   if (response.statusCode != 200) {
  //     return "";
  //   }
  //   Map<String, dynamic> jsonResponse = json.decode(response.body);
  //   return jsonResponse["name"] ?? "";
  // }
}
