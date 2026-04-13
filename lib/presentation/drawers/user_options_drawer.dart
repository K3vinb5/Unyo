import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unyo/config/config.dart' as config;
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/notification/user_notifier.dart';

class UserOptionsDrawer extends StatefulWidget {
  const UserOptionsDrawer({super.key});

  @override
  State<UserOptionsDrawer> createState() => _UserOptionsDrawerState();
}

class _UserOptionsDrawerState extends State<UserOptionsDrawer> {

  final UserNotifier _loggedInUserNotifier = sl<UserNotifier>(instanceName: config.loggedUserNotifier);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: 500.w,
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: ColorScheme.of(context).secondary.withValues(alpha: 0.7),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0.w, vertical: 20.0.h),
              child: const Column(children: []),
            ),
          ),
        ),
      ),
    );
  }
}
