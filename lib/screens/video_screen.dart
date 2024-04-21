import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:peerdart/peerdart.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';
import 'package:unyo/widgets/widgets.dart';

bool fullScreen = false;

class VideoScreen extends StatefulWidget {
  const VideoScreen(
      {super.key,
      required this.stream,
      required this.updateEntry,
      this.captions,
      required this.title,
      });

  final String stream;
  final String? captions;
  final void Function() updateEntry;
  final String title;

  @override
  _VideoScreenState createState() => _VideoScreenState();
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

  late Peer peer;
  late DataConnection conn;
  bool peerConnected = false;
  String? peerId;
  String? myPeerId;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.stream),
      closedCaptionFile:
          widget.captions != null ? loadCaptions(widget.captions!) : null,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    _resetHideControlsTimer();
    interactScreen(true);
    _screenFocusNode.requestFocus();
    setClientPeerConnection();
    /*Timer(const Duration(milliseconds: 200), () {
      int attempts = 0;
      setClientPeerConnection();
      sleep(const Duration(milliseconds: 1500));
      if (myPeerId == null && attempts < 10) {
        attempts++;
        print("Error $attempts");
        setClientPeerConnection();
        return;
      }
    });*/
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void connectToPeer(String receivedPeerId) {
    peerId = receivedPeerId;
    try {
      conn = peer.connect(peerId!);
    } catch (e) {
      print(e);
    }
    peerConnected = true;

    conn.on("open").listen((event) {
      setState(() {
        peerConnected = true;
      });
    });
    conn.on("close").listen((event) {
      setState(() {
        peerConnected = false;
      });
    });

    conn.on("data").listen((data) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
    });

    conn.on("open").listen((_) {
      conn.send({"connected": myPeerId});
    });
  }

  void setClientPeerConnection() {
    peer = Peer(
        /*options: PeerOptions(
        host: "kevin-is-awesome.mooo.com",
        path: "/unyo/",
        key: "unyo",
        //port: 9000,
        secure: true,
      ),*/
        );

    peer.on("open").listen((id) {
      setState(() {
        myPeerId = peer.id;
      });
      print("My Peer Id: $myPeerId");
    });

    peer.on("close").listen((id) {
      setState(() {
        peerConnected = false;
      });
    });

    peer.on<DataConnection>("connection").listen((event) {
      conn = event;

      conn.on("data").listen((data) {
        print("received: $data");

        if (data is Map<String, dynamic>) {
          if (data.containsKey("seekTo")) {
            _controller.seekTo(Duration(milliseconds: data["seekTo"]!.toInt()));
            /*if (!_controller.value.isPlaying) {
              _controller.play();
            }*/
          }

          if (data.containsKey("connected")) {
            peerConnected = true;
            sendConfirmOrder(data["connected"]);
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
          }
        }
        switch (data) {
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
                  milliseconds:
                      _controller.value.position.inMilliseconds + 5000),
            );
            break;
          case "fiveminus":
            _controller.seekTo(
              Duration(
                  milliseconds:
                      _controller.value.position.inMilliseconds - 5000),
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
            peer.disconnect();
            break;
        }
      });

      conn.on("close").listen((event) {
        setState(() {
          peerConnected = false;
        });
      });

      peerConnected = true;
    });
  }

  void sendPauseVideoOrder() {
    print("$peerConnected pause");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("pause");
      });
    }
  }

  void sendPlayVideoOrder() {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("play");
      });
    }
  }

  void sendFifteenPosOrder() {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("fifteenplus");
      });
    }
  }

  void sendFifteenMinOrder() {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("fifteenminus");
      });
    }
  }

  void sendFivePosOrder() {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("fiveplus");
      });
    }
  }

  void sendFiveMinOrder() {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("fiveminus");
      });
    }
  }

  void sendSeekToOrder(double time) {
    print("$peerConnected play");
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send({"seekTo": time});
      });
    }
  }

  void sendConfirmOrder(String receivedPeerId) {
    peerId = receivedPeerId;
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("confirmed");
      });
    }
  }

  void sendEscapeOrder() {
    if (peerConnected) {
      conn = peer.connect(peerId!);
      conn.on("open").listen((_) {
        conn.send("escape");
      });
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
              sendFifteenMinOrder();
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
              peer.disconnect();
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
                                myPeerId: myPeerId ?? "peerId not set",
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
                            peer.disconnect();
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
                      child: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15)),
                    ),
                  )
                ],
              ),
              !fullScreen
                  ? WindowTitleBarBox(
                      child: Row(
                        children: [
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
