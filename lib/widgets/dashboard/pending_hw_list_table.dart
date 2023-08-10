import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/screen/dashboard/hw_pending_details_list.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class HWPendingListTable extends StatelessWidget {
  HWPendingListTable({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> data = [
    {
      "subject": "Maths",
      "ch": 10,
      "altd": "5 Nov",
      "cl": getRandomToMaxNumber(95),
      "by": "Sunita",
    },
    {
      "subject": "Sci",
      "ch": 4,
      "altd": "6 Nov",
      "cl": getRandomToMaxNumber(95),
      "by": "Raj",
    },
    {
      "subject": "Eng",
      "ch": 6,
      "altd": "12 Oct",
      "cl": getRandomToMaxNumber(95),
      "by": "Keval",
    },
    {
      "subject": "Sci",
      "ch": 8,
      "altd": "15 Oct",
      "cl": getRandomToMaxNumber(95),
      "by": "Dipali",
    },
    {
      "subject": "Math",
      "ch": 12,
      "altd": "5 Oct",
      "cl": getRandomToMaxNumber(95),
      "by": "Mira",
    },
    {
      "subject": "SS",
      "ch": 12,
      "altd": "8 Nov",
      "cl": getRandomToMaxNumber(95),
      "by": "Mira",
    },
    {
      "subject": "SS",
      "ch": 10,
      "altd": "14 Nov",
      "cl": getRandomToMaxNumber(95),
      "by": "Mira",
    },
    {
      "subject": "Sci",
      "ch": 3,
      "altd": "3 Sep",
      "cl": getRandomToMaxNumber(95),
      "by": "Dipali",
    },
    {
      "subject": "Eng",
      "ch": 2,
      "altd": "19 Oct",
      "cl": getRandomToMaxNumber(95),
      "by": "Keval",
    },
  ];

  final ScrollController _controller = ScrollController();

  void navigateToFullListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HWPendingListPage(),
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
                      "Avani, HW is pending !",
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
                child: const _HWPendingTableRowHeader(),
              ),
              Column(
                children: data.map((e) {
                  int index = data.indexOf(e);
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: _HWPendingTableDataRow(
                      index: index + 1,
                      sub: e['subject'],
                      chNo: e['ch'],
                      altdDate: e['altd'],
                      clStatus: e['cl'],
                      allotedBy: e['by'],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _HWPendingTableRowHeader extends StatelessWidget {
  const _HWPendingTableRowHeader({
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
            "Altd. on",
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
            "Cl.status",
            style: textTitle10StylePoppins.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorGrey500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "",
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

class _HWPendingTableDataRow extends StatelessWidget {
  const _HWPendingTableDataRow({
    Key? key,
    required this.index,
    required this.sub,
    required this.chNo,
    required this.altdDate,
    required this.clStatus,
    required this.allotedBy,
  }) : super(key: key);

  final int index;
  final String sub;
  final int chNo;
  final String altdDate;
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
            altdDate,
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
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.w),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: colorPurple50,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Text(
              "Complete Now",
              style: textTitle10StylePoppins.merge(
                const TextStyle(color: colorPurple500),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            allotedBy,
            style: textTitle12StylePoppins.merge(
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
