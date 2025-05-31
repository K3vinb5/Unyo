import 'package:hive/hive.dart';
import 'package:unyo/models/models.dart';

class MangaModelAdapter extends TypeAdapter<MangaModel> {
  @override
  MangaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaModel(
      id: fields[0],
      idMal: fields[1],
      userPreferedTitle: fields[2],
      japaneseTitle: fields[3],
      englishTitle: fields[4],
      coverImage: fields[5],
      bannerImage: fields[6],
      startDate: fields[7],
      endDate: fields[8],
      type: fields[9],
      status: fields[10],
      description: fields[11],
      format: fields[12],
      averageScore: fields[13],
      chapters: fields[14],
      currentEpisode: fields[15],
      duration: fields[16],
      genres: fields[17],
    );
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, MangaModel obj) {
    writer.writeByte(17);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.idMal);
    writer.writeByte(2);
    writer.write(obj.userPreferedTitle);
    writer.writeByte(3);
    writer.write(obj.japaneseTitle);
    writer.writeByte(4);
    writer.write(obj.englishTitle);
    writer.writeByte(5);
    writer.write(obj.coverImage);
    writer.writeByte(6);
    writer.write(obj.bannerImage);
    writer.writeByte(7);
    writer.write(obj.startDate);
    writer.writeByte(8);
    writer.write(obj.endDate);
    writer.writeByte(9);
    writer.write(obj.type);
    writer.writeByte(10);
    writer.write(obj.status);
    writer.writeByte(11);
    writer.write(obj.description);
    writer.writeByte(12);
    writer.write(obj.format);
    writer.writeByte(13);
    writer.write(obj.averageScore);
    writer.writeByte(14);
    writer.write(obj.chapters);
    writer.writeByte(15);
    writer.write(obj.currentEpisode);
    writer.writeByte(16);
    writer.write(obj.duration);
    writer.writeByte(17);
    writer.write(obj.genres ?? []);
  }
}
