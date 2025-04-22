import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:unyo/models/models.dart';

class DiscordRPC {
  DateTime initTime = DateTime.now();
  bool discordConnected = false;

  void initDiscordRPC() async {
    try {
      await FlutterDiscordRPC.initialize('1266242749485809748');
      await FlutterDiscordRPC.instance.connect(autoRetry: false);
      discordConnected = FlutterDiscordRPC.instance.isConnected;
      if (discordConnected) {
        setPageActivity('Home Screen');
      } else {
        // print('Discord client not detected');
      }
      FlutterDiscordRPC.instance.isConnectedStream.listen((connected) {
        discordConnected = connected;
        // print('Discord connected: $connected');
        if (connected) {
          setPageActivity('Home Screen');
        }
      });
    } catch (e) {
      discordConnected = false;
      // print('Discord RPC init failed: $e');
    }
  }

  Future<void> setRPCActivity() async {
    if (!discordConnected) return;
    try {
    } catch (e) {
      // print('Failed to set Discord activity: $e');
    }
  }

  Future<void> cleanup() async {
    if (!discordConnected) return;
    try {
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();
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
      ),
    );
  }
}
