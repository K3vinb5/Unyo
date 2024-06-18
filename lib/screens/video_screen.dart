import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';
import 'package:unyo/widgets/widgets.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.stream,
    required this.updateEntry,
    this.captions,
    this.referer,
    required this.title,
  });

  final String stream;
  final String? captions;
  final String? referer;
  final void Function() updateEntry;
  final String title;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool paused = false;
  bool delayedPaused = false;
  String? captions;

  bool soundIsHovered = false;
  Timer soundIsHoveredTimer = Timer(
    Duration.zero,
    () {},
  );

  final FocusNode _screenFocusNode = FocusNode();
  bool keyDelay = false;

  late MqttServerClient client;
  late String topic;
  late String myId;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.stream),
      httpHeaders: widget.referer != null ? {"Referer": widget.referer!} : {},
      closedCaptionFile:
          widget.captions != null ? loadCaptions(widget.captions!) : null,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    // temp();
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
    setClientMqttConnection(false);
  }

  void temp() async {
    await Future.delayed(const Duration(seconds: 10));
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
    setClientMqttConnection(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void connectToPeer(String receivedTopic) {
    client.unsubscribe(topic);
    connected = false;
    topic = "${sha256.convert(utf8.encode(widget.title)).toString().substring(0,10)}-$receivedTopic";
    setClientMqttConnection(true);
  }

  void setClientMqttConnection(bool connection) async {
    client = MqttServerClient('ws://kevin-is-awesome.mooo.com', '',
        maxConnectionAttempts: 10);

    client.useWebSocket = true;
    client.port = 9001;
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    client.setProtocolV311();
    client.keepAlivePeriod = 1800;
    client.logging(on: false);

    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    if (!connection) {
      topic = "${sha256.convert(utf8.encode(widget.title)).toString().substring(0,10)}-${generateRandomId()}";
      myId = generateRandomId();
    }

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
      //TODO dialog
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
      //TODO dialog
    }

    /// Check we are connected
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      connected = false;
      print(
          'Client connection failed - disconnecting... status is ${client.connectionStatus}');
      client.disconnect();
      //TODO dialog
      return;
    } else if (connection) {
      connected = true;
    }

    client.subscribe(topic, MqttQos.exactlyOnce); //qos 2

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final messageStringAndId =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message)
              .split("-");
      if (messageStringAndId[0] == myId) {
        return;
      }
      final messageString = messageStringAndId[1];
      print("Received: $messageString");

      if (messageString.contains("seekTo")) {
        print("Message: ${messageString.split(":")[1]}");
        double value = double.parse(messageString.split(":")[1]);
        _controller.seekTo(Duration(microseconds: (value * 1000).toInt()));
      }

      switch (messageString) {
        case "pause":
          _controller.pause();
          break;
        case "play":
          _controller.play();
          break;
        case "fifteenplus":
          _controller.seekTo(
            Duration(
                milliseconds:
                    _controller.value.position.inMilliseconds + 15000),
          );
          break;
        case "fifteenminus":
          _controller.seekTo(
            Duration(
                milliseconds:
                    _controller.value.position.inMilliseconds - 15000),
          );
          break;
        case "fiveplus":
          _controller.seekTo(
            Duration(
                milliseconds: _controller.value.position.inMilliseconds + 5000),
          );
          break;
        case "fiveminus":
          _controller.seekTo(
            Duration(
                milliseconds: _controller.value.position.inMilliseconds - 5000),
          );
          break;
        case "confirmed":
          _controller.seekTo(const Duration(milliseconds: 0));
          _controller.pause();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Connection Successful",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 37, 37, 37),
                          ),
                          foregroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          break;
        case "escape":
          WindowManager.instance.setFullScreen(false);
          _controller.dispose();
          interactScreen(false);
          print(calculatePercentage());
          if (calculatePercentage() > 0.8) {
            widget.updateEntry();
          }
          Navigator.pop(context);
          client.disconnect();
          break;
        case "connected":
          sendConfirmOrder();
          _controller.seekTo(const Duration(milliseconds: 0));
          _controller.pause();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Connection Successful",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 37, 37, 37),
                          ),
                          foregroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          break;
      }
    });

    if (connection) {
      sendConnectedOrder();
    }
  }

  String generateRandomId() {
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final idLength = 10; // You can adjust the length of the ID as needed
    return String.fromCharCodes(
      List.generate(
        idLength,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  //TODO temp
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('Client disconnected succesfully');
    }
  }

  /// The successful connect callback
  void onConnected() {
    print('Client connection was sucessful');
  }

  void sendPauseVideoOrder() {
    print("$connected pause");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-pause");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendPlayVideoOrder() {
    print("$connected play");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-play");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendFifteenPosOrder() {
    print("$connected fifteenplus");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-fifteenplus");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendFifteenMinOrder() {
    print("$connected fifteenminus");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-fifteenminus");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendFivePosOrder() {
    print("$connected fiveplus");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-fiveplus");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendFiveMinOrder() {
    print("$connected fiveminus");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-fiveminus");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendSeekToOrder(double time) {
    print("$connected seekTo");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-seekTo:$time");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendConfirmOrder() {
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-confirmed");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendEscapeOrder() {
    print("$connected escape");
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-escape");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void sendConnectedOrder() {
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-connected");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  String replaceSecond(String original, String pattern, String replacement) {
    int firstIndex = original.indexOf(pattern);
    if (firstIndex != -1) {
      int secondIndex = original.indexOf(pattern, firstIndex + 1);
      if (secondIndex != -1) {
        return original.replaceFirst(pattern, replacement, secondIndex);
      }
    }
    return original;
  }

  void controlsOverlayOnTap() {
    _hideControlsTimer?.cancel();
    paused = !paused;
    Timer(const Duration(milliseconds: 300),
        () => delayedPaused = !delayedPaused);
    if (paused) {
      _showControls = true;
    } else {
      _resetHideControlsTimer();
    }
  }

  void onEnterSound() {
    setState(() {
      soundIsHovered = true;
    });
  }

  void onExitSound() {
    soundIsHoveredTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        setState(() {
          soundIsHovered = false;
        });
      },
    );
  }

  void interactScreen(bool keepOn) async {
    await DesktopKeepScreenOn.setPreventSleep(keepOn);
  }

  String formatCaptions(String captions) {
    // Split the captions into pieces based on empty lines
    List<String> pieces = captions.split('\n\n');
    List<String> formattedPieces = [];
    for (int i = 0; i < pieces.length; i++) {
      formattedPieces.add(replaceSecond(pieces[i], "\n", " "));
    }
    // Join the formatted pieces back together with empty lines
    String formattedCaptions = formattedPieces.join('\n\n');

    return formattedCaptions;
  }

  Future<ClosedCaptionFile> loadCaptions(String url) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String content = String.fromCharCodes(bytes);
      return WebVTTCaptionFile(formatCaptions(content));
    } catch (error) {
      print("Error downloading captions");
    }
    print("Empty");
    return WebVTTCaptionFile("");
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _showControls = true;
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      setState(() {
        if (!paused) {
          _showControls = false;
        }
      });
    });
  }

  double calculatePercentage() {
    return (_controller.value.position.inMilliseconds /
        _controller.value.duration.inMilliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: KeyboardListener(
        focusNode: _screenFocusNode,
        onKeyEvent: (keyEnvent) {
          if (keyDelay) {
            return;
          }
          keyDelay = true;
          Timer(
            const Duration(milliseconds: 200),
            () {
              keyDelay = false;
            },
          );
          //print("Logical: ${keyEnvent.logicalKey}");
          switch (keyEnvent.logicalKey) {
            case LogicalKeyboardKey.space:
              if (!_controller.value.isPlaying) {
                controlsOverlayOnTap();
                sendPlayVideoOrder();
                _controller.play();
              } else {
                controlsOverlayOnTap();
                sendPauseVideoOrder();
                _controller.pause();
              }
              break;
            case LogicalKeyboardKey.arrowLeft:
              sendFiveMinOrder();
              _controller.seekTo(
                Duration(
                    milliseconds:
                        _controller.value.position.inMilliseconds - 5000),
              );

              break;
            case LogicalKeyboardKey.arrowRight:
              sendFivePosOrder();
              _controller.seekTo(
                Duration(
                    milliseconds:
                        _controller.value.position.inMilliseconds + 5000),
              );
              break;
            case LogicalKeyboardKey.arrowUp:
              _controller.setVolume(min(_controller.value.volume + 0.1, 1));
              break;
            case LogicalKeyboardKey.arrowDown:
              _controller.setVolume(max(_controller.value.volume - 0.1, 0));
              break;
            case LogicalKeyboardKey.keyL:
              sendFifteenPosOrder();
              _controller.seekTo(
                Duration(
                    milliseconds:
                        _controller.value.position.inMilliseconds + 15000),
              );
              _resetHideControlsTimer();
              break;
            case LogicalKeyboardKey.keyJ:
              //sendFifteenMinOrder();
              _controller.seekTo(
                Duration(
                    milliseconds:
                        _controller.value.position.inMilliseconds - 15000),
              );
              _resetHideControlsTimer();
              break;
            case LogicalKeyboardKey.keyK:
              _resetHideControlsTimer();
              if (!_controller.value.isPlaying) {
                controlsOverlayOnTap();
                sendPlayVideoOrder();
                _controller.play();
              } else {
                controlsOverlayOnTap();
                sendPauseVideoOrder();
                _controller.pause();
              }
              break;
            case LogicalKeyboardKey.escape:
              sendEscapeOrder();
              WindowManager.instance.setFullScreen(false);
              _controller.dispose();
              interactScreen(false);
              print(calculatePercentage());
              if (calculatePercentage() > 0.8) {
                widget.updateEntry();
              }
              client.disconnect();
              Navigator.pop(context);
              break;
            default:
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              MouseRegion(
                onHover: (event) {
                  _resetHideControlsTimer();
                },
                cursor: _showControls
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.none,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(_controller),
                    ),
                    ClosedCaption(
                      text: _controller.value.caption.text,
                    ),
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ControlsOverlay(
                            controller: _controller,
                            paused: paused,
                            delayedPaused: delayedPaused,
                            onTap: controlsOverlayOnTap,
                            pausePeer: sendPauseVideoOrder,
                            playPeer: sendPlayVideoOrder,
                            peerPlus: sendFifteenPosOrder,
                            peerMinus: sendFifteenMinOrder,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width - 140,
                                bottom: 35),
                            child: SizedBox(
                              height: 100,
                              child: AnimatedOpacity(
                                opacity: soundIsHovered ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: MouseRegion(
                                  onEnter: (_) {
                                    soundIsHoveredTimer.cancel();
                                    soundIsHovered = true;
                                  },
                                  onExit: (_) {
                                    soundIsHoveredTimer = Timer(
                                      const Duration(milliseconds: 500),
                                      () {
                                        setState(() {
                                          soundIsHovered = false;
                                        });
                                      },
                                    );
                                  },
                                  child: Visibility(
                                    visible: soundIsHovered,
                                    maintainSize: false,
                                    maintainState: true,
                                    maintainAnimation: true,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Slider(
                                        activeColor: Colors.white,
                                        min: 0,
                                        max: 1,
                                        value: _controller.value.volume,
                                        onChanged: (value) =>
                                            _controller.setVolume(value),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SmoothVideoProgress(
                            controller: _controller,
                            builder: (context, progress, duration, child) {
                              return VideoProgressSlider(
                                controller: _controller,
                                height: 40,
                                switchFullScreen: () {
                                  setState(
                                    () {
                                      fullScreen = !fullScreen;
                                    },
                                  );
                                },
                                position: progress,
                                duration: duration,
                                swatch: Colors.red,
                                onEnter: onEnterSound,
                                onExit: onExitSound,
                                connectToPeer: connectToPeer,
                                seekToPeer: sendSeekToOrder,
                                topic: topic,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (!fullScreen) {
                            sendEscapeOrder();
                            _controller.dispose();
                            interactScreen(false);
                            print(calculatePercentage());
                            if (calculatePercentage() > 0.8) {
                              widget.updateEntry();
                            }
                            client.disconnect();
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0, top: 2.0),
                      child: Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15)),
                    ),
                  )
                ],
              ),
              !fullScreen
                  ? WindowTitleBarBox(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          Expanded(
                            child: MoveWindow(),
                          ),
                          const WindowButtons(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
