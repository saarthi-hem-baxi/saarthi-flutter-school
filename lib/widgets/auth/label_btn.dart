import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/style.dart';

class LabelButton extends StatelessWidget {
  const LabelButton({
    required this.onTap,
    required this.title,
    required this.bgColor,
    required this.textColor,
    this.icon,
    this.isRightIcon = false,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Color bgColor;
  final Color textColor;
  final Icon? icon;
  final bool isRightIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: bgColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              !isRightIcon ? icon ?? Container() : Container(),
              !isRightIcon ? SizedBox(width: 10.w) : Container(),
              Center(
                child: Text(
                  title,
                  style: textTitle16StylePoppins.merge(
                    TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ),
              isRightIcon ? SizedBox(width: 10.w) : Container(),
              isRightIcon ? icon ?? Container() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
