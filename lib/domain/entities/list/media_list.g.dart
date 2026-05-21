// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaListModelAdapter extends TypeAdapter<MediaListModel> {
  @override
  final typeId = 5;

  @override
  MediaListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaListModel(
      name: fields[0] as String,
      mediaType: fields[1] as MediaType,
    );
  }

  @override
  void write(BinaryWriter writer, MediaListModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mediaType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaListModel _$MediaListModelFromJson(Map<String, dynamic> json) =>
    _MediaListModel(
      name: json['name'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
    );

Map<String, dynamic> _$MediaListModelToJson(_MediaListModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
    };

const _$MediaTypeEnumMap = {MediaType.anime: 'anime', MediaType.manga: 'manga'};
