// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_list_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaListEntryModelAdapter extends TypeAdapter<MediaListEntryModel> {
  @override
  final typeId = 9;

  @override
  MediaListEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaListEntryModel(
      progress: (fields[0] as num).toInt(),
      progressVolumes: (fields[1] as num).toInt(),
      score: (fields[2] as num).toDouble(),
      repeat: (fields[3] as num).toInt(),
      status: fields[4] as String,
      startedAt: (fields[5] as List).cast<String>(),
      completedAt: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaListEntryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.progress)
      ..writeByte(1)
      ..write(obj.progressVolumes)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.repeat)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.startedAt)
      ..writeByte(6)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaListEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaListEntryModel _$MediaListEntryModelFromJson(Map<String, dynamic> json) =>
    _MediaListEntryModel(
      progress: (json['progress'] as num).toInt(),
      progressVolumes: (json['progressVolumes'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      repeat: (json['repeat'] as num).toInt(),
      status: json['status'] as String,
      startedAt: (json['startedAt'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      completedAt: (json['completedAt'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MediaListEntryModelToJson(
  _MediaListEntryModel instance,
) => <String, dynamic>{
  'progress': instance.progress,
  'progressVolumes': instance.progressVolumes,
  'score': instance.score,
  'repeat': instance.repeat,
  'status': instance.status,
  'startedAt': instance.startedAt,
  'completedAt': instance.completedAt,
};
