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


Future<void> shutdownCleanup() async {
  await discord.cleanup();
  processManager.stopProcess();
}

Future<void> main() async {
  logger.i("Initializing dependencies");
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await EasyLocalization.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  Hive.init(p.join(dir.path, "data"));
  Hive.registerAdapter(AnilistUserModelAdapter());
  Hive.registerAdapter(LocalUserModelAdapter());
  Hive.registerAdapter(UserMediaModelAdapter());
  Hive.registerAdapter(MangaModelAdapter());
  Hive.registerAdapter(AnimeModelAdapter());
  if (Platform.isWindows) {
    fvp.registerWith(options: {
      'platforms': ['windows'],
      'video.decoders': ['DXVA', 'FFmpeg'],
      'player': {"avformat.extension_picky": "0"}
    });
  } else {
  fvp.registerWith(options: {
    'platforms': ['linux', 'macos'],
    });
  }
 
  //Initialize Discord RPC
  await discord.setRPCActivity();

  // Handle forced shutdown (Ctrl+C, SIGTERM)
  ProcessSignal.sigint.watch().listen((_) async {
    await shutdownCleanup();
    exit(0);
  });
  ProcessSignal.sigterm.watch().listen((_) async {
    await shutdownCleanup();
    exit(0);
  });

  logger.i("Initializing Unyo");
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
        Locale('ja'),
        Locale('bn'),
        Locale('hi'),
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
    discordRPC.initDiscordRPC();
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      logger.i("Unyo is exiting...");
      await shutdownCleanup();
      logger.i("Cleanup done; exiting now.");
      return true;
    });
  }

  @override
  void dispose() {
    Future.microtask(() async {
      await shutdownCleanup();
    });
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
