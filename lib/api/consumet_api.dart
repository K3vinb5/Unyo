import 'dart:convert';
import 'package:http/http.dart' as http;

const String consumetEndPoint = "http://kevin-is-awesome.mooo.com:3000";
String source = "animefox";

Future<String> getAnimeConsumetId(String query) async{
  //print("$consumetEndPoint/anime/gogoanime/${Uri.parse(query)}?page=1");
  var url = Uri.parse("$consumetEndPoint/anime/$source/$query?page=1");
  print(url);
  var response = await http.get(url);
  if (response.statusCode != 200){
    print("ERROR CONSUMET_ID: ${response.body}");
    return "";
  }

  List<dynamic> results = jsonDecode(response.body)["results"];
  Map<String,dynamic> first = results[0];

  return first["id"];
}

Future<String> getAnimeConsumetStream(String consumetId, int episode) async{
  print("$consumetEndPoint/anime/$source/watch/$consumetId-episode-$episode");
  var url = Uri.parse("$consumetEndPoint/anime/$source/watch/$consumetId-episode-$episode");
  var response = await http.get(url);

  if (response.statusCode != 200){
    print("ERROR CONSUMET_STREAM:\n${response.body}");
  }

  List<dynamic> urls = jsonDecode(response.body)["sources"];

  for (int i = 0; i < urls.length; i++){
    if (urls[i]["quality"] == "1080p"){
      return urls[i]["url"];
    }
  }

  return urls[-2]["url"]; //default
}