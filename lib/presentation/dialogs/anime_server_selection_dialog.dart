// External dependencies
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Internal dependencies
import 'package:unyo/application/cubits/anime_details_cubit.dart';
import 'package:unyo/application/states/anime_details_state.dart';
import 'package:unyo/domain/entities/extension/video.dart' as ext;
import 'package:unyo/presentation/views/loading_view.dart';
import 'package:unyo/presentation/widgets/styled/unyo_server_button.dart';

class AnimeServerSelectionDialog extends StatefulWidget {
  final AnimeDetailsCubit cubit;
  final int episodeIndex;
  final Future<bool> Function() onOpen;

  const AnimeServerSelectionDialog({super.key, required this.cubit, required this.episodeIndex, required this.onOpen});

  @override
  State<AnimeServerSelectionDialog> createState() => _AnimeServerSelectionDialogState();
}

class _AnimeServerSelectionDialogState extends State<AnimeServerSelectionDialog> {
  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  Future<void> asyncInit() async {
    bool remainOpen = await widget.onOpen();
    if (!remainOpen && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
        builder: (context, state) => Dialog(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          child: SizedBox(
            width: 550.w,
            height: 600.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0.w, vertical: 36.0.h),
              child: state.animeServerDialogReady
                  ? Column(
                      children: [
                        const Text(
                          "Select Server",
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            children: [
                              ...state.extensionVideoResults.mapIndexed(
                                (int videoIndex, ext.Video video) => Column(
                                  children: [
                                    SizedBox(height: 25.0.h),
                                    UnyoServerButton(
                                      videoServer: video,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        context.read<AnimeDetailsCubit>().navigateToVideoPlayer(video, widget.episodeIndex, videoIndex);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : LoadingView(width: 85.w, description: "Please wait, this can take some seconds..."),
            ),
          ),
        ),
      ),
    );
  }
}
