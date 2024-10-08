import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unyo/models/adapters/anilist_user_model_adapter.dart';
import 'package:unyo/models/adapters/anime_model_adapter.dart';
import 'package:unyo/models/adapters/local_user_model_adapter.dart';
import 'package:unyo/models/adapters/manga_model_adapter.dart';
import 'package:unyo/models/adapters/user_media_model_adapter.dart';
import 'package:unyo/router/router.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:path/path.dart' as p;
import 'package:unyo/util/utils.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

Future<void> main() async {
  //needed for video player on desktop!!
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  Hive.init(p.join(dir.path, "data"));
  Hive.registerAdapter(AnilistUserModelAdapter());
  Hive.registerAdapter(LocalUserModelAdapter());
  Hive.registerAdapter(UserMediaModelAdapter());
  Hive.registerAdapter(MangaModelAdapter());
  Hive.registerAdapter(AnimeModelAdapter());
  fvp.registerWith(options: {
    'platforms': ['linux', 'macos']
  });
  if (Platform.isWindows) {
    fvp.registerWith(options: {
      'platforms': ['windows'],
      'video.decoders' : ['DXVA', 'FFmpeg']
    });
  }
  await FlutterDiscordRPC.initialize(
    "1266242749485809748",
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
        Locale('ru'),
        // Locale('po'),
        // Locale('zh-cn'),
        // Locale('zh-hk')
      ],
      useOnlyLangCode: true,
      path: 'assets/languages',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
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
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      processManager.stopProcess();
      print("Killed internal server");
      return true;
    });
  }

  @override
  void dispose() {
    processManager.stopProcess();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: 'Unyo',
      routerConfig: router,
    );
  }
}
