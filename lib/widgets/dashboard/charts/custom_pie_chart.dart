import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({Key? key, required this.pieData, this.size})
      : super(key: key);

  final List<CustomPieChartData> pieData;
  final double? size;

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  List<PieChartSectionData> data = [];
  List<PieChartSectionData> data1 = [];

  @override
  void initState() {
    super.initState();
    data = widget.pieData
        .map(
          (e) => PieChartSectionData(
            color: e.color,
            value: double.parse(e.value.toString()),
            title: '${e.value}%',
            radius: 25,
            borderSide: BorderSide(color: e.borderColor, width: 3),
            showTitle: false,
          ),
        )
        .toList();
    data1 = widget.pieData
        .map(
          (e) => PieChartSectionData(
            color: e.darkColor,
            value: double.parse(e.value.toString()),
            title: '${e.value}%',
            radius: 25,
            showTitle: false,
          ),
        )
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.size != null ? widget.size?.w : 100.w,
          width: widget.size != null ? widget.size?.w : 100.w,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 0,
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 10,
              sections: data1,
            ),
          ),
        ),
        SizedBox(
          height: widget.size != null ? widget.size?.w : 100.w,
          width: widget.size != null ? widget.size?.w : 100.w,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 0,
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 20,
              centerSpaceColor: Colors.transparent,
              sections: data,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPieChartData {
  num value;
  Color color;
  Color darkColor;
  Color borderColor;
  String title;

  CustomPieChartData({
    required this.value,
    required this.color,
    required this.darkColor,
    required this.borderColor,
    required this.title,
  });
}
