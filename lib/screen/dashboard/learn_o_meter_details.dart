import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/dashboard_controller.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../model/dashboard/lo_meter_details_chapter.modal.dart';
import '../../model/dashboard/lo_meter_details_subjects.modal.dart';
import '../../widgets/common/header.dart';
import '../../widgets/dashboard/charts/single_bar_chart.dart';
import '../../widgets/dashboard/learn_o_meter_topic_contacept_table.dart';

class LearnOMeterDetails extends StatelessWidget {
  LearnOMeterDetails({Key? key}) : super(key: key);

  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderCard(
              backEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
              title: "Learn-o-meter",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      const _LearnOMeterSubjectsChart(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() {
                        if (_dashboardController.isLoChapterLoaded.isTrue) {
                          return const _LearnOMeterChaptersChart();
                        } else {
                          return const SizedBox();
                        }
                      }),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // _LearnOMeterChapterMap(),
                      SizedBox(
                        height: 10.h,
                      ),

                      LearnOMeterTopicConceptTable()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LearnOMeterSubjectsChart extends StatefulWidget {
  const _LearnOMeterSubjectsChart({Key? key}) : super(key: key);

  @override
  State<_LearnOMeterSubjectsChart> createState() => _LearnOMeterSubjectsChartState();
}

class _LearnOMeterSubjectsChartState extends State<_LearnOMeterSubjectsChart> {
  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _dashboardController.getLOMeterDetailsSubjects();
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
        if (_dashboardController.loMSubjectsLoading.isTrue) {
          return const Align(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          );
        } else {
          LoMeterDetailsSubjectModal loMeteSubjectData = _dashboardController.loMDetailsSubjectsData.value;
          return AspectRatio(
            aspectRatio: 1.5,
            child: SingleBarChartWidget(
              chartLegendTitle: "Concept understood %",
              isValueInPercentage: true,
              gradinentColors: const [
                orangeGradientC1,
                orangeGradientC2,
              ],
              singleBarChartData: (loMeteSubjectData.chartData ?? []).map((e) {
                return SingleBarChartWidgetDataModal(name: e.name ?? "", value: e.value ?? 0);
              }).toList(),
              onBarPress: (v) {
                Future.delayed(Duration.zero, () {
                  _dashboardController.getLOMeterDetailsChapters(subjectId: (loMeteSubjectData.chartData ?? [])[v].subjectId ?? "");
                });
                debugPrint("this is press ${loMeteSubjectData.chartData?[v].subjectId ?? ''}");
              },
            ),
          );
        }
      }),
    );
  }
}

class _LearnOMeterChaptersChart extends StatefulWidget {
  const _LearnOMeterChaptersChart({Key? key}) : super(key: key);

  @override
  State<_LearnOMeterChaptersChart> createState() => _LearnOMeterChaptersChartState();
}

class _LearnOMeterChaptersChartState extends State<_LearnOMeterChaptersChart> {
  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Text(
            _dashboardController.loMDetailsChapterData.value.subjectName ?? "",
            style: textTitle16WhiteBoldStyle.merge(
              const TextStyle(
                fontWeight: FontWeight.bold,
                color: colorHeaderTextColor,
              ),
            ),
          );
        }),
        SizedBox(
          height: 5.h,
        ),
        Container(
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
          child: Obx(
            () {
              if (_dashboardController.loMChapterLoading.isTrue) {
                return const Align(
                  alignment: Alignment.center,
                  child: LoadingSpinner(),
                );
              } else {
                LoMeterDetailsChapterModal loMeteChapterData = _dashboardController.loMDetailsChapterData.value;
                return AspectRatio(
                  aspectRatio: 1.5,
                  child: SingleBarChartWidget(
                    chartLegendTitle: "Concept understood %",
                    bottomChartLegendTitle: "Chapter no.",
                    isValueInPercentage: true,
                    gradinentColors: const [
                      skyGradientC1,
                      skyGradientC2,
                    ],
                    singleBarChartData: (loMeteChapterData.chartData ?? []).map((e) {
                      return SingleBarChartWidgetDataModal(name: e.chapterNumber.toString(), value: e.value ?? 0);
                    }).toList(),
                    onBarPress: (v) {
                      Future.delayed(Duration.zero, () {
                        _dashboardController.getLOMeterDetailsConceptsTable(
                            subjectId: loMeteChapterData.chartData?[v].subjectId ?? "", chapterId: loMeteChapterData.chartData?[v].chapterId ?? "");
                      });
                      debugPrint("this is press chapter $v");
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
