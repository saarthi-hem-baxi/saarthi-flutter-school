import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/charts/single_bar_chart.dart';

class WSAllotedDetailsPage extends StatelessWidget {
  const WSAllotedDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderCard(
            backEnabled: true,
            onTap: () {
              Navigator.pop(context);
            },
            title: "Worksheet Allotted",
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _WSAllottedSubjectsChart(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Class 1B English",
                      style: textTitle16WhiteBoldStyle.merge(
                        const TextStyle(color: colorHeaderTextColor),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    _WSAllottedChapterChart(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Concepts",
                      style: textTitle16WhiteBoldStyle.merge(
                        const TextStyle(color: colorHeaderTextColor),
                      ),
                    ),
                    _WSAllottedConceptList()
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class _WSAllottedSubjectsChart extends StatefulWidget {
  const _WSAllottedSubjectsChart({Key? key}) : super(key: key);

  @override
  State<_WSAllottedSubjectsChart> createState() =>
      _WSAllottedSubjectsChartState();
}

class _WSAllottedSubjectsChartState extends State<_WSAllottedSubjectsChart> {
  int currentTabIndex = 1;

  void onTabChange(int index) {
    setState(() {
      if (currentTabIndex != index) {
        setState(() {
          currentTabIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: const [
          BoxShadow(
            color: colorDropShadow,
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              top: 12.w,
            ),
            child: Row(
              children: [
                _WStAllotedSubjectChartTabHeader(
                    title: "Teacher Generated",
                    currentIndex: currentTabIndex,
                    itemIndex: 1,
                    onTabPress: onTabChange),
                SizedBox(
                  width: 10.w,
                ),
                _WStAllotedSubjectChartTabHeader(
                    title: "System Generated",
                    currentIndex: currentTabIndex,
                    itemIndex: 2,
                    onTabPress: onTabChange),
              ],
            ),
          ),
          Divider(height: 4.h),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: currentTabIndex == 1
                ? _TeacherGenSubjectChart()
                : _SystemGenSubjectChart(),
          ),
        ],
      ),
    );
  }
}

class _TeacherGenSubjectChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: SingleBarChartWidget(
        chartLegendTitle: "Worksheet %",
        isValueInPercentage: true,
        gradinentColors: const [
          orangeGradientC1,
          orangeGradientC2,
        ],
        singleBarChartData: [
          SingleBarChartWidgetDataModal(name: "Eng", value: 28),
          SingleBarChartWidgetDataModal(name: "Math", value: 45),
          SingleBarChartWidgetDataModal(name: "Sci", value: 62),
          SingleBarChartWidgetDataModal(name: "SST", value: 70),
          SingleBarChartWidgetDataModal(name: "Hin", value: 79),
          SingleBarChartWidgetDataModal(name: "Guj", value: 92),
          SingleBarChartWidgetDataModal(name: "Comp", value: 92),
        ],
        onBarPress: (v) {
          debugPrint("this is press $v");
        },
      ),
    );
  }
}

class _SystemGenSubjectChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: SingleBarChartWidget(
        chartLegendTitle: "Worksheet %",
        isValueInPercentage: true,
        gradinentColors: const [
          skyGradientC1,
          skyGradientC2,
        ],
        singleBarChartData: [
          SingleBarChartWidgetDataModal(name: "Eng", value: 40),
          SingleBarChartWidgetDataModal(name: "Math", value: 48),
          SingleBarChartWidgetDataModal(name: "Sci", value: 85),
          SingleBarChartWidgetDataModal(name: "SST", value: 43),
          SingleBarChartWidgetDataModal(name: "Hin", value: 75),
          SingleBarChartWidgetDataModal(name: "Guj", value: 42),
          SingleBarChartWidgetDataModal(name: "Comp", value: 66),
        ],
        onBarPress: (v) {
          debugPrint("this is press $v");
        },
      ),
    );
  }
}

class _WStAllotedSubjectChartTabHeader extends StatelessWidget {
  const _WStAllotedSubjectChartTabHeader({
    Key? key,
    required this.title,
    required this.currentIndex,
    required this.itemIndex,
    required this.onTabPress,
  }) : super(key: key);

  final String title;
  final int currentIndex;
  final int itemIndex;
  final Function onTabPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTabPress(itemIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2.h,
              color: itemIndex == currentIndex ? colorBlue500 : Colors.white,
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 3.h),
          child: Text(
            title,
            style: textTitle12StylePoppins.merge(
              TextStyle(
                fontWeight: FontWeight.w600,
                color: itemIndex == currentIndex ? colorGrey800 : colorGrey400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WSAllottedChapterChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: const [
          BoxShadow(
            color: colorDropShadow,
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chapters",
            style: textTitle14StylePoppins.merge(
              const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: SingleBarChartWidget(
              chartLegendTitle: "Worksheet %",
              bottomChartLegendTitle: "Chapter no.",
              isValueInPercentage: true,
              gradinentColors: const [
                pinkGradientC1,
                pinkGradientC2,
              ],
              singleBarChartData: [
                SingleBarChartWidgetDataModal(name: "Eng", value: 28),
                SingleBarChartWidgetDataModal(name: "Math", value: 50),
                SingleBarChartWidgetDataModal(name: "Sci", value: 62),
                SingleBarChartWidgetDataModal(name: "SST", value: 70),
                SingleBarChartWidgetDataModal(name: "Hin", value: 79),
                SingleBarChartWidgetDataModal(name: "Guj", value: 92),
                SingleBarChartWidgetDataModal(name: "Comp", value: 92),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WSAllottedConceptList extends StatelessWidget {
  final List d = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: d.map((e) {
        int index = d.indexOf(e);
        return _WSAllottedConceptListItemCard(
          index: index + 1,
          conceptName:
              "Chemical Reactions and Equations asdasd daa add eweopkmmm",
          gainedTeacherGen: getRandomToMaxNumber(80),
          totalTeacherGen: 70,
          gainedSystemGen: getRandomToMaxNumber(95),
          totalSystemGen: 95,
        );
      }).toList(),
    );
  }
}

class _WSAllottedConceptListItemCard extends StatelessWidget {
  const _WSAllottedConceptListItemCard({
    Key? key,
    required this.index,
    required this.conceptName,
    required this.gainedTeacherGen,
    required this.totalTeacherGen,
    required this.gainedSystemGen,
    required this.totalSystemGen,
  }) : super(key: key);

  final int index;
  final String conceptName;
  final int gainedTeacherGen;
  final int totalTeacherGen;
  final int gainedSystemGen;
  final int totalSystemGen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: const [
          BoxShadow(
            color: colorDropShadow,
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$index.",
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(
                        fontWeight: FontWeight.w600, color: colorGrey600),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Text(
                    conceptName,
                    style: textTitle14StylePoppins.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, color: colorGrey700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5.h,
            color: colorGrey300,
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Teacher Gen",
                    style: textTitle12StylePoppins
                        .merge(const TextStyle(color: colorGrey400)),
                  ),
                  Text(
                    "${gainedTeacherGen.toString()}/${totalTeacherGen.toString()}",
                    style: textTitle16StylePoppins.merge(const TextStyle(
                      color: colorGrey500,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "System Gen",
                    style: textTitle12StylePoppins
                        .merge(const TextStyle(color: colorGrey400)),
                  ),
                  Text(
                    "${gainedSystemGen.toString()}/${totalSystemGen.toString()}",
                    style: textTitle16StylePoppins.merge(const TextStyle(
                      color: colorGrey500,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: textTitle12StylePoppins
                        .merge(const TextStyle(color: colorGrey400)),
                  ),
                  Text(
                    "${gainedTeacherGen + gainedSystemGen}/${totalTeacherGen + totalSystemGen}",
                    style: textTitle16StylePoppins.merge(const TextStyle(
                      color: colorGrey700,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}
