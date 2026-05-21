// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaCharacterModel _$MediaCharacterModelFromJson(Map<String, dynamic> json) =>
    _MediaCharacterModel(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      description: json['description'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      age: (json['age'] as num).toInt(),
    );

Map<String, dynamic> _$MediaCharacterModelToJson(
  _MediaCharacterModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'gender': instance.gender,
  'description': instance.description,
  'dateOfBirth': instance.dateOfBirth,
  'age': instance.age,
};
