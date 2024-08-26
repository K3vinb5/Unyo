import 'package:hive/hive.dart';
import 'package:unyo/models/models.dart';

class LocalUserModelAdapter extends TypeAdapter<LocalUserModel> {
  @override
  LocalUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalUserModel(
        avatarImage: fields[0] as String?,
        bannerImage: fields[1] as String?,
        userName: fields[2] as String?,
        userId: fields[3] as int?
       );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, LocalUserModel obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.avatarImage);
    writer.writeByte(1);
    writer.write(obj.bannerImage);
    writer.writeByte(2);
    writer.write(obj.userName);
    writer.writeByte(3);
    writer.write(obj.userId);
  }
}
