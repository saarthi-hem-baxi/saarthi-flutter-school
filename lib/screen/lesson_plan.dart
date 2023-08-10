import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/learn_controller.dart';
import '../controllers/lessonplan_controller.dart';
import '../helpers/const.dart';
import '../helpers/utils.dart';
import '../model/content_report/lp_content_report.modal.dart';
import '../model/lessplan/lesson_plan.dart';
import '../theme/colors.dart';
import '../theme/style.dart';
import '../widgets/common/header.dart';
import '../widgets/common/loading_spinner.dart';
import '../widgets/common/no_data_found.dart';
import '../widgets/lessonplans/lessplans_description.dart';
import '../widgets/lessonplans/lessplans_example.dart';
import '../widgets/lessonplans/lessplans_word_section.dart';
import '../widgets/lessonplans/media/lesson_plan_media_section.dart';
import 'content_report/content_report_icon.dart';
import 'content_report/content_report_screen.dart';

enum LPQBType { topic, concept }

class LessonPlanPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String topicid;
  final String title;
  final LPQBType type;

  const LessonPlanPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.topicid,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  State<LessonPlanPage> createState() => _LessonPlanPageState();
}

class _LessonPlanPageState extends State<LessonPlanPage> with SingleTickerProviderStateMixin {
  final learnController = Get.put(LessonPlanController());
  final dashboardController = Get.put(LearnController());
  final authController = Get.put(AuthController());
  double webviewHeight = 300;
  List<double>? lesswebviewHeight = [];
  List<List<double>> examplewebviewHeight = [];
  double progress = 0;
  bool apiCalled = false;

  get htmlExamples => null;

  @override
  void initState() {
    super.initState();
    log('Title: ${widget.title}');
    log('Type: ${widget.type}');
    sendUserTrackingEvent();

    Future.delayed(Duration.zero, () {
      learnController.getLessonPlanByTopic(
        context: context,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        topicId: widget.topicid,
        type: widget.type == LPQBType.topic ? "topic" : "concept",
      );
    });
    _checkisTourEnable();
  }

  void sendUserTrackingEvent() {
    /* sendAnalyticsData(eventName: "student-topic-learn-screen", data: {
      _authController.sessionToken.value,
      _authController.currentUser.value.school?.id ?? "",
      _authController.currentUser.value.id ?? "",
      _authController.currentUser.value.userClass?.classId ?? "",
      _authController.currentUser.value.section?.id ?? "",
      widget.subjectId,
      widget.chapterId,
      widget.topicid
    }); */
  }
  void onResume() {
    // Implement your code inside here
    _checkisTourEnable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    isTourOnRoadMapLearnScreen = prefs.getBool(isTourOnRoadMapLearnScreenkey);
    dashboardController.getIntroVideos(context, 'ROADMAP_LEARN').then((value) {
      setState(() {
        if ((dashboardController.introVideo.value.data?.videos ?? []).isNotEmpty) {
          dashboardController.tourvideoKey.value = isTourOnRoadMapLearnScreenkey;
          dashboardController.tourCode.value = 'ROADMAP_LEARN';
          if (isTourOnRoadMapLearnScreen == null || isTourOnRoadMapLearnScreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashboardController.updateProductTourVideoStatus(
                    studentUserId: authController.currentUser.value.id.toString(), tourCode: 'ROADMAP_LEARN', isView: true);
                prefs.setBool(isTourOnRoadMapLearnScreenkey, true);
              }
            });
          }
        } else {
          isTourOnScreenEnabled = true;
        }
      });
    });
  }

  bool isDescriptionAvailable({required LessonPlan? lessonPlan}) {
    return (lessonPlan != null && lessonPlan.descriptions != null && (lessonPlan.descriptions ?? []).isNotEmpty);
  }

  bool isWordAvailable({required LessonPlan? lessonPlan}) {
    return (lessonPlan != null && lessonPlan.words != null && (lessonPlan.words ?? []).isNotEmpty);
  }

  bool isMediaAvailable({required LessonPlan? lessonPlan}) {
    if ((lessonPlan?.images ?? []).isNotEmpty ||
        (lessonPlan?.videos ?? []).isNotEmpty ||
        (lessonPlan?.pdfs ?? []).isNotEmpty ||
        (lessonPlan?.audio ?? []).isNotEmpty ||
        (lessonPlan?.links ?? []).isNotEmpty ||
        (lessonPlan?.simulations ?? []).isNotEmpty ||
        (lessonPlan?.documents ?? []).isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isExampleAvailable({required LessonPlan? lessonPlan}) {
    return (lessonPlan != null && (lessonPlan.examples ?? []).isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          LessonPlanListModal lessonPlanListData = learnController.lessonPlanListData.value;
          return Stack(
            children: [
              Column(
                children: [
                  HeaderCard(
                    title: widget.title,
                    backEnabled: true,
                    introVideoEnabled: isTourOnScreenEnabled!,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  learnController.loading.isTrue
                      ? const Center(
                          child: LoadingSpinner(color: Colors.blue),
                        )
                      : (lessonPlanListData.lessonPlans ?? []).isEmpty
                          ? const Expanded(
                              child: NoDataCard(
                                title: "Oops...\n No Lessonplan found",
                                description: " No Lessonplan found \nkindly contact your teacher.",
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ListView.builder(
                                  cacheExtent: 1000,
                                  itemCount: lessonPlanListData.lessonPlans?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    LessonPlan? lessonPlan = lessonPlanListData.lessonPlans?[index];
                                    String lang = lessonPlanListData.lang ?? "";
                                    return Container(
                                      width: getScreenWidth(context),
                                      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                      decoration: boxDecoration10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 5.h,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    lessonPlan?.studentInstruction?[lang] ?? "",
                                                    style: textTitle14BoldStyle
                                                        .merge(const TextStyle(fontWeight: FontWeight.normal, color: colorBodyText)),
                                                  ),
                                                ),
                                                ContentReportIcon(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ContentReportPage(
                                                          typeOfContent: ContentReportType.lessonplan,
                                                          lpContentReportdata: LpContentReportModal(
                                                            lang: lang,
                                                            book: lessonPlan?.book,
                                                            subject: widget.subjectId,
                                                            chapter: widget.chapterId,
                                                            isPublisher: lessonPlan?.isPublisher,
                                                            publisher: lessonPlan?.publisher,
                                                            content: LPReportContent(
                                                              lessonPlan: lessonPlan?.id,
                                                              forStudent: LPReportForStudent(
                                                                forStudent: true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          isDescriptionAvailable(lessonPlan: lessonPlan)
                                              ? const Divider(
                                                  height: 1,
                                                  color: colorText163Gray,
                                                )
                                              : const SizedBox(),
                                          isDescriptionAvailable(lessonPlan: lessonPlan)
                                              ? DescriptionSectionNew(
                                                  lessonPlanModal: lessonPlanListData,
                                                  lessonPlan: lessonPlan,
                                                  lessonPlanIndex: index,
                                                  id: widget.topicid,
                                                  type: widget.type,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                )
                                              : const SizedBox(),
                                          isWordAvailable(lessonPlan: lessonPlan)
                                              ? const Divider(
                                                  height: 1,
                                                  color: colorText163Gray,
                                                )
                                              : const SizedBox(),
                                          isWordAvailable(lessonPlan: lessonPlan)
                                              ? WordSection(
                                                  lessonPlanModal: lessonPlanListData,
                                                  lessonPlan: lessonPlan,
                                                  id: widget.topicid,
                                                  type: widget.type,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                )
                                              : const SizedBox(),
                                          isMediaAvailable(lessonPlan: lessonPlan)
                                              ? MediaSection(
                                                  lessonPlanModal: lessonPlanListData,
                                                  lessonPlan: lessonPlan,
                                                  id: widget.topicid,
                                                  type: widget.type,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                )
                                              : const SizedBox(),
                                          isExampleAvailable(lessonPlan: lessonPlan)
                                              ? const Divider(
                                                  height: 1,
                                                  color: colorText163Gray,
                                                )
                                              : const SizedBox(),
                                          isExampleAvailable(lessonPlan: lessonPlan)
                                              ? ExampleSectionNew(
                                                  lessonPlanModal: lessonPlanListData,
                                                  lessonPlan: lessonPlan,
                                                  lessonPlanIndex: index,
                                                  id: widget.topicid,
                                                  type: widget.type,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
