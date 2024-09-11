import 'package:flutter/material.dart';
import 'package:unyo/widgets/video/m_video_player_controller.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer(this.videoPlayerController, {super.key});

  final VideoPlayerController videoPlayerController;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = widget.videoPlayerController;
    videoPlayerController.player.updateTexture();
  }

  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    videoPlayerController = widget.videoPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ValueListenableBuilder<int?>(
          valueListenable: videoPlayerController.player.textureId,
          builder: (context, id, _) =>
              id == null ? const SizedBox.shrink() : Texture(textureId: id),
        ),
      ),
    ]);
  }
}
