import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/numbers.dart';
import '../../../screen/dashboard/preconcept_cleared_details.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../gained_total_value_row.dart';
import 'cirucluar_liquid_gauge.dart';

class PreConceptClearedChart extends StatelessWidget {
  const PreConceptClearedChart({
    Key? key,
    required this.gainedValue,
    required this.totalValue,
    required this.diffrenceValue,
    required this.isValueUp,
    required this.clearedUsingSaarthi,
  }) : super(key: key);

  final num gainedValue;
  final num totalValue;
  final num diffrenceValue;
  final bool isValueUp;
  final num clearedUsingSaarthi;

  void _navigateTopage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreConceptClearedDetailsPage(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Text(
                  "Pre-concept\nCleared",
                  style: textTitle14StyleMediumPoppins,
                ),
                Text(
                  "${isValueUp ? '+' : '-'} $diffrenceValue%",
                  style: textTitle12StylePoppins.merge(
                    TextStyle(
                      color: isValueUp ? colorGreen500 : colorRed500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.w,
            ),
            SizedBox(
              height: 109.w,
              width: 109.w,
              child: CircularGaugeChart(
                borderColor: const Color(0xff91B6F7),
                color: const Color(0xff0F5BE0),
                value:
                    getValuePercentage(value1: gainedValue, value2: totalValue),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Center(
              child: GainedTotalValueRow(
                gainedValue: gainedValue,
                totalValue: totalValue,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cleared\nusing\nSaarthi",
                  style: textTitle10StylePoppins
                      .merge(const TextStyle(color: colorGrey500)),
                ),
                Text.rich(
                  TextSpan(
                    text: "$clearedUsingSaarthi",
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
            ),
          ],
        ),
      ),
    );
  }
}
