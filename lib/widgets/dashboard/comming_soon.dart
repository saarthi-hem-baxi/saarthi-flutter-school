import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/measured_size.dart';

class CommingSoon extends StatefulWidget {
  const CommingSoon({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  Size childSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          MeasureSize(
            onChange: (size) {
              setState(() {
                childSize = size;
              });
            },
            child: widget.child,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                alignment: Alignment.center,
                height: childSize.height,
                width: childSize.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Text(
                  " Coming Soon... ",
                  style: textTitle18StylePoppins.merge(
                    const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
