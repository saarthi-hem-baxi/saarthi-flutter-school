import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_model_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/pending_completed_tab.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/completed_homework.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/pending_homework.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/colors.dart';

class HomeWorkPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chapterData;
  final String topicOrConceptId;
  final ByHomeworkTypes type;
  final int tab;

  const HomeWorkPage(
      {Key? key, required this.subjectData, required this.chapterData, required this.topicOrConceptId, required this.type, this.tab = 0})
      : super(key: key);

  @override
  State<HomeWorkPage> createState() => _HomeWorkPageState();
}

class _HomeWorkPageState extends State<HomeWorkPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var homeWorkController = Get.put(HomeworkController());
  final dashboardController = Get.put(LearnController());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkisTourEnable();
    homeWorkController.selectedSubjectData = widget.subjectData;
    homeWorkController.selectedChapterData = widget.chapterData;
    homeWorkController.selectedTopicOrConceptId = widget.topicOrConceptId;
    homeWorkController.selectedType = widget.type;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController?.animateTo((widget.tab) % 2);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    homeWorkController.homeworkDetailModel = HomeworkDetailModel().obs;
    homeWorkController.homeworkPendingModel = HomeworkModel().obs;
    homeWorkController.homeworkCompletedModel = HomeworkModel().obs;
  }

  void onResume() {
    // Implement your code inside here
    _checkisTourEnable();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: getStatusBarHeight(context),
              left: -150,
              child: const GradientCircle(
                gradient: circleOrangeGradient,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(125),
                  bottomRight: Radius.circular(125),
                ),
              ),
            ),
            Positioned(
              right: -100.h,
              bottom: -80.h,
              child: const GradientCircle(
                gradient: circlePurpleGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(125),
                  bottomLeft: Radius.circular(125),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      // color: loginScreenBackgroundColor,
                      children: [
                        HeaderCard(
                          title: 'Homework',
                          backEnabled: true,
                          onTap: _onBackPressed,
                          introVideoEnabled: isTourOnScreenEnabled!,
                        ),
                        PendingCompletedTab(tabController: _tabController)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      PendingHomeWorkPage(
                        subjectData: widget.subjectData,
                        chapterData: widget.chapterData,
                        topicOrConceptId: widget.topicOrConceptId,
                        type: widget.type,
                      ),
                      CompletedHomeWorkPage(
                          subjectData: widget.subjectData,
                          chapterData: widget.chapterData,
                          topicOrConceptId: widget.topicOrConceptId,
                          type: widget.type),
                    ],
                  ),
                ),
                // FooterMenu(notifyParent: refresh, route: worksheetRoute)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    isTourOnRoadMapHomeworkScreen = prefs.getBool(isTourOnRoadMapHomeworkScreenkey);
    dashboardController.getIntroVideos(context, 'ROADMAP_HOMEWORK').then((value) {
      setState(() {
        if ((dashboardController.introVideo.value.data?.videos ?? []).isNotEmpty) {
          dashboardController.tourvideoKey.value = isTourOnRoadMapHomeworkScreenkey;
          dashboardController.tourCode.value = 'ROADMAP_HOMEWORK';
          if (isTourOnRoadMapHomeworkScreen == null || isTourOnRoadMapHomeworkScreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashboardController.updateProductTourVideoStatus(
                    studentUserId: authController.currentUser.value.id.toString(), tourCode: 'ROADMAP_HOMEWORK', isView: true);
                prefs.setBool(isTourOnRoadMapHomeworkScreenkey, true);
              }
            });
          }
        } else {
          isTourOnScreenEnabled = true;
        }
      });
    });
  }

  refresh() {
    setState(() {});
  }
}
