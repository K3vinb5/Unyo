import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';

class CastPopupMenuButton extends StatelessWidget {
  const CastPopupMenuButton(
      {super.key, required this.title, required this.url});

  final String title;
  final String url;

  Future<void> _connectAndPlayMedia(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager()
        .startSession(object, const Duration(seconds: 10));

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        AnimatedSnackBar.material(
          "Connected! :D",
          type: AnimatedSnackBarType.success,
          desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
        ).show(context);
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      print(message);
      index += 1;

      // print('receive message: $message')CC1AD845;

      if (index == 2) {
        Future.delayed(const Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    Map<String, String> contentTypeAndStreamType =
        getContentTypeAndStreamType(url);
    print(contentTypeAndStreamType);
    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': url,
      'contentType': /*'video/mp4'*/ contentTypeAndStreamType['contentType'],
      'streamType': /*'BUFFERED'*/
          contentTypeAndStreamType['streamType'],
      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': /*"Big Buck Bunny"*/ title,
        'images': [
          {
            'url': "https://i.imgur.com/tF7Hv84.png"
          }
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }

  Map<String, String> getContentTypeAndStreamType(String url) {
    // Extract the file extension from the URL
    String extension = url.split('.').last.toLowerCase();

    // Default contentType and streamType
    String contentType = 'video/mp4'; // Default to MP4
    String streamType = 'BUFFERED'; // Default to buffered

    // Determine contentType and streamType based on file extension
    switch (extension) {
      // Video Formats
      case 'mp4':
        contentType = 'video/mp4';
        streamType = 'BUFFERED';
        break;
      case 'webm':
        contentType = 'video/webm';
        streamType = 'BUFFERED';
        break;
      case 'mkv':
        contentType = 'video/x-matroska';
        streamType = 'BUFFERED';
        break;
      case 'avi':
        contentType = 'video/avi';
        streamType = 'BUFFERED';
        break;
      case 'mov':
        contentType = 'video/quicktime';
        streamType = 'BUFFERED';
        break;

      // Audio Formats
      case 'mp3':
        contentType = 'audio/mpeg';
        streamType = 'BUFFERED';
        break;
      case 'aac':
        contentType = 'audio/aac';
        streamType = 'BUFFERED';
        break;
      case 'wav':
        contentType = 'audio/wav';
        streamType = 'BUFFERED';
        break;
      case 'flac':
        contentType = 'audio/flac';
        streamType = 'BUFFERED';
        break;
      case 'ogg':
        contentType = 'audio/ogg';
        streamType = 'BUFFERED';
        break;

      // Image Formats
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        streamType = 'BUFFERED';
        break;
      case 'png':
        contentType = 'image/png';
        streamType = 'BUFFERED';
        break;
      case 'gif':
        contentType = 'image/gif';
        streamType = 'BUFFERED';
        break;
      case 'bmp':
        contentType = 'image/bmp';
        streamType = 'BUFFERED';
        break;
      case 'webp':
        contentType = 'image/webp';
        streamType = 'BUFFERED';
        break;

      // Streaming Formats
      case 'm3u8':
        contentType = 'application/x-mpegURL';
        streamType = 'LIVE'; // HLS typically uses LIVE streams
        break;
      case 'mpd':
        contentType = 'application/dash+xml';
        streamType = 'LIVE'; // DASH can be live or buffered
        break;
      case 'm4s':
        contentType = 'video/iso.segment';
        streamType = 'BUFFERED';
        break;

      // Additional Formats
      case 'm3u':
        contentType = 'audio/x-mpegurl';
        streamType = 'LIVE';
        break;
      case 'ts':
        contentType = 'video/mp2t';
        streamType = 'LIVE';
        break;

      default:
        // Default to MP4 if extension is unknown
        contentType = 'video/mp4';
        streamType = 'BUFFERED';
        break;
    }

    return {
      'contentType': contentType,
      'streamType': streamType,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: devices,
      builder: (context, snapshot) {
        return PopupMenuButton<CastDevice>(
          tooltip: "Cast to Tv",
          color: const Color.fromARGB(255, 34, 33, 34),
          icon: const Icon(
            Icons.cast,
            color: Colors.white,
          ),
          onSelected: (device) async {
            _connectAndPlayMedia(context, device);
          },
          itemBuilder: (context) {
            return snapshot.hasError || !snapshot.hasData
                ? []
                : snapshot.data!
                    .map((device) => PopupMenuItem<CastDevice>(
                          value: device,
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              device.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ))
                    .toList();
          },
        );
      },
    );
  }
}
