// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtensionModelAdapter extends TypeAdapter<ExtensionModel> {
  @override
  final typeId = 7;

  @override
  ExtensionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtensionModel(
      name: fields[0] as String,
      pkg: fields[1] as String,
      apk: fields[2] as String,
      icon: fields[3] as String,
      lang: fields[4] as String,
      version: fields[5] as String,
      nsfw: (fields[6] as num).toInt(),
      type: fields[7] as String,
      repositoryUrl: fields[8] == null ? '' : fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExtensionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.pkg)
      ..writeByte(2)
      ..write(obj.apk)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.lang)
      ..writeByte(5)
      ..write(obj.version)
      ..writeByte(6)
      ..write(obj.nsfw)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.repositoryUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtensionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtensionModel _$ExtensionModelFromJson(Map<String, dynamic> json) =>
    _ExtensionModel(
      name: json['name'] as String,
      pkg: json['pkg'] as String,
      apk: json['apk'] as String,
      icon: json['icon'] as String,
      lang: json['lang'] as String,
      version: json['version'] as String,
      nsfw: (json['nsfw'] as num).toInt(),
      type: json['type'] as String,
      repositoryUrl: json['repositoryUrl'] as String? ?? "",
    );

Map<String, dynamic> _$ExtensionModelToJson(_ExtensionModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pkg': instance.pkg,
      'apk': instance.apk,
      'icon': instance.icon,
      'lang': instance.lang,
      'version': instance.version,
      'nsfw': instance.nsfw,
      'type': instance.type,
      'repositoryUrl': instance.repositoryUrl,
    };
