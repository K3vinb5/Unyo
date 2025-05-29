import 'dart:async';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/utils.dart';

class DiscordRPC {
  static const _appId = '1266242749485809748';
  bool _initialized = false;
  DateTime initTime = DateTime.now();
  bool discordConnected = false;
  StreamSubscription<bool>? _connSub;

  /// Initialize Discord RPC once
  Future<void> initDiscordRPC({bool autoRetry = false}) async {
    try {
      // only call initialize() once per process
      if (!_initialized) {
        await FlutterDiscordRPC.initialize(_appId);
        _initialized = true;
      }

      // if we're already connected just update the activity
      if (discordConnected && FlutterDiscordRPC.instance.isConnected) {
        setPageActivity('Home Screen');
        return;
      }

      // otherwise, connect and then set the initial activity
      await FlutterDiscordRPC.instance.connect(autoRetry: autoRetry);
      discordConnected = FlutterDiscordRPC.instance.isConnected;

      logger.i('Discord RPC connected: $discordConnected');

      if (discordConnected) {
        setPageActivity('Home Screen');
      } else {
        logger.i('Discord RPC not connected');
      }

      // listen for reconnects (e.g. if the user restarts Discord)
        _connSub = FlutterDiscordRPC.instance.isConnectedStream.listen((connected) {
          discordConnected = connected;
          logger.i('Discord RPC connection status: $connected');
          if (connected) setPageActivity('Home Screen');
        });
    } catch (e) {
      logger.e('Discord RPC initialization failed: $e');
    }
  }

  Future<void> cleanup() async {
    await _connSub?.cancel();
    _connSub = null;
    if (!discordConnected) return;
    try {
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
    } catch (_) {}
    discordConnected = false;
  }

  void setPageActivity(String page) {
    if (!discordConnected) return;
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: "https://i.imgur.com/fUX8AXq.png",
          largeText: "Navigating $page",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        details: "Navigating $page",
        state: "https://github.com/K3vinb5/Unyo",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
        buttons: [
          const RPCButton(
            label: "GitHub Repository",
            url: "https://github.com/K3vinb5/Unyo",
          ),
          const RPCButton(
            label: "Download App",
            url: "https://github.com/K3vinb5/Unyo/releases",
          ),
        ],
      ),
    );
  }

  void setNavigatingAnimeActivity(AnimeModel animeModel) {
    if (!discordConnected) return;
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: animeModel.coverImage,
          largeText: "Navigating ${animeModel.userPreferedTitle}",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        details: "Navigating ${animeModel.userPreferedTitle}",
        state: "https://github.com/K3vinb5/Unyo",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
        buttons: [
          const RPCButton(
            label: "GitHub Repository",
            url: "https://github.com/K3vinb5/Unyo",
          ),
          const RPCButton(
            label: "Download App",
            url: "https://github.com/K3vinb5/Unyo/releases",
          ),
        ],
      ),
    );
  }

  void setNavigatingMangaActivity(MangaModel mangaModel) {
    if (!discordConnected) return;
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: mangaModel.coverImage,
          largeText: "Navigating ${mangaModel.userPreferedTitle}",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        details: "Navigating ${mangaModel.userPreferedTitle}",
        state: "https://github.com/K3vinb5/Unyo",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
        buttons: [
          const RPCButton(
            label: "GitHub Repository",
            url: "https://github.com/K3vinb5/Unyo",
          ),
          const RPCButton(
            label: "Download App",
            url: "https://github.com/K3vinb5/Unyo/releases",
          ),
        ],
      ),
    );
  }

  void setWatchingAnimeActivity(
    AnimeModel animeModel,
    int episode,
    MediaContentModel mediaContentModel,
  ) {
    if (!discordConnected) return;
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: mediaContentModel.imageUrls != null &&
                  mediaContentModel.imageUrls!.length >= episode
              ? mediaContentModel.imageUrls![episode - 1]
              : animeModel.coverImage,
          largeText: "Watching ${animeModel.userPreferedTitle}, Episode $episode",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        state: mediaContentModel.titles != null &&
                mediaContentModel.titles!.length >= episode
            ? "Episode $episode, ${mediaContentModel.titles![episode - 1]}"
            : "Watching ${animeModel.userPreferedTitle}",
        details: "Watching ${animeModel.userPreferedTitle}",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
        buttons: [
          const RPCButton(
            label: "GitHub Repository",
            url: "https://github.com/K3vinb5/Unyo",
          ),
          const RPCButton(
            label: "Download App",
            url: "https://github.com/K3vinb5/Unyo/releases",
          ),
        ],
      ),
    );
  }

  void setReadingMangaActivity(MangaModel mangaModel, int chapter) {
    if (!discordConnected) return;
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: mangaModel.coverImage,
          largeText: "Reading ${mangaModel.userPreferedTitle}, Chapter $chapter",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        details: "Reading ${mangaModel.userPreferedTitle}",
        state: "Chapter $chapter",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
        buttons: [
          const RPCButton(
            label: "GitHub Repository",
            url: "https://github.com/K3vinb5/Unyo",
          ),
          const RPCButton(
            label: "Download App",
            url: "https://github.com/K3vinb5/Unyo/releases",
          ),
        ],
      ),
    );
  }
}
