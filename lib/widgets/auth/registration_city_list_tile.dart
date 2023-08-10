import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/text_styling.dart';

class RegistrationCityListTile extends StatelessWidget {
  final String title;
  final String highlightText;
  final VoidCallback onTap;

  const RegistrationCityListTile({
    Key? key,
    required this.title,
    required this.highlightText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 10.w,
        ),
        alignment: Alignment.topLeft,
        child: TextStyling(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          caseSensitive: false,
          text: title,
          highlightText: [highlightText],
          multiTextStyles: [
            textTitle16StylePoppins.copyWith(
              color: colorGrey600,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
          textStyle: textTitle16StylePoppins.copyWith(
            color: colorGrey600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }
}
