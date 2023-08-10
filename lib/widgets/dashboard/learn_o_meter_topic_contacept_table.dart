import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/dashboard_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../model/dashboard/learning_outcome_topic_concept.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class LearnOMeterTopicConceptTable extends StatelessWidget {
  LearnOMeterTopicConceptTable({Key? key}) : super(key: key);

  final DashboardController _dashboardController = Get.put(DashboardController());

  List<LearnOMeterTopicConceptTableRowModal> getRowData(TopicTable topicData) {
    if ((topicData.concepts ?? []).isNotEmpty) {
      return (topicData.concepts ?? []).map((c) {
        bool isLastItem = (topicData.concepts ?? []).last == c;
        return LearnOMeterTopicConceptTableRowModal(
          conceptName: c.name ?? "",
          avgPercentage: c.classClearity ?? 0,
          date: formatedDate(c.clearedAt),
          status: c.cleared,
          isLastItem: isLastItem,
        );
      }).toList();
    } else {
      return [
        LearnOMeterTopicConceptTableRowModal(
          conceptName: "-",
          avgPercentage: topicData.classClearity ?? 0,
          date: topicData.clearedAt == null ? "-" : formatedDate(topicData.clearedAt ?? DateTime.now()),
          status: topicData.cleared ?? false,
          isLastItem: true,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
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
        if (_dashboardController.loMConceptLoading.isTrue) {
          return const Align(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          );
        } else {
          LearningOutcomeTopicConceptModal tableData = _dashboardController.learningOutcomeConceptData.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tableData.chapterName ?? "",
                style: textTitle16WhiteBoldStyle.merge(
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorHeaderTextColor,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              _LearnOMeterConceptTableHeaderRow(),
              ...(tableData.topicTable ?? []).map((e) {
                return _TopiceConceptSingleItem(
                  itemData: LearnOMeterTopicConceptTableModal(
                    topicName: e.name ?? "",
                    rowData: getRowData(e),
                  ),
                );
              }).toList(),
            ],
          );
        }
      }),
    );
  }
}

class _LearnOMeterConceptTableHeaderRow extends StatelessWidget {
  _LearnOMeterConceptTableHeaderRow({
    Key? key,
  }) : super(key: key);

  final TextStyle headerTitleTextStyle = textTitle12StylePoppins.merge(
    const TextStyle(fontWeight: FontWeight.w500, color: colorGrey500),
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: colorGrey200),
          left: BorderSide(width: 1, color: colorGrey200),
          right: BorderSide(width: 1, color: colorGrey200),
        )),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Topic/\nConcept",
                style: headerTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),

            const VerticalDivider(
              width: 0,
              endIndent: 0,
              indent: 0,
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Text(
                    "Concept",
                    style: headerTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )),
            const VerticalDivider(
              width: 0,
              endIndent: 0,
              indent: 0,
            ),
            // Expanded(
            //   flex: 2,
            //   child: Padding(
            //     padding: EdgeInsets.all(5.w),
            //     child: Text(
            //       "Avg.% of class cleared",
            //       style: headerTitleTextStyle,
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            // const VerticalDivider(
            //   width: 0,
            //   endIndent: 0,
            //   indent: 0,
            // ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Text(
                  "Status",
                  style: headerTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const VerticalDivider(
              width: 0,
              endIndent: 0,
              indent: 0,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Text(
                  "Date",
                  style: headerTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopiceConceptSingleItem extends StatelessWidget {
  const _TopiceConceptSingleItem({
    Key? key,
    required this.itemData,
  }) : super(key: key);

  final LearnOMeterTopicConceptTableModal itemData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: colorGrey200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Text(
                  itemData.topicName,
                  textAlign: TextAlign.center,
                  style: textTitle12StylePoppins.merge(
                    const TextStyle(fontWeight: FontWeight.w500, color: colorGrey500),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 14.w,
            ),
            const VerticalDivider(
              endIndent: 0,
              indent: 0,
              width: 0,
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: itemData.rowData.map((e) {
                  return Expanded(
                    child: IntrinsicHeight(
                      child: _ConceptTableConceptRow(
                        conceptName: e.conceptName,
                        avgPercentage: e.avgPercentage,
                        status: e.status,
                        date: e.date ?? "-",
                        isLastItem: e.isLastItem,
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ConceptTableConceptRow extends StatelessWidget {
  const _ConceptTableConceptRow({
    Key? key,
    required this.conceptName,
    required this.avgPercentage,
    required this.status,
    required this.date,
    this.isLastItem = false,
  }) : super(key: key);

  final String conceptName;
  final num avgPercentage;
  final bool? status;
  final String date;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: isLastItem == true ? Colors.white : colorGrey200),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Text(
                conceptName.toString(),
                style: textTitle12StylePoppins.merge(const TextStyle(color: colorGrey500)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const VerticalDivider(
            endIndent: 0,
            indent: 0,
            width: 0,
          ),
          // Expanded(
          //   flex: 2,
          //   child: Padding(
          //     padding: EdgeInsets.all(5.w),
          //     child: Text(
          //       "${avgPercentage.toString()}%",
          //       style: textTitle12StylePoppins.merge(const TextStyle(fontWeight: FontWeight.w500, color: colorGrey500)),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          // const VerticalDivider(
          //   width: 0,
          //   endIndent: 0,
          //   indent: 0,
          // ),
          Expanded(
            flex: 2,
            child: status == null
                ? Text(
                    "-",
                    style: textTitle12StylePoppins.merge(const TextStyle(color: colorGrey500)),
                    textAlign: TextAlign.center,
                  )
                : Icon(
                    status == true ? Icons.check_circle : Icons.warning_rounded,
                    color: status == true ? colorGreen500 : colorRed500,
                    size: 20.w,
                  ),
          ),
          const VerticalDivider(
            width: 0,
            endIndent: 0,
            indent: 0,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Text(
                date,
                style: textTitle12StylePoppins.merge(const TextStyle(color: colorGrey500)),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LearnOMeterTopicConceptTableModal {
  String topicName;
  List<LearnOMeterTopicConceptTableRowModal> rowData;

  LearnOMeterTopicConceptTableModal({required this.topicName, required this.rowData});
}

class LearnOMeterTopicConceptTableRowModal {
  String conceptName;
  num avgPercentage;
  bool? status;
  String? date;
  bool isLastItem;

  LearnOMeterTopicConceptTableRowModal({
    required this.conceptName,
    required this.avgPercentage,
    required this.status,
    required this.date,
    this.isLastItem = false,
  });
}
