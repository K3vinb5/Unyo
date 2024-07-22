import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class StyledScreenMenuWidget extends StatelessWidget {
  const StyledScreenMenuWidget(
      {super.key,
      required this.onBackPress,
      required this.onRefreshPress,
      this.onMenuPress,
      this.isRow});

  final void Function()? onBackPress;
  final void Function()? onRefreshPress;
  final bool? onMenuPress;
  final bool? isRow;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets firstButtonPadding = !(isRow ?? false)
        ? const EdgeInsets.only(top: 10.0, left: 4.0, bottom: 4.0)
        : const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0);
    final EdgeInsets allOtherButtonsPadding = !(isRow ?? false)
        ? const EdgeInsets.only(top: 4.0, left: 4.0)
        : const EdgeInsets.only(top: 4.0, right: 4.0);
    final EdgeInsets backPadding = (onMenuPress == null || !onMenuPress!)
        ? firstButtonPadding
        : allOtherButtonsPadding;
    final EdgeInsets refreshPadding =
        (onMenuPress == null || !onMenuPress! && onBackPress == null)
            ? firstButtonPadding
            : allOtherButtonsPadding;
    return Align(
      alignment: Alignment.topLeft,
      child: ColumnOrRowWidget(
        isRow: isRow ?? false,
        children: [
          (onMenuPress != null && onMenuPress!)
              ? Padding(
                  padding: firstButtonPadding,
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          (onBackPress != null && !(onMenuPress != null && onMenuPress!))
              ? Padding(
                  padding: backPadding,
                  child: IconButton(
                    onPressed: onBackPress,
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          onRefreshPress != null
              ? Padding(
                  padding: refreshPadding,
                  child: IconButton(
                    onPressed: onRefreshPress,
                    icon: const Icon(Icons.refresh),
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
