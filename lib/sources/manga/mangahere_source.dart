import 'package:unyo/sources/manga/manga_source.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MangaHereSource implements MangaSource {
  final String consumetEndPoint = "https://kevin-is-awesome.mooo.com/consumet";

  @override
  Future<List<String>> getMangaChapterIds(String mangaId) async {
    List<String> chapterIds = [];
    var url = Uri.parse("$consumetEndPoint/manga/mangahere/info?id=$mangaId");
    // print(url);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      //TODO Dialog

      // print("ERROR CONSUMET_ID: ${response.body}");
      return [];
    }
    List<dynamic> results = jsonDecode(response.body)["chapters"];

    for (var i = 0; i < results.length; i++) {
      chapterIds.add(results[i]["id"]);
    }
    chapterIds = chapterIds.reversed.toList();
    return chapterIds;
  }

  @override
  Future<List<String>> getMangaChapterPages(String chapterId) async {
    List<String> pages = [];
    var url = Uri.parse(
        "$consumetEndPoint/manga/mangahere/read?chapterId=$chapterId");
    // print(url);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      //TODO Dialog

      // print("ERROR CONSUMET_ID: ${response.body}");
      return [];
    }
    List<dynamic> results = jsonDecode(response.body);

    for (var i = 0; i < results.length; i++) {
      pages.add(results[i]["img"]);
    }
    return pages;
  }

  @override
  Future<List<List<String>>> getMangaTitlesAndIds(String query) async {
    List<String> titles = [];
    List<String> ids = [];
    var url = Uri.parse("$consumetEndPoint/manga/mangahere/$query?page=1");
    // print(url);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      //TODO dialog

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
    return "MangaHere";
  }
}
