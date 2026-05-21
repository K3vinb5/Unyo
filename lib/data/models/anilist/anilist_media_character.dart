import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_graphql_entity.dart' show MediaDetailsGraphqlMediaCharactersNodes;
import 'package:unyo/domain/entities/media/media_character.dart';

part 'anilist_media_character.freezed.dart';

part 'anilist_media_character.g.dart';

@freezed
abstract class AnilistMediaCharacterModel
    with _$AnilistMediaCharacterModel
    implements MediaCharacter {
  const factory AnilistMediaCharacterModel({
    required int id,
    required String image,
    required String name,
    required String gender,
    required String description,
    required String dateOfBirth,
    required int age
  }) = _AnilistMediaCharacterModel;

  factory AnilistMediaCharacterModel.empty() =>
      const AnilistMediaCharacterModel(
          id: -1,
          image: '',
          name: '',
          gender: '',
          description: '',
          dateOfBirth: '',
          age: 0
      );

  factory AnilistMediaCharacterModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistMediaCharacterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AnilistMediaCharacterModelToJson(this as _AnilistMediaCharacterModel);

  factory AnilistMediaCharacterModel.fromCharacterNode(
      MediaDetailsGraphqlMediaCharactersNodes characterNode) {
    return AnilistMediaCharacterModel(
        id: characterNode.id,
        image: characterNode.image.large,
        name: characterNode.name.userPreferred,
        gender: characterNode.gender,
        description: characterNode.description,
        dateOfBirth: "${characterNode.dateOfBirth.day}/${characterNode.dateOfBirth.month}/${characterNode.dateOfBirth.year}",
        age: int.tryParse(characterNode.age) ?? -1
    );
  }
}