import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:unyo/models/models.dart';

class DiscordRPC {
  late DateTime initTime;

  void initDiscordRPC() {
    FlutterDiscordRPC.instance.connect();
    initTime = DateTime.now();
  }

  void setPageActivity(String page) {
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
      AnimeModel animeModel, int episode, MediaContentModel mediaContentModel) {
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: mediaContentModel.imageUrls != null &&
                  mediaContentModel.imageUrls!.length > episode
              ? mediaContentModel.imageUrls![episode - 1]
              : animeModel.coverImage,
          largeText:
              "Watching ${animeModel.userPreferedTitle}, Episode $episode",
          smallImage: "https://i.imgur.com/tF7Hv84.png",
          smallText: "Unyo",
        ),
        state: mediaContentModel.titles != null &&
                mediaContentModel.titles!.length > episode
            ? "Episode $episode, ${mediaContentModel.titles![episode - 1]}"
            : "Watching ${animeModel.userPreferedTitle}",
        details: mediaContentModel.titles != null &&
                mediaContentModel.titles!.length > episode
            ? "Watching ${animeModel.userPreferedTitle}"
            : "Episode $episode",
        timestamps: RPCTimestamps(
          start: initTime.millisecondsSinceEpoch,
          end: null,
        ),
      ),
    );
  }

  void setReadingMangaActivity(MangaModel mangaModel, int chapter) {
    FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        assets: RPCAssets(
          largeImage: mangaModel.coverImage,
          largeText:
              "Reading ${mangaModel.userPreferedTitle}, Chapter $chapter",
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
