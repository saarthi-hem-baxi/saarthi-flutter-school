import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/numbers.dart';
import '../../screen/dashboard/top_perfomers_full_list.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'multi_range_slider_chart.dart';

class TopPerfomersTable extends StatelessWidget {
  TopPerfomersTable({Key? key}) : super(key: key);

  final List d = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  final ScrollController _controller = ScrollController();

  void _navigateToFullListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TopPerfomersListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
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
      child: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Performers",
                      style: textTitle14StylePoppins.merge(
                        const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _navigateToFullListPage(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            color: colorBlue600,
                            borderRadius: BorderRadius.circular(5.w)),
                        child: Row(
                          children: [
                            Text(
                              "View all",
                              style: textTitle10StylePoppins.merge(
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 25,
                color: colorGrey50,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const _TopPerfomersTableHeaderRow(),
              ),
              Column(
                children: d.map((e) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: _TopPerfomersLoTableDataRow(
                      studentName: "Rajesh shah",
                      loMaxValue: 70,
                      loValue: getRandomToMaxNumber(50),
                      prevValue: getRandomToMaxNumber(100),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
