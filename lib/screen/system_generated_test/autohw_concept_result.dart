import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/system_generated_test_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_retest_concept_clear.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_topic_list.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../controllers/retest_controller.dart';
import '../../model/homework_model/homework_detail.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../home/bottom_footer_navigation.dart';
import 'autohw_answer_key.dart';

class AutoHWConceptBasedResultScreenPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final bool fromRetestList;
  final bool isSelfAutoHW;

  const AutoHWConceptBasedResultScreenPage({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
    this.fromRetestList = false,
    this.isSelfAutoHW = false,
  }) : super(key: key);

  @override
  State<AutoHWConceptBasedResultScreenPage> createState() => _AutoHWConceptBasedResultScreenPageState();
}

class _AutoHWConceptBasedResultScreenPageState extends State<AutoHWConceptBasedResultScreenPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());
  final homeworkController = Get.put(HomeworkController());
  final systemGeneratedTestController = Get.put(SystemGeneratedTestController());
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
    await homeworkController.getHomeworkDetail(
      context: context,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
      isSelfAutoHW: widget.isSelfAutoHW,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    if (homeworkController.isFromNotification ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomFooterNavigation(),
        ),
      );
      homeworkController.isFromNotification = false;
    } else {
      if (!widget.fromRetestList) {
        // if (homeworkController.isFromPending ?? false) {
        //   Navigator.pop(context);
        // }
        if ((homeworkController.isFromTests ?? false)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomFooterNavigation(
                selectedIndex: (homeworkController.isFromPending ?? false) ? 1 : 2,
              ),
            ),
          );
        } else {
          if (!widget.isSelfAutoHW) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeWorkPage(
                  subjectData: homeworkController.selectedSubjectData!,
                  chapterData: homeworkController.selectedChapterData!,
                  topicOrConceptId: homeworkController.selectedTopicOrConceptId!,
                  type: homeworkController.selectedType!,
                  tab: (homeworkController.isFromPending ?? false) ? 0 : 1,
                ),
              ),
            );
          }
        }
      }
    }
    return true;
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
                    homeworkController.loading.isTrue || homeworkController.homeworkDetailModel.value.data == null
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
                                                sections: showingSections(homeworkController.homeworkDetailModel.value.data),
                                                // sections: showingSections(),
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
                                                        homeworkController.homeworkDetailModel.value.data?.attempts?.toString() ?? "0",
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
                                                        homeworkController.homeworkDetailModel.value.data?.correct?.toString() ?? "0",
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
                                                        homeworkController.homeworkDetailModel.value.data?.wrong?.toString() ?? "0",
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
                                                  (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (homeworkController.homeworkDetailModel.value.data?.concepts ?? [])
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
                                                  (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (homeworkController.homeworkDetailModel.value.data?.concepts ?? [])
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
                                                  (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (homeworkController.homeworkDetailModel.value.data?.concepts ?? [])
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
                                                  (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).isNotEmpty
                                                      ? (homeworkController.homeworkDetailModel.value.data?.concepts ?? [])
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
                                  (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).isNotEmpty
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
                                                children:
                                                    homeworkController.homeworkDetailModel.value.data!.concepts!.mapIndexed((position, preConcepts) {
                                              return Container(
                                                // height: 78,
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
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Wrap(
                                                            direction: Axis.horizontal,
                                                            spacing: 10,
                                                            children: preConcepts.keyLearnings!
                                                                .map(
                                                                  (keyLearningData) => Container(
                                                                    margin: EdgeInsets.only(top: 5.h),
                                                                    padding: const EdgeInsets.all(5),
                                                                    width: ((getScreenWidth(context) - 100) / 2).w,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: const BorderRadius.all(
                                                                        Radius.circular(14),
                                                                      ),
                                                                      border: Border.all(color: const Color(0xfff0f0f0)),

                                                                      // color: keyLearningData.cleared == true ? colorGreenLight : colorRedLight,
                                                                      color: colorgray249,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          height: 16.h,
                                                                          width: 16.h,
                                                                          margin: EdgeInsets.only(right: 5.w),
                                                                          alignment: AlignmentDirectional.center,
                                                                          decoration: const BoxDecoration(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(8),
                                                                            ),
                                                                          ),
                                                                          child: keyLearningData.cleared == true
                                                                              ? SvgPicture.asset(
                                                                                  imageAssets + 'donebutton.svg',
                                                                                  height: 10.h,
                                                                                  width: 10.h,
                                                                                  color: colorGDGreenDark,
                                                                                )
                                                                              : SvgPicture.asset(imageAssets + 'closebutton.svg',
                                                                                  height: 8.h, width: 8.h, color: colorGDRedDark),
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                            keyLearningData.keyLearning?.name?.enUs ?? "",
                                                                            style: textTitle12BoldStyle.merge(const TextStyle(
                                                                                color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
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
                                                        ),
                                                        Column(
                                                          children: [
                                                            Container(
                                                                height: 20.h,
                                                                width: 20.h,
                                                                margin: EdgeInsets.only(right: 5.w),
                                                                alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  gradient: preConcepts.cleared == true ? greenGradient : redGradient,
                                                                ),
                                                                child: preConcepts.cleared == true
                                                                    ? SvgPicture.asset(
                                                                        imageAssets + 'donebutton.svg',
                                                                        height: 14.h,
                                                                        width: 14.h,
                                                                      )
                                                                    : SvgPicture.asset(
                                                                        imageAssets + 'closebutton.svg',
                                                                        height: 8.h,
                                                                        width: 8.h,
                                                                      )),
                                                            SizedBox(height: 10.w),
                                                            Text(
                                                              'Clarity ${preConcepts.clarity.toString()}%',
                                                              textAlign: TextAlign.center,
                                                              style: textTitle12BoldStyle
                                                                  .merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 6.w),
                                                            preConcepts.cleared == true
                                                                ? Container()
                                                                : !(homeworkController.homeworkDetailModel.value.data?.hasRetest ?? false)
                                                                    ? GestureDetector(
                                                                        behavior: HitTestBehavior.opaque,
                                                                        onTap: () => {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => AutoHWReTestConceptClear(
                                                                                retestResult: (homeworkController.homeworkDetailModel.value.data
                                                                                        ?.retestResultList?[position] ??
                                                                                    RetestResult()),
                                                                                title: preConcepts.concept?.name?.enUs?.toString() ?? "",
                                                                                chapterId: widget.chapterId,
                                                                                subjectId: widget.subjectId,
                                                                                topicId: homeworkController
                                                                                    .homeworkDetailModel.value.data!.topics![0].topic.id,
                                                                                topicType: homeworkController
                                                                                    .homeworkDetailModel.value.data!.topics![0].type
                                                                                    .toString(),
                                                                                topicName: homeworkController
                                                                                    .homeworkDetailModel.value.data!.topics![0].topic.name,
                                                                                homeworkId: widget.homeworkId,
                                                                                isSelfAutoHW: widget.isSelfAutoHW,
                                                                                type: homeworkController.selectedType!,
                                                                                isOngoing: false,
                                                                              ),
                                                                            ),
                                                                          ).then(
                                                                            (value) {
                                                                              onResume();
                                                                            },
                                                                          )
                                                                        },
                                                                        child: Container(
                                                                          height: 22.h,
                                                                          decoration: const BoxDecoration(
                                                                              // color: Colors.amber,
                                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
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
                                                                          child: Row(
                                                                            children: [
                                                                              Center(
                                                                                  child: Padding(
                                                                                padding: const EdgeInsets.only(left: 4, right: 4),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text("Clear Now", style: textTitle12BoldStyle),
                                                                                    const SizedBox(
                                                                                      width: 2,
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.arrow_forward,
                                                                                      color: Colors.white,
                                                                                      size: 16,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList()),
                                          ],
                                        )
                                      : Container(),
                                  homeworkController.homeworkDetailModel.value.data?.skills?.problemSolving != null ||
                                          homeworkController.homeworkDetailModel.value.data?.skills?.creativity != null ||
                                          homeworkController.homeworkDetailModel.value.data?.skills?.criticalThinking != null ||
                                          homeworkController.homeworkDetailModel.value.data?.skills?.decisionMaking != null
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
                                                      ...(homeworkController.homeworkDetailModel.value.data?.skills?.problemSolving != null
                                                          ? [
                                                              {
                                                                "title": "Problem Solving",
                                                                "percentage":
                                                                    homeworkController.homeworkDetailModel.value.data?.skills?.problemSolving ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(homeworkController.homeworkDetailModel.value.data?.skills?.creativity != null
                                                          ? [
                                                              {
                                                                "title": "Creativity",
                                                                "percentage":
                                                                    homeworkController.homeworkDetailModel.value.data?.skills?.creativity ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(homeworkController.homeworkDetailModel.value.data?.skills?.criticalThinking != null
                                                          ? [
                                                              {
                                                                "title": "Critical Thinking",
                                                                "percentage":
                                                                    homeworkController.homeworkDetailModel.value.data?.skills?.criticalThinking ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(homeworkController.homeworkDetailModel.value.data?.skills?.decisionMaking != null
                                                          ? [
                                                              {
                                                                "title": "Decision Making",
                                                                "percentage":
                                                                    homeworkController.homeworkDetailModel.value.data?.skills?.decisionMaking ?? ""
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
                                  homeworkController.homeworkDetailModel.value.data?.blooms?.knowledge != null ||
                                          homeworkController.homeworkDetailModel.value.data?.blooms?.understanding != null ||
                                          homeworkController.homeworkDetailModel.value.data?.blooms?.application != null ||
                                          homeworkController.homeworkDetailModel.value.data?.blooms?.evaluation != null ||
                                          homeworkController.homeworkDetailModel.value.data?.blooms?.analysis != null ||
                                          homeworkController.homeworkDetailModel.value.data?.blooms?.creations != null
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
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.knowledge != null
                                                      ? [
                                                          {
                                                            "title": "Knowledge",
                                                            "percentage": homeworkController.homeworkDetailModel.value.data?.blooms?.knowledge ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.understanding != null
                                                      ? [
                                                          {
                                                            "title": "Understanding",
                                                            "percentage":
                                                                homeworkController.homeworkDetailModel.value.data?.blooms?.understanding ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.application != null
                                                      ? [
                                                          {
                                                            "title": "Application",
                                                            "percentage":
                                                                homeworkController.homeworkDetailModel.value.data?.blooms?.application ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.evaluation != null
                                                      ? [
                                                          {
                                                            "title": "Evaluation",
                                                            "percentage": homeworkController.homeworkDetailModel.value.data?.blooms?.evaluation ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.analysis != null
                                                      ? [
                                                          {
                                                            "title": "Analysis",
                                                            "percentage": homeworkController.homeworkDetailModel.value.data?.blooms?.analysis ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(homeworkController.homeworkDetailModel.value.data?.blooms?.creations != null
                                                      ? [
                                                          {
                                                            "title": "Creations",
                                                            "percentage": homeworkController.homeworkDetailModel.value.data?.blooms?.creations ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                ]
                                                    .map(
                                                      (value) => Container(
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
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                      height: (homeworkController.homeworkDetailModel.value.data?.cleared ?? false) ||
                                              widget.fromRetestList ||
                                              !(homeworkController.homeworkDetailModel.value.data?.hasRetest ?? false)
                                          ? 128.h
                                          : 64.h),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  width: getScreenWidth(context),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          !(homeworkController.homeworkDetailModel.value.data?.cleared ?? false)
                              ? !(homeworkController.homeworkDetailModel.value.data?.clearedRetest ?? false)
                                  ? !widget.fromRetestList
                                      ? GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => RetestConceptTopicList(
                                            //         homeworkId: widget.homeworkId,
                                            //         subjectId: widget.subjectId,
                                            //         chapterId: widget.chapterId,
                                            //         topicOrConcept: "concept",
                                            //         isSelfAutoHW: widget.isSelfAutoHW),
                                            //   ),
                                            // ).then((value) {
                                            //   onResume();
                                            showRetestSelectionDialog()
                                            //   Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) => AutoHWRetestConceptBasedResultScreenPage(
                                            //         homeworkId: widget.homeworkId,
                                            //         subjectId: widget.subjectId,
                                            //         chapterId: widget.chapterId,
                                            //       ),
                                            //     ),
                                            //   );
                                            // })
                                          },
                                          child: Container(
                                            height: 36.h,
                                            margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                                              gradient: pinkGradient,
                                            ),
                                            alignment: AlignmentDirectional.topStart,
                                            child: Center(
                                              child: Text(
                                                "Retest",
                                                style: textTitle18WhiteBoldStyle,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox()
                              : const SizedBox(),
                          (homeworkController.homeworkDetailModel.value.data?.cleared ?? false) ||
                                  widget.fromRetestList ||
                                  !(homeworkController.homeworkDetailModel.value.data?.hasRetest ?? false)
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AutoHWAnswerKeyPage(
                                            homeworkId: widget.homeworkId, subjectId: widget.subjectId, chapterId: widget.chapterId),
                                      ),
                                    ).then((value) => {onResume()})
                                  },
                                  child: Container(
                                    height: 36.h,
                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                                )
                              : const SizedBox(),
                        ],
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

  showRetestSelectionDialog() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          backgroundColor: Colors.grey.shade200,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: showClearRetestDialogScreen(
            retestResult: (homeworkController.homeworkDetailModel.value.data?.retestResultList ?? []),
            chapterId: widget.chapterId,
            homeworkId: widget.homeworkId,
            isSelfAutoHW: widget.isSelfAutoHW,
            subjectId: widget.subjectId,
            topicOrConcept: "concept",
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(HomeworkDetail? homeworkData) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 75.0 : 65.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colorGreen,
            value: ((homeworkData?.correct ?? 0) * 100) / (homeworkData?.attempts ?? 0),
            title: '',
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: colorRed,
            value: ((homeworkData?.wrong ?? 0) * 100) / (homeworkData?.attempts ?? 0),
            title: '',
            radius: radius,
          );

        default:
          throw Error();
      }
    });
  }
}

// ignore: camel_case_types
class showClearRetestDialogScreen extends StatefulWidget {
  const showClearRetestDialogScreen(
      {Key? key,
      required this.retestResult,
      required this.homeworkId,
      required this.subjectId,
      required this.chapterId,
      required this.isSelfAutoHW,
      required this.topicOrConcept})
      : super(key: key);
  final List<RetestResult>? retestResult;
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final bool isSelfAutoHW;
  final String topicOrConcept;

  @override
  State<showClearRetestDialogScreen> createState() => _showClearRetestDialogScreenState();
}

// ignore: camel_case_types
class _showClearRetestDialogScreenState extends State<showClearRetestDialogScreen> {
  List<RetestResult>? retestResultList = [];
  List<String>? isAllConceptCheckedList = [];

  @override
  void initState() {
    super.initState();

    (widget.retestResult ?? []).map((retestData) {
      if (retestData.cleared == false) {
        RetestResult retestResult = RetestResult();
        retestResult.id = retestData.id;
        retestResult.cleared = retestData.cleared;
        retestResult.concept = retestData.concept;
        retestResult.clarity = retestData.clarity;
        retestResult.clearedAt = retestData.clearedAt;
        List<KeyLearning> keyLearningList = [];
        (retestData.keyLearnings ?? []).map((keyLearningData) {
          if (keyLearningData.cleared == false) {
            KeyLearning keyLearning = KeyLearning();
            keyLearning.id = keyLearningData.id;
            keyLearning.cleared = keyLearningData.cleared;
            keyLearning.clearedAt = keyLearningData.clearedAt;
            keyLearning.keyLearning = keyLearningData.keyLearning;
            keyLearningList.add(keyLearning);
          }
        }).toList();
        retestResult.keyLearnings = keyLearningList;
        retestResultList?.add(retestResult);
        isAllConceptCheckedList?.add("-1");
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Column(
          children: [
            Container(
              width: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 40.h,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  alignment: Alignment.centerLeft,
                  color: const Color(0xffF9F6F8),
                  child: Text(
                    'Select Concept & Keylearning',
                    style: textTitle18WhiteBoldStyle.merge(
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sectionTitleColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: (retestResultList?.length ?? 0),
                      itemBuilder: ((context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: colorGDTealLight.withOpacity(0.1),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (isAllConceptCheckedList?[index] == "-1") {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = true;
                                                retestResultList?[index].cleared = true;
                                                isAllConceptCheckedList?[index] = "1";
                                              });
                                            }).toList();
                                          } else if (isAllConceptCheckedList?[index] == "0") {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = true;
                                                retestResultList?[index].cleared = true;
                                                isAllConceptCheckedList?[index] = "1";
                                              });
                                            }).toList();
                                          } else {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = false;
                                                retestResultList?[index].cleared = false;
                                                isAllConceptCheckedList?[index] = "-1";
                                              });
                                            }).toList();
                                          }
                                        },
                                        child: Icon(
                                            isAllConceptCheckedList?[index] == "1"
                                                ? Icons.check_box
                                                : isAllConceptCheckedList?[index] == "0"
                                                    ? Icons.indeterminate_check_box
                                                    : Icons.crop_square,
                                            color: colorGDTealLight),
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          (retestResultList?[index].concept?.name?.enUs.toString() ?? ""),
                                          style: textTitle18WhiteBoldStyle.merge(
                                            const TextStyle(fontWeight: FontWeight.bold, color: colorGDTealLight),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 26.w),
                                  child: Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: (retestResultList?[index].keyLearnings ?? []).mapIndexed((i, item) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Row(
                                            children: [
                                              Theme(
                                                data: ThemeData(unselectedWidgetColor: colorPurple),
                                                child: Checkbox(
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    value: item.cleared,
                                                    activeColor: colorPurple,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        item.cleared = val!;
                                                      });

                                                      Iterable<KeyLearning> list =
                                                          (retestResultList?[index].keyLearnings ?? []).where((element) => element.cleared! == false);

                                                      if (list.isEmpty) {
                                                        setState(() {
                                                          retestResultList?[index].cleared = true;
                                                          isAllConceptCheckedList![index] = "1";
                                                        });
                                                      } else if (list.length == retestResultList?[index].keyLearnings?.length) {
                                                        setState(() {
                                                          retestResultList?[index].cleared = false;
                                                          isAllConceptCheckedList?[index] = "-1";
                                                        });
                                                      } else {
                                                        setState(() {
                                                          retestResultList?[index].cleared = true;
                                                          isAllConceptCheckedList?[index] = "0";
                                                        });
                                                      }
                                                    }),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  (retestResultList?[index].keyLearnings?[i].keyLearning?.name?.enUs.toString() ?? ""),
                                                  style: textTitle14StyleMediumPoppins,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                )
                              ],
                            ),
                          ],
                        );
                      })),
                )
              ]),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 35.h,
                        width: 100.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: colorBlue400.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          const Icon(
                            Icons.cancel,
                            color: colorBlueDark,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text('Cancel', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold, color: colorBlueDark)))
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((isAllConceptCheckedList ?? []).where((element) => element == "1" || element == "0").toList().isNotEmpty) {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RetestConceptTopicList(
                                homeworkId: widget.homeworkId,
                                subjectId: widget.subjectId,
                                chapterId: widget.chapterId,
                                topicOrConcept: widget.topicOrConcept,
                                isSelfAutoHW: widget.isSelfAutoHW,
                                retestResultList: retestResultList,
                                isFromRoadMapResult: true,
                              ),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(msg: "Select at-least one key-learning.");
                        }
                      },
                      child: Container(
                        height: 35.h,
                        width: 115.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: colorBlueDark,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          Text('Give Retest', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 10.w,
                          ),
                          SvgPicture.asset(
                            imageAssets + 'tests/start_rocket.svg',
                            height: 20,
                            width: 20,
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
