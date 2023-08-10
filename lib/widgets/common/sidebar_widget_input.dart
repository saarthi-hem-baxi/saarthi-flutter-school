import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class SideBarWidgetInput extends StatelessWidget {
  const SideBarWidgetInput({Key? key, required this.text, required this.sideWidget, required this.onTap}) : super(key: key);

  final String text;
  final Widget sideWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: colorFormFieldBorder),
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    text,
                    style: textFormSmallerTitleStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(width: 1, color: colorFormFieldBorder)),
                  color: colorSkyLight,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: sideWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
