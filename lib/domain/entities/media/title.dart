import 'package:freezed_annotation/freezed_annotation.dart';

part 'title.freezed.dart';
part 'title.g.dart';

abstract class Title {
  final String romaji;
  final String english;
  final String nativeTitle;
  final String userPreferred;

  const Title({
    required this.romaji,
    required this.english,
    required this.nativeTitle,
    required this.userPreferred,
  });

  @override
  String toString() {
    return 'Title(romaji: $romaji, english: $english, nativeTitle: $nativeTitle, userPreferred: $userPreferred)';
  }
}

@freezed
abstract class TitleModel with _$TitleModel implements Title {
  const factory TitleModel({
    required String romaji,
    required String english,
    required String nativeTitle,
    required String userPreferred,
  }) = _TitleModel;

  factory TitleModel.empty() => const TitleModel(
    romaji: '',
    english: '',
    nativeTitle: '',
    userPreferred: '',
  );

  factory TitleModel.fromJson(Map<String, dynamic> json) =>
      _$TitleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$TitleModelToJson(this as _TitleModel);
}

class TitleConverter implements JsonConverter<Title, Map<String, dynamic>> {
  const TitleConverter();

  @override
  Title fromJson(Map<String, dynamic> json) => TitleModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(Title object) =>
      (object as TitleModel).toJson();
}