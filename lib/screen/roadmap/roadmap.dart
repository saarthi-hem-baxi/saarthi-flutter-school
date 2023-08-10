import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap_appbar.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap_layout.widget.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/road_map_model/topics.dart';
import '../../model/road_map_model/unclear_pre_concept.dart';
import '../../theme/colors.dart';
import '../homework/homework.dart';
import '../lesson_plan.dart';
import '../system_generated_test/self_autohw/self_autohw_concept_keylearning_list.dart';
import 'concept_map_webview.dart';

class RoadmapPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chaptersData;

  const RoadmapPage({
    Key? key,
    required this.subjectData,
    required this.chaptersData,
  }) : super(key: key);

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final roadmMapController = Get.put(RoadmapController());

  List<dynamic> milestones = [];
  final dashBoardController = Get.put(LearnController());
  final authController = Get.put(AuthController());
  final roadMapController = Get.put(RoadmapController());

  String get lang => roadMapController.roadMapModel.value.data?.lang ?? "";

  @override
  void initState() {
    super.initState();

    sendUserTrackingEvent();

    _controller = AnimationController(
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      _getRoadMapData();
      showConceptMapPopUp();
      _checkisTourEnable();
    });
  }

  sendUserTrackingEvent() {
    /* sendAnalyticsData(eventName: "student-chapter-screen", data: {
      _authController.sessionToken.value,
      _authController.currentUser.value.school?.id ?? "",
      _authController.currentUser.value.id ?? "",
      _authController.currentUser.value.userClass?.classId ?? "",
      _authController.currentUser.value.section?.id ?? "",
      widget.subjectData.id ?? "",
      widget.chaptersData.id ?? ""
    }); */
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onResume() {
    // Implement your code inside here
    _checkisTourEnable();
  }

  _getRoadMapData() async {
    await roadmMapController.getRoadMap(
      context: context,
      subjectData: widget.subjectData,
      chapterData: widget.chaptersData,
    );
  }

  void showConceptMapPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConceptWebViewPage(
            subjectId: widget.subjectData.id ?? "",
            chapterId: widget.chaptersData.id ?? "",
            fromPage: 'roadmap',
            onActionHandler: (value) {
              Map<String, dynamic> data = value;
              if (data['type'] != null && data['actionType'] != null && data['id'] != null) {
                Future.delayed(Duration.zero, () {
                  _showConceptMapActionBottomSheet(type: data['type'] ?? "", actionType: data['actionType'] ?? "", id: data['id']);
                });
              }
            },
          );
        });
  }

  void _showConceptMapActionBottomSheet({required String type, required String actionType, required String id}) {
    String widgetType = type; // the value shoud be topic/concept

    Topics? topicData;
    UnclearPreConcept? unclearPreConcept;

    if (widgetType == "topic") {
      List<Topics> topicDataList = (roadMapController.roadMapModel.value.data?.topics ?? []).where((element) => element.topic?.id == id).toList();

      if (topicDataList.isEmpty) {
        return;
      }
      topicData = topicDataList.first;
    }

    if (widgetType == "concept") {
      List<UnclearPreConcept> preconceptList =
          (roadMapController.roadMapModel.value.data?.unclearPreConcepts ?? []).where((element) => element.preConcept?.id == id).toList();
      if (preconceptList.isEmpty) {
        return;
      }
      unclearPreConcept = preconceptList.first;
    }

    bool isShowLearn() {
      if (widgetType == "topic") {
        return topicData?.topic?.status == "active";
      } else {
        return unclearPreConcept?.preConcept?.status == "active";
      }
    }

    String getTopicOrConceptId() {
      if (widgetType == "topic") {
        return topicData?.topic?.id ?? "-1";
      } else {
        return unclearPreConcept?.preConcept?.id ?? "-1";
      }
    }

    String getTitle() {
      if (widgetType == "topic") {
        return topicData?.topic?.name ?? "";
      } else {
        return unclearPreConcept?.preConcept?.name?[lang] ?? "";
      }
    }

    bool isShowSelfAutoHW() {
      if (widgetType == "topic") {
        return false;
      } else {
        return (unclearPreConcept?.isSelfAutoHomework ?? false);
      }
    }

    if (actionType == 'learn' && isShowLearn()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonPlanPage(
            subjectId: roadMapController.selectedSubjectData?.id ?? "",
            chapterId: roadMapController.selectedChaptersData?.id ?? "",
            topicid: getTopicOrConceptId(),
            title: getTitle(),
            type: widgetType == "topic" ? LPQBType.topic : LPQBType.concept,
          ),
        ),
      ).then((value) => {onResume()});
    }

    if (actionType == 'homework') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWorkPage(
            subjectData: roadMapController.selectedSubjectData!,
            chapterData: roadMapController.selectedChaptersData!,
            topicOrConceptId: getTopicOrConceptId(),
            type: widgetType == "topic" ? ByHomeworkTypes.topic : ByHomeworkTypes.concept,
          ),
        ),
      ).then((value) => {onResume()});
    }

    if (actionType == 'self-auto-homework' && isShowSelfAutoHW()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelfAutoHWConceptkeyLearningPage(
            subjectId: roadMapController.selectedSubjectData!.id!,
            chapterId: roadMapController.selectedChaptersData!.id!,
            conceptId: unclearPreConcept?.preConcept?.id ?? "-1",
            selfAutoHomeworkId: unclearPreConcept?.selfAutoHomeworkId ?? "",
          ),
        ),
      ).then((value) => {onResume()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ChaperRoadmapAppBar(
          title: widget.chaptersData.name ?? "",
          onActionTap: showConceptMapPopUp,
          introVideoEnabled: isTourOnScreenEnabled!,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(color: colorBlueDark),
          child: Obx(
            () => roadmMapController.loading.isTrue
                ? const Center(
                    child: LoadingSpinner(
                      color: Colors.white,
                    ),
                  )
                : RoadmapLayout(roadmapUserTrackFunc: sendUserTrackingEvent),
          ),
        ),
      ),
    );
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnChapterScreen = prefs.getBool(isTourOnChapterScreenkey);
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    dashBoardController.getIntroVideos(context, 'CHAPTER LIST').then((value) {
      setState(() {
        if ((dashBoardController.introVideo.value.data?.videos ?? []).isNotEmpty) {
          dashBoardController.tourvideoKey.value = isTourOnChapterScreenkey;
          dashBoardController.tourCode.value = 'CHAPTER LIST';
          if (isTourOnChapterScreen == null || isTourOnChapterScreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashBoardController.updateProductTourVideoStatus(
                    studentUserId: authController.currentUser.value.id.toString(), tourCode: 'CHAPTER LIST', isView: true);
                prefs.setBool(isTourOnChapterScreenkey, true);
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
