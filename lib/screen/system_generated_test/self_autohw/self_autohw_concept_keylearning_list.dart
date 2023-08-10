import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/system_generated_test_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/concepts.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/concept_list_item.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../ItemCards/self_concept_list_item.dart';
import '../autohw_concept_result.dart';
import '../autohw_retest_concept_result.dart';
import 'self_autohw_concept_exam.dart';

class SelfAutoHWConceptkeyLearningPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String conceptId;
  final String selfAutoHomeworkId;

  const SelfAutoHWConceptkeyLearningPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.conceptId,
    required this.selfAutoHomeworkId,
  }) : super(key: key);

  @override
  State<SelfAutoHWConceptkeyLearningPage> createState() => _SelfAutoHWConceptkeyLearningPageState();
}

class _SelfAutoHWConceptkeyLearningPageState extends State<SelfAutoHWConceptkeyLearningPage> with SingleTickerProviderStateMixin {
  var homeWorkController = Get.put(HomeworkController());
  final testsController = Get.put(PrecapController());
  var systemGeneratedTestController = Get.put(SystemGeneratedTestController());
  var shouldDisplay = false;
  var selfAutoHwId = "";

  @override
  void initState() {
    super.initState();
    selfAutoHwId = widget.selfAutoHomeworkId;
    onResume(selfAutoHwId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume(String selfAutoHomeworkId) {
    selfAutoHwId = selfAutoHomeworkId;
    testsController.precapLoading.value = true;
    testsController.isKeylearningScreen = true;
    testsController.totalKeyLearnings = 0;
    testsController.totalKeylerningExamPer = 0.0;
    testsController.totalKeyLearningsPercentage = 0.0;
    Future.delayed(
      Duration.zero,
      () => {
        if (selfAutoHomeworkId.isNotEmpty)
          {
            homeWorkController
                .getHomeworkDetail(
                    context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: selfAutoHomeworkId, isSelfAutoHW: true)
                .then(
              (value) {
                if (homeWorkController.homeworkDetailModel.value.data?.completed?.status != null) {
                  ((homeWorkController.homeworkDetailModel.value.data?.concepts ?? []).isEmpty &&
                          (homeWorkController.homeworkDetailModel.value.data?.topics ?? []).isNotEmpty)
                      ? homeWorkController.homeworkDetailModel.value.data?.topics![0].type!.toLowerCase() == "topic"
                          ? []
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (homeWorkController.homeworkDetailModel.value.data?.cleared ?? false)
                                    ? AutoHWConceptBasedResultScreenPage(
                                        homeworkId: selfAutoHomeworkId,
                                        subjectId: widget.subjectId,
                                        chapterId: widget.chapterId,
                                        isSelfAutoHW: true,
                                      )
                                    : AutoHWRetestConceptBasedResultScreenPage(
                                        homeworkId: selfAutoHomeworkId,
                                        subjectId: widget.subjectId,
                                        chapterId: widget.chapterId,
                                        isSelfAutoHW: true,
                                      ),
                              ),
                            )
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (homeWorkController.homeworkDetailModel.value.data?.cleared ?? false)
                                ? AutoHWConceptBasedResultScreenPage(
                                    homeworkId: selfAutoHomeworkId,
                                    subjectId: widget.subjectId,
                                    chapterId: widget.chapterId,
                                    isSelfAutoHW: true,
                                  )
                                : AutoHWRetestConceptBasedResultScreenPage(
                                    homeworkId: widget.selfAutoHomeworkId,
                                    subjectId: widget.subjectId,
                                    chapterId: widget.chapterId,
                                    isSelfAutoHW: true,
                                  ),
                          ),
                        );
                } else {
                  setState(
                    () {
                      shouldDisplay = true;
                    },
                  );
                }
              },
            )
          }
        else
          {
            homeWorkController
                .getSelfAutoHWDetail(
              context: context,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              conceptId: widget.conceptId,
            )
                .then((value) {
              setState(() {
                shouldDisplay = true;
              });
            })
          }
      },
    );
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Navigator.pop(context);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(
            children: [
              const Positioned(
                left: -100,
                child: GradientCircle(
                  gradient: circleOrangeGradient,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(125),
                    bottomRight: Radius.circular(125),
                  ),
                ),
              ),
              shouldDisplay
                  ? Obx(
                      () => homeWorkController.loading.isTrue
                          ? const Center(
                              child: LoadingSpinner(color: Colors.blue),
                            )
                          : selfAutoHwId.isNotEmpty
                              ? homeWorkController.homeworkDetailModel.value.data == null
                                  ? const NoDataCard(
                                      title: "Oops...\n No Data found",
                                      description: "No Data found \nkindly contact your teacher.",
                                      headerEnabled: true,
                                    )
                                  : Column(
                                      children: [
                                        HeaderCard(
                                          title: "Auto Homework",
                                          backEnabled: true,
                                          onTap: () {
                                            _onBackPressed();
                                          },
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: getScreenWidth(context),
                                            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Preconcept",
                                                  style: sectionTitleTextStyle.merge(
                                                    const TextStyle(fontSize: 16, color: sectionTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: getScreenWidth(context),
                                                    child: ListView.builder(
                                                      itemCount: (homeWorkController.homeworkDetailModel.value.data?.concepts ?? []).length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        Concepts conceptData =
                                                            (homeWorkController.homeworkDetailModel.value.data?.concepts ?? [])[index];
                                                        return ConceptListItem(conceptData: conceptData);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            {
                                              systemGeneratedTestController
                                                  .getSelfAutoHWTest(
                                                context: context,
                                                subjectId: widget.subjectId,
                                                chapterId: widget.chapterId,
                                                homeworkData: homeWorkController.homeworkDetailModel.value.data!,
                                                map: {},
                                                isFirst: true,
                                              )
                                                  .then(
                                                (value) {
                                                  if (value == "topic") {
                                                  } else {
                                                    testsController.isKeylearningScreen = true;
                                                    getPercentage().then((value) => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => SelfAutoHWTestConceptBasedExamPage(
                                                              //This is Self Auto HW Concept Based Exam
                                                              subjectId: widget.subjectId,
                                                              chapterId: widget.chapterId,
                                                              homeworkId: widget.selfAutoHomeworkId,
                                                            ),
                                                          ),
                                                        ).then((value) => {onResume(value)}));
                                                  }
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            height: 46,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: homeWorkController.homeworkDetailModel.value.data!.started?.status ?? false
                                                  ? pinkGradient
                                                  : purpleGradient,
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    homeWorkController.homeworkDetailModel.value.data?.started?.status ?? false
                                                        ? "Continue Auto Homework"
                                                        : "Start Auto Homework",
                                                    style: textTitle18WhiteBoldStyle),
                                                SvgPicture.asset(
                                                  imageAssets +
                                                      (homeWorkController.homeworkDetailModel.value.data?.started?.status ?? false
                                                          ? 'tests/continueprecap.svg'
                                                          : 'tests/start_rocket.svg'),
                                                  height: 23,
                                                  width: 23,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                              : homeWorkController.selfAutoHWDetailModel.value.data == null
                                  ? Column(
                                      children: [
                                        HeaderCard(
                                          title: "Retest",
                                          backEnabled: true,
                                          onTap: () {
                                            _onBackPressed();
                                          },
                                        ),
                                        const NoDataCard(
                                          title: "Oops...\n No Data found",
                                          description: "No Data found \nkindly contact your teacher.",
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        HeaderCard(
                                          title: "Auto Homework",
                                          backEnabled: true,
                                          onTap: () {
                                            _onBackPressed();
                                          },
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: getScreenWidth(context),
                                            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Preconcept",
                                                  style: sectionTitleTextStyle.merge(
                                                    const TextStyle(fontSize: 16, color: sectionTitleColor),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getScreenWidth(context),
                                                  child: homeWorkController.selfAutoHWDetailModel.value.data?.unclearPreConcepts != null
                                                      ? SelfConceptListItem(
                                                          conceptData: homeWorkController.selfAutoHWDetailModel.value.data!.unclearPreConcepts!)
                                                      : const SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            systemGeneratedTestController
                                                .createSelfAutoHWTest(
                                                    subjectId: widget.subjectId, chapterId: widget.chapterId, conceptId: widget.conceptId)
                                                .then(
                                                  (createResponse) => {
                                                    if (createResponse != null)
                                                      {
                                                        homeWorkController
                                                            .getHomeworkDetail(
                                                                context: context,
                                                                subjectId: widget.subjectId,
                                                                chapterId: widget.chapterId,
                                                                homeworkId: createResponse["selfAutoHomeworkId"] ?? "-1",
                                                                isSelfAutoHW: true)
                                                            .then(
                                                          (value) {
                                                            systemGeneratedTestController
                                                                .getSelfAutoHWTest(
                                                              context: context,
                                                              subjectId: widget.subjectId,
                                                              chapterId: widget.chapterId,
                                                              homeworkData: homeWorkController.homeworkDetailModel.value.data!,
                                                              map: {},
                                                              isFirst: true,
                                                            )
                                                                .then(
                                                              (value) {
                                                                if (value == "topic") {
                                                                } else {
                                                                  testsController.isKeylearningScreen = true;
                                                                  getPercentage().then((value) => Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => SelfAutoHWTestConceptBasedExamPage(
                                                                            //This is Self Auto HW Concept Based Exam
                                                                            subjectId: widget.subjectId,
                                                                            chapterId: widget.chapterId,
                                                                            homeworkId: widget.selfAutoHomeworkId,
                                                                          ),
                                                                        ),
                                                                      ).then((value) => {onResume(value)}));
                                                                }
                                                              },
                                                            );
                                                          },
                                                        )
                                                      }
                                                  },
                                                )
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            height: 46,
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              gradient: purpleGradient,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Start Auto Homework", style: textTitle18WhiteBoldStyle),
                                                SvgPicture.asset(
                                                  imageAssets + 'tests/start_rocket.svg',
                                                  height: 23,
                                                  width: 23,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                    )
                  : const Center(
                      child: LoadingSpinner(
                        color: Colors.blue,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getPercentage() async {
    for (Concepts item in (homeWorkController.homeworkDetailModel.value.data?.concepts ?? [])) {
      testsController.totalKeyLearnings = testsController.totalKeyLearnings + item.keyLearnings!.length;
    }
    if (testsController.totalKeyLearnings != 0) {
      testsController.totalKeyLearningsPercentage = 100 / testsController.totalKeyLearnings;
    }

    if (testsController.isKeylearningScreen) {
      for (Concepts cItem in (homeWorkController.homeworkDetailModel.value.data?.concepts ?? [])) {
        for (KeyLearnings kItem in cItem.keyLearnings ?? []) {
          if (kItem.cleared != null) {
            testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
          }
        }
      }
    }

    return true;
  }
}
