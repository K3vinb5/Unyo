import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:unyo/sources/sources.dart';
import 'package:unyo/util/utils.dart';

late Map<int, AnimeSource> globalAnimesSources;

addEmbeddedAniyomiExtensions() async {
  globalAnimesSources = {};
  var urlStream = Uri.parse("${getEndpoint()}/unyo/sources");
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
      String name = await getSourceNameAndLangAsync(source);
      globalAnimesSources.addAll({
        sourcesLenght: EmbeddedSource(source: source as String, name: name)
      });
      sourcesLenght++;
    }
  }
}

Future<String> getSourceNameAndLangAsync(String source) async {
  var urlStream =
      Uri.parse("${getEndpoint()}/unyo/sources/name?source=$source");
  var response = await http.get(urlStream);

  if (response.statusCode != 200) {
    return "";
  }
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["name"] ?? "";
}
