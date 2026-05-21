// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalUserModelAdapter extends TypeAdapter<LocalUserModel> {
  @override
  final typeId = 1;

  @override
  LocalUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalUserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      settings: fields[2] as Settings,
      avatarImage: fields[3] as String,
      bannerImage: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalUserModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.settings)
      ..writeByte(3)
      ..write(obj.avatarImage)
      ..writeByte(4)
      ..write(obj.bannerImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalUserModel _$LocalUserModelFromJson(Map<String, dynamic> json) =>
    _LocalUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      settings: const SettingsConverter().fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      avatarImage: json['avatarImage'] as String,
      bannerImage: json['bannerImage'] as String,
    );

Map<String, dynamic> _$LocalUserModelToJson(_LocalUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'settings': const SettingsConverter().toJson(instance.settings),
      'avatarImage': instance.avatarImage,
      'bannerImage': instance.bannerImage,
    };
