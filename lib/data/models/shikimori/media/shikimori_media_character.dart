// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

// Internal dependencies
import 'package:unyo/domain/entities/media/media_character.dart';

part 'shikimori_media_character.freezed.dart';
part 'shikimori_media_character.g.dart';

@freezed
abstract class ShikimoriMediaCharacterModel
    with _$ShikimoriMediaCharacterModel
    implements MediaCharacter {
  const factory ShikimoriMediaCharacterModel({
    required int id,
    required String image,
    required String name,
    required String gender,
    required String description,
    required String dateOfBirth,
    required int age,
  }) = _ShikimoriMediaCharacterModel;

  factory ShikimoriMediaCharacterModel.empty() =>
      const ShikimoriMediaCharacterModel(
        id: -1,
        image: '',
        name: '',
        gender: '',
        description: '',
        dateOfBirth: '',
        age: 0,
      );

  factory ShikimoriMediaCharacterModel.fromJson(Map<String, dynamic> json) =>
      _$ShikimoriMediaCharacterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ShikimoriMediaCharacterModelToJson(this as _ShikimoriMediaCharacterModel);

  // factory ShikimoriMediaCharacterModel.fromCharacterRole(
  //     ShikimoriAnimeDetailsGraphqlAnimeCharacterRoles role,) {
  //   return ShikimoriMediaCharacterModel(
  //     id: int.parse(role.character.id),
  //     image: role.character.poster.originalUrl,
  //     name: role.character.name,
  //     gender: '',
  //     description: '',
  //     dateOfBirth: '',
  //     age: 0,
  //   );
  // }

  // factory ShikimoriMediaCharacterModel.fromMangaCharacterRole(
  //     ShikimoriMangaDetailsGraphqlMangaCharacterRoles role,) {
  //   return ShikimoriMediaCharacterModel(
  //     id: int.parse(role.character.id),
  //     image: role.character.poster.originalUrl,
  //     name: role.character.name,
  //     gender: '',
  //     description: '',
  //     dateOfBirth: '',
  //     age: 0,
  //   );
  // }
}
