import 'package:flutter/material.dart';
import 'package:flutter_nime/screens/screens.dart';
import 'package:flutter_nime/widgets/floatting_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Widget> screens = [const AnimeScreen(), const HomeScreen(), const MangaScreen()];
  late Widget currentScreen;
  int currentScreenIndex = 1;
  @override
  void initState() {
    super.initState();
    currentScreen = screens[1];
  }

  void setScreen(int screenIndex){
    if (screenIndex != currentScreenIndex){
      setState(() {
        currentScreen = screens[screenIndex];
        currentScreenIndex = screenIndex;
      });
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
      home: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            currentScreen,
            FloattingMenu(
              setScreen: setScreen,
            ),
          ],
        ),
      ),
    );
  }
}
