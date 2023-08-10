import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../widgets/common/header.dart';

class HWPendingListPage extends StatelessWidget {
  HWPendingListPage({Key? key}) : super(key: key);

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
    20,
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
              title: "HW Pending",
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
                      "HW pending",
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
                    child: const _HWPendingListTableRowHeader(),
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
                              child: _HWPendingListTableDataRow(
                                index: index + 1,
                                sub: "Maths asdsd sa",
                                chNo: index * 2,
                                allotedDate: "5 Nov",
                                clStatus: 20,
                                allotedBy: "Sunita",
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HWPendingListTableRowHeader extends StatelessWidget {
  const _HWPendingListTableRowHeader({
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
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Sub",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Allotted on",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Cl. status",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Alloted by",
            style: textTitle10StylePoppins.merge(
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

class _HWPendingListTableDataRow extends StatelessWidget {
  const _HWPendingListTableDataRow({
    Key? key,
    required this.index,
    required this.sub,
    required this.chNo,
    required this.allotedDate,
    required this.clStatus,
    required this.allotedBy,
  }) : super(key: key);

  final int index;
  final String sub;
  final int chNo;
  final String allotedDate;
  final int clStatus;
  final String allotedBy;

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
          flex: 2,
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
          flex: 1,
          child: Text(
            allotedDate,
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "$clStatus%",
            style: textTitle12StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            allotedBy,
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
