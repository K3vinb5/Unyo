// External dependencies
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unyo/application/cubits/video_cubit.dart';
import 'package:unyo/application/states/video_state.dart';

// Internal dependencies
import 'package:unyo/core/services/video/video_service.dart';
import 'package:unyo/presentation/widgets/styled/dark_unyo_button.dart';

class UnyoVideoControls extends StatefulWidget {
  final VideoCubit videoCubit;
  final VideoService videoService;

  const UnyoVideoControls({super.key, required this.videoCubit, required this.videoService});

  @override
  State<UnyoVideoControls> createState() => _UnyoVideoControlsState();
}

class _UnyoVideoControlsState extends State<UnyoVideoControls> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _refreshTimer;
  late VideoService _videoService;
  late Timer _hideControlsTimer;
  late bool _controlsVisible;

  @override
  void initState() {
    super.initState();
    _controlsVisible = true;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Adjust the duration as needed
    );
    _controller.animateTo(1.0);
    _videoService = widget.videoService;
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _videoService.isPlaying) {
        setState(() {});
      }
    });
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _videoService.isPlaying) {
        _controlsVisible = false;
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _hideControlsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.videoCubit,
      child: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          return !_videoService.isBuffering
              ? MouseRegion(
                  onHover: (event) {
                    _hideControlsTimer.cancel();
                    _controlsVisible = true;
                    setState(() {});
                    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
                      if (mounted && _videoService.isPlaying) {
                        _controlsVisible = false;
                        setState(() {});
                      }
                    });
                  },
                  cursor: _controlsVisible ? SystemMouseCursors.basic : SystemMouseCursors.none,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _controlsVisible ? 1 : 0,
                    child: Stack(
                      children: [
                        // Screen Gestures
                        GestureDetector(
                          onTap: () {
                            if (_videoService.isPlaying) {
                              _refreshTimer.cancel();
                              _videoService.pause();
                              _controlsVisible = true;
                              setState(() {});
                              _controller.animateTo(0.0);
                            }
                          },
                        ),
                        // Header
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        context.read<VideoCubit>().navigateBackToAnimeDetailsPage(context),
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: ColorScheme.of(context).tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${state.selectedAnime.title.userPreferred}  -  Episode ${state.videoInfo.playlistIndex + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Video Controls Overlay
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _videoService.isPlaying ? 0 : 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: IgnorePointer(
                              ignoring: _videoService.isPlaying,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _videoService.reverse(const Duration(seconds: 15));
                                      setState(() {});
                                    },
                                    icon: Tooltip(
                                      waitDuration: const Duration(milliseconds: 2000),
                                      textAlign: TextAlign.center,
                                      message: "Reverse 15s",
                                      child: Icon(Icons.fast_rewind_rounded, color: Colors.white, size: 80.w),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Material(
                                    color: Colors.transparent,
                                    child: Tooltip(
                                      waitDuration: const Duration(milliseconds: 2000),
                                      textAlign: TextAlign.center,
                                      message: "Resume Play",
                                      child: InkWell(
                                        onTap: () {
                                          if (!_videoService.isPlaying) {
                                            _videoService.play();
                                            setState(() {});
                                            _refreshTimer = Timer.periodic(
                                              const Duration(milliseconds: 100),
                                              (_) {
                                                if (mounted && _videoService.isPlaying) {
                                                  setState(() {});
                                                }
                                              },
                                            );
                                            _hideControlsTimer = Timer(const Duration(seconds: 3), () {
                                              if (mounted && _videoService.isPlaying) {
                                                _controlsVisible = false;
                                              }
                                            });
                                            _controller.animateTo(1.0);
                                          }
                                        },
                                        // highlightColor: Colors.white12,
                                        hoverColor: Colors.white10,
                                        splashColor: Colors.white12,
                                        borderRadius: BorderRadius.circular(60.w),
                                        child: AnimatedIcon(
                                          icon: AnimatedIcons.play_pause,
                                          size: 100.w,
                                          color: Colors.white,
                                          progress: _controller,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Tooltip(
                                    waitDuration: const Duration(milliseconds: 2000),
                                    textAlign: TextAlign.center,
                                    message: "Forward 15s",
                                    child: IconButton(
                                      onPressed: () {
                                        _videoService.forward(const Duration(seconds: 15));
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.fast_forward_rounded, color: Colors.white, size: 80.w),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Video Slider And Controls
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 135,
                            child: Column(
                              children: [
                                // Video Slider
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // TODO - AniSkip
                                    Opacity(
                                      opacity: 0.7,
                                      child: DarkUnyoButton(
                                        text: "${state.loggedUser.settings.manualSkipTime.toString()}s",
                                        color: ColorScheme.of(context).primary,
                                        width: 80.w,
                                        maxWidth: 90,
                                        maxHeight: 45,
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                  ],
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  children: [
                                    SizedBox(width: 20.w),
                                    SizedBox(
                                      width: 75,
                                      child: Text(
                                        _videoService.position.toString().substring(0, 7),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Expanded(
                                      child: Slider(
                                        min: 0,
                                        max: _videoService.duration.inMilliseconds.toDouble(),
                                        value: _videoService.position.inMilliseconds.toDouble(),
                                        label: _videoService.formattedPosition,
                                        divisions: _videoService.duration.inMilliseconds.toDouble() > 0
                                            ? _videoService.duration.inMilliseconds
                                            : null,
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {});
                                          _videoService.seekTo(Duration(milliseconds: value.toInt()));
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 75,
                                      child: Text(
                                        _videoService.duration.toString().substring(0, 7),
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                  ],
                                ),
                                // Video Controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left Aligned
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: []),
                                    // Right Aligned
                                    Row(mainAxisAlignment: MainAxisAlignment.end, children: []),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.read<VideoCubit>().navigateBackToAnimeDetailsPage(context),
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: ColorScheme.of(context).tertiary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${state.selectedAnime.title.userPreferred}  -  Episode ${state.videoInfo.playlistIndex + 1}",
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 100.w),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
