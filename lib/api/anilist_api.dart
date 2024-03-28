import 'dart:convert';
import 'dart:math';
import 'package:flutter_nime/main.dart';
import 'package:flutter_nime/models/models.dart';
import 'package:flutter_nime/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String anilistEndpoint = "https://graphql.anilist.co";
const String anilistEndPointGetToken =
    "https://anilist.co/api/v2/oauth/authorize?client_id=17550&response_type=token";
late String token;

Future<List<AnimeModel>> getAnimeModelListTrending(int page, int n) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int = 1 \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id title{userPreferred}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "ANIME",
      "sort": ["TRENDING_DESC", "POPULARITY_DESC"]
    }
  };
  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode != 200) {
    print("ERROR:\n${response.statusCode}");
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<AnimeModel> list = [];
    for (int i = 0; i < n; i++) {
      Map<String, dynamic> json = media[i];
      list.add(AnimeModel(
        id: json["id"],
        title: json["title"]["userPreferred"],
        coverImage: json["coverImage"]["large"],
        bannerImage: json["bannerImage"],
        startDate:
            "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
        endDate:
            "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
        type: json["type"],
        description: json["description"],
        status: json["status"],
        averageScore: json["averageScore"],
        episodes: json["episodes"],
        duration: json["duration"],
      ));
    }
    return list;
  }
}

Future<List<AnimeModel>> getAnimeModelListSeasonPopular(
    int page, int n, int year, String season) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int = 1 \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id title{userPreferred}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "ANIME",
      "seasonYear": year,
      "season": season,
    }
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode != 200) {
    print("ERROR:\n${response.statusCode}");
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<AnimeModel> list = [];
    for (int i = 0; i < n; i++) {
      Map<String, dynamic> json = media[i];
      list.add(AnimeModel(
        id: json["id"],
        title: json["title"]["userPreferred"],
        coverImage: json["coverImage"]["large"],
        bannerImage: json["bannerImage"],
        startDate:
            "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
        endDate:
            "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
        type: json["type"],
        description: json["description"],
        status: json["status"],
        averageScore: json["averageScore"],
        episodes: json["episodes"],
        duration: json["duration"],
      ));
    }
    return list;
  }
}

Future<List<AnimeModel>> getAnimeModelListSearch(String search, String sort, String season, String format, String year, int n) async {
  Map<String, dynamic> query = {
    "query" : "query(\$page:Int = 1 \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id title{userPreferred}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables" : {
      "page":1,
      "type":"ANIME",
      if (sort == "Select Sorting") "sort": "SEARCH_MATCH" else "sort" : sort.toUpperCase(),
      if( format != "Select Format") "format" : format.toUpperCase(),
      if (season != "Select Season") "season": season.toUpperCase(),
      if (year != "Select Year") "seasonYear": int.parse(year),
      "search": search
    }
  };
  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode != 200) {
    print("ERROR:\n${response.statusCode}");
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<AnimeModel> list = [];
    for (int i = 0; i < media.length; i++) {
      Map<String, dynamic> json = media[i];
      list.add(AnimeModel(
        id: json["id"],
        title: json["title"]["userPreferred"],
        coverImage: json["coverImage"]["large"],
        bannerImage: json["bannerImage"],
        startDate:
            "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
        endDate:
            "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
        type: json["type"],
        description: json["description"],
        status: json["status"],
        averageScore: json["averageScore"],
        episodes: json["episodes"],
        duration: json["duration"],
      ));
    }
    return list;
  }
}

Future<String?> getRandomAnimeBanner() async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query":
        "query (\$seasonYear: Int){Media(seasonYear: \$seasonYear){bannerImage}}",
    "variables": {
      "seasonYear": Random().nextInt(2024 - 2000 + 1) + 2000,
    }
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["data"]["Media"]["bannerImage"];
}

getUserToken() async {
  var url = Uri.parse(anilistEndPointGetToken);
  launchUrl(url, mode: LaunchMode.platformDefault); //TODO verify launchMode
}

Future<String> getUserbannerImageUrl(String name) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query":
        "query (\$id: Int \$name: String){User(id: \$id, name: \$name){bannerImage}}",
    "variables": {
      "name": name,
    }
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["data"]["User"]["bannerImage"];
}

Future<String> getUserAvatarImageUrl(String name) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query":
        "query (\$id: Int \$name: String){User(id: \$id, name: \$name){avatar {medium}}}",
    "variables": {
      "name": name,
    }
  };

  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["data"]["User"]["avatar"]["medium"];
}

Future<List<AnimeModel>> getUserAnimeLists(int userId, String listName) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query":
        "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id title{userPreferred romaji english native}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day}}}",
    "variables": {
      "userId": /*859862*/ userId,
      "type": "ANIME",
    }
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  List<AnimeModel> animeModelList = [];
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  List<dynamic> animeLists =
      jsonResponse["data"]["MediaListCollection"]["lists"];
  for (int i = 0; i < animeLists.length; i++) {
    if (animeLists[i]["name"] == listName) {
      List<dynamic> wantedList = animeLists[i]["entries"];
      for (int i = 0; i < wantedList.length; i++) {
        animeModelList.add(
          AnimeModel(
            id: wantedList[i]["media"]["id"],
            title: wantedList[i]["media"]["title"]["userPreferred"],
            coverImage: wantedList[i]["media"]["coverImage"]["large"],
            bannerImage: wantedList[i]["media"]["bannerImage"],
            startDate: "",
            //"${wantedList[i]["media"]["startDate"]["day"]}/${wantedList[i]["media"]["startDate"]["month"]}/${wantedList[i]["media"]["startDate"]["year"]}",
            endDate: "",
            //"${wantedList[i]["media"]["endDate"]["day"]}/${wantedList[i]["media"]["endDate"]["month"]}/${wantedList[i]["media"]["endDate"]["year"]}",
            type: wantedList[i]["media"]["type"],
            description: wantedList[i]["media"]["description"],
            status: wantedList[i]["media"]["status"],
            averageScore: wantedList[i]["media"]["averageScore"],
            episodes: wantedList[i]["media"]["episodes"],
            duration: wantedList[i]["media"]["episodes"],
          ),
        );
      }
      break;
    }
  }
  return animeModelList;
}

Future<List<String>> getUserAccessToken(String code) async {
  var url = Uri.parse("https://anilist.co/api/v2/oauth/token");
  Map<String, dynamic> query = {
    "grant_type": "authorization_code",
    "client_id": 17550,
    "client_secret": "xI8KTZlKm2F3kHXLko1ArQ21bKap4MojgDTk6Ukx",
    "redirect_uri": "http://localhost:9999/auth", // http://example.com/callback
    "code": code,
  };
  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: json.encode(query),
  );
  print(response.body);
  Map<String, dynamic> jsonResponse = json.decode(response.body);

  return [jsonResponse["access_token"], jsonResponse["refresh_token"]];
}

Future<List<String>> getUserNameAndId(String access_token) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query": "query {Viewer{name id}}",
  };
  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $access_token"
    },
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return [
    jsonResponse["data"]["Viewer"]["name"],
    jsonResponse["data"]["Viewer"]["id"].toString()
  ];
}

Future<UserAnimeModel> getUserAnimeInfo(int mediaId) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query":
        "query(\$mediaId:Int){Media(id:\$mediaId){id title{userPreferred}coverImage{large}bannerImage type status(version:2)episodes chapters volumes isFavourite mediaListEntry{id mediaId status score advancedScores progress progressVolumes repeat priority private hiddenFromStatusLists customLists notes updatedAt startedAt{year month day}completedAt{year month day}user{id name}}}}",
    "variables": {
      "variables": {
        "mediaId": mediaId,
      }
    }
  };
  var response = await http.post(
    url,
    headers: {
      "Authorization" : "Bearer $accessToken",
      "Content-Type": "application/json",
    },
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  Map<String, dynamic> mediaListEntry =
      jsonResponse["data"]["Media"]["mediaListEntry"];
  return UserAnimeModel(
    score: mediaListEntry["score"],
    progress: mediaListEntry["progress"],
    repeat: mediaListEntry["repeat"],
    priority: mediaListEntry["priority"],
  );
}

/*Future<Map<String,List<AnimeModel>>> getUserAnimeLists(){

}*/
