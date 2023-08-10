import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../home/bottom_footer_navigation.dart';
import 'online_test_answerkey.dart';

class HWOnlineTestResultPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String homeworkId;

  const HWOnlineTestResultPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkId,
  }) : super(key: key);

  @override
  State<HWOnlineTestResultPage> createState() => _HWOnlineTestResultPageState();
}

class _HWOnlineTestResultPageState extends State<HWOnlineTestResultPage> with SingleTickerProviderStateMixin {
  final homeworkController = Get.put(HomeworkController());

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
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
      subjectId: widget.subjectId,
      context: context,
    );

    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    if (homeworkController.isFromPending ?? false) {
      Navigator.pop(context);
    }
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
                                                sections: showingSectionsHomework(homeworkController.homeworkDetailModel.value.data),
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
                            builder: (context) => HWOnlineTestAnswerKey(
                              homeworkId: widget.homeworkId,
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
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

  List<PieChartSectionData> showingSectionsHomework(HomeworkDetail? homeworkData) {
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
