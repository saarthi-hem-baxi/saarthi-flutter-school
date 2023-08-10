import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/numbers.dart';
import '../../helpers/utils.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';

class ProgressivePerfomersListPage extends StatelessWidget {
  const ProgressivePerfomersListPage({Key? key}) : super(key: key);

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
            title: "Progressive performers",
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
                    "Progressive Performers",
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
                  child: const _ProgressivePerfomersTableHeaderRow(),
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
                            lastWeekLo:
                                "${getRandomToMaxNumber(70).toString()}/${getRandomToMaxNumber(80).toString()}",
                            thisWeekLo:
                                "${getRandomToMaxNumber(70).toString()}/${getRandomToMaxNumber(80).toString()}",
                            deltaChange: getRandomToMaxNumber(90),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
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
