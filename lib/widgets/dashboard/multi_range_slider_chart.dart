import 'package:flutter/material.dart';

class MultiRangeSliderChart extends StatelessWidget {
  const MultiRangeSliderChart({
    Key? key,
    this.sliderMainWidth,
    required this.firstValueInPercentage,
    required this.maxStopValueInPercentage,
    this.firstSliderColors = const [
      Color(0xff3350F3),
      Color(0xff011CB0),
    ],
    this.secondSliderColors = const [
      Color(0xffE87385),
      Color(0xffE87385),
    ],
    this.firstSliderIndicatorColor = const Color(0xff011CB0),
    this.secondSliderIndicatorColor = const Color(0xffDC2945),
  }) : super(key: key);

  final double? sliderMainWidth;
  final double firstValueInPercentage;
  final double maxStopValueInPercentage;
  final List<Color> firstSliderColors;
  final List<Color> secondSliderColors;
  final Color firstSliderIndicatorColor;
  final Color secondSliderIndicatorColor;

  @override
  Widget build(BuildContext context) {
    double sliderMainWidthIn =
        (sliderMainWidth ?? MediaQuery.of(context).size.width) / 1.2;
    double firstSliderWidth =
        (sliderMainWidthIn * (firstValueInPercentage / 100));
    double secondSliderWidth =
        (sliderMainWidthIn * (maxStopValueInPercentage / 100));
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: sliderMainWidth,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xffD0D5DD),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: secondSliderWidth + 5,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: secondSliderColors,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: secondSliderWidth,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: secondSliderColors,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 1.5,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: secondSliderIndicatorColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: firstSliderWidth,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffD0D5DD),
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: firstSliderColors),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: firstSliderWidth,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xffD0D5DD),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: firstSliderColors),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: firstSliderIndicatorColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: firstSliderIndicatorColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
