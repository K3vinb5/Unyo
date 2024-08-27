import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/utils.dart';

String? accessToken;
String? avatarImageUrl;
String? bannerImageUrl;
String? userName;
int? userId;
List<AnimeModel>? watchingList;
List<MangaModel>? readingList;
late PreferencesModel prefs;
late UserModel loggedUserModel;
List<UserModel>? users;
Color veryLightBorderColor = Colors.white;
Color lightBorderColor = Colors.grey;
Color darkBorderColor = Colors.black;
List<Color> colorList = [];
List<int> isScreenRefreshed = [0, 1, 2, 3, 4, 5];
final ProcessManager processManager = ProcessManager();
String remoteEndPoint = "https://kevin-is-awesome.mooo.com/api";
String localEndPoint = "http://localhost:8084";

String getEndpoint() {
  if (prefs.getBool("remote_endpoint") ?? false) {
    return localEndPoint;
  } else {
    return localEndPoint;
    // return remoteEndPoint;
  }
}

Map<String, Map<String, Color>?> themes = {
  "Default (Banner)": null,
  "Red": redTheme,
  "Blue": blueTheme,
  "Green": greenTheme,
  "Yellow": yellowTheme,
  "Purple": purpleTheme,
  "Orange": orangeTheme,
  "Pink": pinkTheme,
  "Teal": tealTheme,
};
Map<String, String> langs = {
  "en": "English",
  "pt": "Portuguese",
  "fr": "French",
  "es": "Spanish",
  "it": "Italian",
  "de": "German",
  // "po" : "Polish",
  "ru": "Russian",
  // "zh-cn" : "Chinese (Traditional)",
  // "zh-hk" : "Chinese (Simplified)"
};

List<int> skipTimes = [75, 80, 85, 90, 95];

List<String> defaultTitleTypes = [
  "Default titles",
  "English titles",
  "Romaji titles"
];

Map<String, double> episodeCompletedOptions = {
  "80%": 0.8,
  "85%": 0.85,
  "90%": 0.9,
  "95%": 0.95,
};

Map<String, double> chapterCompletedOptions = {
  "80%": 0.8,
  "85%": 0.85,
  "90%": 0.9,
  "95%": 0.95,
  "100%": 1.0,
};

void setBannerPallete(
    String url, void Function(void Function()) setState) async {
  ImageProvider image = NetworkImage(url);
  var newPaletteGenerator = await PaletteGenerator.fromImageProvider(
    image,
    maximumColorCount: 20,
  );
  List<Color> lightToDarkColors = newPaletteGenerator.colors.toList();
  List<Color> newColorList = newPaletteGenerator.colors.toList();
  int lightest = lightToDarkColors.length - 1;
  while (newColorList.length < 20) {
    newColorList.addAll(newPaletteGenerator.colors.toList());
  }
  lightToDarkColors.sort((color1, color2) =>
      (color1.computeLuminance() * 10 - color2.computeLuminance() * 10)
          .toInt());

  setState(() {
    //NOTE higher the number the lighter the color
    bannerImageUrl = url;
    veryLightBorderColor = lightToDarkColors[lightest];
    lightBorderColor = lightToDarkColors[10];
    darkBorderColor = lightToDarkColors[0];
    colorList = newColorList;
  });
}

void initThemes(int selected, void Function(void Function()) setState) async {
  if (selected == 0) {
    String newbannerUrl = "https://i.imgur.com/x6TGK1x.png";
    try {
      newbannerUrl = await loggedUserModel.getUserbannerImageUrl();
    } catch (error) {
      //If newBannerURL never returns a string use default avatar
    }
    setBannerPallete(newbannerUrl, setState);
    return;
  }
  ImageProvider image = NetworkImage(themeWallpapers[selected - 1]);
  var newPaletteGenerator = await PaletteGenerator.fromImageProvider(
    image,
    maximumColorCount: 20,
  );
  List<Color> newColorList = newPaletteGenerator.colors.toList();
  while (newColorList.length < 20) {
    newColorList.addAll(newPaletteGenerator.colors.toList());
  }
  setState(() {
    veryLightBorderColor = themes.values.toList()[selected]!["veryLightColor"]!;
    lightBorderColor = themes.values.toList()[selected]!["lightColor"]!;
    darkBorderColor = themes.values.toList()[selected]!["darkColor"]!;
    bannerImageUrl = themeWallpapers[selected - 1];
    colorList = newColorList;
  });
}

List<String> themeWallpapers = [
  "https://wallpapercave.com/wp/wp5136563.jpg",
  "https://wallpapercave.com/uwp/uwp3713519.png",
  "https://wallpapercave.com/wp/wp8372475.jpg",
  "https://wallpapercave.com/wp/wp9209234.jpg",
  "https://wallpapercave.com/wp/wp13163437.jpg",
  "https://wallpapercave.com/wp/wp13567939.jpg",
  "https://wallpapercave.com/wp/wp5573232.jpg",
  "https://wallpapercave.com/wp/wp10475940.jpg"
];

Map<String, Color> redTheme = {
  "veryLightColor": const Color.fromARGB(255, 255, 204, 204),
  "lightColor": const Color.fromARGB(255, 255, 102, 102),
  "darkColor": const Color.fromARGB(255, 153, 0, 0),
};

Map<String, Color> blueTheme = {
  "veryLightColor": const Color.fromARGB(255, 204, 229, 255),
  "lightColor": const Color.fromARGB(255, 102, 153, 255),
  "darkColor": const Color.fromARGB(255, 0, 0, 153),
};

Map<String, Color> greenTheme = {
  "veryLightColor": const Color.fromARGB(255, 204, 255, 204),
  "lightColor": const Color.fromARGB(255, 102, 255, 102),
  "darkColor": const Color.fromARGB(255, 0, 153, 0),
};

Map<String, Color> yellowTheme = {
  "veryLightColor": const Color.fromARGB(255, 255, 255, 204),
  "lightColor": const Color.fromARGB(255, 255, 255, 102),
  "darkColor": const Color.fromARGB(255, 153, 153, 0),
};

Map<String, Color> purpleTheme = {
  "veryLightColor": const Color.fromARGB(255, 229, 204, 255),
  "lightColor": const Color.fromARGB(255, 178, 102, 255),
  "darkColor": const Color.fromARGB(255, 102, 0, 153),
};

Map<String, Color> orangeTheme = {
  "veryLightColor": const Color.fromARGB(255, 255, 229, 204),
  "lightColor": const Color.fromARGB(255, 255, 153, 102),
  "darkColor": const Color.fromARGB(255, 153, 76, 0),
};

Map<String, Color> pinkTheme = {
  "veryLightColor": const Color.fromARGB(255, 255, 204, 229),
  "lightColor": const Color.fromARGB(255, 255, 102, 178),
  "darkColor": const Color.fromARGB(255, 153, 0, 76),
};

Map<String, Color> tealTheme = {
  "veryLightColor": const Color.fromARGB(255, 204, 255, 255),
  "lightColor": const Color.fromARGB(255, 102, 255, 255),
  "darkColor": const Color.fromARGB(255, 0, 153, 153),
};

double getAdjustedHeight(double value, BuildContext context) {
  if (MediaQuery.of(context).size.aspectRatio > 1.77777777778) {
    return value;
  } else {
    return value *
        ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
  }
}

double getAdjustedWidth(double value, BuildContext context) {
  if (MediaQuery.of(context).size.aspectRatio < 1.77777777778) {
    return value;
  } else {
    return value *
        ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
  }
}
