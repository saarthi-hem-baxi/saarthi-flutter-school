import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/numbers.dart';
import '../../helpers/utils.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/multi_range_slider_chart.dart';

class TopPerfomersListPage extends StatelessWidget {
  const TopPerfomersListPage({Key? key}) : super(key: key);

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
              title: "Top performers",
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Text(
                      "Top performers",
                      style: textTitle14StylePoppins.merge(
                        const TextStyle(
                            fontWeight: FontWeight.w600, color: colorGrey600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    color: colorGrey50,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: const _TopPerfomersTableHeaderRow(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height:
                        getScrenHeight(context) - getScrenHeight(context) / 3.2,
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 30,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            child: _TopPerfomersLoTableDataRow(
                              studentName: "Rajesh shah",
                              loMaxValue: 70,
                              loValue: getRandomToMaxNumber(50),
                              prevValue: getRandomToMaxNumber(100),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPerfomersTableHeaderRow extends StatelessWidget {
  const _TopPerfomersTableHeaderRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Students",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Achived LO(70+)",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Prev",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopPerfomersLoTableDataRow extends StatelessWidget {
  const _TopPerfomersLoTableDataRow({
    Key? key,
    required this.studentName,
    required this.loMaxValue,
    required this.loValue,
    required this.prevValue,
  }) : super(key: key);

  final String studentName;

  final int loMaxValue;
  final int loValue;
  final int prevValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            studentName,
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              SizedBox(
                width: 80.w,
                child: MultiRangeSliderChart(
                  firstValueInPercentage: loValue.toDouble(),
                  maxStopValueInPercentage: loMaxValue.toDouble(),
                  sliderMainWidth: 80.w,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "$loValue%",
                style: textTitle12StylePoppins.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorGrey500,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "$prevValue%",
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
