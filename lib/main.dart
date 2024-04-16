import 'package:flutter/material.dart';
import 'package:unyo/screens/screens.dart';
import 'package:fvp/fvp.dart' as fvp;


void main() {
  //needed for video player!!
  fvp.registerWith();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unyo',
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
