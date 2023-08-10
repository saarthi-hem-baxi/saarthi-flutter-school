import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../theme/style.dart';

class BooksCards extends StatefulWidget {
  final String title;
  final bool learn;

  final List<LinearGradient> gradient;
  final int index;

  const BooksCards({Key? key, required this.learn, required this.title, required this.index, required this.gradient}) : super(key: key);

  @override
  _BooksCardsState createState() => _BooksCardsState();
}

class _BooksCardsState extends State<BooksCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = ((getScreenWidth(context) - 50) / 3);
    return Container(
      height: 130.h,
      width: containerWidth, //62 is for 32 left right padding and 30 for center items padding
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        gradient: widget.index < widget.gradient.length ? widget.gradient[widget.index] : widget.gradient[widget.index % 7],
      ),
      child: Center(
        child: Text(
          widget.title,
          style: textTitle16WhiteBoldStyle.merge(
            const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
