import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unyo/screens/screens.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _animeScreen =
    GlobalKey<NavigatorState>(debugLabel: 'anime');
final GlobalKey<NavigatorState> _mangaScreen =
    GlobalKey<NavigatorState>(debugLabel: 'manga');
final GlobalKey<NavigatorState> _userAnimeListScreen =
    GlobalKey<NavigatorState>(debugLabel: 'userAnimeList');
final GlobalKey<NavigatorState> _userMangaListScreen =
    GlobalKey<NavigatorState>(debugLabel: 'userMangaList');
final GlobalKey<NavigatorState> _calendarScreen =
    GlobalKey<NavigatorState>(debugLabel: 'calendarScreen');

final GoRouter router = GoRouter(
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
      branches: [
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
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userAnimeListScreen,
          routes: <RouteBase>[
            GoRoute(
              path: '/userAnimeList',
              builder: (BuildContext context, GoRouterState state) =>
                  const AnimeUserListsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userMangaListScreen,
          routes: <RouteBase>[
            GoRoute(
              path: '/userMangaList',
              builder: (BuildContext context, GoRouterState state) =>
                  const MangaUserListsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _calendarScreen,
          routes: <RouteBase>[
            GoRoute(
              path: '/calendarScreen',
              builder: (BuildContext context, GoRouterState state) =>
                  const CalendarScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

