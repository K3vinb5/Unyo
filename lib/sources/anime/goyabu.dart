import 'package:html/parser.dart';
import 'package:unyo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GoyabuSource implements AnimeSource {
  @override
  Future<List<List<String?>?>> getAnimeStreamAndCaptions(
      String id, int episode, BuildContext context) async {
    var url = Uri.parse(id);
    var response =
        await http.get(url, headers: {"Referer": "https://www.goyabu.us/"});

    if (response.statusCode != 200) {
      return [];
    }

    List<String> episodePages = [];
    String htmlContent = response.body;
    var document = parse(htmlContent);
    var elements = document.querySelectorAll('.ultimosEpisodiosHomeItem');
    for (var element in elements) {
      //episodePages
      String? episodePage = element.querySelector('a')?.attributes['href'];
      if (episodePage != null) {
        episodePages.add(episodePage);
      }
    }

    if (episodePages.length < episode) {
      //TODO handle cases where episode is higher than 30
      return [];
    }

    url = Uri.parse("https://www.goyabu.us/${episodePages[episode - 1]}");
    // print(episodePages);
    response =
        await http.get(url, headers: {"Referer": "https://www.goaybu.us/"});

    if (response.statusCode != 200) {
      return [];
    }

    htmlContent = response.body;
    List<String> lines = htmlContent.split('\n');
    List<String> linesWithFile =
        lines.where((line) => line.contains('file: ')).toList();
    List<String> cleanLines = [];
    for (var line in linesWithFile) {
      String newLine = line
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll(" ", "")
          .replaceAll("file:", "")
          .replaceAll("'", "")
          .replaceAll(",", "");
      newLine = newLine.substring(0, newLine.length - 1);
      cleanLines.add(newLine);
    }
    List<String> qualities = [
      "appfullhd",
      "apphd",
      "apphd2",
      "appsd",
      "appsd2",
    ];
    bool newMp4 = false;
    for(String line in cleanLines){
      newMp4 = newMp4 || (line.contains("appsd2") || line.contains("apphd2"));
    }
    if(!newMp4) qualities.removeAt(0);
    for (String quality in qualities) {
      for (String line in cleanLines) {
        if (line.contains(quality)) {
          print(line);
          return [
            [line],
            null,
            ["Referer"],
            ["https://www.goyabu.us/"]
          ];
        }
      }
    }
    return [];
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    final String animeTitlesAndIdsEndpoint =
        "https://www.goyabu.us/busca?busca=$query";
    var url = Uri.parse(animeTitlesAndIdsEndpoint);
    var response =
        await http.get(url, headers: {"Referer": "https://www.goyabu.us/"});

    if (response.statusCode != 200) {
      return [[], []];
    }
    List<List<String>> titlesAndIds = [[], []];
    String htmlContent = response.body;
    var document = parse(htmlContent);

    var elements = document.querySelectorAll('.ultimosAnimesHomeItem');
    for (var element in elements) {
      //link
      var id = element.querySelector('a')?.attributes['href'];
      //title
      var title =
          element.querySelector('.ultimosAnimesHomeItemInfosNome')?.text.trim();

      if (id != null && title != null) {
        titlesAndIds[0].add(title);
        titlesAndIds[1].add(id);
      }
    }
    return titlesAndIds;
  }

  @override
  String getSourceName() {
    return "Goyabu (Pt-Br)";
  }

}
