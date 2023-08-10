import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/dashboard_controller.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../../helpers/numbers.dart';
import '../../../model/dashboard/learning_time.dart';
import '../../../screen/dashboard/learning_time_details.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';

class LearningTimeChart extends StatelessWidget {
  LearningTimeChart({
    Key? key,
  }) : super(key: key);

  final DashboardController _dashboardController = Get.put(DashboardController());

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LearningTimeDetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _dashboardController.getLearningTime();
    return InkWell(
      onTap: () {
        _navigateTopage(context);
      },
      child: Container(
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
          if (_dashboardController.learningTimeLoading.isTrue) {
            return const Align(
              alignment: Alignment.center,
              child: LoadingSpinner(),
            );
          } else {
            LearningTimeChartModal learningTimeData = _dashboardController.learningTimeData.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Learning\nTime",
                      style: textTitle14StyleMediumPoppins,
                    ),
                    // Text(
                    //   "${(learningTimeData.isValueUp ?? false) ? '+' : '-'} ${learningTimeData.differenceValue}%",
                    //   style: textTitle12StylePoppins.merge(
                    //     TextStyle(
                    //       color: (learningTimeData.isValueUp ?? false) ? colorGreen500 : colorRed500,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1.9,
                  child: SingleLineChartWidget(
                    singleChartData: SingleLineChartDataModal(
                      gradientColors: const [
                        Color(0xff8B54D4),
                        Color(0xff411D72),
                      ],
                      lineChartSpotData: (learningTimeData.chartData ?? []).map((e) {
                        int index = (learningTimeData.chartData ?? []).indexOf(e);
                        return FlSpot(index.toDouble(), convertSecToMinute(e.value ?? 0).toDouble());
                      }).toList(),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: displaySecFormat(learningTimeData.totalDuration ?? 0).split(' ')[0],
                    style: textTitle24StylePoppins,
                    children: <InlineSpan>[
                      TextSpan(
                        text: displaySecFormat(learningTimeData.totalDuration ?? 0).split(' ')[1],
                        style: textTitle12StylePoppins,
                      )
                    ],
                  ),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}

class SingleLineChartWidget extends StatelessWidget {
  const SingleLineChartWidget({
    Key? key,
    required this.singleChartData,
  }) : super(key: key);

  final SingleLineChartDataModal singleChartData;

  List<num> getMaxValue() {
    if (singleChartData.lineChartSpotData.isEmpty) {
      return [0, 0];
    }
    List<num> xValue = [];
    List<num> yValue = [];
    for (var item in singleChartData.lineChartSpotData) {
      xValue.add(item.x);
      yValue.add(item.y);
    }
    num maxXNumber = xValue.reduce(max);
    num maxYNumber = yValue.reduce(max);
    return [maxXNumber, maxYNumber];
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: false,
          drawVerticalLine: false,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: getMaxValue()[0].toDouble(),
        minY: 0,
        maxY: getMaxValue()[1].toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: singleChartData.lineChartSpotData,
            isCurved: true,
            gradient: LinearGradient(
              colors: singleChartData.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            show: true,
            preventCurveOverShooting: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (a, b) {
                if (a.x == singleChartData.lineChartSpotData.last.x && a.y == singleChartData.lineChartSpotData.last.y) {
                  return true;
                } else {
                  return false;
                }
              },
            ),
            isStrokeJoinRound: true,
            belowBarData: BarAreaData(
              show: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SingleLineChartDataModal {
  List<Color> gradientColors;
  List<FlSpot> lineChartSpotData;

  SingleLineChartDataModal({
    required this.gradientColors,
    required this.lineChartSpotData,
  });
}
