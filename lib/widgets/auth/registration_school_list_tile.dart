import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/custom_network_image.dart';
import '../common/text_styling.dart';

class RegistrtionSchoolListTile extends StatelessWidget {
  final String title;
  final String highlightText;
  final String schoolLogoUrl;
  final VoidCallback onTap;

  const RegistrtionSchoolListTile({
    Key? key,
    required this.title,
    required this.highlightText,
    required this.schoolLogoUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 5.h,
          horizontal: 10.w,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 25.w,
              height: 25.h,
              child: schoolLogoUrl.isNotEmpty
                  ? CustomNetworkImage(
                      imageUrl: schoolLogoUrl,
                      fit: BoxFit.contain,
                    )
                  : SvgPicture.asset(
                      '${imageAssets}schoollogo.svg',
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(
              width: 7.w,
            ),
            Flexible(
              child: TextStyling(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: title,
                caseSensitive: false,
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
          ],
        ),
      ),
    );
  }
}
