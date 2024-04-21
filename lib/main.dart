import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unyo/screens/screens.dart';
import 'package:fvp/fvp.dart' as fvp;

void main() {
  //needed for video player!!
  fvp.registerWith();
  runApp(const MyApp());
  doWhenWindowReady(() {
    appWindow.minSize = const Size(854, 480);
    appWindow.size = const Size(1280, 720);
    appWindow.title = "Unyo";
    appWindow.position = const Offset(200, 200);
    appWindow.show();
  });
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _animeScreen =
    GlobalKey<NavigatorState>(debugLabel: 'anime');
final GlobalKey<NavigatorState> _mangaScreen =
GlobalKey<NavigatorState>(debugLabel: 'manga');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        // Return the widget that implements the custom shell (in this case
        // using a BottomNavigationBar). The StatefulNavigationShell is passed
        // to be able access the state of the shell and to navigate to other
        // branches in a stateful way.
        return ScaffoldScreen(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _animeScreen,
          routes: <RouteBase>[
            GoRoute(
              path: '/anime',
              builder: (BuildContext context, GoRouterState state) =>
              const AnimeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _mangaScreen,
          routes: <RouteBase>[
            GoRoute(
              path: '/manga',
              builder: (BuildContext context, GoRouterState state) =>
                  const MangaScreen(),
              /*routes: [
                We can have internal routes, will be needed for details and video
              ],*/
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Unyo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
