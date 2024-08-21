import 'package:unyo/util/constants.dart';

class AnimeModel {
  AnimeModel({
    required this.id,
    this.idMal,
    required this.userPreferedTitle,
    this.englishTitle,
    this.japaneseTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.averageScore,
    required this.episodes,
    required this.duration,
    required this.description,
    required this.format,
    this.currentEpisode,
  });

  int id;
  int? idMal;
  String? userPreferedTitle;
  String? englishTitle;
  String? japaneseTitle;
  String? coverImage;
  String? bannerImage;
  String? startDate;
  String? endDate;
  String? type;
  String? status;
  String? description;
  String? format;
  int? averageScore;
  int? episodes;
  int? currentEpisode;
  int? duration;

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['id'],
      idMal: json['idMal'],
      userPreferedTitle: json["title"]["userPreferred"],
      japaneseTitle: json['title']['romaji'],
      englishTitle: json['title']['english'],
      coverImage: json['coverImage']['large'],
      bannerImage: json['bannerImage'],
      startDate:
          "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
      endDate:
          "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
      type: json['type'],
      status: json['status'],
      description: json['description'],
      format: json['format'],
      averageScore: json['averageScore'],
      episodes: json['episodes'],
      currentEpisode: json['currentEpisode'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'malId': idMal,
      'title': userPreferedTitle,
      'coverImage': coverImage,
      'bannerImage': bannerImage,
      'startDate': startDate,
      'endDate': endDate,
      'type': type,
      'status': status,
      'description': description,
      'format': format,
      'averageScore': averageScore,
      'episodes': episodes,
      'currentEpisode': currentEpisode,
      'duration': duration,
    };
  }

  String getDefaultTitle() {
    int titleType = prefs.getInt("default_title_type") ?? 0;
    switch (titleType) {
      case 0:
        return userPreferedTitle ?? "";
      case 1:
        return englishTitle ?? "";
      case 2:
        return japaneseTitle ?? "";
      default:
        return userPreferedTitle ?? "";
    }
  }

  @override
  String toString() {
    return "$id $coverImage";
  }
}
