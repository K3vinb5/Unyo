// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anilist_anime_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeProgressModelAdapter extends TypeAdapter<AnilistAnimeDetailsModel> {
  @override
  final typeId = 4;

  @override
  AnilistAnimeDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnilistAnimeDetailsModel(
      mediaListEntry: fields[0] as MediaListEntry,
      recommendedAnimes: (fields[1] as List).cast<Anime>(),
      characters: (fields[2] as List).cast<MediaCharacter>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnilistAnimeDetailsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mediaListEntry)
      ..writeByte(1)
      ..write(obj.recommendedAnimes)
      ..writeByte(2)
      ..write(obj.characters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnilistAnimeDetailsModel _$AnilistAnimeDetailsModelFromJson(
  Map<String, dynamic> json,
) => _AnilistAnimeDetailsModel(
  mediaListEntry: const MediaListEntryConverter().fromJson(
    json['mediaListEntry'] as Map<String, dynamic>,
  ),
  recommendedAnimes: (json['recommendedAnimes'] as List<dynamic>)
      .map((e) => const AnimeConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  characters: (json['characters'] as List<dynamic>)
      .map(
        (e) =>
            const MediaCharacterConverter().fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AnilistAnimeDetailsModelToJson(
  _AnilistAnimeDetailsModel instance,
) => <String, dynamic>{
  'mediaListEntry': const MediaListEntryConverter().toJson(
    instance.mediaListEntry,
  ),
  'recommendedAnimes': instance.recommendedAnimes
      .map(const AnimeConverter().toJson)
      .toList(),
  'characters': instance.characters
      .map(const MediaCharacterConverter().toJson)
      .toList(),
};
