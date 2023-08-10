import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({
    Key? key,
    required this.indicatorColor,
    required this.indicatorName,
    required this.indicatorValue,
  }) : super(key: key);

  final Color indicatorColor;
  final String indicatorName;
  final String indicatorValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                indicatorName,
                style: textTitle10StylePoppins
                    .merge(const TextStyle(color: colorGrey500)),
              )
            ],
          ),
          Text.rich(
            TextSpan(
              text: indicatorValue,
              style: textTitle14StylePoppins.merge(
                const TextStyle(
                  color: colorGrey700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: const <InlineSpan>[
                TextSpan(
                  text: '%',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
