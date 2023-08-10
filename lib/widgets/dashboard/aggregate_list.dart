import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../theme/colors.dart';

class AggregateSubjectList extends StatelessWidget {
  AggregateSubjectList({Key? key, required this.listOfAggregateData})
      : super(key: key);

  final List<AggregatedSubjectListModal> listOfAggregateData;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(12.w),
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
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Aggregate",
              style: textTitle14StyleMediumPoppins,
            ),
          ),
          SizedBox(
            height: 250.h,
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listOfAggregateData.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return AggregatedSubjectListTitle(
                      aggregatedSubjectListModal: listOfAggregateData[index],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AggregatedSubjectListTitle extends StatelessWidget {
  const AggregatedSubjectListTitle({
    Key? key,
    required this.aggregatedSubjectListModal,
  }) : super(key: key);

  final AggregatedSubjectListModal aggregatedSubjectListModal;

  Color getValueTextColor() {
    if (aggregatedSubjectListModal.value <= 20) {
      return colorRed500;
    } else if (aggregatedSubjectListModal.value > 20 &&
        aggregatedSubjectListModal.value <= 50) {
      return colorYellow500;
    } else {
      return colorGreen500;
    }
  }

  Color getTitleTextColor() {
    if (aggregatedSubjectListModal.value <= 20) {
      return colorRed500;
    } else {
      return colorGrey60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              aggregatedSubjectListModal.subjectName,
              style: textTitle14StylePoppins.merge(
                TextStyle(
                  color: getTitleTextColor(),
                ),
              ),
            ),
          ),
          Text(
            "${aggregatedSubjectListModal.value} %",
            style: textTitle12StylePoppins.merge(TextStyle(
              fontWeight: FontWeight.w600,
              color: getValueTextColor(),
            )),
          ),
        ],
      ),
    );
  }
}

class AggregatedSubjectListModal {
  String subjectName;
  num value;

  AggregatedSubjectListModal({required this.subjectName, required this.value});
}
