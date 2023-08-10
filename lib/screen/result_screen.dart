import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/refresh_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/precapdata.dart';
import 'package:saarthi_pedagogy_studentapp/screen/precap_answer_key.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../controllers/learn_controller.dart';
import '../model/chapters_model/datum.dart';
import '../model/subject_model/datum.dart';
import '../theme/colors.dart';
import '../theme/style.dart';
import 'home/bottom_footer_navigation.dart';

class ResultScreenPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chaptersData;
  final bool isFromTests;

  const ResultScreenPage({
    Key? key,
    required this.subjectData,
    required this.chaptersData,
    this.isFromTests = false,
  }) : super(key: key);

  @override
  State<ResultScreenPage> createState() => _ResultScreenPageState();
}

class _ResultScreenPageState extends State<ResultScreenPage> with SingleTickerProviderStateMixin {
  final precapController = Get.put(PrecapController());
  final dashBoardController = Get.put(LearnController());
  var refreshController = Get.put(RefreshController());
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      precapController.getPrecapData(subjectData: widget.subjectData, chaptersData: widget.chaptersData);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    refreshController.refreshRoadmapData();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    if (precapController.isFromPending ?? false) {
      Navigator.pop(context);
    }
    if (widget.isFromTests) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomFooterNavigation(
            selectedIndex: (precapController.isFromPending ?? false) ? 1 : 2,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoadmapPage(
            subjectData: precapController.subjectData,
            chaptersData: precapController.chaptersData,
          ),
        ),
      );
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
                    precapController.loading.isTrue
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
                                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                                    setState(() {
                                                      if (!event.isInterestedForInteractions ||
                                                          pieTouchResponse == null ||
                                                          pieTouchResponse.touchedSection == null) {
                                                        touchedIndex = -1;
                                                        return;
                                                      }
                                                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                    });
                                                  },
                                                ),
                                                // startDegreeOffset: 180,
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 0,
                                                sections: precapController.preCapModel.value.precapData != null
                                                    ? showingSections(precapController.preCapModel.value.precapData!)
                                                    : [],
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
                                                  margin: EdgeInsets.only(top: 6.h, left: 20.w),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 10.w),
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
                                                        precapController.preCapModel.value.precapData?.attempts?.toString() ?? "0",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: sectionTitleColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Container(
                                                  margin: EdgeInsets.only(top: 6.h, left: 20.w),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 10.w),
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
                                                        precapController.preCapModel.value.precapData?.correct?.toString() ?? "0",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: sectionTitleColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Container(
                                                  margin: EdgeInsets.only(top: 6.h, left: 20.w),
                                                  height: 30.h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            margin: EdgeInsets.only(right: 10.w),
                                                            decoration: const BoxDecoration(
                                                              gradient: redGradient,
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(7),
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
                                                        precapController.preCapModel.value.precapData?.wrong?.toString() ?? "0",
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
                                                  precapController.preCapModel.value.precapData?.preConcepts != null
                                                      ? precapController.preCapModel.value.precapData!.preConcepts!
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
                                                  precapController.preCapModel.value.precapData?.preConcepts != null
                                                      ? precapController.preCapModel.value.precapData!.preConcepts!
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
                                                  precapController.preCapModel.value.precapData?.preConcepts != null
                                                      ? precapController.preCapModel.value.precapData!.preConcepts!
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
                                                  precapController.preCapModel.value.precapData?.preConcepts != null
                                                      ? precapController.preCapModel.value.precapData!.preConcepts!
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
                                  Container(
                                    width: getScreenWidth(context),
                                    margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                    child: Text(
                                      "Pre concepts",
                                      style: textTitle18WhiteBoldStyle.merge(
                                        const TextStyle(color: sectionTitleColor),
                                      ),
                                    ),
                                  ),
                                  Column(
                                      children: (precapController.preCapModel.value.precapData?.preConcepts ?? [])
                                          .map(
                                            (preConcepts) => Container(
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
                                                                fontWeight: FontWeight.normal),
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
                                                                        const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
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
                                  precapController.preCapModel.value.precapData?.skills?.problemSolving != null ||
                                          precapController.preCapModel.value.precapData?.skills?.creativity != null ||
                                          precapController.preCapModel.value.precapData?.skills?.criticalThinking != null ||
                                          precapController.preCapModel.value.precapData?.skills?.decisionMaking != null
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
                                                      ...(precapController.preCapModel.value.precapData?.skills?.problemSolving != null
                                                          ? [
                                                              {
                                                                "title": "Problem Solving",
                                                                "percentage":
                                                                    precapController.preCapModel.value.precapData?.skills?.problemSolving ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(precapController.preCapModel.value.precapData?.skills?.creativity != null
                                                          ? [
                                                              {
                                                                "title": "Creativity",
                                                                "percentage": precapController.preCapModel.value.precapData?.skills?.creativity ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(precapController.preCapModel.value.precapData?.skills?.criticalThinking != null
                                                          ? [
                                                              {
                                                                "title": "Critical Thinking",
                                                                "percentage":
                                                                    precapController.preCapModel.value.precapData?.skills?.criticalThinking ?? ""
                                                              }
                                                            ]
                                                          : []),
                                                      ...(precapController.preCapModel.value.precapData?.skills?.decisionMaking != null
                                                          ? [
                                                              {
                                                                "title": "Decision Making",
                                                                "percentage":
                                                                    precapController.preCapModel.value.precapData?.skills?.decisionMaking ?? ""
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
                                  precapController.preCapModel.value.precapData?.blooms?.knowledge != null ||
                                          precapController.preCapModel.value.precapData?.blooms?.understanding != null ||
                                          precapController.preCapModel.value.precapData?.blooms?.application != null ||
                                          precapController.preCapModel.value.precapData?.blooms?.evaluation != null ||
                                          precapController.preCapModel.value.precapData?.blooms?.analysis != null ||
                                          precapController.preCapModel.value.precapData?.blooms?.creations != null
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
                                              margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 46.h),
                                              padding: EdgeInsets.all(10.w),
                                              decoration: boxDecoration14,
                                              child: Wrap(
                                                direction: Axis.horizontal,
                                                spacing: 10,
                                                children: [
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.knowledge != null
                                                      ? [
                                                          {
                                                            "title": "Knowledge",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.knowledge ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.understanding != null
                                                      ? [
                                                          {
                                                            "title": "Understanding",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.understanding ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.application != null
                                                      ? [
                                                          {
                                                            "title": "Application",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.application ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.evaluation != null
                                                      ? [
                                                          {
                                                            "title": "Evaluation",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.evaluation ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.analysis != null
                                                      ? [
                                                          {
                                                            "title": "Analysis",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.analysis ?? "",
                                                          }
                                                        ]
                                                      : []),
                                                  ...(precapController.preCapModel.value.precapData?.blooms?.creations != null
                                                      ? [
                                                          {
                                                            "title": "Creations",
                                                            "percentage": precapController.preCapModel.value.precapData?.blooms?.creations ?? "",
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
                                  SizedBox(height: 64.h),
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
                            builder: (context) => const PrecapAnswerKeyPage(),
                          ),
                        )
                      },
                      child: Container(
                        height: 46.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

  List<PieChartSectionData> showingSections(PrecapData precapData) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 75.0 : 65.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colorGreen,
            value: ((precapData.correct ?? 0) * 100) / precapData.attempts!,
            title: '',
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: colorRed,
            value: ((precapData.wrong ?? 0) * 100) / precapData.attempts!,
            title: '',
            radius: radius,
          );
        // case 2:
        //   return PieChartSectionData(
        //     color: const Color(0xff845bef),
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize,
        //         fontWeight: FontWeight.bold,
        //         color: const Color(0xffffffff)),
        //   );
        // case 3:
        //   return PieChartSectionData(
        //     color: const Color(0xff13d38e),
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize,
        //         fontWeight: FontWeight.bold,
        //         color: const Color(0xffffffff)),
        //   );
        default:
          throw Error();
      }
    });
  }
}
