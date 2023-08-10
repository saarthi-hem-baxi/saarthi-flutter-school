import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/online_test_topic_concept.dart';
import 'package:saarthi_pedagogy_studentapp/screen/precap_concept_key_learning_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/title_description.dart';

// import '../../model/tests_model/tests_model.dart';
import '../../model/worksheet_model/homework_model_new.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../homework/online_test_result.dart';
import '../result_screen.dart';
import '../system_generated_test/autohw_concept_keylearning_list.dart';
import '../system_generated_test/autohw_concept_result.dart';
import '../system_generated_test/autohw_retest_concept_result.dart';
import '../system_generated_test/autohw_retest_topic_result.dart';
import '../system_generated_test/autohw_topic_keylearning_list.dart';
import '../system_generated_test/autohw_topic_result.dart';

class TestsCards extends StatefulWidget {
  final Worksheet testDatum;
  final bool isPending;
  final VoidCallback? refreshData;

  const TestsCards({
    Key? key,
    required this.testDatum,
    required this.isPending,
    required this.refreshData,
  }) : super(key: key);

  @override
  _TestsCardsState createState() => _TestsCardsState();
}

class _TestsCardsState extends State<TestsCards> {
  var homeWorkController = Get.put(HomeworkController());
  var precapController = Get.put(PrecapController());

  @override
  void initState() {
    super.initState();
  }

  onResume() {
    debugPrint("onResume Called");

    widget.refreshData!();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
      ),
      child: GestureDetector(
        onTap: () {
          if (getType(widget.testDatum) == TestType.precap) {
            widget.testDatum.examCompleted?.status == true
                ? navigateToResultPage(widget.testDatum)
                : navigateToTopicConceptListPage(widget.testDatum);
          } else {
            widget.testDatum.completed?.status == true
                ? navigateToResultPage(widget.testDatum)
                : navigateToTopicConceptListPage(
                    widget.testDatum,
                  );
          }
        },
        child: Container(
          padding: EdgeInsets.all(10.h),
          decoration: boxDecoration10,
          child: TestCard(testData: widget.testDatum),
        ),
      ),
    );
  }

  navigateToTopicConceptListPage(Worksheet testData) {
    homeWorkController.selectedSubjectData = testData.subject;
    homeWorkController.selectedChapterData = testData.chapter;
    homeWorkController.selectedTopicOrConceptId = "-1";
    homeWorkController.selectedType = ByHomeworkTypes.chapter;
    homeWorkController.isFromTests = true;
    homeWorkController.isFromPending = widget.isPending;
    precapController.testsRefreshData = widget.refreshData;
    precapController.isFromPending = widget.isPending;

    switch (getType(testData)) {
      case TestType.precap:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrecapConceptkeyLearningPage(
              subjectData: testData.subject!,
              chaptersData: testData.chapter!,
              isFromTests: true,
            ),
          ),
        ).then(
          (value) => {
            onResume(),
          },
        );
        break;

      case TestType.hw:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestTopicsPage(
              title: testData.chapter!.name!,
              homeworkId: testData.id!,
              subjectId: testData.subject!.id!,
              chapterId: testData.chapter!.id!,
            ),
          ),
        ).then((value) => {onResume()});
        break;
      case TestType.onlinetest:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestTopicsPage(
              title: testData.chapter!.name!,
              homeworkId: testData.id!,
              subjectId: testData.subject!.id!,
              chapterId: testData.chapter!.id!,
            ),
          ),
        ).then((value) => {onResume()});
        break;
      case TestType.systemgenerated:
        if (testData.topics?[0].type!.toLowerCase() == "topic") {
          if ((testData.concepts ?? []).isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoHWTopickeyLearningPage(
                  homeworkId: testData.id!,
                  subjectId: testData.subject!.id!,
                  chapterId: testData.chapter!.id!,
                ),
              ),
            ).then((value) => {onResume()});
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoHWConceptkeyLearningPage(
                  homeworkId: testData.id!,
                  subjectId: testData.subject!.id!,
                  chapterId: testData.chapter!.id!,
                ),
              ),
            ).then((value) => {onResume()});
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AutoHWConceptkeyLearningPage(
                homeworkId: testData.id!,
                subjectId: testData.subject!.id!,
                chapterId: testData.chapter!.id!,
              ),
            ),
          ).then((value) => {onResume()});
        }
        break;
      default:
    }
  }

  navigateToResultPage(Worksheet testData) {
    homeWorkController.selectedSubjectData = testData.subject;
    homeWorkController.selectedChapterData = testData.chapter;
    homeWorkController.selectedTopicOrConceptId = "-1";
    homeWorkController.selectedType = ByHomeworkTypes.chapter;
    homeWorkController.isFromTests = true;
    homeWorkController.isFromPending = widget.isPending;

    precapController.testsRefreshData = widget.refreshData;
    precapController.isFromPending = widget.isPending;

    switch (getType(testData)) {
      case TestType.precap:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreenPage(
              subjectData: testData.subject!,
              chaptersData: testData.chapter!,
              isFromTests: true,
            ),
          ),
        ).then((value) => {onResume()});
        break;

      case TestType.hw:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestResultPage(
              subjectId: testData.subject!.id!,
              chapterId: testData.chapter!.id!,
              homeworkId: testData.id!,
            ),
          ),
        ).then((value) => {onResume()});
        break;
      case TestType.onlinetest:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestResultPage(
              subjectId: testData.subject!.id!,
              chapterId: testData.chapter!.id!,
              homeworkId: testData.id!,
            ),
          ),
        ).then((value) => {onResume()});
        break;
      case TestType.systemgenerated:
        if (testData.topics![0].type!.toLowerCase() == "topic") {
          if ((testData.concepts ?? []).isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (testData.cleared ?? false)
                    ? AutoHWTopicBasedResultScreenPage(
                        homeworkId: testData.id!,
                        subjectId: testData.subject!.id!,
                        chapterId: testData.chapter!.id!,
                      )
                    : (testData.clearedRetest ?? false)
                        ? AutoHWRetestTopicBasedResultScreenPage(
                            homeworkId: testData.id!,
                            subjectId: testData.subject!.id!,
                            chapterId: testData.chapter!.id!,
                          )
                        : AutoHWRetestTopicBasedResultScreenPage(
                            homeworkId: testData.id!,
                            subjectId: testData.subject!.id!,
                            chapterId: testData.chapter!.id!,
                          ),
              ),
            ).then((value) => {onResume()});
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (testData.cleared ?? false)
                    ? AutoHWConceptBasedResultScreenPage(
                        homeworkId: testData.id!,
                        subjectId: testData.subject!.id!,
                        chapterId: testData.chapter!.id!,
                      )
                    : (testData.clearedRetest ?? false)
                        ? AutoHWRetestConceptBasedResultScreenPage(
                            homeworkId: testData.id!,
                            subjectId: testData.subject!.id!,
                            chapterId: testData.chapter!.id!,
                            type: testData.topics?[0].type!.toLowerCase() == "topic" ? ByHomeworkTypes.topic : ByHomeworkTypes.concept,
                            isFromRoadMapResult: false,
                          )
                        : AutoHWRetestConceptBasedResultScreenPage(
                            homeworkId: testData.id!,
                            subjectId: testData.subject!.id!,
                            chapterId: testData.chapter!.id!,
                            type: testData.topics?[0].type!.toLowerCase() == "topic" ? ByHomeworkTypes.topic : ByHomeworkTypes.concept,
                            isFromRoadMapResult: false,
                          ),
              ),
            ).then((value) => {onResume()});
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (testData.cleared ?? false)
                  ? AutoHWConceptBasedResultScreenPage(
                      homeworkId: testData.id!,
                      subjectId: testData.subject!.id!,
                      chapterId: testData.chapter!.id!,
                    )
                  : (testData.clearedRetest ?? false)
                      ? AutoHWRetestConceptBasedResultScreenPage(
                          homeworkId: testData.id!,
                          subjectId: testData.subject!.id!,
                          chapterId: testData.chapter!.id!,
                          type: testData.topics?[0].type!.toLowerCase() == "topic" ? ByHomeworkTypes.topic : ByHomeworkTypes.concept,
                          isFromRoadMapResult: false,
                        )
                      : AutoHWRetestConceptBasedResultScreenPage(
                          homeworkId: testData.id!,
                          subjectId: testData.subject!.id!,
                          chapterId: testData.chapter!.id!,
                          type: testData.topics?[0].type!.toLowerCase() == "topic" ? ByHomeworkTypes.topic : ByHomeworkTypes.concept,
                          isFromRoadMapResult: false,
                        ),
            ),
          ).then((value) => {onResume()});
        }
        break;
      default:
    }
  }
}

// TestType getType(Worksheet testData) {
//   if ((testData.type ?? "").isEmpty) {
//     if ((testData.precap ?? "").isNotEmpty) {
//       return TestType.precap;
//     } else {
//       //for Homework
//       return TestType.hw;
//     }
//   } else {
//     if ((testData.type ?? "") == "online-test") {
//       return TestType.onlinetest;
//     } else {
//       return TestType.systemgenerated;
//     }
//   }
// }

TestType getType(Worksheet testData) {
  if ((testData.type ?? "").isEmpty) {
    if ((testData.precap ?? "").isNotEmpty) {
      return TestType.precap;
    } else {
      return TestType.hw;
    }
  } else {
    if ((testData.type ?? "") == "online-test") {
      return TestType.onlinetest;
    } else {
      return TestType.systemgenerated;
    }
  }
}

class TestTypeIconData {
  final Color textColor;
  final Color bgColor;
  final String text;
  final String iconPath;

  TestTypeIconData({required this.textColor, required this.bgColor, required this.text, required this.iconPath});
}

class TestCard extends StatelessWidget {
  final Worksheet? testData;
  const TestCard({Key? key, required this.testData}) : super(key: key);

  TestTypeIconData getData(TestType type) {
    TestTypeIconData data;
    switch (type) {
      case TestType.precap:
        data = TestTypeIconData(text: "Online Test", textColor: colorSky, bgColor: colorSkyLight, iconPath: 'precap.svg');
        break;
      case TestType.cw:
        data = TestTypeIconData(text: "WS", textColor: colorGreenDark, bgColor: colorGreenLight, iconPath: 'cw.svg');
        break;
      case TestType.hw:
        data = TestTypeIconData(text: "WS", textColor: colorPurple, bgColor: colorPurpleLight, iconPath: 'hw.svg');
        break;
      case TestType.systemgenerated:
        data = TestTypeIconData(text: "Online Test", textColor: colorPurple, bgColor: colorPurpleLight, iconPath: 'hw.svg');
        break;
      case TestType.onlinetest:
        data = TestTypeIconData(text: "Online Test", textColor: colorPurple, bgColor: colorPurpleLight, iconPath: 'hw.svg');
        break;
      default:
        data = TestTypeIconData(text: "Online Test", textColor: colorSky, bgColor: colorSkyLight, iconPath: 'tests/start_rocket.svg');
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    TestTypeIconData testTypeIconData = getData(getType(testData!));

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          (testData?.name ?? "").isNotEmpty
                              ? Text(
                                  testData?.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTitle18WhiteBoldStyle.merge(
                                    const TextStyle(fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                                  ),
                                )
                              : Row(
                                  children: [
                                    testData?.chapter?.orderNumber != null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              right: 5.w,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              color: colorOrangeLight,
                                            ),
                                            child: Text(
                                              'CH ${testData?.chapter?.orderNumber ?? ""}',
                                              style: textTitle12BoldStyle.merge(
                                                const TextStyle(
                                                  color: colorOrange,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Flexible(
                                      child: Text(
                                        testData?.chapter?.name ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: textTitle18WhiteBoldStyle.merge(
                                          const TextStyle(fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          (testData?.precap ?? "").isEmpty
                              ? Row(
                                  children: [
                                    testData?.chapter?.orderNumber != null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              right: 5.w,
                                              top: 5.w,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              color: colorOrangeLight,
                                            ),
                                            child: Text(
                                              'CH ${testData?.chapter?.orderNumber ?? ""}',
                                              style: textTitle12BoldStyle.merge(
                                                const TextStyle(
                                                  color: colorOrange,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Flexible(
                                      child: Text(
                                        testData?.chapter?.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTitle14BoldStyle.merge(
                                          const TextStyle(fontWeight: FontWeight.normal, color: colorBodyText),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Text(
                            testData?.subject?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTitle12BoldStyle.merge(
                              const TextStyle(fontWeight: FontWeight.w700, color: colorDisable),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Container(
                  padding: EdgeInsets.all(5.h),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                    color: testTypeIconData.bgColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 14.h,
                        width: 14.h,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.h),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: SvgPicture.asset(
                            imageAssets + testTypeIconData.iconPath,
                            color: testTypeIconData.textColor,
                          ),
                        ),
                      ),
                      Text(
                        testTypeIconData.text,
                        style: textTitle12BoldStyle.merge(
                          TextStyle(
                            color: testTypeIconData.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.h),
                  child: TitleDescription(
                    title: "Assign",
                    desc: (getType(testData!) == TestType.precap)
                        ? testData?.examAssigned?.date != null
                            ? DateFormat("d MMM").format(testData!.examAssigned!.date!)
                            : "-"
                        : testData?.assigned?.date != null
                            ? DateFormat("d MMM").format(testData!.assigned!.date!)
                            : "-",
                    titleStyle: textTitle8BoldStyle.merge(
                      const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                    ),
                    descStyle: textTitle12BoldStyle.merge(
                      const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: TitleDescription(
                    title: "Due",
                    desc: testData?.dueDate != null ? DateFormat("d MMM").format(testData!.dueDate!) : "-",
                    titleStyle: textTitle8BoldStyle.merge(
                      const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                    ),
                    descStyle: textTitle12BoldStyle.merge(
                      const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ((getType(testData!) == TestType.precap) && (testData?.examCompleted?.status ?? false)) || (testData?.completed?.status ?? false)
                    ? Container(
                        padding: EdgeInsets.all(5.h),
                        child: TitleDescription(
                          title: "Attend",
                          desc: (getType(testData!) == TestType.precap)
                              ? testData?.examCompleted?.date != null
                                  ? DateFormat("d MMM").format(testData!.examCompleted!.date!)
                                  : "-"
                              : testData?.completed?.date != null
                                  ? DateFormat("d MMM").format(testData!.completed!.date!)
                                  : "-",
                          titleStyle: textTitle8BoldStyle.merge(
                            const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                          ),
                          descStyle: textTitle12BoldStyle.merge(
                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : const SizedBox(),
                getType(testData!) == TestType.systemgenerated
                    ? Container(
                        padding: const EdgeInsets.all(3),
                        child: TitleDescription(
                          title: "Concept/Topic",
                          desc: (testData?.concepts ?? []).isNotEmpty
                              ? (testData?.concepts ?? []).length.toString()
                              : (testData?.topics ?? []).length.toString(),
                          titleStyle: textTitle8BoldStyle.merge(
                            const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                          ),
                          descStyle: textTitle12BoldStyle.merge(
                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(3),
                        child: TitleDescription(
                          title: "Marks",
                          desc: (getType(testData!) == TestType.precap && (testData?.examCompleted?.status ?? false)) ||
                                  (testData?.completed?.status ?? false)
                              ? testData!.correct == null && testData!.attempts == null || testData!.correct == 0 && testData!.attempts == 0
                                  ? "-"
                                  : testData!.correct.toString() + "/" + testData!.attempts.toString()
                              : "${(testData?.topics ?? []).isNotEmpty ? testData?.topics?.map((e) => e.questionCount ?? 0).reduce(
                                    (value, element) => value + element,
                                  ) : "-"}",
                          titleStyle: textTitle8BoldStyle.merge(
                            const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                          ),
                          descStyle: textTitle12BoldStyle.merge(
                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
              ]),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 41.h,
              width: 41.h,
              padding: EdgeInsets.all(6.h),
              decoration: BoxDecoration(
                gradient:
                    (getType(testData!) == TestType.precap && (testData?.examCompleted?.status ?? false)) || (testData?.completed?.status ?? false)
                        ? pinkGradient
                        : (testData?.started?.status == true || testData?.examStarted?.status == true)
                            ? pinkGradient
                            : purpleGradient,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                imageAssets +
                    ((getType(testData!) == TestType.precap && (testData?.examCompleted?.status ?? false)) || (testData?.completed?.status ?? false)
                        ? 'tests/result.svg'
                        : (testData?.started?.status == true || testData?.examStarted?.status == true)
                            ? 'tests/continueprecap.svg'
                            : 'tests/start_rocket.svg'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                (getType(testData!) == TestType.precap && (testData?.examCompleted?.status ?? false)) || (testData?.completed?.status ?? false)
                    ? "Result"
                    : (testData?.started?.status == true || testData?.examStarted?.status == true)
                        ? "Resume"
                        : "Start",
                style: textTitle10BoldStyle.merge(
                  const TextStyle(color: sectionTitleColor),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
