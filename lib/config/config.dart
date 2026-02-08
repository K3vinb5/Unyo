// Application configuration
const String version = 'v1.0.0';
const String applicationSupportDirectory = "applicationSupportDirectory";
const String anilistGraphQlService = 'anilistGraphQlService';
const String loggedUserNotifier = 'loggedUserNotifier';
const String newUserNotifier = 'newUserNotifier';
// Anilist API configuration
const String anilistOAuthEndpoint = 'https://anilist.co/api/v2/oauth/token';
const String shutDownTorrentServer = 'http://127.0.0.1:8090/shutdown';
const String anilistAuthUrl =
    'https://anilist.co/api/v2/oauth/authorize?client_id=$anilistClientId&redirect_uri=$anilistRedirectUri&response_type=code';
const String anilistRedirectUri = 'http://localhost:9999/auth';
const String anilistClientId = '17550';
const String anilistClientSecret = 'xI8KTZlKm2F3kHXLko1ArQ21bKap4MojgDTk6Ukx';
const String anilistGraphQLEndpoint = 'https://graphql.anilist.co';
// Anizip API configuration
const String anizipBaseEndpoint = 'https://api.ani.zip';
// Aniski API configuration
const String aniskiBaseEndpoint = 'https://api.aniskip.com';
// Torrent API configuration
const String torrentServiceEndpoint = 'http://127.0.0.1:8090';
// Cache configuration
const Set<String> cacheDisabledEndpoints = <String>{
  anilistOAuthEndpoint,
  shutDownTorrentServer
};
const Set<String> cacheIgnoredHeaders = <String>{
  'Authorization'
};
// Extensions condiguration
const String aniyomiExtensionsRepositoryUrl = 'https://gitea.k3vinb5.dev/Backups/kohi-den-extensions/raw/branch/main/index.min.json';
const String tachiyomiExtensionsRepositoryUrl = 'https://gitea.k3vinb5.dev/Backups/keiyoushi-extensions/raw/branch/repo/index.min.json';
// TODO move to an asset
const plusImageUrl = "https://i.ibb.co/Kj8CQZH/cross.png";