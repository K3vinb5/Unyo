import 'package:flutter/material.dart';
import 'package:flutter_nime/screens/screens.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:localstorage/localstorage.dart';

String? authorizationToken;
final LocalStorage storage = new LocalStorage('flutter_nime');

void _saveToStorage(String key, String value) {
  storage.setItem(key, value);
}

String? _isSaved() {
  var returnValue = storage.getItem("has_saved");
  return returnValue;
}

String? getName(){
  var returnValue = storage.getItem("name");
  return returnValue;
}

String _retrieveFromStorage() {
  return storage.getItem("auth_token");
}

void main() {
  if (_isSaved() == "true") {
  //ja esta guardado
    authorizationToken = _retrieveFromStorage();
  } else {
    authorizationToken = Uri.parse(Uri.base.toString().replaceFirst("/#", "?")).queryParameters['access_token'];
    if (authorizationToken != null) {
      if(authorizationToken!.length > 10){
        _saveToStorage("auth_token", authorizationToken!);
        _saveToStorage("has_saved", "true");
      }
    }else{
      _saveToStorage("has_saved", "false");
    }
  }

  print("token $authorizationToken");

  fvp.registerWith();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, String> routeNames = {
    0: "animeScreen",
    1: "homeScren",
    2: "mangaScreen",
  };
  int currentScreenIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  void setScreen(int screenIndex) {
    if (screenIndex != currentScreenIndex) {
      Navigator.popAndPushNamed(context, routeNames[screenIndex]!);
      currentScreenIndex = screenIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterNime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        extendBody: true,
        body: HomeScreen(),
      ),
      routes: {
        "animeScreen": (context) => const AnimeScreen(),
        "homeScreen": (context) => const HomeScreen(),
        "mangaScreen": (context) => const MangaScreen(),
        //"loginScreen": (context) => const WebViewScreen(),
      },
    );
  }
}
