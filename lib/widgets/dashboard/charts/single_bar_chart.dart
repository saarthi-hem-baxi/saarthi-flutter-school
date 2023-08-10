// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

class SingleBarChartWidget extends StatelessWidget {
  SingleBarChartWidget({
    Key? key,
    required this.singleBarChartData,
    this.chartLegendTitle,
    this.bottomChartLegendTitle,
    required this.isValueInPercentage,
    required this.gradinentColors,
    this.onBarPress,
  }) : super(key: key);

  final List<SingleBarChartWidgetDataModal> singleBarChartData;
  final String? chartLegendTitle;
  final String? bottomChartLegendTitle;
  final bool isValueInPercentage;

  final ScrollController _scrollController = ScrollController();

  final List<Color> gradinentColors;
  final Function? onBarPress;

  num getMaxNumber() {
    if (singleBarChartData.isEmpty) {
      return 0;
    }
    List<num> listOfBarValue = singleBarChartData.map<num>((e) => e.value).toList();

    num maxNumber = listOfBarValue.reduce(max);

    double intervalValue = getInterValValue(maxNumber.toDouble());
    num roundedValue = (((maxNumber / intervalValue).floor()) * intervalValue) + intervalValue;

    return roundedValue;
  }

  double getInterValValue(double maxValue) {
    int len = maxValue.toStringAsFixed(0).length;
    String value = "1";
    for (int i = 1; i < len; i++) {
      value = value + "0";
    }
    return double.parse(value);
  }

  double getChartWidth(BuildContext context) {
    double caluculatedWidth = MediaQuery.of(context).size.width * (singleBarChartData.length / 10);
    if (caluculatedWidth < MediaQuery.of(context).size.width) {
      return MediaQuery.of(context).size.width;
    } else {
      return caluculatedWidth;
    }
  }

  bool isChartCenterAlign(context) {
    double caluculatedWidth = MediaQuery.of(context).size.width * (singleBarChartData.length / 10);
    if (caluculatedWidth < MediaQuery.of(context).size.width) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      hoverThickness: 5,
      thickness: 2,
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: getChartWidth(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  // horizontalInterval: 5,
                ),
                alignment: isChartCenterAlign(context) ? BarChartAlignment.center : BarChartAlignment.spaceAround,
                minY: 0,
                baselineY: 0,
                maxY: isValueInPercentage ? 100 : getMaxNumber().toDouble(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            onBarPress!(groupIndex);
            return BarTooltipItem(
              "",
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        singleBarChartData[value.toInt()].name,
        style: textTitle6StylePoppins.merge(
          const TextStyle(
            color: colorGrey500,
          ),
        ),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameSize: bottomChartLegendTitle != null ? 10 : 0,
          axisNameWidget: Text(
            bottomChartLegendTitle ?? "",
            style: textTitle10BoldStyle.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey400,
              ),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: chartLegendTitle != null ? 10 : 0,
          axisNameWidget: Text(
            chartLegendTitle ?? "",
            style: textTitle10BoldStyle.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey400,
              ),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // interval: singleBarChartData.length.toDouble(),
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: textTitle10StylePoppins.merge(
                  const TextStyle(
                    color: colorGrey500,
                  ),
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: colorGrey300,
          ),
        ),
      );

  LinearGradient _getBargradient() {
    return LinearGradient(
      colors: gradinentColors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  final barBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(5),
    topRight: Radius.circular(5),
    bottomLeft: Radius.circular(5),
    bottomRight: Radius.circular(5),
  );

  List<BarChartGroupData> get barGroups => singleBarChartData
      .map(
        (e) => BarChartGroupData(
          x: singleBarChartData.indexOf(e),
          barsSpace: 40,
          barRods: [
            BarChartRodData(
              toY: e.value.toDouble(),
              borderRadius: barBorderRadius,
              width: 20,
              gradient: _getBargradient(),
            ),
          ],
          showingTooltipIndicators: [1],
        ),
      )
      .toList();
}

class SingleBarChartWidgetDataModal {
  String name;
  num value;

  SingleBarChartWidgetDataModal({
    required this.name,
    required this.value,
  });
}
