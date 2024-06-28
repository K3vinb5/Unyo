import 'dart:convert';
import 'package:http/http.dart' as http; 

const String endpoint = "https://api.ani.zip/mappings?anilist_id=";

class MediaContentModel {
  MediaContentModel({required this.anilistId});

  void init() async{
    var url = Uri.parse("$endpoint$anilistId");
    var response = await http.get(url); 
    if (response.statusCode != 200){
      if (attempt < 5){
         
      } 
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    Map<String, dynamic> episodes = jsonResponse["episodes"];
    imageUrls = episodes.values.map((e) => e["image"] as String?).toList(); 
    titles = episodes.values.map((e) => e["title"]["en"] as String?).toList();
    // if (titles != null){
    //   titles!.addAll(List.filled(10, null));
    // }
    // if (imageUrls != null){
    //   imageUrls!.addAll(List.filled(10, null));
    // }
  }

  final int anilistId;
  int attempt = 0;
  List<String?>? titles;
  List<String?>? imageUrls;
}
