import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';

import '../../../theme/colors.dart';

class StartingPointMileStone extends StatelessWidget {
  final GlobalKey milestoneKey;
  final GlobalKey containerKey;
  const StartingPointMileStone({
    Key? key,
    required this.milestoneKey,
    required this.containerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: containerKey,
      alignment: Alignment.center,
      padding:
          const EdgeInsets.symmetric(vertical: startingPointPaddingVertical),
      child: Container(
        key: milestoneKey,
        width: startingPointSize,
        height: startingPointSize,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(startingPointSize)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 10,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(105, 200, 55, 1),
              Color.fromRGBO(150, 216, 115, 1),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Container(
            height: startingPointSize * 0.8,
            width: startingPointSize * 0.8,
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(startingPointSize * 0.8)),
              color: colorBlueDark,
            ),
            child: Center(
              child: Container(
                height: startingPointSize * 0.5,
                width: startingPointSize * 0.5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(startingPointRadius * 0.6)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(235, 71, 153, 1),
                      Color.fromRGBO(240, 117, 178, 1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
