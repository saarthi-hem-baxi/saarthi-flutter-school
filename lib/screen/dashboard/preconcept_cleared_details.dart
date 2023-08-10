// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/charts/single_bar_chart.dart';

class PreConceptClearedDetailsPage extends StatelessWidget {
  const PreConceptClearedDetailsPage({Key? key}) : super(key: key);

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
              title: "Pre-concepts Cleared",
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
                      const _PreConceptClearedSubjectsChart(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Maths",
                        style: textTitle16WhiteBoldStyle.merge(
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorHeaderTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const _ConceptClearedChartChaptersChart(),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // Text(
                      //   "Chapter map",
                      //   style: textTitle16WhiteBoldStyle.merge(
                      //     const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: colorHeaderTextColor,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 5.h,
                      // ),
                      // _PreConceptClearedChapterMap(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Ch. 1 - Addition",
                        style: textTitle16WhiteBoldStyle.merge(
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorHeaderTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      _PreConceptClearedConceptTable(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreConceptClearedSubjectsChart extends StatelessWidget {
  const _PreConceptClearedSubjectsChart({Key? key}) : super(key: key);

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
      child: AspectRatio(
        aspectRatio: 1.5,
        child: SingleBarChartWidget(
          chartLegendTitle: "Pre-concept understood %",
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
      ),
    );
  }
}

class _ConceptClearedChartChaptersChart extends StatelessWidget {
  const _ConceptClearedChartChaptersChart({Key? key}) : super(key: key);

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
      child: AspectRatio(
        aspectRatio: 1.5,
        child: SingleBarChartWidget(
          chartLegendTitle: "Pre-concept understood %",
          isValueInPercentage: true,
          gradinentColors: const [
            skyGradientC1,
            skyGradientC2,
          ],
          singleBarChartData: [
            SingleBarChartWidgetDataModal(name: "1", value: 40),
            SingleBarChartWidgetDataModal(name: "2", value: 50),
            SingleBarChartWidgetDataModal(name: "3", value: 85),
            SingleBarChartWidgetDataModal(name: "4", value: 44),
            SingleBarChartWidgetDataModal(name: "5", value: 79),
            SingleBarChartWidgetDataModal(name: "6", value: 66),
            SingleBarChartWidgetDataModal(name: "7", value: 92),
          ],
          onBarPress: (v) {
            debugPrint("this is press chapter $v");
          },
        ),
      ),
    );
  }
}

class _PreConceptClearedChapterMap extends StatelessWidget {
  _PreConceptClearedChapterMap({Key? key}) : super(key: key);
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: d.map((e) {
        int index = d.indexOf(e);
        return Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: colorGrey300,
            ),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Text(
            "${index + 1}",
            style: textTitle22StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey600,
              ),
            ),
          ),
        );
      }).toList()),
    );
  }
}

class _PreConceptClearedConceptTable extends StatelessWidget {
  _PreConceptClearedConceptTable({Key? key}) : super(key: key);

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
            padding: EdgeInsets.all(12.w),
            child: Text(
              "Pre-concepts",
              style: textTitle14StylePoppins.merge(
                const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          _ConceptClearedTableView()
        ],
      ),
    );
  }
}

class _ConceptClearedTableView extends StatelessWidget {
  final List d = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  _ConceptClearedTableView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          Column(children: [
            Container(
              height: 54.h,
              color: colorGrey50,
              alignment: Alignment.center,
              child: Text(
                "No.",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              height: 54.h,
              color: colorGrey50,
              alignment: Alignment.center,
              child: Text(
                "Pre-concepts",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              height: 54.h,
              color: colorGrey50,
              alignment: Alignment.center,
              child: Text(
                "Avg.% of\nclass",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              ),
            )
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 54.h,
              color: colorGrey50,
              alignment: Alignment.center,
              child: Text(
                "Status",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              height: 54.h,
              color: colorYellow100,
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "Cleared\nusing SP",
                  style: textTitle12StylePoppins.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorGrey500,
                    ),
                  ),
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              height: 54.h,
              color: colorGrey50,
              alignment: Alignment.center,
              child: Text(
                "Date",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              ),
            )
          ]),
        ]),
        ...d.map((e) {
          int index = d.indexOf(e);
          return TableRow(children: [
            Column(children: [
              Text(
                "${index + 1}",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(
                    color: colorGrey500,
                  ),
                ),
              )
            ]),
            Column(children: [
              Text(
                "dsadsjadjdsjsdksad dsadsa",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              )
            ]),
            Column(children: [
              Text(
                "${getRandomToMaxNumber(80).toString()}%",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              )
            ]),
            Column(children: [
              Container(
                alignment: Alignment.center,
                child: Icon(
                  index % 2 == 0 ? Icons.check_circle : Icons.warning_rounded,
                  color: index % 2 == 0 ? colorGreen500 : colorRed500,
                ),
              )
            ]),
            Column(children: [
              Container(
                height: 54.h,
                color: colorYellow50,
                child: Image.asset(imageAssets + "sp_favicon.png"),
              )
            ]),
            Column(children: [
              Text(
                "22 July",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              )
            ]),
          ]);
        })
      ],
    );
  }
}
