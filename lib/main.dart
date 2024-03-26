import 'package:flutter/material.dart';
import 'package:flutter_nime/screens/screens.dart';

String? authorizationToken;

void main() {
  authorizationToken = Uri.parse(Uri.base.toString().replaceFirst("/#", "?"))
      .queryParameters['access_token'];
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
      },
    );
  }
}
