// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anilist_manga_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaProgressModelAdapter extends TypeAdapter<AnilistMangaDetailsModel> {
  @override
  final typeId = 8;

  @override
  AnilistMangaDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnilistMangaDetailsModel(
      mediaListEntry: fields[0] as MediaListEntry,
      recommendedMangas: (fields[1] as List).cast<Manga>(),
      characters: (fields[2] as List).cast<MediaCharacter>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnilistMangaDetailsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mediaListEntry)
      ..writeByte(1)
      ..write(obj.recommendedMangas)
      ..writeByte(2)
      ..write(obj.characters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnilistMangaDetailsModel _$AnilistMangaDetailsModelFromJson(
  Map<String, dynamic> json,
) => _AnilistMangaDetailsModel(
  mediaListEntry: const MediaListEntryConverter().fromJson(
    json['mediaListEntry'] as Map<String, dynamic>,
  ),
  recommendedMangas: (json['recommendedMangas'] as List<dynamic>)
      .map((e) => const MangaConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  characters: (json['characters'] as List<dynamic>)
      .map(
        (e) =>
            const MediaCharacterConverter().fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AnilistMangaDetailsModelToJson(
  _AnilistMangaDetailsModel instance,
) => <String, dynamic>{
  'mediaListEntry': const MediaListEntryConverter().toJson(
    instance.mediaListEntry,
  ),
  'recommendedMangas': instance.recommendedMangas
      .map(const MangaConverter().toJson)
      .toList(),
  'characters': instance.characters
      .map(const MediaCharacterConverter().toJson)
      .toList(),
};
