class MangaModel {
  MangaModel(
      {required this.id,
        required this.title,
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
  String? title;
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

  @override
  String toString() {
    return "$id $title";
  }
}
