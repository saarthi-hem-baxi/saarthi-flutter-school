import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void forceClosedApp() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

void openPlayStoreAppStore() async {
  if (Platform.isIOS) {
    if (!await launchUrl(
      Uri.parse(
          'https://apps.apple.com/app/student-app-saarthi-pedagogy/id1611867530'),
      mode: LaunchMode.externalApplication,
    )) {
      Fluttertoast.showToast(msg: 'Cannot open app store');
    }
  } else if (Platform.isAndroid) {
    if (!await launchUrl(
      Uri.parse(
        'https://play.google.com/store/apps/details?id=com.saarthipedagogy.students',
      ),
      mode: LaunchMode.externalApplication,
    )) {
      Fluttertoast.showToast(msg: 'Cannot open play store');
    }
  }
}

String getAppName() {
  if (Platform.isIOS) {
    return "student-mobile-ios";
  } else if (Platform.isAndroid) {
    return "student-mobile-android";
  }
  return 'student-mobile-android';
}

Future<String> getAppCurrentVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}
