import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/numbers.dart';
import '../../helpers/utils.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/multi_range_slider_chart.dart';

class LessThenLoListPage extends StatelessWidget {
  const LessThenLoListPage({Key? key}) : super(key: key);

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
              title: "Less then 50% LO",
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
                      "Less then 50% LO",
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
                    child: const _LessThenLoTableRowHeader(),
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
                            child: _LessThenLoTableDataRow(
                              index: index + 1,
                              sub: "Maths asdsd sa",
                              chNo: index * 2,
                              loMaxValue: 60,
                              loValue: getRandomToMaxNumber(50),
                              avgClassLoValue: getRandomToMaxNumber(95),
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

class _LessThenLoTableRowHeader extends StatelessWidget {
  const _LessThenLoTableRowHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "No",
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
            "Sub",
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
            "Ch",
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
            "Lo % (<50)",
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
            "Avg. Class LO",
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

class _LessThenLoTableDataRow extends StatelessWidget {
  const _LessThenLoTableDataRow({
    Key? key,
    required this.index,
    required this.sub,
    required this.chNo,
    required this.loMaxValue,
    required this.loValue,
    required this.avgClassLoValue,
  }) : super(key: key);

  final int index;
  final String sub;
  final int chNo;
  final int loMaxValue;
  final int loValue;
  final int avgClassLoValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            index.toString(),
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            sub,
            style: textTitle14StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "$chNo",
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
            "$avgClassLoValue%",
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
