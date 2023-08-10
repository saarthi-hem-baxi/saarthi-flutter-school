// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:saarthi_pedagogy_studentapp/helpers/app_operation.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/tests_model/hint_solution_model.dart';
import '../theme/style.dart';
import '../widgets/media/media_utils.dart';

double getScrenHeight(context) {
  return (MediaQuery.of(context).size.height);
}

double getScreenWidth(context) {
  return (MediaQuery.of(context).size.width);
}

double getScreenRatio(context) {
  return (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width);
}

double getStatusBarHeight(context) {
  return MediaQuery.of(context).padding.top;
}

emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Email Required';
  } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return 'Email Invalid';
  } else {
    return '';
  }
}

emptyValidator(value, msg) {
  if (value == null || value.isEmpty) {
    return msg;
  } else {
    return "";
  }
}

getPrefsValue(key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString(key);
}

// Future<User> getUserData() async {
//   var userData = await getPrefsValue(loginUserData);
//   if (userData != "") {
//     User userModel = User.fromJson(jsonDecode(userData));
//     return userModel;
//   } else {
//     return User.fromJson(jsonDecode('{}'));
//     ;
//   }
// }

bool isLink(String input) {
  final matcher = RegExp(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
  return matcher.hasMatch(input);
}

int maxPage(int totalRecords, int limit) {
  return (totalRecords / limit).ceilToDouble().toInt();
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isNetworkUrl(String url) {
  if (url.startsWith('http') || url.startsWith('https')) {
    return true;
  } else {
    return false;
  }
}

bool checkPasswordvalidation({required String password, required String confirmPassword}) {
  if (password.trim() == "") {
    Fluttertoast.showToast(msg: "Password Required");
    return false;
  } else if (confirmPassword == "") {
    Fluttertoast.showToast(msg: "Confirm Password Required");
    return false;
  } else if (password.length < 8) {
    Fluttertoast.showToast(msg: "Your password must be at least 8 characters");
    return false;
  } else if (password.length > 32) {
    Fluttertoast.showToast(msg: "Your password must be at max 32 characters");
    return false;
  } else if (!password.contains(RegExp(r'[a-z]'))) {
    Fluttertoast.showToast(msg: "Your password must contain at least one lower case letter.");
    return false;
  } else if (!password.contains(RegExp(r'[A-Z]'))) {
    Fluttertoast.showToast(msg: "Your password must contain at least one upper case letter.");
    return false;
  } else if (!password.contains(RegExp(r'[0-9]'))) {
    Fluttertoast.showToast(msg: "Your password must contain at least one digit.");
    return false;
  } else if (!password.contains(RegExp(r'[!@#$?%^&*,]'))) {
    Fluttertoast.showToast(msg: "Your password must contain at least special char from - ! @ #  % ^ & * , \$");
    return false;
  } else if (password != confirmPassword) {
    Fluttertoast.showToast(msg: "Both password are not match");
    return false;
  } else {
    return true;
  }
}

schoolDeactivateDialog({required String message}) {
  return getx.Get.defaultDialog(
    barrierDismissible: false,
    title: '',
    titlePadding: EdgeInsets.zero,
    content: WillPopScope(
      onWillPop: () async => false,
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            message,
            style: textTitle14BoldStyle.merge(
              TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Platform.isAndroid
                  ? GestureDetector(
                      onTap: forceClosedApp,
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(width: 1, color: colorBlue),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          child: Center(
                            child: Text(
                              "Exit App ",
                              style: textFormSmallerTitleStyle.merge(
                                const TextStyle(
                                  color: colorBlueDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 0.w,
                    ),
            ],
          ),
        ],
      ),
    ),
  );
}

String getTypeDesc(String type) {
  if (type == "upload") {
    return "Upload";
  } else if (type == "online-test") {
    return "Online Test";
  } else if (type == "existing") {
    return "Existing";
  } else if (type == "system-generated") {
    return "Auto HW";
  } else if (type == "generate") {
    return "Generated";
  } else {
    return "";
  }
}

extension FicListExtension<T> on List<T> {
  /// Maps each element of the list.
  /// The [map] function gets both the original [item] and its [index].
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) =>
      fold(<K, List<E>>{}, (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

String capitalize(String s) {
  if (s.isNotEmpty) {
    return "${s[0].toUpperCase()}${s.substring(1)}";
  } else {
    return "";
  }
}

void showGetxSnakBar({
  required String msg,
  int durationInSec = 5,
  Color backgroundColor = Colors.grey,
  Widget actionWidget = const SizedBox(),
}) {
  getx.Get.showSnackbar(
    getx.GetSnackBar(
      messageText: Text(
        msg,
      ),
      isDismissible: true,
      duration: Duration(seconds: durationInSec),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(20),
      barBlur: 20,
      backgroundColor: backgroundColor.withOpacity(0.5),
      borderRadius: 10,
      mainButton: actionWidget,
    ),
  );
}

List<SolutionMedia> getfilteredVideoMedia({required List solutionMedia}) {
  List<SolutionMedia> videoMedia = [];
  for (SolutionMedia mediaItem in solutionMedia) {
    if (getMediaTypeFromUrl(mediaItem.url?.enUs ?? '') == MediaTypes.video) {
      videoMedia.add(mediaItem);
    }
  }
  return videoMedia;
}
