// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anilist_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnilistUserModelAdapter extends TypeAdapter<AnilistUserModel> {
  @override
  final typeId = 0;

  @override
  AnilistUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnilistUserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      settings: fields[2] as Settings,
      avatarImage: fields[3] as String,
      bannerImage: fields[4] as String,
      accessCode: fields[5] as String,
      accessToken: fields[6] as String,
      refreshToken: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnilistUserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.settings)
      ..writeByte(3)
      ..write(obj.avatarImage)
      ..writeByte(4)
      ..write(obj.bannerImage)
      ..writeByte(5)
      ..write(obj.accessCode)
      ..writeByte(6)
      ..write(obj.accessToken)
      ..writeByte(7)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnilistUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnilistUserModel _$AnilistUserModelFromJson(Map<String, dynamic> json) =>
    _AnilistUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      settings: const SettingsConverter().fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      avatarImage: json['avatarImage'] as String,
      bannerImage: json['bannerImage'] as String,
      accessCode: json['accessCode'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AnilistUserModelToJson(_AnilistUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'settings': const SettingsConverter().toJson(instance.settings),
      'avatarImage': instance.avatarImage,
      'bannerImage': instance.bannerImage,
      'accessCode': instance.accessCode,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
