import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:unyo/ffi/torrent_server_ffi.dart' as libmtorrentserver_ffi;
import 'package:unyo/util/extensions/string_extensions.dart';

class MTorrentServer {
  // final http = MClient.init();

  //TODO probalby to remove the torrent file
  // Future<bool> removeTorrent(String? inforHash) async {
  //   if (inforHash == null || inforHash.isEmpty) return false;
  //   try {
  //     final res = await http
  //         .delete(Uri.parse("$_baseUrl/torrent/remove?infohash=$inforHash"));
  //     if (res.statusCode == 200) {
  //       return true;
  //     }
  //     return false;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  Future<bool> check() async {
    try {
      final res = await http.get(Uri.parse("$_baseUrl/"));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  //TODO To get .torrent infohash, used when it is not a magnet (not urgent, fix later)
  // Future<String> getInfohash(String url, bool isFilePath) async {
  //   try {
  //     final torrentByte = isFilePath
  //         ? File(url).readAsBytesSync()
  //         : (await http.get(Uri.parse(url))).bodyBytes;
  //     var request =
  //         http.post(Uri.parse('$_baseUrl/torrent/add'));
  //
  //     request.files.add(MultipartFile.fromBytes('file', torrentByte,
  //         filename: 'file.torrent'));
  //     final response = await http.send(request);
  //     return await response.stream.bytesToString();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<List<String?>> getTorrentPlaylist(
      String? url, String? archivePath) async {
    try {
      Directory supportDirectoryPath = await getApplicationSupportDirectory();
      if (await Directory(p.join(supportDirectoryPath.path, "torrent")).exists()) {
        Directory(p.join(supportDirectoryPath.path, "torrent")).deleteSync(recursive: true);
      }
      final isFilePath = archivePath?.isNotEmpty ?? false;
      final isRunning = await check();
      if (!isRunning) {
        final path =
            Directory(p.join(supportDirectoryPath.path, "torrent")).path;
        final config = jsonEncode({"path": path, "address": "127.0.0.1:8085"});
        int port = await Isolate.run(() async {
          return libmtorrentserver_ffi.start(config);
        });
        print("port: server is running $port");
        // _setBtServerPort(port);
      }
      url = isFilePath ? archivePath! : url!;
      //TODO when fixed infohash fix this
      // String finalUrl = "";
      // String? infohash;
      // bool isMagnet = url.startsWith("magnet:?");
      // if (!isMagnet) {
      // infohash = await getInfohash(url, isFilePath);
      // finalUrl = "$_baseUrl/torrent/play?infohash=$infohash";
      // } else {
      String finalUrl = "$_baseUrl/torrent/play?magnet=$url";
      // }

      final masterPlaylist = (await http.get(Uri.parse(finalUrl))).body;
      List<String?> urlList = [];
      const separator = "#EXTINF:";
      for (var e in masterPlaylist.substringAfter(separator).split(separator)) {
        final fileName = e.substringAfter("-1,").substringBefore("\n");
        if (fileName.isMediaVideo()) {
          var videoUrl = e.substringAfter("\n").substringBefore("\n");
          urlList.add(videoUrl);
          // videoList.add(Video(videoUrl, fileName, videoUrl));
        }
      }

      return urlList;
    } catch (e) {
      rethrow;
    }
  }
}

String get _baseUrl {
  // final port = settings!.btServerPort ?? 0;
  const port = 8085;
  // final address = settings.btServerAddress ?? "127.0.0.1";
  const address = "127.0.0.1";
  return "http://$address:$port";
}

// void _setBtServerPort(int newPort) {
//   isar.writeTxnSync(() => isar.settings
//       .putSync(isar.settings.getSync(227)!..btServerPort = newPort));
// }
