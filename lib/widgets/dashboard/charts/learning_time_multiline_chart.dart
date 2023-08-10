// ignore_for_file: unused_field

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/dashboard_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../../model/dashboard/learning_time_multi_line_month.dart';
import '../../../model/dashboard/learning_time_multi_line_quater.dart';
import '../../../model/dashboard/learning_time_multi_line_week.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../multi_line_chart_year.dart';

class LearnigTimeMultiLineChart extends StatefulWidget {
  const LearnigTimeMultiLineChart({Key? key}) : super(key: key);

  @override
  State<LearnigTimeMultiLineChart> createState() => _LearnigTimeMultiLineChartState();
}

class _LearnigTimeMultiLineChartState extends State<LearnigTimeMultiLineChart> {
  int timeFilterIndex = 1;
  bool isPrepararingData = false;

  final DashboardController _dashboardController = Get.put(DashboardController());

  final List<Color> _listOfLineColors = const [
    colorPink500,
    colorGreen500,
    colorYellow500,
    colorSky500,
    colorRed500,
    colorBlue500,
    colorPurple500,
  ];

  List<MultiLineChartDataModal> chartData = [];
  List<MultiLineChartDataModal> chartIndicatorData = [];

  List<MultiLineChartDataModal> weekData = [];
  List<MultiLineChartDataModal> quaterData = [];
  List<MultiLineChartDataModal> monthData = [];

  Color getLineColor(int index) {
    int v = index % (_listOfLineColors.length);
    return _listOfLineColors[v];
  }

  List<FlSpot> getWeekData(List<WeekValue> weekValue) {
    List<FlSpot> spotData = [];
    for (var item in weekValue) {
      if (item.w1 != null) {
        spotData.add(FlSpot(1, convertSecToMinute(item.w1 ?? 0).toDouble()));
      }
      if (item.w2 != null) {
        spotData.add(FlSpot(2, convertSecToMinute(item.w2 ?? 0).toDouble()));
      }
      if (item.w3 != null) {
        spotData.add(FlSpot(3, convertSecToMinute(item.w3 ?? 0).toDouble()));
      }
      if (item.w4 != null) {
        spotData.add(FlSpot(4, convertSecToMinute(item.w4 ?? 0).toDouble()));
      }
      if (item.w5 != null) {
        spotData.add(FlSpot(5, convertSecToMinute(item.w5 ?? 0).toDouble()));
      }
    }
    return spotData;
  }

  List<FlSpot> getQuaterData(List<QuaterValue> quaterValue) {
    List<FlSpot> spotData = [];
    for (var item in quaterValue) {
      if (item.q1 != null) {
        spotData.add(FlSpot(1, convertSecToMinute(item.q1 ?? 0).toDouble()));
      }
      if (item.q2 != null) {
        spotData.add(FlSpot(2, convertSecToMinute(item.q2 ?? 0).toDouble()));
      }
      if (item.q3 != null) {
        spotData.add(FlSpot(3, convertSecToMinute(item.q3 ?? 0).toDouble()));
      }
      if (item.q4 != null) {
        spotData.add(FlSpot(4, convertSecToMinute(item.q4 ?? 0).toDouble()));
      }
    }
    return spotData;
  }

  List<FlSpot> getMonthData(List<MonthValue> monthValue) {
    List<FlSpot> spotData = [];
    for (var item in monthValue) {
      if (item.jan != null) {
        spotData.add(FlSpot(1, convertSecToMinute(item.jan ?? 0).toDouble()));
      }
      if (item.feb != null) {
        spotData.add(FlSpot(2, convertSecToMinute(item.feb ?? 0).toDouble()));
      }
      if (item.mar != null) {
        spotData.add(FlSpot(3, convertSecToMinute(item.mar ?? 0).toDouble()));
      }
      if (item.apr != null) {
        spotData.add(FlSpot(4, convertSecToMinute(item.apr ?? 0).toDouble()));
      }
      if (item.may != null) {
        spotData.add(FlSpot(5, convertSecToMinute(item.may ?? 0).toDouble()));
      }
      if (item.jun != null) {
        spotData.add(FlSpot(6, convertSecToMinute(item.jun ?? 0).toDouble()));
      }
      if (item.jul != null) {
        spotData.add(FlSpot(7, convertSecToMinute(item.jul ?? 0).toDouble()));
      }
      if (item.aug != null) {
        spotData.add(FlSpot(8, convertSecToMinute(item.aug ?? 0).toDouble()));
      }
      if (item.sep != null) {
        spotData.add(FlSpot(9, convertSecToMinute(item.sep ?? 0).toDouble()));
      }
      if (item.oct != null) {
        spotData.add(FlSpot(10, convertSecToMinute(item.oct ?? 0).toDouble()));
      }
      if (item.nov != null) {
        spotData.add(FlSpot(11, convertSecToMinute(item.nov ?? 0).toDouble()));
      }
      if (item.dec != null) {
        spotData.add(FlSpot(12, convertSecToMinute(item.dec ?? 0).toDouble()));
      }
    }
    return spotData;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _prepareChartData();
    });
  }

  void _prepareChartData() {
    setState(() {
      isPrepararingData = true;
    });

    final List<MultiLineChartDataModal> data1 = [
      MultiLineChartDataModal(
        lineIndex: 1,
        isChecked: true,
        lineColor: const Color(0xffb362ad),
        lineIndicatortitle: "GUJ",
        bottomTitles: ["Week1", "Week2", "Week3", "Week4"],
        lineSpotData: const [
          FlSpot(1, 1000),
          FlSpot(2, 12000),
          FlSpot(3, 14000),
          FlSpot(4, 18000),
        ],
      ),
      MultiLineChartDataModal(
        lineIndex: 2,
        isChecked: true,
        lineColor: const Color(0xffdc2945),
        lineIndicatortitle: "SCI",
        bottomTitles: ["Week1", "Week2", "Week3", "Week4"],
        lineSpotData: const [
          FlSpot(1, 0),
          FlSpot(2, 11000),
          FlSpot(3, 5000),
          FlSpot(4, 1700),
        ],
      ),
    ];

    chartData = data1;
    chartIndicatorData = data1;

    // _dashboardController.getLearningTimeMultiLineChartWeekWise().then((value) {
    //   for (var item in _dashboardController.learningTimeMultiLineWeekData.value.chartData ?? []) {
    //     int index = _dashboardController.learningTimeMultiLineWeekData.value.chartData?.indexOf(item) ?? 0;
    //     MultiLineChartDataModal d = MultiLineChartDataModal(
    //       lineIndex: index,
    //       lineColor: getLineColor(index),
    //       isChecked: true,
    //       bottomTitles: ["W1", "W2", "W3", "W4", "W5"],
    //       lineIndicatortitle: item.subjectName ?? "",
    //       lineSpotData: getWeekData(item.value ?? []),
    //     );
    //     weekData = [...weekData, d];

    //     setState(() {});
    //   }
    //   chartData = weekData;
    //   chartIndicatorData = weekData;
    // }); //week wise

    // _dashboardController.getLearningTimeMultiLineChartQuaterWise().then((value) {
    //   for (var item in _dashboardController.learningTimeMultiLineQuaterData.value.chartData ?? []) {
    //     int index = _dashboardController.learningTimeMultiLineQuaterData.value.chartData?.indexOf(item) ?? 0;
    //     MultiLineChartDataModal d = MultiLineChartDataModal(
    //       lineIndex: index,
    //       lineColor: getLineColor(index),
    //       isChecked: true,
    //       bottomTitles: ["Q1", "Q2", "Q3", "Q4"],
    //       lineIndicatortitle: item.subjectName ?? "",
    //       lineSpotData: getQuaterData(item.value ?? []),
    //     );
    //     quaterData = [...quaterData, d];
    //     setState(() {});
    //   }
    // }); //quater wise

    // _dashboardController.getLeaningTimeMultiLineChartMonthWise().then((value) {
    //   for (var item in _dashboardController.learningTimeMultiLineMonthData.value.chartData ?? []) {
    //     int index = _dashboardController.learningTimeMultiLineMonthData.value.chartData?.indexOf(item) ?? 0;
    //     MultiLineChartDataModal d = MultiLineChartDataModal(
    //       lineIndex: index,
    //       lineColor: getLineColor(index),
    //       isChecked: true,
    //       bottomTitles: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    //       lineIndicatortitle: item.subjectName ?? "",
    //       lineSpotData: getMonthData(item.value ?? []),
    //     );
    //     monthData = [...monthData, d];
    //     setState(() {});
    //   }
    // }); //month wise

    setState(() {
      isPrepararingData = false;
    });
  }

  void onLoTimeRangeChange(int index, BuildContext ctx) {
    // 1 -> week
    // 2 -> month
    // 3 -> qt
    // 4 -> Date Range

    timeFilterIndex = index;
    switch (index) {
      case 1:
        chartData = weekData;
        chartIndicatorData = weekData;
        break;
      case 2:
        chartData = monthData;
        chartIndicatorData = monthData;
        break;
      case 3:
        chartData = quaterData;
        chartIndicatorData = quaterData;
        break;
      case 4:
        break;
    }
    setState(() {});
  }

  void onSelectLine() {
    switch (timeFilterIndex) {
      case 1:
        chartData = weekData.where((element) => element.isChecked == true).toList();
        break;
      case 2:
        chartData = monthData.where((element) => element.isChecked == true).toList();
        break;
      case 3:
        chartData = quaterData.where((element) => element.isChecked == true).toList();
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      constraints: BoxConstraints(minHeight: 100.h, minWidth: double.infinity),
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
      child: Obx(() {
        if (_dashboardController.learningTimeMultiChartLoading.isTrue || isPrepararingData == true) {
          return const Align(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Learning Time",
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                LOTimeRangeSelectionBtnGroup(
                  callBackFunc: (v) {
                    onLoTimeRangeChange(v, context);
                  },
                  getdateRangePickerValue: (startDate, endDate) {
                    debugPrint("date selected $startDate - $endDate");
                  },
                ),
              ],
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.9,
                child: MultiLineChartWidget(
                  multiLineChartData: chartData,
                  multiLineChartIndicatorData: chartIndicatorData,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Wrap(
              children: chartIndicatorData
                  .map((e) => InkWell(
                        onTap: () {
                          e.isChecked = !e.isChecked;
                          onSelectLine();
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: e.isChecked == true ? e.lineColor : e.lineColor.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                e.lineIndicatortitle,
                                style: textTitle12StylePoppins.merge(
                                  const TextStyle(color: colorGrey400),
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            )
          ],
        );
      }),
    );
  }
}

class LOTimeRangeSelectionBtnGroup extends StatefulWidget {
  const LOTimeRangeSelectionBtnGroup({Key? key, required this.callBackFunc, required this.getdateRangePickerValue}) : super(key: key);

  final Function callBackFunc;
  final Function getdateRangePickerValue;

  @override
  State<LOTimeRangeSelectionBtnGroup> createState() => _LOTimeRangeSelectionBtnGroupState();
}

class _LOTimeRangeSelectionBtnGroupState extends State<LOTimeRangeSelectionBtnGroup> {
  int currentIndex = 1;

  DateTimeRange? _selectedDateRange;
  String? startDate;
  String? endDate;

  bool isDateSelected = false;

  void onRangeChange(int itemIndex) {
    if (itemIndex != currentIndex) {
      currentIndex = itemIndex;
      widget.callBackFunc(itemIndex);
      setState(() {});
      if (itemIndex == 4) {
        _show(context);
      }
    }
  }

  bool isCurrentSelection(int index) {
    return index == currentIndex;
  }

  // This function will be triggered when the btn press
  void _show(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4A5BF6), //Head background
            //dialogBackgroundColor: Colors.white,//Background color
          ),
          child: child!,
        );
      },
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Save',
    );

    if (result != null) {
      // Rebuild the UI

      setState(() {
        _selectedDateRange = result;
        isDateSelected = true;
        startDate = DateFormat("dd/MM/yyyy").format(result.start);
        endDate = DateFormat("dd/MM/yyyy").format(result.end);
      });

      widget.getdateRangePickerValue(result.start.toLocal().toIso8601String(), result.end.toLocal().toIso8601String());
    } else {
      setState(() {
        onRangeChange(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isDateSelected
        ? Row(
            children: [
              Text(
                "From",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(
                    color: colorGrey400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: colorGrey50,
                  border: Border.all(width: 1, color: colorGrey300),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Text(
                  startDate ?? "",
                  style: textTitle10StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "To",
                style: textTitle14StylePoppins.merge(
                  const TextStyle(
                    color: colorGrey400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: colorGrey50,
                  border: Border.all(width: 1, color: colorGrey300),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Text(
                  endDate ?? "",
                  style: textTitle10StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onRangeChange(1);
                  isDateSelected = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  child: const Icon(
                    Icons.close,
                    color: colorGrey400,
                    size: 20,
                  ),
                ),
              )
            ],
          )
        : Row(
            children: [
              InkWell(
                onTap: () {
                  onRangeChange(1);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: isCurrentSelection(1) ? colorBlue500 : Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Wl",
                      style: textTitle14StylePoppins.merge(
                        TextStyle(
                          color: isCurrentSelection(1) ? Colors.white : colorGrey400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onRangeChange(2);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: isCurrentSelection(2) ? colorBlue500 : Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Mth",
                      style: textTitle14StylePoppins.merge(
                        TextStyle(
                          color: isCurrentSelection(2) ? Colors.white : colorGrey400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onRangeChange(3);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: isCurrentSelection(3) ? colorBlue500 : Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Qt",
                      style: textTitle14StylePoppins.merge(
                        TextStyle(
                          color: isCurrentSelection(3) ? Colors.white : colorGrey400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     onRangeChange(4);
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 5.w),
              //     child: Container(
              //       padding: const EdgeInsets.all(5),
              //       decoration: BoxDecoration(color: isCurrentSelection(4) ? colorBlue500 : Colors.white, borderRadius: BorderRadius.circular(5)),
              //       child: Icon(
              //         Icons.event,
              //         color: isCurrentSelection(4) ? Colors.white : colorBlue500,
              //       ),
              //     ),
              //   ),
              // )
            ],
          );
  }
}
