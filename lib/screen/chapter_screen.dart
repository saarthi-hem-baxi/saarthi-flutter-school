import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/chapters_cards.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/learn_controller.dart';
import '../theme/colors.dart';
import '../theme/style.dart';
import 'ItemCards/pending_cards.dart';
import 'productvideotour/learn_introvideo_screen.dart';

class ChaptersPage extends StatefulWidget {
  final Datum subjectData;

  const ChaptersPage({
    Key? key,
    required this.subjectData,
  }) : super(key: key);

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  final authController = Get.put(AuthController());
  final dashBoardController = Get.put(LearnController());

  @override
  void initState() {
    super.initState();

    sendUserTrackingEvent();

    Future.delayed(Duration.zero, () {
      dashBoardController.getChapters(
          context: context, subjectData: widget.subjectData);
      dashBoardController.getpendingCounts(subjectId: widget.subjectData.id!);
    });
    _checkisTourEnable();
  }

  sendUserTrackingEvent() {
    /* sendAnalyticsData(eventName: "student-subject-screen", data: {
      authController.sessionToken.value,
      authController.currentUser.value.school?.id ?? "",
      authController.currentUser.value.id ?? "",
      authController.currentUser.value.userClass?.classId ?? "",
      authController.currentUser.value.section?.id ?? "",
      widget.subjectData.id ?? "",
    }); */
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    Future.delayed(Duration.zero, () {
      dashBoardController.getChapters(
          context: context, subjectData: widget.subjectData);
      dashBoardController.getpendingCounts(subjectId: widget.subjectData.id!);
    });
    _checkisTourEnable();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: colorScreenBg1Purple,
            child: Obx(
              () => dashBoardController.loading.isTrue
                  ? Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: SvgPicture.asset(
                            imageAssets + 'back/chapters_back.svg',
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: LoadingSpinner(),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: SvgPicture.asset(
                            imageAssets + 'back/chapters_back.svg',
                            // allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Column(
                          children: [
                            HeaderCard(
                              title: widget.subjectData.name ?? "",
                              backEnabled: true,
                              textColor: sectionTitleColor,
                              introVideoEnabled: isTourOnScreenEnabled!,
                              onTap: () => {
                                Navigator.pop(context, true)
                              }, //Colors.white,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    dashBoardController.pendingLoading.isTrue
                                        ? const Center(
                                            child: LoadingSpinner(),
                                          )
                                        : PendingCounts(),
                                    (dashBoardController
                                                    .chaptersData.value.data ??
                                                [])
                                            .isEmpty
                                        ? Center(
                                            child: Text(
                                              "No Chapter found !",
                                              style: textTitle16WhiteBoldStyle
                                                  .merge(const TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          )
                                        : Container(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            margin: marginLeftRight16,
                                            child: Column(
                                              children: [
                                                ...(dashBoardController
                                                            .chaptersData
                                                            .value
                                                            .data ??
                                                        [])
                                                    .mapIndexed(
                                                  (index, data) {
                                                    return ChaptersDataItem(
                                                      data: data,
                                                      index: index,
                                                      subjectData:
                                                          widget.subjectData,
                                                      onResume: onResume,
                                                      thenPress:
                                                          sendUserTrackingEvent,
                                                    );
                                                  },
                                                ).toList(),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    isTourOnSubjectScreen = prefs.getBool(isTourOnSubjectScreenkey);
    dashBoardController.getIntroVideos(context, 'SUBJECT').then((value) {
      setState(() {
        if ((dashBoardController.introVideo.value.data?.videos ?? [])
            .isNotEmpty) {
          dashBoardController.tourvideoKey.value = isTourOnSubjectScreenkey;
          dashBoardController.tourCode.value = 'SUBJECT';
          if (isTourOnSubjectScreen == null || isTourOnSubjectScreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashBoardController.updateProductTourVideoStatus(
                    studentUserId:
                        authController.currentUser.value.id.toString(),
                    tourCode: 'SUBJECT',
                    isView: true);
                prefs.setBool(isTourOnSubjectScreenkey, true);
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

class PendingCounts extends StatelessWidget {
  PendingCounts({Key? key}) : super(key: key);
  final dashBoardController = Get.put(LearnController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(123, 160, 44, 0.12),
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // SvgPicture.asset(
          //   imageAssets + 'ic_bg_pending.svg',
          //   fit: BoxFit.fitWidth,
          //   height: 150.h,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pending...(${dashBoardController.pendingCounts["total"]})",
                style: textTitle18WhiteBoldStyle
                    .merge(const TextStyle(color: sectionTitleColor)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    PendingCards(
                      title: 'Precap',
                      count: dashBoardController
                          .pendingCounts["precapPendingCount"]
                          .toString(),
                      gradient: skyBlueGradient,
                      icon: 'precap.svg',
                    ),
                    PendingCards(
                      title: 'HW',
                      count: dashBoardController
                          .pendingCounts["homeworkPendingCount"]
                          .toString(),
                      gradient: purpleGradient,
                      icon: 'hw.svg',
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
