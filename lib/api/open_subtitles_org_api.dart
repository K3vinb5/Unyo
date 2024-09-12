import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

const searchEndPoint =
    "https://www.opensubtitles.org/libs/suggest.php?format=json3&MovieName=";
const animeEpisodesEndpoint =
    "https://www.opensubtitles.org/en/ssearch/idmovie-";

class OpenSubtitlesApi {
  Future<Map<String, String>> getSubtitlesUrl(
      String query, int season, int episode) async {
    String animeId = await getAnimeId(query);
    if (animeId == "-1") {
      return {};
    }
    List<List<String>> seasons = await getAnimeEpisodes(animeId);
    print(seasons);
    if (seasons.isEmpty ||
        seasons.length < season ||
        seasons[season - 1].length < episode) {
      return {};
    }
    String episodeSubtitlesUrl = seasons[season - 1][episode - 1];
    Map<String, String> subtitles =
        await getSubtitlesUrlAndLanguage(episodeSubtitlesUrl);
    return subtitles;
  }

  Future<String> getAnimeId(String query) async {
    var url =
        Uri.parse("$searchEndPoint${query.replaceAll(RegExp(r'[:!.,]'), '')}");
    var response = await http.get(url);
    print(response.body);
    List<dynamic> jsonResponse = [];
    try {
      jsonResponse = json.decode(response.body);
    } catch (e) {
      print("OpenSubtitles is Down");
      return "-1";
    }
    
    if (jsonResponse.isEmpty) {
      return "-1";
    }
    return jsonResponse[0]["id"].toString();
  }

  Future<List<List<String>>> getAnimeEpisodes(String animeId) async {
    var url = Uri.parse("$animeEpisodesEndpoint$animeId");
    var response = await http.get(url);
    String html = response.body;
    print(url);
    var document = parser.parse(html);
    List<Element> elements = document.querySelectorAll('tr');
    List<String> idsAttribute = elements
        .map((element) =>
            element.querySelector('td span[id]')?.attributes['id'] ?? "-1")
        .toList();
    List<int> ids = idsAttribute
        .asMap()
        .entries
        .where((element) => element.value.contains("season"))
        .map((e) => e.key)
        .toList();
    List<String> urls = elements
        .map((element) =>
            element.querySelector('td a[href]')?.attributes['href'] ?? "-1")
        .toList();
    List<List<String>> seasons = urls
        .asMap()
        .entries
        .splitBefore((element) => ids.contains(element.key))
        .toList()
        .map((list) => list.map((map) => map.value).toList())
        .toList();
    if (seasons.isNotEmpty) {
      seasons.removeAt(0);
    }
    for (List<String> list in seasons) {
      list.removeAt(0);
      list.removeWhere((element) => !element.contains("imdbid"));
    }
    return seasons;
  }

  Future<Map<String, String>> getSubtitlesUrlAndLanguage(
      String episodeUrl) async {
    var url =
        Uri.parse("https://www.opensubtitles.org$episodeUrl/subformat-srt");
    var response = await http.get(url);
    var document = parser.parse(response.body);
    List<String> hrefsWithSrt = document
        .querySelectorAll('tr td')
        .where((tdElement) =>
            tdElement.querySelector('span')?.text.contains("srt") ?? false)
        .map((tdElement) => tdElement.querySelector('a')?.attributes['href'])
        .where((href) => href != null)
        .cast<String>()
        .toList();
    List<String> titlesWithSublanguageId = document
        .querySelectorAll('tr td a[href*="sublanguageid"]')
        .map((aElement) => aElement.attributes['title'])
        .where((title) => title != null)
        .cast<String>()
        .toList();
    titlesWithSublanguageId.removeLast();
    print(titlesWithSublanguageId.length);
    print(hrefsWithSrt.length);
    if (hrefsWithSrt.length != titlesWithSublanguageId.length) {
      return {};
    }
    return Map.fromIterables(titlesWithSublanguageId, hrefsWithSrt);
  }
}
