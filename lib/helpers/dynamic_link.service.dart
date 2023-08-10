import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_screen_2.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_screen_3.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_with_link.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controllers.dart';

Future<Uri> generateDynamicLink() async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    // The Dynamic Link URI domain. You can view created URIs on your Firebase console
    uriPrefix: 'https://saarthipedagogy.page.link/students',
    // The deep Link passed to your application which you can use to affect change
    link: Uri.parse('https://saarthipedagogy.com/teachers?name=87767'),
    // Android application details needed for opening correct app on device/Play Store
    androidParameters: const AndroidParameters(
      packageName: "com.saarthipedagogy.students",
      minimumVersion: 1,
    ),
    // iOS application details needed for opening correct app on device/App Store
    iosParameters: const IOSParameters(
      bundleId: "com.saarthipedagogy.students",
      minimumVersion: '2',
    ),
  );
  final Uri shortDynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);

  return shortDynamicLink;
}

void checkDynamicIntialLink() async {
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  handleDynamicLink(
    link: initialLink?.link ?? Uri.parse(""),
  );
}

void dynamicLinkListner() async {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
    handleDynamicLink(
      link: dynamicLink.link,
    );
  }).onError((error) {
    debugPrint("Dynamic Link Error: $error");
    // Handle errors
  });
}

void handleDynamicLink({
  required Uri link,
}) async {
  try {
    if (link.queryParameters.containsKey('type') && link.queryParameters.containsKey('value')) {
      var jsonData = {
        'type': link.queryParameters['type'],
        'value': link.queryParameters['value'],
      };
      getSchoolIdFromLink(
        jsonData: jsonData,
      );
    }
  } catch (e) {
    debugPrint("Something went wrong when retrieving data from the dynamic link $e");
  }
}

void getSchoolIdFromLink({
  required jsonData,
}) async {
  final authController = Get.put(AuthController());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var login = prefs.getBool(loginKey);

  if (jsonData['type'] == "register") {
    String schoolId = jsonData['value'];

    if (login ?? false) {
      authController
          .getSchoolDetail(
            schoolId: schoolId,
            isFromRegistrationLink: true,
          )
          .then((value) => {
                if (value == null)
                  {
                    authController.getSessionUserData().then((value) {
                      if (authController.allUsers.length == 1) {
                        Get.offAll(() => RegistrationScreen2(
                              fromAddSchool: true,
                              schoolId: schoolId,
                              isBackButton: false,
                              isSingleSchoolUser: true,
                            ));
                      } else if (authController.allUsers.length > 1) {
                        var contain = authController.allUsers.where((element) => element.school?.schoolId == schoolId);
                        if (contain.isEmpty) {
                          Get.offAll(() => RegistrationScreen3(
                                userInputData: const {},
                                schoolId: schoolId,
                                fromAddSchool: true,
                                fromRegitrationLink: true,
                                isBackButton: false,
                              ));
                        } else {
                          Fluttertoast.showToast(msg: "You are already register with the school");
                        }
                      } else {
                        Get.offAll(() => RegistrationScreen2(
                              fromAddSchool: true,
                              schoolId: schoolId,
                              isBackButton: false,
                            ));
                      }
                    })
                  }
              });
    } else {
      authController.schoolId.value = schoolId;
      Get.offAll(() => RegistrationWithLinkScreen(schoolId: schoolId));
    }
  }
}
