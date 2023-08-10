import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

// ignore: must_be_immutable
class MultiLineChartWidget extends StatelessWidget {
  MultiLineChartWidget({
    Key? key,
    required this.multiLineChartData,
    required this.multiLineChartIndicatorData,
  }) : super(key: key);

  final List<MultiLineChartDataModal> multiLineChartData;
  final List<MultiLineChartDataModal> multiLineChartIndicatorData;
  num? maxNumberBkp;

  double getYMaxValue() {
    List<num> d = [];
    for (var item1 in multiLineChartIndicatorData) {
      for (var item in item1.lineSpotData) {
        d.add(item.y);
      }
    }
    num maxNumber = d.isEmpty ? 100 : d.reduce(max);
    maxNumberBkp = maxNumber;
    if (maxNumberBkp == 0) {
      return 100;
    }
    double intervalValue = getInterValValue(maxNumber.toDouble());
    num roundedValue = (((maxNumber / intervalValue).floor()) * intervalValue) + intervalValue;
    return double.parse(roundedValue.toString());
  }

  double getInterValValue(double maxValue) {
    int len = maxValue.toStringAsFixed(0).length;
    String value = "1";
    for (int i = 1; i < len; i++) {
      value = value + "0";
    }
    return double.parse(value);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text(
            value == 0 ? "0" : value.toStringAsFixed(0),
            // value.toStringAsFixed(0),
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
            textAlign: TextAlign.center,
          );
        },
        showTitles: true,
        interval: getInterValValue(getYMaxValue()),
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        multiLineChartIndicatorData.first.bottomTitles[value.toInt() - 1],
        // value.toInt() == 0 ? "" : multiLineChartIndicatorData.first.bottomTitles[value.toInt() - 1],
        style: textTitle8StylePoppins.merge(
          const TextStyle(
            color: colorWebPanelDarkText,
          ),
        ),
      ),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  SideTitles get topTitles => SideTitles(
        showTitles: true,
        reservedSize: 25,
        interval: 1,
        getTitlesWidget: (double value, TitleMeta meta) {
          return SideTitleWidget(child: const Text(""), axisSide: meta.axisSide);
        },
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: getInterValValue(getYMaxValue()),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: colorGrey300,
            width: 1,
            style: BorderStyle.solid,
          ),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(
            color: colorGrey300,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: false,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: topTitles,
        ),
        leftTitles: AxisTitles(
          axisNameSize: 10,
          axisNameWidget: Text(
            "Time (minute)",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                color: colorGrey400,
              ),
            ),
          ),
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => multiLineChartData
      .map(
        (e) => LineChartBarData(
          isCurved: true,
          color: e.lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: e.lineSpotData,
          preventCurveOverShooting: true,
        ),
      )
      .toList();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    getYMaxValue();
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: getChartWidth(context),
        child: LineChart(
          LineChartData(
            lineTouchData: lineTouchData1,
            gridData: gridData,
            titlesData: titlesData1,
            borderData: borderData,
            lineBarsData: lineBarsData1,
            minX: 1,
            maxY: getYMaxValue(),
            minY: 0,
            baselineX: 0,
            baselineY: 0,
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 0,
                  dashArray: [7],
                  strokeWidth: 0.5,
                  color: Colors.black.withOpacity(0.2),
                ),
                HorizontalLine(
                  y: getYMaxValue(),
                  dashArray: [7],
                  strokeWidth: 0.5,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getChartWidth(BuildContext context) {
    double caluculatedWidth = MediaQuery.of(context).size.width * (multiLineChartIndicatorData.length / 10);
    if (caluculatedWidth < MediaQuery.of(context).size.width) {
      return MediaQuery.of(context).size.width;
    } else {
      return caluculatedWidth;
    }
  }
}

class MultiLineChartDataModal {
  int lineIndex;
  Color lineColor;
  List<FlSpot> lineSpotData;
  String lineIndicatortitle;
  bool isChecked;
  List<String> bottomTitles;

  MultiLineChartDataModal({
    required this.lineIndex,
    required this.lineColor,
    required this.lineSpotData,
    required this.lineIndicatortitle,
    required this.isChecked,
    required this.bottomTitles,
  });
}
