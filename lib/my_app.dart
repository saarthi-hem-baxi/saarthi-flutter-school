import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/splash_screen.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    // Send this token in API call or save in a shared controller
    debugPrint('Token : $token');
  }

  @override
  void initState() {
    super.initState();

    try {
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          saveTokenToDatabase(token);
        } else {
          debugPrint('Cannot get token');
        }
      }).catchError((onError) {
        debugPrint(onError.toString());
      });

      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      // Save the initial token to the database

      // Run code required to handle interacted messages in an async function
      // as initState() must not be async

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  Widget build(BuildContext context) {
    // FirebaseCrashlytics.instance.crash();
    return ScreenUtilInit(
      designSize: const Size(414, 736),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Students',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          backgroundColor: colorExtraLightGreybg,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
            child: widget!,
          );
        },
        home: const SplashScreenPage(),
      ),
    );
  }
}
