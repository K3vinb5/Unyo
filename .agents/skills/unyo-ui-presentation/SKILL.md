---
name: unyo-ui-presentation
description: How to build screens, widgets, and handle effects in the Unyo Flutter app's presentation layer. Use this skill whenever creating new screens, adding BlocProvider/BlocListener/BlocBuilder patterns, building custom styled widgets, handling side effects from cubits in the UI, creating dialogs or drawers, or organizing UI code. Also use when understanding the screen widget structure pattern or troubleshooting UI rendering issues.
---

# Unyo UI & Presentation Layer

The presentation layer in Unyo follows a consistent pattern: each screen is a three-layer widget tree that separates concerns of creation, effect handling, and UI building. This skill covers the structure, conventions, and patterns for building UI in Unyo.

## Architecture Overview

```
lib/presentation/
├── screens/           # Full-page route screens (@RoutePage annotated)
│   ├── home_screen.dart
│   ├── anime_screen.dart
│   ├── anime_details_screen.dart
│   ├── video_screen.dart
│   ├── settings_screen.dart
│   └── ...
├── widgets/
│   ├── styled/        # Reusable styled UI components
│   │   ├── unyo_menu_bar.dart
│   │   ├── media_card.dart
│   │   ├── unyo_textfield.dart
│   │   └── ...
│   └── text/          # Typography components
│       ├── text_display_small.dart
│       ├── text_body_medium.dart
│       └── ...
├── dialogs/           # Modal dialogs
│   ├── warning_dialog.dart
│   ├── textfield_dialog.dart
│   └── anime_details_media_entry_dialog.dart
├── drawers/           # Slide-in drawer dialogs
│   ├── user_options_drawer.dart
│   ├── anime_server_selection_drawer.dart
│   └── episode_list_drawer.dart
└── views/             # Loading/error state views
    └── loading_view.dart
```

## The Three-Layer Screen Pattern

Every screen in Unyo follows the same three-widget structure:

```
Screen (outer) → Listener (middle) → View (inner)
```

### Layer 1: Screen — Creates the BlocProvider

```dart
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const _HomeListener(),
    );
  }
}
```

This is the entry point. It:
- Has the `@RoutePage()` annotation for AutoRoute code generation
- Creates a new cubit instance via `sl<HomeCubit>()` (factory, so each screen gets its own)
- Is a `StatelessWidget` (never holds state)
- Does nothing else — no logic, no UI rendering

### Layer 2: Listener — Handles Effects

```dart
class _HomeListener extends StatelessWidget {
  const _HomeListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.effects.isNotEmpty) {
          sl<AppEffectHandler>().handleEffects(
            context,
            state.effects,
            context.read<HomeCubit>().clearEffects,
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => state.isLoading
            ? const LoadingView()
            : const _HomeView(),
      ),
    );
  }
}
```

This layer:
- Wraps content in `BlocListener` to process effects
- The `listener` callback fires on every state change — when effects are present, it delegates to `AppEffectHandler`
- After processing, it calls `cubit.clearEffects()` to remove the processed effects
- Can conditionally render different views (e.g., `LoadingView` when `isLoading`)
- Is typically a `StatelessWidget` unless it needs `ScrollController` lifecycle management

### Layer 3: View — Renders the UI

```dart
class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ScrollController continueWatchingController = ScrollController();
  final ScrollController continueReadingController = ScrollController();

  @override
  void dispose() {
    continueWatchingController.dispose();
    continueReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 15.0.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // UI using state properties
                AnimeCardList(
                  listTitle: "Continue Watching",
                  animeList: state.continueWatching,
                  controller: continueWatchingController,
                  onPressed: context.read<HomeCubit>().navigateToAnimeDetails,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

This layer:
- Is where all the visual rendering happens
- Uses `BlocBuilder` to rebuild when state changes
- Can be `StatefulWidget` (if it needs controllers) or `StatelessWidget`
- Accesses cubit methods via `context.read<HomeCubit>()`
- Reads state properties directly (e.g., `state.continueWatching`, `state.isLoading`)

## Effect Handling in Detail

The `AppEffectHandler` is a singleton that processes effects emitted by cubits:

```dart
// In every screen's BlocListener
if (state.effects.isNotEmpty) {
  sl<AppEffectHandler>().handleEffects(
    context,                           // BuildContext for navigation/dialogs
    state.effects,                      // List of effects from state
    context.read<HomeCubit>().clearEffects,  // Callback to clear effects
  );
}
```

The handler processes each effect type:

| Effect Type | Action |
|---|---|
| `PushRouteEffect` | `AutoRouter.of(context).pushPath(path)` |
| `ReplaceRouteEffect` | `AutoRouter.of(context).replacePath(path)` |
| `NavigateRouteEffect` | `AutoRouter.of(context).navigatePath(path)` |
| `ChangeTabRouteEffect` | `AutoTabsRouter.of(context).setActiveIndex(index)` |
| `ShowSnackbarEffect` | Material banner with `AwesomeSnackbarContent` |
| `ShowWidgetDialogEffect` | `showDialog(context: context, builder: ...)` |
| `ShowDrawerDialogEffect` | `showGeneralDialog` with slide transition |
| `CloseDialogEffect` | `Navigator.pop(context)` |

**Important**: `clearEffects()` must always be called after processing. The `handleEffects` method calls it automatically as the third parameter.

## AppEffectHandler Details

The `AppEffectHandler` also has an `attachRootContext()` method that's used in the tabs screen for tab switching:

```dart
// In tabs_screen.dart
sl<AppEffectHandler>().attachRootContext(context);
```

This stores a reference to the root `BuildContext` for tab navigation, which operates outside the scope of an individual screen's BlocListener. Most effects don't need this — they use the context passed from the BlocListener.

## Screen Types in Unyo

### Tab screens (inside AutoTabsRouter)

These screens live inside `AutoTabsRouter` and have a sidebar menu:

```dart
// Tab screens follow the standard 3-layer pattern
// They access TabsCubit for menu state and tab switching
```

### Push screens (detail views)

These screens are pushed on top of the tab navigator:

- AnimeDetails, MangaDetails, Video, Calendar, AdvancedSearch, MediaList
- They use more elaborate transitions (scale+fade, slide+fade)
- They receive data via notifiers (not route arguments)

### Login screen

The login screen is special — it's the `initial: true` route and replaces itself with `TabsRoute` on success.

## Widget Conventions

### Styled widgets (`widgets/styled/`)

Reusable UI components follow a naming convention:
- `Unyo` prefix for custom components: `UnyoMenuBar`, `UnyoTextField`, `UnyoSlider`
- Domain-specific names: `MediaCard`, `AnimeCardList`, `ImageCard`
- Each widget is in its own file

### Typography (`widgets/text/`)

Text widgets are thin wrappers around Flutter's `Text` widget with consistent styling:
- `TextDisplaySmall`, `TextDisplayMedium`, `TextDisplayLarge`
- `TextHeadlineSmall`, `TextHeadlineMedium`, `TextHeadlineLarge`
- `TextTitleSmall`, `TextTitleMedium`, `TextTitleLarge`
- `TextBodySmall`, `TextBodyMedium`, `TextBodyLarge`
- `TextLabelSmall`, `TextLabelMedium`, `TextLabelLarge`

These correspond to Material Design 3 type scale.

### Responsive sizing

The app uses `flutter_screenutil` for responsive sizing:
- `.w` for width-based sizing: `SizedBox(width: 15.0.w)`
- `.h` for height-based sizing: `SizedBox(height: 50.0.h)`
- `.sp` for font sizing: `TextStyle(fontSize: 14.0.sp)`
- `.r` for border radius: `BorderRadius.circular(8.0.r)`

Design base size is 1280x720 (set in `main.dart`).

### Barrel exports

Styled widgets and text components export through barrel files:
- `lib/presentation/widgets/styled/styled.dart`
- `lib/presentation/widgets/text/texts.dart`

## Dialogs

Dialogs are shown via the Effect system:

```dart
// In a cubit
showWidgetDialogEffect(
  dialog: WarningDialog(
    title: "Delete?",
    message: "This action cannot be undone.",
    onConfirm: () => _deleteItem(),
  ),
);
```

Custom dialogs should be created in `lib/presentation/dialogs/` and can accept callbacks for actions.

## Drawers

Drawer dialogs slide in from a specified direction:

```dart
// In a cubit
showDrawerDialogEffect(
  drawerDialog: AnimeServerSelectionDrawer(anime: anime),
  backgroundColor: Colors.black54,
  startPosition: AxisDirection.right,
);
```

Drawers are in `lib/presentation/drawers/` and use `showGeneralDialog` with slide transitions.

## Creating a New Screen: Complete Workflow

1. **Create the screen file** at `lib/presentation/screens/<feature>_screen.dart`:
   - Follow the three-layer pattern (Screen → Listener → View)
   - Add `@RoutePage()` annotation to the outer widget
   - Use `BlocProvider(create: (context) => sl<FeatureCubit>())` in the Screen layer
   - Handle effects in the Listener layer
   - Build UI in the View layer

2. **Add the route** in `lib/core/router/app_router.dart` — see `unyo-routing-navigation` skill

3. **Register the cubit** in `lib/core/di/locator.dart` — see `unyo-dependency-injection` skill

4. **Run code generation**:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Import the cubit and state** in the screen file

## Common Pitfalls

- **Putting logic in the Screen layer**: The Screen widget should only create the BlocProvider. No `initState`, no state holders, no business logic.
- **Forgetting BlocListener for effects**: If you skip the Listener layer, effects from the cubit won't be processed. No navigation, no snackbars, no dialogs.
- **Not calling clearEffects**: Always pass `cubit.clearEffects` as the third argument to `handleEffects()`. Without this, effects fire on every rebuild.
- **Using `context.watch<>()` instead of `context.read<>()`**: In callbacks and event handlers, use `read` (no rebuild). In `build` methods, the `BlocBuilder` handles rebuilds.
- **Creating ScrollControllers in StatelessWidget**: If a screen needs `ScrollController` or `TextEditingController`, the View must be a `StatefulWidget` with proper `dispose()` cleanup.
- **Importing cubit logic in View**: The View should read state and call cubit methods. It should never contain business logic — delegate to the cubit.
- **Using `BlocBuilder` where `BlocListener` is needed**: `BlocBuilder` is for UI that changes based on state. `BlocListener` is for one-time actions (effects, navigation). Use both when you need both — wrap BlocListener outside BlocBuilder.

## Cross-references

- **Cubit and Effect pattern**: See `unyo-bloc-state-management` skill for how cubits emit effects
- **Routing and navigation**: See `unyo-routing-navigation` skill for route configuration
- **Notifier pattern for cross-screen data**: See `unyo-reactive-notifiers` skill
- **DI for screen cubits**: See `unyo-dependency-injection` skill