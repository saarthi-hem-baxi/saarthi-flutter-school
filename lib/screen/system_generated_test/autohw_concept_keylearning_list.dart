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

import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'autohw_concept_result.dart';
import 'autohw_test_concept_exam.dart';
import 'autohw_topic_result.dart';

class AutoHWConceptkeyLearningPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;

  const AutoHWConceptkeyLearningPage({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<AutoHWConceptkeyLearningPage> createState() => _AutoHWConceptkeyLearningPageState();
}

class _AutoHWConceptkeyLearningPageState extends State<AutoHWConceptkeyLearningPage> with SingleTickerProviderStateMixin {
  var homeWorkController = Get.put(HomeworkController());
  var systemGeneratedTestController = Get.put(SystemGeneratedTestController());
  var shouldDisplay = false;
  final precapController = Get.put(PrecapController());

  @override
  void initState() {
    super.initState();
    precapController.isKeylearningScreen = true;
    precapController.totalKeyLearnings = 0;
    precapController.totalKeylerningExamPer = 0.0;
    precapController.totalKeyLearningsPercentage = 0.0;
    homeWorkController.loading.value = true;
    Future.delayed(
      Duration.zero,
      () => {
        homeWorkController
            .getHomeworkDetail(context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: widget.homeworkId)
            .then(
          (value) {
            setState(
              () {},
            );
          },
        )
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    precapController.totalKeyLearnings = 0;
    precapController.totalKeylerningExamPer = 0.0;
    precapController.totalKeyLearningsPercentage = 0.0;
    homeWorkController.loading.value = true;
    Future.delayed(
      Duration.zero,
      () => {
        homeWorkController
            .getHomeworkDetail(context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: widget.homeworkId)
            .then((value) {
          if (mounted) {
            setState(() {});
          }
        })
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
              Obx(
                () => homeWorkController.loading.isTrue
                    ? const Center(
                        child: LoadingSpinner(color: Colors.blue),
                      )
                    : homeWorkController.homeworkDetailModel.value.data == null
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
                              Container(
                                width: getScreenWidth(context),
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Topic",
                                      style: sectionTitleTextStyle.merge(
                                        const TextStyle(fontSize: 16, color: sectionTitleColor),
                                      ),
                                    ),
                                    Container(
                                      width: getScreenWidth(context),
                                      margin: const EdgeInsets.only(top: 5),
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                      decoration: boxDecoration14,
                                      alignment: AlignmentDirectional.centerStart,
                                      child: Text(
                                        homeWorkController.homeworkDetailModel.value.data?.topics?[0].topic?.name ?? "",
                                        style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: getScreenWidth(context),
                                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (homeWorkController.homeworkDetailModel.value.data?.topics![0].type!.toLowerCase() == "topic")
                                            ? "Concepts"
                                            : "Preconcept",
                                        style: sectionTitleTextStyle.merge(
                                          const TextStyle(fontSize: 16, color: sectionTitleColor),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: getScreenWidth(context),
                                          child: ListView.builder(
                                            itemCount: (homeWorkController.homeworkDetailModel.value.data!.concepts ?? []).length,
                                            itemBuilder: (BuildContext context, int index) {
                                              Concepts conceptData = homeWorkController.homeworkDetailModel.value.data!.concepts![index];
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
                                    precapController.isKeylearningScreen = true;
                                    precapController.totalKeyLearnings = 0;
                                    precapController.totalKeylerningExamPer = 0.0;
                                    precapController.totalKeyLearningsPercentage = 0.0;
                                    getTotalPercentage().then((value) {
                                      if (homeWorkController.homeworkDetailModel.value.data?.completed?.status == null) {
                                        systemGeneratedTestController.getSystemGeneratedTest(
                                            context: context,
                                            subjectId: widget.subjectId,
                                            chapterId: widget.chapterId,
                                            homeworkData: homeWorkController.homeworkDetailModel.value.data!,
                                            isFirst: true,
                                            // homeworkId: widget.homeworkId,
                                            // examStarted: homeWorkController.homeworkDetailModel.value.data?.started?.status ?? false,
                                            // examCompleted: homeWorkController.homeworkDetailModel.value.data?.completed?.status ?? false,
                                            // lang: homeWorkController.homeworkDetailModel.value.data?.lang ?? "",
                                            map: {}).then((value) {
                                          if (systemGeneratedTestController.strTopicType.value == "topic") {
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AutoHWTestConceptBasedExamPage(
                                                  //This is Concept Based Exam
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                  homeWorkId: widget.homeworkId,
                                                ),
                                              ),
                                            ).then((value) => {onResume()});
                                          }
                                        });
                                      } else {
                                        homeWorkController
                                            .getHomeworkDetail(
                                                context: context,
                                                subjectId: widget.subjectId,
                                                chapterId: widget.chapterId,
                                                homeworkId: widget.homeworkId)
                                            .then(
                                              (value) => {
                                                ((homeWorkController.homeworkDetailModel.value.data?.concepts ?? []).isEmpty &&
                                                        (homeWorkController.homeworkDetailModel.value.data?.topics ?? []).isNotEmpty)
                                                    ? homeWorkController.homeworkDetailModel.value.data?.topics![0].type!.toLowerCase() == "topic"
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AutoHWTopicBasedResultScreenPage(
                                                                homeworkId: widget.homeworkId,
                                                                subjectId: widget.subjectId,
                                                                chapterId: widget.chapterId,
                                                              ),
                                                            ),
                                                          ).then((value) => {onResume()})
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AutoHWConceptBasedResultScreenPage(
                                                                homeworkId: widget.homeworkId,
                                                                subjectId: widget.subjectId,
                                                                chapterId: widget.chapterId,
                                                              ),
                                                            ),
                                                          ).then((value) => {onResume()})
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => AutoHWConceptBasedResultScreenPage(
                                                            homeworkId: widget.homeworkId,
                                                            subjectId: widget.subjectId,
                                                            chapterId: widget.chapterId,
                                                          ),
                                                        ),
                                                      ).then((value) => {onResume()})
                                              },
                                            );
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(16),
                                  height: 46,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient:
                                        homeWorkController.homeworkDetailModel.value.data!.started?.status ?? false ? pinkGradient : purpleGradient,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          homeWorkController.homeworkDetailModel.value.data!.started?.status ?? false
                                              ? "Continue Auto Homework"
                                              : "Start Auto Homework",
                                          style: textTitle18WhiteBoldStyle),
                                      SvgPicture.asset(
                                        imageAssets +
                                            (homeWorkController.homeworkDetailModel.value.data!.started?.status ?? false
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
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getTotalPercentage() async {
    for (Concepts item in (homeWorkController.homeworkDetailModel.value.data!.concepts ?? [])) {
      precapController.totalKeyLearnings = precapController.totalKeyLearnings + item.keyLearnings!.length;
    }
    precapController.totalKeyLearningsPercentage = 100 / precapController.totalKeyLearnings;
    if (precapController.isKeylearningScreen) {
      for (Concepts cItem in (homeWorkController.homeworkDetailModel.value.data!.concepts ?? [])) {
        for (KeyLearnings kItem in cItem.keyLearnings ?? []) {
          if (kItem.cleared != null) {
            precapController.totalKeylerningExamPer = precapController.totalKeylerningExamPer + precapController.totalKeyLearningsPercentage;
          }
        }
      }
    }
    return true;
  }
}
