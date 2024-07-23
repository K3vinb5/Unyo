import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:unyo/sources/anime/util/embedded_extensions.dart';
import 'package:unyo/router/router.dart';
import 'package:fvp/fvp.dart' as fvp;

Future<void> main() async {
  //needed for video player on desktop!!
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  fvp.registerWith(options: {
    'platforms': ['windows', 'linux', 'macos']
  });
  runApp(const MyApp());
  doWhenWindowReady(() {
    appWindow.position = const Offset(200, 200);
    appWindow.minSize = const Size(1280, 720);
    appWindow.title = "Unyo";
    appWindow.size = const Size(1280, 720);
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    addEmbeddedAniyomiExtensions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: 'Unyo',
      routerConfig: router,
    );
  }
}
