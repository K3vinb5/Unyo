import 'package:hive/hive.dart';
import 'package:unyo/models/models.dart';

class UserMediaModelAdapter extends TypeAdapter<UserMediaModel> {
  @override
  UserMediaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMediaModel(
      score: fields[0] as num?,
      progress: fields[1] as num?,
      repeat: fields[2] as int?,
      priority: fields[3] as int?,
      status: fields[4] as String?,
      startDate: fields[5] as String?,
      endDate: fields[6] as String?,
    );
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, UserMediaModel obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.score);
    writer.writeByte(1);
    writer.write(obj.progress);
    writer.writeByte(2);
    writer.write(obj.repeat);
    writer.writeByte(3);
    writer.write(obj.priority);
    writer.writeByte(4);
    writer.write(obj.status);
    writer.writeByte(5);
    writer.write(obj.startDate);
    writer.writeByte(6);
    writer.write(obj.endDate);
  }
}
