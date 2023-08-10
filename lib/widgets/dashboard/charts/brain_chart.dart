import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../../helpers/numbers.dart';
import '../../../theme/colors.dart';

class BrainChart extends StatelessWidget {
  const BrainChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Text(
            "Brain Chart",
            style: textTitle14StylePoppins.merge(
              const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            "No. Indicates % and count of student have that skill.",
            style: textTitle12StylePoppins,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(imageAssets + "brain_chart_img.png"),
                Positioned(
                  left: 10,
                  top: 0,
                  child: BrainChartIndicator(
                    title: "Knowledge",
                    value: "67%",
                    count: converNumToString(9500),
                    mainColor: const Color(0xffFF920F),
                    subColor: const Color(0xffFFEAD1),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: -2,
                  child: BrainChartIndicator(
                    title: "Analysis &\nEvalution",
                    value: "74%",
                    count: converNumToString(48000),
                    mainColor: const Color(0xff08B4E8),
                    subColor: const Color(0xffEBFAFE),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 0,
                  child: BrainChartIndicator(
                    title: "Application &\nUnderstanding",
                    value: "82%",
                    count: converNumToString(41000),
                    mainColor: const Color(0xffDC2945),
                    subColor: const Color(0xffFCEEF0),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 5,
                  child: BrainChartIndicator(
                    title: "Creation",
                    value: "95%",
                    count: converNumToString(50000000),
                    mainColor: const Color(0xff0DBC72),
                    subColor: const Color(0xffECFEF6),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BrainChartIndicator extends StatelessWidget {
  const BrainChartIndicator({
    Key? key,
    required this.title,
    required this.value,
    required this.count,
    required this.mainColor,
    required this.subColor,
  }) : super(key: key);

  final String title;
  final Color mainColor;
  final Color subColor;
  final String value;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTitle12StylePoppins.merge(
            TextStyle(
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Text(
                value,
                style: textTitle14StylePoppins.merge(
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: subColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Text(
                count,
                style: textTitle14StylePoppins.merge(
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
