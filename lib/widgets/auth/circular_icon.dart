import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final LinearGradient bgGradient;

  const CircularIcon({
    Key? key,
    required this.icon,
    required this.bgGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      width: 32.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: bgGradient,
      ),
      child: Icon(
        icon,
        size: 18.h,
        color: Colors.white,
      ),
    );
  }
}
