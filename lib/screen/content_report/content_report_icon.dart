import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentReportIcon extends StatelessWidget {
  const ContentReportIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            border: Border.all(width: 0.1, color: Colors.white),
            color: Colors.white,
          ),
          child: Icon(
            Icons.info,
            color: const Color(0xff0C9FDA),
            size: 14.w,
          ),
        ),
      ),
    );
  }
}
