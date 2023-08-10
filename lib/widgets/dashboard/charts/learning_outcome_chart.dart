import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../model/dashboard/learning_outcome_subject.dart';
import '../../../theme/colors.dart';
import '../../common/loading_spinner.dart';
import 'single_bar_chart.dart';

class LerningOutComeChart extends StatelessWidget {
  LerningOutComeChart({Key? key}) : super(key: key);

  final DashboardController _dashboardController = Get.put(DashboardController());

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Learning Outcome",
            style: textTitle14StylePoppins.merge(
              const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          FutureBuilder(
              future: _dashboardController.getLearningOutCome(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Align(
                    alignment: Alignment.center,
                    child: LoadingSpinner(),
                  );
                } else {
                  if (snapshot.hasData) {
                    LearningOutcomeSubjectModal learningOutcomeSubjectData = snapshot.data as LearningOutcomeSubjectModal;
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: SingleBarChartWidget(
                            chartLegendTitle: "LO %",
                            isValueInPercentage: true,
                            gradinentColors: const [
                              purpleGradient1,
                              purpleGradinet2,
                            ],
                            singleBarChartData: (learningOutcomeSubjectData.chartData ?? []).map((e) {
                              return SingleBarChartWidgetDataModal(name: e.name ?? "", value: e.value ?? 0);
                            }).toList(),
                            onBarPress: (v) {},
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Align(
                      alignment: Alignment.center,
                      child: LoadingSpinner(),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
