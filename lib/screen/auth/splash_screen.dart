import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/connectivity.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/bottom_footer_navigation.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth_controllers.dart';
import '../../helpers/dynamic_link.service.dart';
import '../../model/auth/users.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final authController = Get.put(AuthController());
  bool moveNext = false;
  ConnectivityHandler? connectivityHandler;
  @override
  void initState() {
    super.initState();
    //getInAppReviewStatus

    authController.getAppInReviewStatus().then((value) {
      setState(() {
        moveNext = true;
        _checkLogin();
      });
    });
  }

  _checkLogin() async {
    Timer(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var login = prefs.getBool(loginKey);
      var userData = prefs.getString(loginUserDataKey);
      String tokenString = prefs.getString(userTokenKey) ?? "";

      if (userData != null && userData.isNotEmpty) {
        authController.currentUser.value = User.fromJson(jsonDecode(userData));
      }

      if (tokenString.isNotEmpty) {
        authController.sessionToken.value = tokenString;
      }

      connectivityHandler = ConnectivityHandler();
      connectivityHandler?.isConnected.listen((value) {
        if (value) {
          if (moveNext) {
            if (login != null && login != false) {
              prefs.setBool(isTourOnScreenEnabledkey, false);
              isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
              if (isTourOnScreenEnabled == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomFooterNavigation()),
                  (route) => false,
                );
                callDynamicLink();
              } else {
                authController.totalTime().then((value) async {
                  prefs.setBool(isTourOnLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.lEARN ?? false);
                  prefs.setBool(isTourOnSubjectScreenkey, authController.totalTimeSpent.value.data?.screenData?.sUBJECT ?? false);
                  prefs.setBool(isTourOnChapterScreenkey, authController.totalTimeSpent.value.data?.screenData?.cHAPTERLIST ?? false);
                  prefs.setBool(isTourOnRoadMapLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPLEARN ?? false);
                  prefs.setBool(isTourOnRoadMapHomeworkScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPHOMEWORK ?? false);

                  if (authController.totalTimeSpent.value.data?.minutesReached == true) {
                    prefs.setBool(isTourOnScreenEnabledkey, false);
                  } else {
                    prefs.setBool(isTourOnScreenEnabledkey, false);
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomFooterNavigation()),
                    (route) => false,
                  );
                  callDynamicLink();
                });
              }
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginNewScreen()),
                (route) => false,
              );

              callDynamicLink();
            }
          }
        }
      });
    });
  }

  callDynamicLink() {
    // Handle dynamic links listener
    dynamicLinkListner();
    // Check dynamic intial link
    checkDynamicIntialLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBGBlue,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30.h),
          width: 250.h,
          height: 200.h,
          child: SvgPicture.asset(
            imageAssets + "auth/saarthi_logo.svg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
