import 'dart:convert';

import 'package:unyo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/util/constants.dart';

class EmbeddedMangaSource implements MangaSource {
  const EmbeddedMangaSource({required this.source, required this.name});

  final String source;
  final String name;

  @override
  Future<List<String>> getMangaChapterIds(String mangaId) async {
    var urlStream = Uri.parse("${getEndpoint()}/unyo/manga/chapterIds");
    Map<String, dynamic> requestBody = {
      "source": source,
      "id": mangaId,
    };
    var response = await http.post(urlStream, body: json.encode(requestBody));

    if (response.statusCode != 200) {
      print(response.body);
      return [];
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> ids = jsonResponse["chapterIds"];
    return ids.map((e) => e as String).toList().reversed.toList();
  }

  @override
  Future<List<String>> getMangaChapterPages(String chapterId) async {
    var urlStream = Uri.parse("${getEndpoint()}/unyo/manga/chapterPages");
    Map<String, dynamic> requestBody = {
      "source": source,
      "id": chapterId,
    };
    var response = await http.post(urlStream, body: json.encode(requestBody));

    if (response.statusCode != 200) {
      print(response.body);
      return [];
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> pagesUrls = jsonResponse["chapterPages"];
    return pagesUrls.map((e) => e as String).toList();
  }

  @override
  Future<List<List<String>>> getMangaTitlesAndIds(String query) async {
    var urlStream = Uri.parse(
        "${getEndpoint()}/unyo/manga/titleAndIds?source=$source&query=$query");
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
}
