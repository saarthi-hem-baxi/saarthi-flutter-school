import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/charts/bubble_chart.dart';

import '../../theme/colors.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/charts/single_bar_chart.dart';

class AttemptedQuestionChartsPage extends StatelessWidget {
  AttemptedQuestionChartsPage({Key? key}) : super(key: key);

  final ScrollController _bubbleChartScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  final List<BubbleChartDataModal> data = [
    BubbleChartDataModal(
        subjectName: "Social Science",
        attemptedQuestionCount: 110,
        totalQuestionCount: 120),
    BubbleChartDataModal(
        subjectName: "Computer",
        attemptedQuestionCount: 68,
        totalQuestionCount: 70),
    BubbleChartDataModal(
        subjectName: "English",
        attemptedQuestionCount: 40,
        totalQuestionCount: 50),
    BubbleChartDataModal(
        subjectName: "Science",
        attemptedQuestionCount: 10,
        totalQuestionCount: 190),
    BubbleChartDataModal(
        subjectName: "Physics",
        attemptedQuestionCount: 30,
        totalQuestionCount: 140),
    BubbleChartDataModal(
        subjectName: "Maths",
        attemptedQuestionCount: 70,
        totalQuestionCount: 120),
    BubbleChartDataModal(
        subjectName: "Environment Studies",
        attemptedQuestionCount: 85,
        totalQuestionCount: 85),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderCard(
            backEnabled: true,
            onTap: () {
              Navigator.pop(context);
            },
            title: "Attempted Questions",
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: getScrenHeight(context) / 1.5,
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: Colors.white,
                    ),
                    child: Scrollbar(
                      controller: _bubbleChartScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _bubbleChartScrollController,
                        scrollDirection: Axis.horizontal,
                        child: BubbleChart(
                          bubbleChartData: data,
                          onBubbleTap: (v) {
                            debugPrint("on bubble press $v");
                            debugPrint(data[v].subjectName);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Social Studies",
                      style: textTitle16WhiteBoldStyle
                          .merge(const TextStyle(color: colorHeaderTextColor)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const AttemptedQueChaptersChart(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Ch. 1 - Addition",
                      style: textTitle16WhiteBoldStyle
                          .merge(const TextStyle(color: colorHeaderTextColor)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AttemptedQueConceptTable(),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class AttemptedQueChaptersChart extends StatelessWidget {
  const AttemptedQueChaptersChart({Key? key}) : super(key: key);

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
              chartLegendTitle: "Attempted Questions %",
              bottomChartLegendTitle: "Chapter No.",
              isValueInPercentage: true,
              onBarPress: (v) {
                debugPrint("press on bar item $v");
              },
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
                SingleBarChartWidgetDataModal(name: "7", value: 66),
                SingleBarChartWidgetDataModal(name: "8", value: 78),
                SingleBarChartWidgetDataModal(name: "9", value: 96),
                SingleBarChartWidgetDataModal(name: "10", value: 89),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttemptedQueConceptTable extends StatelessWidget {
  AttemptedQueConceptTable({Key? key}) : super(key: key);

  final List d = [1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: EdgeInsets.all(10.w),
            child: Text(
              "Concepts",
              style: textTitle14StylePoppins.merge(
                const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            height: 25,
            color: colorGrey50,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const _AttemptedQueConceptTableHeaderRow(),
          ),
          Column(
            children: d.map((e) {
              int index = d.indexOf(e);
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: _AttemptedQueConceptTableDataRow(
                  index: index + 1,
                  conceptName: "rasdsasdasdas dasd adsdsa",
                  attemptedQueCount: getRandomToMaxNumber(150),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AttemptedQueConceptTableHeaderRow extends StatelessWidget {
  const _AttemptedQueConceptTableHeaderRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "No.",
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            "Concept",
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Attempted Ques.",
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttemptedQueConceptTableDataRow extends StatelessWidget {
  const _AttemptedQueConceptTableDataRow({
    Key? key,
    required this.index,
    required this.conceptName,
    required this.attemptedQueCount,
  }) : super(key: key);

  final int index;
  final String conceptName;
  final int attemptedQueCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "$index.",
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            conceptName,
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "$attemptedQueCount",
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
