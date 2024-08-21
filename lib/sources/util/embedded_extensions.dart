import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:unyo/sources/manga/embedded_manga_source.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/util/utils.dart';

late Map<int, AnimeSource> globalAnimesSources;
late Map<int, MangaSource> globalMangasSources;

void addEmbeddedAniyomiExtensions() async {
  globalAnimesSources = {};
  // print("restarted extensions");
  var urlStream = Uri.parse("${getEndpoint()}/unyo/anime/sources");
  late Response response;
  try {
    response = await http.get(urlStream);
  } catch (e) {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    addEmbeddedAniyomiExtensions();
    return;
  }

  if (response.statusCode == 200) {
    List<dynamic> sources = json.decode(response.body)["sources"];
    int sourcesLenght = globalAnimesSources.length;
    for (var source in sources) {
      String name = await getSourceNameAndLangAsync(source, "anime");
      // print(name);
      globalAnimesSources.addAll({
        sourcesLenght: EmbeddedAnimeSource(source: source as String, name: name)
      });
      sourcesLenght++;
    }
  }
}

void addEmbeddedTachiyomiExtensions() async {
  globalMangasSources = {};
  print("restarted manga extensions");
  var urlStream = Uri.parse("${getEndpoint()}/unyo/manga/sources");
  late Response response;
  try {
    response = await http.get(urlStream);
  } catch (e) {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    addEmbeddedTachiyomiExtensions();
    return;
  }

  if (response.statusCode == 200) {
    List<dynamic> sources = json.decode(response.body)["sources"];
    int sourcesLenght = globalAnimesSources.length;
    for (var source in sources) {
      String name = await getSourceNameAndLangAsync(source, "manga");
      print(name);
      globalMangasSources.addAll({
        sourcesLenght: EmbeddedMangaSource(source: source as String, name: name)
      });
      sourcesLenght++;
    }
  }
}

Future<String> getSourceNameAndLangAsync(String source, String type) async {
  var urlStream =
      Uri.parse("${getEndpoint()}/unyo/$type/sources/name?source=$source");
  var response = await http.get(urlStream);

  if (response.statusCode != 200) {
    return "";
  }
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["name"] ?? "";
}
