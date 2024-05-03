class UserMediaModel{
  UserMediaModel({
    required this.score,
    required this.progress,
    required this.repeat,
    required this.priority,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  num? score;
  num? progress;
  int? repeat;
  int? priority;
  String? status;
  String? startDate;
  String? endDate;
}