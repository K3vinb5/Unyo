import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/constants.dart';

class PreferencesModel {
  late SharedPreferences sharedPreferences;
  late Box box;
  String? userName;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("user_logged");
    if (userName != null && userName != "null") {
      box = await Hive.openBox(userName!);
    }
  }

  void getUsers(void Function(void Function()) setState) async {
    var userBox = await Hive.openBox("users");
    List<dynamic> anilistSavedUsers = userBox.get("anilistUsers") ?? [];
    List<dynamic> localSavedUsers = userBox.get("localUsers") ?? [];

    List<UserModel> savedUsers =
        List.from(anilistSavedUsers.map((e) => e as AnilistUserModel));
    savedUsers.addAll(localSavedUsers.map((e) => e as LocalUserModel));

    print("saved users number: ${savedUsers.length}");
    setState(() {
      users = savedUsers;
    });
  }

  void saveUser(UserModel user) async {
    print("Saving user: ${user.userName}");
    var userBox = await Hive.openBox("users");
    List<dynamic> anilistSavedUsers =
        userBox.get("anilistUsers") ?? [];
    List<dynamic> localSavedUsers = userBox.get("localUsers") ?? [];

    List<UserModel> savedUsers =
        List.from(anilistSavedUsers.map((e) => e as AnilistUserModel));
    savedUsers.addAll(localSavedUsers.map((e) => e as LocalUserModel));

    if (savedUsers
        .where((listUser) => listUser.userName == user.userName)
        .isEmpty) {
      if (user is AnilistUserModel) {
        anilistSavedUsers.add(user);
      } else if (user is LocalUserModel) {
        localSavedUsers.add(user);
      }
    }

    userBox.put("anilistUsers", anilistSavedUsers);
    userBox.put("localUsers", localSavedUsers);
    users = savedUsers;
  }

  Future<void> loginUser(String user) async {
    print("Logging user: $user");
    sharedPreferences.setString("user_logged", user);
    userName = user;
    box = await Hive.openBox(user);
  }

  bool isUserLogged() {
    return userName != null && userName != "null";
  }

  void logOut() {
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
