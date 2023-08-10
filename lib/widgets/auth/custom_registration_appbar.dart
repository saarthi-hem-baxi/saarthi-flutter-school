import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import 'rounded_corner_progressbar.dart';

class CustomRegistrationAppBar extends StatelessWidget {
  const CustomRegistrationAppBar({
    Key? key,
    required this.isfromRegistrationLink,
    required this.progress,
    this.isBackButton = true,
  }) : super(key: key);

  final bool isfromRegistrationLink;
  final double progress;
  final bool isBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isBackButton
            ? GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: Container(
                  height: 32.w,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: colorBackground,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.w),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 18.w,
                    color: colorGrey800,
                  ),
                ),
              )
            : SizedBox(
                height: 32.w,
                width: 32.w,
              ),
        isfromRegistrationLink
            ? const SizedBox()
            : Expanded(
                child: Center(
                  child: SizedBox(
                    width: 120.w,
                    height: 4.h,
                    child: RoundedCornerProgressBar(
                      current: progress * 100,
                      max: 100,
                      color: colorPink600,
                    ),
                  ),
                ),
              ),
        SizedBox(
          width: 30.w,
        )
      ],
    );
  }
}
