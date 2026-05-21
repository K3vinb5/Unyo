import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_character.freezed.dart';
part 'media_character.g.dart';

abstract class MediaCharacter {
  final int id;
  final String image;
  final String name;
  final String gender;
  final String description;
  final String dateOfBirth;
  final int age;

  const MediaCharacter({
    required this.id,
    required this.image,
    required this.name,
    required this.gender,
    required this.description,
    required this.dateOfBirth,
    required this.age
  });

  @override
  String toString() {
    return 'MediaCharacter(id: $id, image: $image, name: $name, gender: $gender, description: $description, dateOfBirth: $dateOfBirth, age: $age)';
  }
}

@freezed
abstract class MediaCharacterModel with _$MediaCharacterModel implements MediaCharacter {
  const factory MediaCharacterModel({
    required int id,
    required String image,
    required String name,
    required String gender,
    required String description,
    required String dateOfBirth,
    required int age
  }) = _MediaCharacterModel;

  factory MediaCharacterModel.empty() => const MediaCharacterModel(
    id: -1,
    image: '',
    name: '',
    gender: '',
    description: '',
    dateOfBirth: '',
    age: 0
  );

  factory MediaCharacterModel.fromJson(Map<String, dynamic> json) =>
      _$MediaCharacterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MediaCharacterModelToJson(this as _MediaCharacterModel);
}

class MediaCharacterConverter implements JsonConverter<MediaCharacter, Map<String, dynamic>> {
  const MediaCharacterConverter();

  @override
  MediaCharacter fromJson(Map<String, dynamic> json) => MediaCharacterModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(MediaCharacter object) =>
      (object as MediaCharacterModel).toJson();
}