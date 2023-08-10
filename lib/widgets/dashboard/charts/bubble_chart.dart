import 'package:bubble_chart/bubble_chart.dart';
import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

class BubbleChart extends StatelessWidget {
  const BubbleChart({
    Key? key,
    required this.bubbleChartData,
    this.onBubbleTap,
  }) : super(key: key);

  final List<BubbleChartDataModal> bubbleChartData;

  final Function? onBubbleTap;

  num generatePercentage(num attempted, num total) {
    return ((attempted / total) * 100).ceil();
  }

  double getValue(num value) {
    if (value > 0 && value < 40) {
      return 40 + value.toDouble();
    } else {
      return value.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: getScreenWidth(context) / (getScrenHeight(context) / 2),
      child: BubbleChartLayout(
        duration: const Duration(milliseconds: 100),
        radius: ((BubbleNode bubbleNode) {
          return getValue(bubbleNode.value);
        }),
        padding: 10,
        children: [
          ...bubbleChartData.map((e) {
            int index = bubbleChartData.indexOf(e);
            return BubbleNode.leaf(
              value: generatePercentage(
                e.attemptedQuestionCount,
                e.totalQuestionCount,
              ),
              options: BubbleOptions(
                border: Border.all(width: 2, color: Colors.white),
                child: InkWell(
                  onTap: () {
                    onBubbleTap!(index);
                  },
                  child: SingleBubble(
                    index: index,
                    subjectName: e.subjectName,
                    attemptedQuestionCount: e.attemptedQuestionCount,
                    totalQuestionCount: e.totalQuestionCount,
                    percentage: generatePercentage(
                      e.attemptedQuestionCount,
                      e.totalQuestionCount,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class SingleBubble extends StatelessWidget {
  SingleBubble({
    Key? key,
    required this.subjectName,
    required this.attemptedQuestionCount,
    required this.totalQuestionCount,
    required this.percentage,
    required this.index,
  }) : super(key: key);

  final String subjectName;
  final num attemptedQuestionCount;
  final num totalQuestionCount;
  final num percentage;
  final int index;

  final List<RadialGradient> gradientsList = [
    yellowGradient,
    skyBlueGradient,
    redGradient,
    purpleGradient,
    greenGradient,
    blueGradient
  ];

  RadialGradient getGradinets(int index) {
    int i = index % (gradientsList.length);
    return gradientsList[i];
  }

  static RadialGradient yellowGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(255, 169, 66, 1),
      Color.fromRGBO(168, 92, 0, 1),
    ],
  );
  static RadialGradient skyBlueGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(92, 213, 250, 1),
      Color.fromRGBO(5, 122, 158, 1),
    ],
  );
  static RadialGradient redGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(225, 71, 95, 1),
      Color.fromRGBO(123, 20, 36, 1),
    ],
  );
  static RadialGradient purpleGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(184, 105, 241, 1),
      Color.fromRGBO(80, 12, 131, 1),
    ],
  );
  static RadialGradient greenGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(15, 210, 127, 1),
      Color.fromRGBO(7, 95, 58, 1),
    ],
  );
  static RadialGradient blueGradient = const RadialGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromRGBO(49, 119, 241, 1),
      Color.fromRGBO(9, 52, 129, 1),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(width: 2, color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: getGradinets(index).colors.first,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          )
        ],
        gradient: getGradinets(index),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: percentage.toString(),
                  style: textTitle20StylePoppins.merge(
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "%",
                      style: textTitle10StylePoppins.merge(
                        const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                subjectName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTitle14StyleMediumPoppins.merge(
                  const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          Text.rich(
            TextSpan(
              text: attemptedQuestionCount.toString(),
              style: textTitle12StylePoppins.merge(
                const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: "/$totalQuestionCount",
                  style: textTitle10StylePoppins.merge(
                    const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleChartDataModal {
  String subjectName;
  num totalQuestionCount;
  num attemptedQuestionCount;

  BubbleChartDataModal({
    required this.subjectName,
    required this.totalQuestionCount,
    required this.attemptedQuestionCount,
  });
}

class BubbleChartWithColorModal extends BubbleChartDataModal {
  RadialGradient gradient;

  BubbleChartWithColorModal({
    required subjectName,
    required totalQuestionCount,
    required attemptedQuestionCount,
    required this.gradient,
  }) : super(
          attemptedQuestionCount: attemptedQuestionCount,
          subjectName: subjectName,
          totalQuestionCount: totalQuestionCount,
        );
}
