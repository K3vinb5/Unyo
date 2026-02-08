import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnyoExtensionButton extends StatelessWidget {
  final void Function()? onDownloadPressed;
  final void Function()? onDeletePressed;
  final void Function()? onSettingsPressed;
  final String iconUrl;
  final String name;
  final String lang;
  final String version;
  final int nsfw;

  const UnyoExtensionButton({
    super.key,
    this.onDownloadPressed,
    required this.iconUrl,
    required this.name,
    required this.lang,
    required this.version,
    required this.nsfw,
    this.onDeletePressed,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withValues(alpha: 0.15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 20.w),
                ClipOval(child: Image.network(iconUrl, fit: BoxFit.fill, width: 52, height: 52)),
                SizedBox(width: 14.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        nsfw == 1
                            ? Container(
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber.withValues(alpha: 0.3),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    "NFSW",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorScheme.of(context).primary.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                "${lang.substring(0, 1).toUpperCase()}${lang.substring(1)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Container(
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorScheme.of(context).tertiary.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                version,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                onDownloadPressed != null
                    ? Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: Tooltip(
                        waitDuration: const Duration(milliseconds: 1000),
                        message: "Download",
                        child: InkWell(
                          onTap: onDownloadPressed,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorScheme.of(context).primary.withValues(alpha: 0.2),
                            ),
                            child: Icon(Icons.download_rounded, color: ColorScheme.of(context).tertiary),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox(),
                onSettingsPressed != null
                    ? Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: Tooltip(
                        waitDuration: const Duration(milliseconds: 1000),
                        message: "Settings",
                        child: InkWell(
                          onTap: onSettingsPressed,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorScheme.of(context).primary.withValues(alpha: 0.2),
                            ),
                            child: Icon(Icons.settings_rounded, color: ColorScheme.of(context).tertiary),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox(),
                onDeletePressed != null
                    ? Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: Tooltip(
                        waitDuration: const Duration(milliseconds: 1000),
                        message: "Delete",
                        child: InkWell(
                          onTap: onDeletePressed,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red.withValues(alpha: 0.2),
                            ),
                            child: Icon(Icons.delete_rounded, color: Colors.redAccent.withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox(),
                SizedBox(width: 20.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
