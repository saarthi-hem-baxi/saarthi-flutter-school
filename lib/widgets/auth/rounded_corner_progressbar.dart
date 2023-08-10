import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class RoundedCornerProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;

  const RoundedCornerProgressBar({
    Key? key,
    required this.max,
    required this.current,
    this.color = colorPink600,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorGrey200,
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            Container(
              width: percent,
              height: 4.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
          ],
        );
      },
    );
  }
}
