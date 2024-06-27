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
        await http.get(url, headers: {"Referer": "https://www.goyabu.us/"});

    if (response.statusCode != 200) {
      return [];
    }

    htmlContent = response.body;
    // print("content: $htmlContent");
    List<String> lines = htmlContent.split("\n");
    List<String> linesWithFile =
        lines.where((line) => line.contains('file:')).toList();
    // print("raw: $linesWithFile");
    List<String> cleanLines = [];
    for (var line in linesWithFile) {
      String newLine = getStream(line) 
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll(" ", "")
          .replaceAll("file:", "")
          .replaceAll("'", "")
          .replaceAll(",", "").trim();
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
    // bool newMp4 = false;
    // for(String line in cleanLines){
    //   newMp4 = newMp4 || (line.contains("appsd2") || line.contains("apphd2"));
    // }
    // if(!newMp4) qualities.removeAt(0);
    print("streams: $cleanLines");
    List<List<String?>?> returnList = [[], null, [], [], [], []];
    for (String quality in qualities) {
      for (String line in cleanLines) {
        returnList[0]?.add(line);
        returnList[2]?.add("Referer");
        returnList[3]?.add("https://www.goyabu.us/");
        returnList[4]?.add("Qualidade - $quality");
        returnList[5]?.add("");
      }
    }
    print(returnList);
    return returnList;
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

  String getStream(String htmlContent) {
    int startIndex = htmlContent.indexOf("{file:'");
    if (startIndex == -1) return "error";
    int endIndex = htmlContent.indexOf("'", startIndex + 1);
    if (endIndex == -1) return "error";
    String streamingUrl = htmlContent
        .substring(startIndex, endIndex + 1)
        .replaceAll("\\", "")
        .replaceAll('{"file":"', '')
        .replaceAll('"', '')
        .trim();
    return streamingUrl;
  }

  @override
  String getSourceName() {
    return "Goyabu (Pt-Br)";
  }
}
