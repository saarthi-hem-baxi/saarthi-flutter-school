import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/charts/cirucluar_liquid_gauge.dart';

import '../../../screen/dashboard/concept_cleared_details.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../gained_total_value_row.dart';

class ConceptClearedChart extends StatelessWidget {
  const ConceptClearedChart({
    Key? key,
    required this.gainedValue,
    required this.totalValue,
    required this.bySaarthiLearning,
    required this.bySelf,
  }) : super(key: key);

  final num gainedValue;
  final num totalValue;
  final num bySaarthiLearning;
  final num bySelf;

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConceptClearedDetailsPage(),
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
                  "Concept Cleared",
                  style: textTitle14StyleMediumPoppins,
                ),
                GainedTotalValueRow(
                  gainedValue: gainedValue,
                  totalValue: totalValue,
                ),
              ],
            ),
            SizedBox(
              width: 10.w,
            ),
            Row(
              children: [
                CircularGaugeChart(
                  borderColor: colorRed50,
                  color: const Color(0xffE1475F),
                  value: getValuePercentage(
                      value1: gainedValue, value2: totalValue),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AttemptedQueInnerRow(
                        title: "By saarthi\nlearning res.",
                        value: 40,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const AttemptedQueInnerRow(
                        title: "By Self",
                        value: 35,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AttemptedQueInnerRow extends StatelessWidget {
  const AttemptedQueInnerRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final num value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTitle10StylePoppins
              .merge(const TextStyle(color: colorGrey500)),
        ),
        Text.rich(
          TextSpan(
            text: "$value",
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey700,
              ),
            ),
            children: <InlineSpan>[
              TextSpan(
                text: "%",
                style: textTitle8StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey700,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
