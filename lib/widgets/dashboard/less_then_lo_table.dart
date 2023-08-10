import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/multi_range_slider_chart.dart';

import '../../helpers/numbers.dart';
import '../../screen/dashboard/less_then_lo_full_list.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class LessthenLOTable extends StatelessWidget {
  LessthenLOTable({Key? key}) : super(key: key);

  final List d = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  final ScrollController _controller = ScrollController();

  void navigateToFullListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LessThenLoListPage(),
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
                      "Less Then 50% LO",
                      style: textTitle14StylePoppins.merge(
                        const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigateToFullListPage(context);
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
                child: const _LessThenLoTableRowHeader(),
              ),
              Column(
                children: d.map((e) {
                  int index = d.indexOf(e);
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: _LessThenLoTableDataRow(
                      index: index + 1,
                      sub: "Maths asdsd sa",
                      chNo: index * 2,
                      loMaxValue: 60,
                      loValue: getRandomToMaxNumber(50),
                      avgClassLoValue: getRandomToMaxNumber(95),
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
