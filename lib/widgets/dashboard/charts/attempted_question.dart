import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../screen/dashboard/attempted_questions_details.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../pie_chart_indicator.dart';
import 'custom_pie_chart.dart';

class AttemptedQuestionsChart extends StatelessWidget {
  const AttemptedQuestionsChart({
    Key? key,
    required this.value,
    required this.pieData,
  }) : super(key: key);

  final num value;
  final List<CustomPieChartData> pieData;

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttemptedQuestionChartsPage(),
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
                  "Attempted Ques.",
                  style: textTitle14StyleMediumPoppins,
                ),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: colorBlue25,
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Text(
                    value.toString(),
                    style: textTitle16StylePoppins.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorBlue600,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                CustomPieChart(
                  pieData: pieData,
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
