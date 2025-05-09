import 'package:unyo/util/constants.dart';

class MangaModel {
  MangaModel({
    required this.id,
    required this.idMal,
    required this.userPreferedTitle,
    required this.englishTitle,
    required this.japaneseTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.averageScore,
    required this.chapters,
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
  int? chapters;
  int? currentEpisode;
  int? duration;

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
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
      chapters: json['chapters'],
      currentEpisode: json['currentEpisode'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'malId': idMal,
      'userPreferedTitle': userPreferedTitle,
      'englishTitle': englishTitle,
      'japaneseTitle': japaneseTitle,
      'coverImage': coverImage,
      'bannerImage': bannerImage,
      'startDate': startDate,
      'endDate': endDate,
      'type': type,
      'status': status,
      'description': description,
      'format': format,
      'averageScore': averageScore,
      'chapters': chapters,
      'currentEpisode': currentEpisode,
      'duration': duration,
    };
  }

  /// Returns the first non-empty string in [candidates], or `''` if none.
  String _firstNonEmpty(List<String?> candidates) {
    for (final s in candidates) {
      if (s?.isNotEmpty ?? false) return s!;
    }
    return '';
  }

  String getDefaultTitle() {
    final type = prefs.getInt("default_title_type") ?? 0;

    // Define the three title‐orderings
    final orders = <List<String?>>[
      [userPreferedTitle, englishTitle, japaneseTitle], // 0
      [englishTitle, userPreferedTitle, japaneseTitle], // 1
      [japaneseTitle, userPreferedTitle, englishTitle], // 2
    ];

    // Safely pick an order (defaults to orders[0])
    final candidates = (type >= 0 && type < orders.length)
        ? orders[type]
        : orders[0];

    return _firstNonEmpty(candidates);
  }

  @override
  String toString() {
    return "$id $userPreferedTitle";
  }
}
