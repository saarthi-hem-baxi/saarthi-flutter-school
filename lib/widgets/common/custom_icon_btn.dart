import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.title,
    required this.icon,
    required this.onTap,
    this.bgColor = colorLightButton,
    this.textColor = colorBlue,
    this.iconColor = colorBlue,
    this.isRightIcon = false,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final bool isRightIcon;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10.w)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isRightIcon
                ? isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: LoadingSpinner(
                          color: iconColor,
                        ),
                      )
                    : Icon(
                        icon,
                        color: iconColor,
                      )
                : const SizedBox(),
            SizedBox(
              width: !isRightIcon ? 10.w : 0,
            ),
            Text(
              isLoading ? "Loading" : title,
              style: textButton15SemiBold.merge(TextStyle(color: textColor)),
            ),
            SizedBox(
              width: isRightIcon ? 10.w : 0,
            ),
            isRightIcon
                ? isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: LoadingSpinner(
                          color: iconColor,
                        ),
                      )
                    : Icon(
                        icon,
                        color: iconColor,
                      )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
