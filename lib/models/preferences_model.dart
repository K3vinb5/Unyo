import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesModel {

  late SharedPreferences sharedPreferences;
  late Box box;
  String? userName;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("user_logged");
    print("logged user: $userName");
    if (userName != null || userName == "null") {
      box = await Hive.openBox(userName!);
    }
  }

  Future<void> loginUser(String user) async{
    sharedPreferences.setString("user_logged", user);
    box = await Hive.openBox(userName!);

  }

  bool isUserLogged() {
    return userName != null || userName != "null";
  }

  void clear() {
    userName = null;
    sharedPreferences.setString("user_logged", "null");
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
