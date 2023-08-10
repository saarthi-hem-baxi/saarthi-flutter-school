import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';

import '../../theme/style.dart';

class GainedTotalValueRow extends StatelessWidget {
  const GainedTotalValueRow({
    Key? key,
    required this.gainedValue,
    required this.totalValue,
    this.bgColor = colorBlue25,
    this.textColor = colorBlue600,
  }) : super(key: key);

  final num gainedValue;
  final num totalValue;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorBlue25,
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Text.rich(
        TextSpan(
          text: "$gainedValue/",
          style: textTitle16StylePoppins.merge(
            const TextStyle(
              fontWeight: FontWeight.w600,
              color: colorBlue600,
            ),
          ),
          children: <InlineSpan>[
            TextSpan(
              text: "$totalValue",
              style: textTitle14StylePoppins.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorBlue600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
