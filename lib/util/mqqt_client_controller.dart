import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:desktop_keep_screen_on/desktop_keep_screen_on.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/util/utils.dart';

class MqqtClientController {
  MqqtClientController({
    required this.context,
    required this.key,
    required this.controlsOverlayOnTap,
    required this.resetHideControlsTimer,
    required this.updateEntry,
    required this.mixedController,
  });

  final BuildContext context;
  final MixedController mixedController;
  final String key;
  final void Function() controlsOverlayOnTap;
  final void Function() resetHideControlsTimer;
  final void Function() updateEntry;

  late MqttServerClient client;
  late String topic;
  late String myId;
  late String partyId;
  bool firstConnection = true;
  bool firstConfirm = true;
  bool connected = false;

  void init() {
    myId = generateRandomId();
    partyId = sha256.convert(utf8.encode(key)).toString().substring(0, 10);
    topic = "$partyId-${generateRandomId()}";
  }

  void connectToPeer(String newTopic) async {
    if (newTopic.contains("-") || newTopic.contains(":")) {
      newTopic = newTopic.replaceAll("-", "@").replaceAll(":", "@");
    }
    if (newTopic.trim() == "") {
      // showErrorDialog(context, "Empty topic");
      // return;
      newTopic = topic.split("-")[1];
    }
    if (firstConnection) {
      client = MqttServerClient('ws://kevin-is-awesome.mooo.com', '',
          maxConnectionAttempts: 10);

      client.useWebSocket = true;
      client.port = 9001;
      client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
      client.setProtocolV311();
      client.keepAlivePeriod = 1800;
      client.logging(on: false);

      client.onDisconnected = onDisconnected;

      firstConnection = false;
    } else {
      client.unsubscribe(topic);
    }
    connected = true;
    topic = "$partyId-$newTopic";

    try {
      await client.connect();
    } catch (e) {
      // Raised by the client when connection fails.
      client.disconnect();
      connected = false;
      if (!context.mounted) return;
      showErrorDialog(context, exception: e.toString());
    }

    /// Check we are connected
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      connected = false;
      client.disconnect();
      if (!context.mounted) return;
      showErrorDialog(context,
          exception:
              'Client connection failed - disconnecting... status is ${client.connectionStatus}');
      return;
    }
    client.subscribe(topic, MqttQos.exactlyOnce); //qos 2

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final messageStringAndIds =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message)
              .split("-");
      if (messageStringAndIds[1] != partyId || messageStringAndIds[0] == myId) {
        return;
      }
      final message = messageStringAndIds[2];

      if (message.contains("seekTo")) {
        double value = double.parse(message.split(":")[1]);
        mixedController.seekTo(Duration(microseconds: (value * 1000).toInt()));
      }

      switch (message) {
        case "pause":
          controlsOverlayOnTap();

          mixedController.pause();
          break;
        case "play":
          controlsOverlayOnTap();
          mixedController.play();
          break;
        case "fifteenplus":
          mixedController.seekTo(
            Duration(
                milliseconds: mixedController
                        .videoController.value.position.inMilliseconds +
                    15000),
          );
          break;
        case "fifteenminus":
          mixedController.seekTo(
            Duration(
                milliseconds: mixedController
                        .videoController.value.position.inMilliseconds -
                    15000),
          );
          break;
        case "fiveplus":
          mixedController.seekTo(
            Duration(
                milliseconds: mixedController
                        .videoController.value.position.inMilliseconds +
                    5000),
          );
          break;
        case "fiveminus":
          mixedController.seekTo(
            Duration(
                milliseconds: mixedController
                        .videoController.value.position.inMilliseconds -
                    5000),
          );
          break;
        case "confirmed":
          mixedController.seekTo(const Duration(milliseconds: 0));
          if (mixedController.isPlaying) {
            controlsOverlayOnTap();
            mixedController.pause();
          }
          if (firstConfirm) {
            showConnectionSuccessfulDialog(context);
            firstConfirm = false;
          }
          break;
        case "escape":
          mixedController.canDispose = true;
          if (prefs.getBool("exit_fullscreen_on_video_exit") ?? false) {
            Window.exitFullscreen();
          }
          mixedController.dispose();
          mixedController.interactScreen(false);
          Navigator.pop(context);
          break;
        case "connected":
          firstConfirm = false;
          sendOrder("confirmed");
          mixedController.seekTo(const Duration(milliseconds: 0));
          if (mixedController.isPlaying) {
            controlsOverlayOnTap();
            mixedController.pause();
          }
          showConnectionSuccessfulDialog(context);
          break;
      }
    });
    sendOrder("connected");
  }

  void onDisconnected() {
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {}
  }

  String generateRandomId() {
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    const idLength = 20; // You can adjust the length of the ID as needed
    String newId = String.fromCharCodes(
      List.generate(
        idLength,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
    for (int i = 1; i < 4; i++) {
      int index = 5 * i + (i - 2);
      newId = insertCharacter(newId, index, "@");
    }
    return newId;
  }

  String insertCharacter(String original, int index, String charToInsert) {
    return '${original.substring(0, index)}$charToInsert${original.substring(index)}';
  }

  void sendOrder(String message) {
    if (connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString("$myId-$partyId-$message");
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      print("sent $message");
    }
  }
}
