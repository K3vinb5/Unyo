import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/sources.dart';

late Map<int, AnimeSource> globalAnimesSources;

 addEmbeddedAniyomiExtensions() async {
    globalAnimesSources = {};
    var urlStream = Uri.parse("https://kevin-is-awesome.mooo.com/api/unyo/sources");
    var response = await http.get(urlStream);

    if (response.statusCode == 200) {
      List<dynamic> sources = json.decode(response.body)["sources"];
      int sourcesLenght = globalAnimesSources.length;
      for (var source in sources) {
        String name = await getSourceNameAndLangAsync(source);
        // print(name);
        globalAnimesSources.addAll({
          sourcesLenght: EmbeddedSource(source: source as String, name: name)
        });
        sourcesLenght++;
      }
      globalAnimesSources.addAll({sourcesLenght++ : GoyabuSource()});
      globalAnimesSources.addAll({sourcesLenght++ : AnimesGamesSource()});
    }
  }

  Future<String> getSourceNameAndLangAsync(String source) async {
    var urlStream =
        Uri.parse("https://kevin-is-awesome.mooo.com/api/unyo/sources/name?source=$source");
    var response = await http.get(urlStream);

    if (response.statusCode != 200) {
      return "";
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse["name"] ?? "";
  }
