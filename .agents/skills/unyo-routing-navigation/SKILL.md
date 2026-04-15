---
name: unyo-routing-navigation
description: How to add routes, configure navigation, and use AutoRoute in the Unyo Flutter app. Use this skill whenever adding new screens/routes, configuring nested tab navigation, defining route transitions, navigating between screens from cubits via effects, or debugging routing issues like "route not found" errors.
---

# Unyo Routing & Navigation

Unyo uses **AutoRoute** for type-safe declarative routing. Routes are defined in a single `AppRouter` class, and code generation creates the `.gr.dart` file with typed route pages. Navigation from cubits uses the Effect system rather than direct `BuildContext`.

## Architecture Overview

```
lib/core/router/
├── app_router.dart       # Route definitions (the source of truth)
└── app_router.gr.dart    # Generated file (DO NOT EDIT)
```

The router is instantiated once in `main.dart`:

```dart
final _appRouter = AppRouter();
```

And used in `MaterialApp.router()`:

```dart
MaterialApp.router(
  routerConfig: _appRouter.config(),
)
```

## Route Configuration

All routes are defined in `lib/core/router/app_router.dart` as a nested tree:

```dart
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: RootRoute.page,
      path: '/',
      transitionsBuilder: TransitionsBuilders.noTransition,
      duration: Duration.zero,
      reverseDuration: Duration.zero,
      children: [
        // Tab-level routes (inside AutoTabsRouter)
        CustomRoute(page: LoginRoute.page, path: 'login', initial: true, ...),
        CustomRoute(page: TabsRoute.page, path: 'tabs', children: [
          CustomRoute(page: HomeRoute.page, path: 'home', ...),
          CustomRoute(page: AnimeRoute.page, path: 'anime', ...),
          CustomRoute(page: MangaRoute.page, path: 'manga', ...),
          CustomRoute(page: ExtensionsRoute.page, path: 'extensions', ...),
          CustomRoute(page: SettingsRoute.page, path: 'settings', ...),
        ]),
        // Detail/push routes (outside tabs, overlaid on top)
        CustomRoute(page: MediaListRoute.page, path: 'userlist', ...),
        CustomRoute(page: AnimeDetailsRoute.page, path: 'animedetails', ...),
        CustomRoute(page: VideoRoute.page, path: 'video', ...),
      ],
    ),
  ];
}
```

### Route structure

The app has a **RootRoute** that contains:
1. **LoginRoute** — the initial/auth screen
2. **TabsRoute** — contains nested tab children (Home, Anime, Manga, Extensions, Settings)
3. **Detail routes** — pushed on top of the tab navigator (MediaList, AnimeDetails, MangaDetails, Video, Calendar, AdvancedSearch)

The nested structure means tab routes and detail routes are siblings under Root, creating a proper navigation stack.

### `replaceInRouteName: 'Screen|Page,Route'`

This tells AutoRoute to strip `Screen` or `Page` from class names and replace with `Route`. So `HomeScreen` becomes `HomeRoute`, `TabsScreen` becomes `TabsRoute`.

## Adding a New Route

### Example: Adding a "Studio Details" screen

**1. Create the screen widget** with `@RoutePage()` annotation:

```dart
// lib/presentation/screens/studio_details_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unyo/application/cubits/studio_details_cubit.dart';
import 'package:unyo/application/states/studio_details_state.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/services/effects/app_effect_handler.dart';

@RoutePage()
class StudioDetailsScreen extends StatelessWidget {
  const StudioDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StudioDetailsCubit>(),
      child: const _StudioDetailsListener(),
    );
  }
}

class _StudioDetailsListener extends StatelessWidget {
  const _StudioDetailsListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudioDetailsCubit, StudioDetailsState>(
      listener: (context, state) {
        if (state.effects.isNotEmpty) {
          sl<AppEffectHandler>().handleEffects(
            context,
            state.effects,
            context.read<StudioDetailsCubit>().clearEffects,
          );
        }
      },
      child: BlocBuilder<StudioDetailsCubit, StudioDetailsState>(
        builder: (context, state) {
          // Build UI here
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

**2. Add the route to AppRouter**:

```dart
// In app_router.dart, add as a child of RootRoute (sibling to TabsRoute)
CustomRoute(
  page: StudioDetailsRoute.page,
  path: 'studiodetails',
  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  duration: const Duration(milliseconds: 250),
  reverseDuration: const Duration(milliseconds: 250),
),
```

**3. Run code generation**:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the `StudioDetailsRoute` class in `app_router.gr.dart`.

**4. Navigate to it from a cubit**:

```dart
// In a cubit that has access to the StudioNotifier
void navigateToStudioDetails(Studio studio) {
  _studioNotifier.updateSelectedStudio(studio);
  pushRouteEffect(path: "/studiodetails");
}
```

## Route Transition Styles

The app uses different transitions for different route types:

| Route Type | Transition | Duration |
|---|---|---|
| Tab routes | `noTransition` | 0ms |
| Login/Tabs | `noTransition` | 0ms |
| MediaList | Slide up + Fade | 250ms |
| Calendar | `slideRightWithFade` | 250ms |
| Search screens | `slideLeftWithFade` | 250ms |
| Detail screens | Scale + Fade | 250ms |
| Video | Scale + Fade | 250ms |

Convention: **Tab navigation is instant** (no transition). **Push routes use 250ms transitions** for visual feedback.

### Custom transition example (Scale + Fade for detail screens):

```dart
CustomRoute(
  page: AnimeDetailsRoute.page,
  path: 'animedetails',
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.decelerate),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
          child: child,
        ),
      ),
  duration: const Duration(milliseconds: 250),
  reverseDuration: const Duration(milliseconds: 250),
),
```

## Navigation from Cubits

Cubits never hold `BuildContext` or call `AutoRouter` directly. Instead, they emit navigation effects:

```dart
// Push a route onto the stack
pushRouteEffect(path: "/animedetails");

// Replace the current route (e.g., after login, go to tabs)
replaceRouteEffect(path: "/tabs");

// Navigate to a path (within nested routers)
navigateRouteEffect(path: "/tabs");

// Switch tabs in AutoTabsRouter
changeRouteTabEffect(context, path: "/anime");

// Pop the current route
popRouteEffect(context);
```

The `AppEffectHandler` processes these effects on the UI side. See `unyo-bloc-state-management` skill for how effects work.

## Tab Navigation

The `TabsRoute` uses `AutoTabsRouter` in its screen widget to manage tab switching:

```dart
// In tabs_screen.dart
AutoTabsRouter(
  lazyLoad: true,
  routes: const [
    HomeRoute(),
    AnimeRoute(),
    MangaRoute(),
    ExtensionsRoute(),
    SettingsRoute(),
  ],
  builder: (context, child) {
    // The child is the currently active tab's content
    return Row(
      children: [
        SideMenuBar(...),
        Expanded(child: child),
      ],
    );
  },
)
```

Switching tabs from a cubit:

```dart
// In TabsCubit
void selectMenuOption(SelectedMenuOption option, BuildContext context) {
  emit(state.copyWith(selectedMenuOption: option));
  changeRouteTabEffect(context, path: _optionToPath(option));
}
```

The `EffectMixin` maps tab paths to indices:

```dart
static const Map<String, int> _routesIndexMapper = {
  "/home": 0,
  "/anime": 1,
  "/manga": 2,
  "/extensions": 3,
  "/settings": 4,
};
```

If you add a new tab, you must update this mapper.

## Passing Data Between Routes

Unyo does NOT use route parameters/arguments. Instead, it uses the **Notifier pattern** to pass data between screens:

1. Source cubit pushes data into a notifier (e.g., `_animeNotifier.updateSelectedAnime(anime)`)
2. Source cubit navigates via effect (e.g., `pushRouteEffect(path: "/animedetails")`)
3. Destination cubit subscribes to the notifier stream and reacts

This is intentional — it decouples routes from data types and avoids the complexity of typed route arguments in AutoRoute.

## Common Pitfalls

- **Forgetting `@RoutePage()`**: Every screen that AutoRoute should manage must have this annotation. Without it, code generation won't create the route page class.
- **Forgetting to run `build_runner`**: After adding or modifying routes, you MUST run `flutter pub run build_runner build --delete-conflicting-outputs`. The `.gr.dart` file is auto-generated.
- **Editing `.gr.dart` directly**: Never manually edit generated files. Changes will be overwritten.
- **Adding a tab route as a push route**: Tab routes must be children of the `TabsRoute` in the route tree, not siblings of it. If you add a tab route as a sibling of `TabsRoute`, it will navigate as a push route instead of a tab switch.
- **Using `AutoRouter.of(context).push()` in cubits**: Cubits should not access `BuildContext` for navigation. Use the Effect system instead.
- **Not updating `_routesIndexMapper`**: When adding a new tab, update the index mapper in `EffectMixin` or `changeRouteTabEffect` won't find the correct tab index.
- **Path mismatch**: The `path` in the route definition must match the path used in effects (e.g., `path: 'animedetails'` in router matches `pushRouteEffect(path: "/animedetails")` in cubit — note the leading `/` in effects).

## Cross-references

- **Effect system for navigation**: See `unyo-bloc-state-management` skill
- **Screen widget structure**: See `unyo-ui-presentation` skill for BlocProvider/BlocListener/BlocBuilder patterns
- **Notifier pattern for passing data**: See `unyo-reactive-notifiers` skill