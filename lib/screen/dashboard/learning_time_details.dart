// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/dashboard_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/screen/dashboard/your_learning_time_details.dart';
import '../../model/dashboard/learnig_time_temp_modal.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/loading_spinner.dart';
import '../../widgets/dashboard/charts/single_bar_chart.dart';

class LearningTimeDetailsPage extends StatelessWidget {
  const LearningTimeDetailsPage({Key? key}) : super(key: key);

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YourLearningTimeDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: HeaderCard(
                    backEnabled: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: "Learning Time",
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     _navigateTopage(context);
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(right: 10.w),
                //     padding: EdgeInsets.all(5.w),
                //     decoration: BoxDecoration(color: colorBlue600, borderRadius: BorderRadius.circular(5.w)),
                //     child: Row(
                //       children: [
                //         Text(
                //           "Check Yourself",
                //           style: textTitle10StylePoppins.merge(
                //             const TextStyle(color: Colors.white),
                //           ),
                //         ),
                //         const Icon(
                //           Icons.arrow_forward,
                //           color: Colors.white,
                //           size: 15,
                //         )
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LearningTimeTempChart(),
                      SizedBox(
                        height: 10.h,
                      ),
                      // CommingSoon(child: _LearningTimeSubjectsCharts()),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // CommingSoon(child: _LearningTimeChapterChart()),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // CommingSoon(child: __LearningTimeTimeReportsTable())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LearningTimeTempChart extends StatefulWidget {
  @override
  State<_LearningTimeTempChart> createState() => _LearningTimeTempChartState();
}

class _LearningTimeTempChartState extends State<_LearningTimeTempChart> {
  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _dashboardController.getLearningTimeTempChart();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: const [
              BoxShadow(
                color: colorDropShadow,
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() {
            if (_dashboardController.learningTimeTempLoading.isTrue) {
              return const Align(
                alignment: Alignment.center,
                child: LoadingSpinner(),
              );
            } else {
              LearningTimeTempChartModal learningTimeTempData = _dashboardController.learningTimeTempData.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Chapters",
                  //   style: textTitle14StylePoppins.merge(
                  //     const TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: SingleBarChartWidget(
                      chartLegendTitle: "Time(mins.)",
                      bottomChartLegendTitle: "Date",
                      isValueInPercentage: false,
                      gradinentColors: const [
                        skyGradientC1,
                        skyGradientC2,
                      ],
                      // ,
                      singleBarChartData: (learningTimeTempData.chartData ?? []).map((e) {
                        return SingleBarChartWidgetDataModal(
                          name: formatedDate(e.date ?? DateTime.now(), formate: 'dd/MM'),
                          value: convertSecToMinute(e.value ?? 0),
                        );
                      }).toList(),
                    ),
                  )
                ],
              );
            }
          }),
        ),
      ],
    );
  }
}

class _LearningTimeSubjectsCharts extends StatefulWidget {
  @override
  State<_LearningTimeSubjectsCharts> createState() => _LearningTimeSubjectsChartsState();
}

class _LearningTimeSubjectsChartsState extends State<_LearningTimeSubjectsCharts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: const [
            BoxShadow(
              color: colorDropShadow,
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subjects",
              style: textTitle14StylePoppins.merge(
                const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            AspectRatio(
              aspectRatio: 1.5,
              child: SingleBarChartWidget(
                chartLegendTitle: "Time(mins.)",
                isValueInPercentage: true,
                gradinentColors: const [
                  purpleGradient1,
                  purpleGradinet2,
                ],
                singleBarChartData: [
                  SingleBarChartWidgetDataModal(name: "Eng", value: 28),
                  SingleBarChartWidgetDataModal(name: "Math", value: 50),
                  SingleBarChartWidgetDataModal(name: "Sci", value: 62),
                  SingleBarChartWidgetDataModal(name: "SST", value: 70),
                  SingleBarChartWidgetDataModal(name: "Hin", value: 79),
                  SingleBarChartWidgetDataModal(name: "Guj", value: 92),
                  SingleBarChartWidgetDataModal(name: "Comp", value: 92),
                ],
                onBarPress: (index) {},
              ),
            ),
          ],
        ));
  }
}

class _LearningTimeChapterChart extends StatefulWidget {
  @override
  State<_LearningTimeChapterChart> createState() => _LearningTimeChapterChartState();
}

class _LearningTimeChapterChartState extends State<_LearningTimeChapterChart> {
  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dashboardController.learningTimeChapterData.value.subjectName ?? "",
          style: textTitle16WhiteBoldStyle.merge(
            const TextStyle(
              fontWeight: FontWeight.bold,
              color: colorHeaderTextColor,
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: const [
              BoxShadow(
                color: colorDropShadow,
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chapters",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              AspectRatio(
                aspectRatio: 1.5,
                child: SingleBarChartWidget(
                  chartLegendTitle: "Time(mins.)",
                  bottomChartLegendTitle: "Chapter no.",
                  isValueInPercentage: false,
                  gradinentColors: const [
                    skyGradientC1,
                    skyGradientC2,
                  ],
                  singleBarChartData: [
                    SingleBarChartWidgetDataModal(name: "1", value: 28),
                    SingleBarChartWidgetDataModal(name: "2", value: 50),
                    SingleBarChartWidgetDataModal(name: "3", value: 62),
                    SingleBarChartWidgetDataModal(name: "4", value: 70),
                    SingleBarChartWidgetDataModal(name: "5", value: 79),
                    SingleBarChartWidgetDataModal(name: "6", value: 92),
                    SingleBarChartWidgetDataModal(name: "7", value: 92),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class __LearningTimeTimeReportsTable extends StatelessWidget {
  final List d = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chapter 1 - Real Numbers",
          style: textTitle16WhiteBoldStyle.merge(
            const TextStyle(color: colorHeaderTextColor),
          ),
        ),
        Text(
          "(Time in minutes)",
          style: textTitle12StylePoppins.merge(
            const TextStyle(color: colorGrey400),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        const _LearningTimeTimeReportsTableItemCard(
          chNo: "Ch No.",
          chapterName: "Chapter Name",
          yourBookValue: "Time spent",
          yourTestValue: "Time spent",
          yourVideoValue: "Time spent",
          classBookValue1: "Avg\ntime",
          classBookValue2: "Topper\ntime",
          classVideoValue1: "Avg\ntime",
          classVideoValue2: "Topper\ntime",
          classTestValue1: "Avg\ntime",
          classTestValue2: "Topper\ntime",
          saarthiBookValue1: "Avg\ntime",
          saarthiBookValue2: "Topper\ntime",
          saarthiVideoValue1: "Avg\ntime",
          saarthiVideoValue2: "Topper\ntime",
          saarthiTestValue1: "Avg\ntime",
          saarthiTestValue2: "Topper\ntime",
          isHeaderCard: true,
        ),
        ...d.map((e) {
          int index = d.indexOf(e);
          return _LearningTimeTimeReportsTableItemCard(
            chNo: (index + 1).toString(),
            chapterName: "Chapter Name",
            yourBookValue: getRandomToMaxNumber(20).toString(),
            yourTestValue: getRandomToMaxNumber(70).toString(),
            yourVideoValue: getRandomToMaxNumber(70).toString(),
            classBookValue1: getRandomToMaxNumber(80).toString(),
            classBookValue2: getRandomToMaxNumber(75).toString(),
            classVideoValue1: getRandomToMaxNumber(95).toString(),
            classVideoValue2: getRandomToMaxNumber(72).toString(),
            classTestValue1: getRandomToMaxNumber(66).toString(),
            classTestValue2: getRandomToMaxNumber(55).toString(),
            saarthiBookValue1: getRandomToMaxNumber(74).toString(),
            saarthiBookValue2: getRandomToMaxNumber(35).toString(),
            saarthiVideoValue1: getRandomToMaxNumber(75).toString(),
            saarthiVideoValue2: getRandomToMaxNumber(99).toString(),
            saarthiTestValue1: getRandomToMaxNumber(22).toString(),
            saarthiTestValue2: getRandomToMaxNumber(45).toString(),
            isHeaderCard: false,
          );
        }).toList()
      ],
    );
  }
}

class _LearningTimeTimeReportsTableItemCard extends StatelessWidget {
  const _LearningTimeTimeReportsTableItemCard({
    Key? key,
    required this.chNo,
    required this.chapterName,
    required this.yourBookValue,
    required this.yourVideoValue,
    required this.yourTestValue,
    required this.classBookValue1,
    required this.classBookValue2,
    required this.classVideoValue1,
    required this.classVideoValue2,
    required this.classTestValue1,
    required this.classTestValue2,
    required this.saarthiBookValue1,
    required this.saarthiBookValue2,
    required this.saarthiVideoValue1,
    required this.saarthiVideoValue2,
    required this.saarthiTestValue1,
    required this.saarthiTestValue2,
    required this.isHeaderCard,
  }) : super(key: key);

  final String chNo;
  final String chapterName;
  final String yourBookValue;
  final String yourVideoValue;
  final String yourTestValue;
  final String classBookValue1;
  final String classBookValue2;
  final String classVideoValue1;
  final String classVideoValue2;
  final String classTestValue1;
  final String classTestValue2;
  final String saarthiBookValue1;
  final String saarthiBookValue2;
  final String saarthiVideoValue1;
  final String saarthiVideoValue2;
  final String saarthiTestValue1;
  final String saarthiTestValue2;
  final bool isHeaderCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: const [
          BoxShadow(
            color: colorDropShadow,
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  chNo,
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  chapterName,
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Column(
            children: [
              const _LearningTimeTimeReportsTableHeaderRow(),
              const Divider(
                height: 0,
              ),
              _LearningTimeTimeReportsTableSingleRow(
                bgColor: colorSky50,
                bookValue: yourBookValue,
                videoValue: yourVideoValue,
                testsValue: yourTestValue,
                isHeaderCard: isHeaderCard,
              ),
              const Divider(
                height: 0,
              ),
              _LearningTimeTimeReportsTableMultiRow(
                bgColor: colorYellow50,
                rowTitleColor: colorYellow600,
                title: "Class",
                bookValue1: classBookValue1,
                bookValue2: classBookValue2,
                videoValue1: classVideoValue1,
                videoValue2: classVideoValue2,
                testValue1: classTestValue1,
                testValue2: classTestValue2,
                isHeaderCard: isHeaderCard,
                isLastRow: false,
              ),
              const Divider(
                height: 0,
              ),
              _LearningTimeTimeReportsTableMultiRow(
                bgColor: colorGreen50,
                rowTitleColor: colorGreen600,
                title: "Saarthi",
                bookValue1: saarthiBookValue1,
                bookValue2: saarthiBookValue2,
                videoValue1: saarthiVideoValue1,
                videoValue2: saarthiVideoValue2,
                testValue1: saarthiTestValue1,
                testValue2: saarthiTestValue2,
                isHeaderCard: isHeaderCard,
                isLastRow: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _LearningTimeTimeReportsTableHeaderRow extends StatelessWidget {
  const _LearningTimeTimeReportsTableHeaderRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              " ",
              style: textTitle14StylePoppins.merge(
                const TextStyle(fontWeight: FontWeight.w500, color: colorGrey400),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                "Book",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(fontWeight: FontWeight.w500, color: colorGrey400),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                "Video",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(fontWeight: FontWeight.w500, color: colorGrey400),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                "Tests",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(fontWeight: FontWeight.w500, color: colorGrey400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningTimeTimeReportsTableMultiRow extends StatelessWidget {
  const _LearningTimeTimeReportsTableMultiRow({
    Key? key,
    required this.bgColor,
    required this.rowTitleColor,
    required this.title,
    required this.bookValue1,
    required this.bookValue2,
    required this.videoValue1,
    required this.videoValue2,
    required this.testValue1,
    required this.testValue2,
    required this.isHeaderCard,
    required this.isLastRow,
  }) : super(key: key);

  final Color bgColor;
  final Color rowTitleColor;
  final String title;
  final String bookValue1;
  final String bookValue2;
  final String videoValue1;
  final String videoValue2;
  final String testValue1;
  final String testValue2;
  final bool isHeaderCard;
  final bool isLastRow;

  TextStyle _getFontStyle() {
    if (isHeaderCard) {
      return textTitle10StylePoppins.merge(
        const TextStyle(fontWeight: FontWeight.w500, color: colorGrey600),
      );
    } else {
      return textTitle16StylePoppins.merge(
        const TextStyle(color: colorGrey600),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          bottomLeft: isLastRow ? Radius.circular(12.w) : const Radius.circular(0),
          bottomRight: isLastRow ? Radius.circular(12.w) : const Radius.circular(0),
        ),
      ),
      height: 30.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: textTitle14StylePoppins.merge(
                  TextStyle(fontWeight: FontWeight.w500, color: rowTitleColor),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(bookValue1, style: _getFontStyle()))),
                  const VerticalDivider(
                    color: colorGrey200,
                  ),
                  Expanded(child: Center(child: Text(bookValue2, style: _getFontStyle())))
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
            thickness: 1,
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(videoValue1, style: _getFontStyle()))),
                  const VerticalDivider(
                    color: colorGrey200,
                    thickness: 1,
                  ),
                  Expanded(child: Center(child: Text(videoValue2, style: _getFontStyle())))
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(testValue1, style: _getFontStyle()))),
                  const VerticalDivider(
                    color: colorGrey200,
                  ),
                  Expanded(child: Center(child: Text(testValue2, style: _getFontStyle())))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningTimeTimeReportsTableSingleRow extends StatelessWidget {
  const _LearningTimeTimeReportsTableSingleRow({
    Key? key,
    required this.bgColor,
    required this.bookValue,
    required this.videoValue,
    required this.testsValue,
    required this.isHeaderCard,
  }) : super(key: key);

  final Color bgColor;
  final String bookValue;
  final String videoValue;
  final String testsValue;
  final bool isHeaderCard;

  TextStyle getFontStyle() {
    if (isHeaderCard) {
      return textTitle10StylePoppins.merge(
        const TextStyle(fontWeight: FontWeight.w500, color: colorGrey600),
      );
    } else {
      return textTitle16StylePoppins.merge(
        const TextStyle(color: colorGrey600),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      height: 30.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Your",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(fontWeight: FontWeight.w500, color: colorSky800),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                bookValue,
                style: getFontStyle(),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                videoValue,
                style: getFontStyle(),
              ),
            ),
          ),
          const VerticalDivider(
            color: colorGrey200,
          ),
          Expanded(
            child: Center(
              child: Text(
                testsValue,
                style: getFontStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
