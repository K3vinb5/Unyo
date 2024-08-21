import 'dart:convert';

import 'package:http/http.dart' as http;

const aniskipEndpoint = "https://api.aniskip.com/v1/skip-times";

Future<Map<String, double>> getOpeningSkipTimeStamps(
    String malId, String episode) async {
  var url = Uri.parse("$aniskipEndpoint/$malId/$episode?types=op");
  var response = await http.get(url);
  Map<String, dynamic> json = jsonDecode(response.body);
  if (json["found"] && malId != "-1") {
    return {
      "start": json["results"][0]["interval"]["start_time"].toDouble(),
      "end": json["results"][0]["interval"]["end_time"].toDouble(),
    };
  } else {
    return {"start": -1, "end": -1};
  }
}
