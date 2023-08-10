import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/screen/dashboard/ws_allotted_details.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/gained_total_value_row.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../pie_chart_indicator.dart';
import 'custom_pie_chart.dart';

class WSAllotedChart extends StatelessWidget {
  const WSAllotedChart({
    Key? key,
    required this.gainedValue,
    required this.totalValue,
    required this.pieData,
  }) : super(key: key);

  final num gainedValue;
  final num totalValue;
  final List<CustomPieChartData> pieData;

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WSAllotedDetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WS Allotted",
                  style: textTitle14StyleMediumPoppins,
                ),
                GainedTotalValueRow(
                  gainedValue: gainedValue,
                  totalValue: totalValue,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomPieChart(
                    pieData: pieData,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Column(
                      children: pieData
                          .map(
                            (e) => PieChartIndicator(
                              indicatorColor: e.color.withOpacity(0.8),
                              indicatorName: e.title,
                              indicatorValue: e.value.toString(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.w,
            ),
          ],
        ),
      ),
    );
  }
}
