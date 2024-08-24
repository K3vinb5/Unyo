import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesModel {
  late SharedPreferences sharedPreferences;

  PreferencesModel(this.sharedPreferences);
  late Box box;
  String? userName;

  void init() async {
    userName = sharedPreferences.getString("user_logged");
    if (userName != null) {
      box = await Hive.openBox(userName!);
    }
  }

  bool isUserLogged() {
    return userName != null;
  }

  void clear() {
    box.clear();
  }

  String? getString(String key) {
    return box.get(key) as String?;
  }

  void setString(String key, String value) {
    box.put(key, value);
  }

  int? getInt(String key) {
    return box.get(key) as int?;
  }

  void setInt(String key, int value) {
    box.put(key, value);
  }

  bool? getBool(String key) {
    return box.get(key) as bool?;
  }

  void setBool(String key, bool value) {
    box.put(key, value);
  }
}
