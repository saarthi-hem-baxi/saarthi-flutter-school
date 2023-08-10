import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/numbers.dart';
import '../../screen/dashboard/progressive_perfomers_full_list.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class ProgressivePerfomersTable extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  final List d = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  ProgressivePerfomersTable({Key? key}) : super(key: key);

  void _navigateToFullListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProgressivePerfomersListPage(),
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
                      "Progressive Performers",
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
                child: const _ProgressivePerfomersTableHeaderRow(),
              ),
              Column(
                children: d.map((e) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: _TopPerfomersLoTableDataRow(
                      studentName: "Rajesh shah",
                      lastWeekLo:
                          "${getRandomToMaxNumber(70).toString()}/${getRandomToMaxNumber(80).toString()}",
                      thisWeekLo:
                          "${getRandomToMaxNumber(70).toString()}/${getRandomToMaxNumber(80).toString()}",
                      deltaChange: getRandomToMaxNumber(90),
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

class _ProgressivePerfomersTableHeaderRow extends StatelessWidget {
  const _ProgressivePerfomersTableHeaderRow({
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
          flex: 2,
          child: Text(
            "Last wk LO",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "This wk LO",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Delta Change",
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
    required this.lastWeekLo,
    required this.thisWeekLo,
    required this.deltaChange,
  }) : super(key: key);

  final String studentName;
  final String lastWeekLo;
  final String thisWeekLo;
  final int deltaChange;

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
          flex: 2,
          child: Text(
            lastWeekLo,
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            thisWeekLo,
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "$deltaChange%",
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
