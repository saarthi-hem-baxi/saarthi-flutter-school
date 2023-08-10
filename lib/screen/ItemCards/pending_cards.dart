import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class PendingCards extends StatefulWidget {
  final String title;
  final String count;
  final LinearGradient gradient;
  final String icon;
  const PendingCards({
    Key? key,
    required this.title,
    required this.count,
    required this.gradient,
    required this.icon,
  }) : super(key: key);

  @override
  _PendingCardsState createState() => _PendingCardsState();
}

class _PendingCardsState extends State<PendingCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(
            color: colorDropShadowLight,
            offset: Offset(
              1.0,
              1.0,
            ),
            blurRadius: 1.0,
            spreadRadius: .0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            margin: const EdgeInsets.only(top: 5),
            alignment: AlignmentDirectional.center,
            child: Container(
              height: 50,
              width: 50,
              alignment: AlignmentDirectional.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: SizedBox(
                height: 32,
                width: 32,
                child: SvgPicture.asset(
                  imageAssets + widget.icon,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              widget.title,
              style: textTitle16WhiteBoldStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              widget.count,
              style: textTitle20WhiteBoldStyle
                  .merge(const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
