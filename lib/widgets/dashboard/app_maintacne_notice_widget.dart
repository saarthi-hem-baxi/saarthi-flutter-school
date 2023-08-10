import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controllers.dart';
import '../../helpers/utils.dart';
import '../../theme/style.dart';
import 'marquee/marquee.dart';

class AppMaintanceNoticeWidget extends StatefulWidget {
  const AppMaintanceNoticeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AppMaintanceNoticeWidget> createState() => _AppMaintanceNoticeWidgetState();
}

class _AppMaintanceNoticeWidgetState extends State<AppMaintanceNoticeWidget> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.getAppMaintanceNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_authController.appMaintanceNotes.value.isNotEmpty) {
          return Container(
            alignment: Alignment.center,
            height: 30.h,
            child: Center(
              child: Marquee(
                text: _authController.appMaintanceNotes.value,
                style: textTitle14StylePoppins.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: getScreenWidth(context) - 32.w,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(milliseconds: 100),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
