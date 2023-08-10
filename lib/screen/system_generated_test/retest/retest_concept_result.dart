import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_detail.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_answer_key.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../../controllers/retest_controller.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../autohw_retest_concept_result.dart';

class RetestConceptBasedResultScreenPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final String retestHomeworkId;
  final bool isSelfAutoHW;

  const RetestConceptBasedResultScreenPage(
      {Key? key,
      required this.homeworkId,
      required this.subjectId,
      required this.chapterId,
      required this.retestHomeworkId,
      this.isSelfAutoHW = false})
      : super(key: key);

  @override
  State<RetestConceptBasedResultScreenPage> createState() => _RetestConceptBasedResultScreenPageState();
}

class _RetestConceptBasedResultScreenPageState extends State<RetestConceptBasedResultScreenPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      reloadData();
    });
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
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  void reloadData() async {
    await retestsController.getRetestDetail(
        context: context,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        homeworkId: widget.homeworkId,
        retestHomeworkId: widget.retestHomeworkId);
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    if (retestsController.isFromExam ?? false) {
      retestsController.isFromExam = false;
      Navigator.pop(context);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AutoHWRetestConceptBasedResultScreenPage(
          homeworkId: widget.homeworkId,
          subjectId: widget.subjectId,
          chapterId: widget.chapterId,
          isSelfAutoHW: widget.isSelfAutoHW,
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      retestResult();
    });
    return true;
  }

  void retestResult() async {
    await retestsController.getRetestResult(
      context: context,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Obx(
            () => Stack(
              children: [
                Positioned(
                  left: -125,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 250.h,
                      width: 250.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color.fromRGBO(247, 110, 178, 0.2),
                            Color.fromRGBO(247, 110, 178, 0),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(125),
                          bottomRight: Radius.circular(125),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -175,
                  bottom: -175,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 250.h,
                      width: 250.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color.fromRGBO(97, 0, 224, 0.2), Color.fromRGBO(97, 0, 224, 0)],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(125),
                          bottomLeft: Radius.circular(125),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5.h, left: 16.w, bottom: 10.h),
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Result",
                            style: sectionTitleTextStyle,
                          ),
                        ),
                        Container(
                          height: 26.h,
                          width: 26.h,
                          margin: EdgeInsets.only(right: 16.w),
                          alignment: AlignmentDirectional.center,
                          decoration: boxDecoration10,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.close,
                            ),
                            iconSize: 14.h,
                            color: Colors.black,
                            onPressed: _onBackPressed,
                          ),
                        ),
                      ],
                    ),
                    retestsController.loading.isTrue || retestsController.retestDetailModel.value.data == null
                        ? const Center(
                            child: LoadingSpinner(color: Colors.blue),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 16.h,
                                      right: 16.h,
                                    ),
                                    decoration: boxDecoration20,
                                    child: Container(
                                      width: getScreenWidth(context),
                                      margin: EdgeInsets.all(16.h),
                                      height: 160.h,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                                  setState(() {
                                                    if (!event.isInterestedForInteractions ||
                                                        pieTouchResponse == null ||
                                                        pieTouchResponse.touchedSection == null) {
                                                      touchedIndex = -1;
                                                      return;
                                                    }
                                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                  });
                                                }),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 0,
                                                sections: showingSections(
                                                  retestsController.retestDetailModel.value.data,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 6.h),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 20.w),
                                                          ),
                                                          Text(
                                                            "Attempt Ques.",
                                                            style: textTitle14BoldStyle.merge(
                                                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        retestsController.retestDetailModel.value.data?.attempts?.toString() ?? "0",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: sectionTitleColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Container(
                                                  margin: EdgeInsets.only(top: 6.h),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 20.w),
                                                            decoration: BoxDecoration(
                                                              gradient: greenGradient,
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(7.h),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Correct Ques.",
                                                            style: textTitle14BoldStyle.merge(
                                                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        retestsController.retestDetailModel.value.data?.correct?.toString() ?? "0",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: sectionTitleColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Container(
                                                  margin: EdgeInsets.only(top: 6.h),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 20.w),
                                                            decoration: BoxDecoration(
                                                              gradient: redGradient,
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(7.h),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Incorrect Ques.",
                                                            style: textTitle14BoldStyle.merge(
                                                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        retestsController.retestDetailModel.value.data?.wrong?.toString() ?? "0",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: sectionTitleColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // alignment: AlignmentDirectional.center,
                                          width: ((MediaQuery.of(context).size.width - 45) / 2),
                                          height: 54.h,
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                          decoration: boxDecoration14,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10.w),
                                                child: Text(
                                                  (retestsController.retestDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (retestsController.retestDetailModel.value.data?.concepts ?? [])
                                                          .where((e) => e.cleared == true)
                                                          .length
                                                          .toString()
                                                          .padLeft(2, '0')
                                                      : "0",
                                                  style: textTitle26WhiteBoldStyle.merge(
                                                    const TextStyle(color: colorGreenDark),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Cleared Concept",
                                                  style: textTitle14BoldStyle.merge(
                                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // alignment: AlignmentDirectional.center,
                                          width: ((MediaQuery.of(context).size.width - 45) / 2),
                                          height: 54.h,
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          decoration: boxDecoration14,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10.w),
                                                child: Text(
                                                  (retestsController.retestDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (retestsController.retestDetailModel.value.data?.concepts ?? [])
                                                          .map((e) => e.keyLearnings!.where((element) => element.cleared == true).length)
                                                          .reduce((value, element) => value + element)
                                                          .toString()
                                                          .padLeft(2, '0')
                                                      : "0",
                                                  style: textTitle26WhiteBoldStyle.merge(
                                                    const TextStyle(color: colorGreenDark),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Cleared Keylearning",
                                                  style: textTitle14BoldStyle.merge(
                                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context).size.width - 45) / 2,
                                          height: 54.h,
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                          decoration: boxDecoration14,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10.w),
                                                child: Text(
                                                  (retestsController.retestDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (retestsController.retestDetailModel.value.data?.concepts ?? [])
                                                          .where((e) => e.cleared == false)
                                                          .length
                                                          .toString()
                                                          .padLeft(2, '0')
                                                      : "0",
                                                  style: textTitle26WhiteBoldStyle.merge(
                                                    const TextStyle(color: colorRed),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Uncleared Concept",
                                                  style: textTitle14BoldStyle.merge(
                                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context).size.width - 45) / 2,
                                          height: 54.h,
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                          decoration: boxDecoration14,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10.w),
                                                child: Text(
                                                  (retestsController.retestDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (retestsController.retestDetailModel.value.data?.concepts ?? [])
                                                          .map((e) => e.keyLearnings!.where((element) => element.cleared == false).length)
                                                          .reduce((value, element) => value + element)
                                                          .toString()
                                                          .padLeft(2, '0')
                                                      : "0",
                                                  style: textTitle26WhiteBoldStyle.merge(
                                                    const TextStyle(color: colorRed),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Uncleared Keylearning",
                                                  style: textTitle14BoldStyle.merge(
                                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (retestsController.retestDetailModel.value.data?.concepts ?? []).isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                              width: getScreenWidth(context),
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                              child: Text(
                                                "Concepts",
                                                style: textTitle18WhiteBoldStyle.merge(
                                                  const TextStyle(color: sectionTitleColor),
                                                ),
                                              ),
                                            ),
                                            Column(
                                                children: retestsController.retestDetailModel.value.data!.concepts!
                                                    .map(
                                                      (preConcepts) => Container(
                                                        width: getScreenWidth(context),
                                                        margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                                        padding: EdgeInsets.all(10.h),
                                                        decoration: boxDecoration14,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    preConcepts.concept?.name?.enUs?.toString() ?? "",
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: textTitle16WhiteBoldStyle.merge(
                                                                      TextStyle(
                                                                        color: preConcepts.cleared == true ? colorGreen : colorRed,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Wrap(
                                                              direction: Axis.horizontal,
                                                              spacing: 10,
                                                              children: preConcepts.keyLearnings!
                                                                  .map(
                                                                    (keyLearningData) => Container(
                                                                      margin: EdgeInsets.only(top: 5.h),
                                                                      padding: const EdgeInsets.all(5),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.all(
                                                                          Radius.circular(14),
                                                                        ),
                                                                        color: keyLearningData.cleared == true ? colorGreenLight : colorRedLight,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            height: 16.h,
                                                                            width: 16.h,
                                                                            margin: EdgeInsets.only(right: 5.w),
                                                                            alignment: AlignmentDirectional.center,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(8),
                                                                              ),
                                                                              gradient: keyLearningData.cleared == true ? greenGradient : redGradient,
                                                                            ),
                                                                            child: keyLearningData.cleared == true
                                                                                ? SvgPicture.asset(
                                                                                    imageAssets + 'donebutton.svg',
                                                                                    height: 10.h,
                                                                                    width: 10.h,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    imageAssets + 'closebutton.svg',
                                                                                    height: 8.h,
                                                                                    width: 8.h,
                                                                                  ),
                                                                          ),
                                                                          Flexible(
                                                                            child: Text(
                                                                              keyLearningData.keyLearning?.name?.enUs ?? "",
                                                                              style: textTitle12BoldStyle.merge(
                                                                                const TextStyle(
                                                                                  color: colorWebPanelDarkText,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList()),
                                          ],
                                        )
                                      : Container(),
                                  retestsController.retestDetailModel.value.data?.skills?.problemSolving != null ||
                                          retestsController.retestDetailModel.value.data?.skills?.creativity != null ||
                                          retestsController.retestDetailModel.value.data?.skills?.criticalThinking != null ||
                                          retestsController.retestDetailModel.value.data?.skills?.decisionMaking != null
                                      ? Column(
                                          children: [
                                            Container(
                                              width: getScreenWidth(context),
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                              child: Text(
                                                "Skills",
                                                style: textTitle16WhiteBoldStyle.merge(
                                                  const TextStyle(color: sectionTitleColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: getScreenWidth(context),
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                              padding: EdgeInsets.all(10.w),
                                              decoration: boxDecoration14,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    spacing: 10,
                                                    children: [
                                                      ...(retestsController.retestDetailModel.value.data?.skills?.problemSolving != null
                                                          ? [
                                                              {
                                                                "title": "Problem Solving",
                                                                "percentage":
                                                                    retestsController.retestDetailModel.value.data?.skills?.problemSolving ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(retestsController.retestDetailModel.value.data?.skills?.creativity != null
                                                          ? [
                                                              {
                                                                "title": "Creativity",
                                                                "percentage": retestsController.retestDetailModel.value.data?.skills?.creativity ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(retestsController.retestDetailModel.value.data?.skills?.criticalThinking != null
                                                          ? [
                                                              {
                                                                "title": "Critical Thinking",
                                                                "percentage":
                                                                    retestsController.retestDetailModel.value.data?.skills?.criticalThinking ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(retestsController.retestDetailModel.value.data?.skills?.decisionMaking != null
                                                          ? [
                                                              {
                                                                "title": "Decision Making",
                                                                "percentage":
                                                                    retestsController.retestDetailModel.value.data?.skills?.decisionMaking ?? ""
                                                              }
                                                            ]
                                                          : [])
                                                    ]
                                                        .map((value) => Container(
                                                              margin: const EdgeInsets.only(top: 5),
                                                              padding: const EdgeInsets.all(5),
                                                              width: ((getScreenWidth(context) - 68) / 2),
                                                              decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(14),
                                                                ),
                                                                color: colorgray249,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                                    child: Text(
                                                                      value["percentage"].toString() + "%",
                                                                      style: textTitle14BoldStyle.merge(const TextStyle(
                                                                        color: colorSkyDark,
                                                                      )),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      value["title"].toString(),
                                                                      style: textTitle14BoldStyle
                                                                          .merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.w600)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  retestsController.retestDetailModel.value.data?.blooms?.knowledge != null ||
                                          retestsController.retestDetailModel.value.data?.blooms?.understanding != null ||
                                          retestsController.retestDetailModel.value.data?.blooms?.application != null ||
                                          retestsController.retestDetailModel.value.data?.blooms?.evaluation != null ||
                                          retestsController.retestDetailModel.value.data?.blooms?.analysis != null ||
                                          retestsController.retestDetailModel.value.data?.blooms?.creations != null
                                      ? Column(
                                          children: [
                                            Container(
                                              width: getScreenWidth(context),
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                              child: Text(
                                                "Blooms",
                                                style: textTitle16WhiteBoldStyle.merge(
                                                  const TextStyle(color: sectionTitleColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: getScreenWidth(context),
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 50.w),
                                              padding: EdgeInsets.all(10.w),
                                              decoration: boxDecoration14,
                                              child: Wrap(
                                                direction: Axis.horizontal,
                                                spacing: 10,
                                                children: [
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.knowledge != null
                                                      ? [
                                                          {
                                                            "title": "Knowledge",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.knowledge ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.understanding != null
                                                      ? [
                                                          {
                                                            "title": "Understanding",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.understanding ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.application != null
                                                      ? [
                                                          {
                                                            "title": "Application",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.application ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.evaluation != null
                                                      ? [
                                                          {
                                                            "title": "Evaluation",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.evaluation ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.analysis != null
                                                      ? [
                                                          {
                                                            "title": "Analysis",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.analysis ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(retestsController.retestDetailModel.value.data?.blooms?.creations != null
                                                      ? [
                                                          {
                                                            "title": "Creations",
                                                            "percentage": retestsController.retestDetailModel.value.data?.blooms?.creations ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                ]
                                                    .map((value) => Container(
                                                          margin: const EdgeInsets.only(top: 5),
                                                          padding: const EdgeInsets.all(5),
                                                          width: ((getScreenWidth(context) - 68) / 2),
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(14),
                                                            ),
                                                            color: colorgray249,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                                child: Text(
                                                                  value["percentage"].toString() + "%",
                                                                  style: textTitle14BoldStyle.merge(const TextStyle(
                                                                    color: colorSkyDark,
                                                                  )),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  value["title"].toString(),
                                                                  style: textTitle14BoldStyle
                                                                      .merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.w600)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(height: 128.h),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: getScreenWidth(context),
                  child: SafeArea(
                    top: false,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RetestAnswerKeyPage(
                              homeworkId: widget.homeworkId,
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
                              retestHomeworkId: widget.retestHomeworkId,
                            ),
                          ),
                        ).then((value) => {onResume()})
                      },
                      child: Container(
                        height: 46.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: const BoxDecoration(
                            // color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: colorDropShadowLight,
                                blurRadius: 1,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                            gradient: purpleGradient),
                        alignment: AlignmentDirectional.topStart,
                        child: Center(
                          child: Text("View Answer Key", style: textTitle18WhiteBoldStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(RetestDetail? retestData) {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 75.0 : 65.0;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: colorGreen,
              value: ((retestData?.correct ?? 0) * 100) / (retestData?.attempts ?? 0),
              title: '',
              radius: radius,
            );
          case 1:
            return PieChartSectionData(
              color: colorRed,
              value: ((retestData?.wrong ?? 0) * 100) / (retestData?.attempts ?? 0),
              title: '',
              radius: radius,
            );

          default:
            throw Error();
        }
      },
    );
  }
}
