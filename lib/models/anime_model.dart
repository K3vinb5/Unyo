class AnimeModel {
  AnimeModel(
      {required this.id,
      required this.title,
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
      });

  int id;
  String? title;
  String? coverImage;
  String? bannerImage;
  String? startDate;
  String? endDate;
  String? type;
  String? status;
  String? description;
  int? averageScore;
  int? episodes;
  int? duration;

  @override
  String toString() {
    return "$id $coverImage";
  }
}
