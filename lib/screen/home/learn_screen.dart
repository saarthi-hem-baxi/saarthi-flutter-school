import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/communication_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart' as global;
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/book_cards.dart';
import 'package:saarthi_pedagogy_studentapp/screen/chapter_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/communication/class_communication.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/learn_controller.dart';
import '../../helpers/connectivity.dart';
import '../../helpers/socket_helper.dart';
import '../../model/auth/users.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with SingleTickerProviderStateMixin {
  final dashBoardController = Get.put(LearnController());
  final communicationController = Get.put(CommunicationController());
  final authController = Get.put(AuthController());

  ConnectivityHandler? connectivityHandler;
  User _currentUser = User();
  bool shouldProceed = false;

  @override
  void initState() {
    super.initState();

    sendUserTrackingEvent();

    connectivityHandler = ConnectivityHandler();
    // connectivityHandler?.shouldOpenNoInternet = false;
    connectivityHandler?.isConnected.listen((value) {
      if (value) {
        doProcess();
      } else {}
    });
    dashBoardController.studentUserId.value = authController.currentUser.value.id.toString();
    _checkisTourEnable();
  }

  sendUserTrackingEvent() {
    /* sendAnalyticsData(eventName: "student-learn-screen", data: {
      _authController.sessionToken.value,
      _authController.currentUser.value.school?.id ?? "",
      _authController.currentUser.value.id ?? "",
      _authController.currentUser.value.userClass?.classId ?? "",
      _authController.currentUser.value.section?.id ?? ""
    }); */
  }

  doProcess() {
    _getLocalStorage();
    sendStudentActiveStatus();
    dashBoardController.getSubjects(context).then((value) {
      setState(() {
        shouldProceed = true;
      });
    });
    communicationController.checkNewMessage();
  }

  _getLocalStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var userData = pref.getString(loginUserDataKey) ?? "";
    _currentUser = User.fromJson(json.decode(userData));
    setState(() {});
    connectAndListen(_currentUser);
  }

  void connectAndListen(User currentUser) async {
    try {
      global.socket?.on(
        'group-message',
        (data) {
          communicationController.isHasNewMessage.value = true;
          if (mounted) {
            setState(() {});
          }
        },
      );
      // ignore: empty_catches
    } catch (e) {
      debugPrint('catch block executed');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onResume() {
    // Implement your code inside here

    // _checkisTourEnable();

    dashBoardController.getSubjects(context);
    _checkisTourEnable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClassCommunicationPage(title: 'Communication'),
                    ),
                  ).then((value) {
                    communicationController.checkNewMessage();
                    setState(() {});
                  }).then((value) {
                    sendUserTrackingEvent();
                  });
                },
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        decoration: boxDecoration10.copyWith(
                          color: colorPurpleLight,
                        ),
                        width: 50.w,
                        height: 50.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32.w,
                              height: 32.w,
                              child: SvgPicture.asset(
                                imageAssets + 'menu/communication_icon.svg',
                                // allowDrawingOutsideViewBox: true,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: communicationController.isHasNewMessage.isTrue
                          ? Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                            )
                          : Container(),
                    )
                  ],
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => dashBoardController.loading.isTrue
              ? const Center(
                  child: LoadingSpinner(),
                )
              : Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SvgPicture.asset(
                        imageAssets + 'learn_back.svg',
                        // allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    shouldProceed
                        ? dashBoardController.subjectModel.value.data == null
                            ? Center(
                                child: Text(
                                  "Oops...\nSomething Went Wrong! Try Again",
                                  style: sectionTitleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(right: 10.w),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    HeaderCard(
                                      title: "Learn",
                                      backEnabled: false,
                                      introVideoEnabled: isTourOnScreenEnabled!,
                                      onTap: () => {},
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: GridView.count(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 10.0,
                                          childAspectRatio: 3 / 4,
                                          shrinkWrap: true,
                                          // direction: Axis.horizontal,
                                          // runSpacing: 10.h,
                                          children: (dashBoardController.subjectModel.value.data ?? []).map((item) {
                                            var index = (dashBoardController.subjectModel.value.data ?? []).indexOf(item);
                                            var gradient = [
                                              redGradient,
                                              orangeGradient,
                                              purpleGradient,
                                              greenGradient,
                                              blueDarkGradient,
                                              pinkGradient,
                                              skyBlueGradient
                                            ];
                                            return GestureDetector(
                                              onTap: () => {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ChaptersPage(
                                                      subjectData: item,
                                                    ),
                                                  ),
                                                ).then(
                                                  (value) => {onResume(), sendUserTrackingEvent()},
                                                )
                                                // dashBoardController.getChapters(
                                                //     context, item),
                                              },
                                              child: BooksCards(
                                                learn: true,
                                                title: item.name ?? "",
                                                index: index,
                                                gradient: gradient,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : const Center(
                            child: LoadingSpinner(),
                          )
                  ],
                ),
        ),
      ),
    );
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    isTourOnLearnscreen = prefs.getBool(isTourOnLearnScreenkey);
    dashBoardController.getIntroVideos(context, 'LEARN').then((value) {
      setState(() {
        if ((dashBoardController.introVideo.value.data?.videos ?? []).isNotEmpty) {
          dashBoardController.tourvideoKey.value = isTourOnLearnScreenkey;
          dashBoardController.tourCode.value = 'LEARN';
          if (isTourOnLearnscreen == null || isTourOnLearnscreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashBoardController.updateProductTourVideoStatus(
                    studentUserId: authController.currentUser.value.id.toString(), tourCode: 'LEARN', isView: true);
                prefs.setBool(isTourOnLearnScreenkey, true);
              }
            });
          }
        } else {
          isTourOnScreenEnabled = true;
        }
      });
    });
  }
}
