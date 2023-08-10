import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

class NoticeBoard extends StatelessWidget {
  const NoticeBoard({Key? key, required this.noticeBoardText})
      : super(key: key);

  final String noticeBoardText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: colorGreen600,
        border: Border.all(
          width: 3,
          color: const Color(0xffF0CE75),
        ),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notice Board",
            style: textTitle18StylePoppins.merge(
              const TextStyle(fontWeight: FontWeight.w600, color: colorGrey25),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            noticeBoardText,
            textAlign: TextAlign.justify,
            style: textTitle16StylePoppins.merge(
              const TextStyle(color: colorGrey25),
            ),
          )
        ],
      ),
    );
  }
}
