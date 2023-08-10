import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/content_report/lp_content_report.modal.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/content_report/content_report_icon.dart';
import 'package:saarthi_pedagogy_studentapp/screen/content_report/content_report_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_topic_list.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/outline_indicator.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/lessonplans/lessplans_description.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/lessonplans/lessplans_example.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/lessonplans/lessplans_word_section.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/lessonplans/media/lesson_plan_media_section.dart';
import '../../controllers/retest_controller.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/key_learning.dart';

class AutoHWReTestConceptClear extends StatefulWidget {
  const AutoHWReTestConceptClear({
    Key? key,
    this.retestResult,
    this.title,
    required this.subjectId,
    required this.chapterId,
    required this.topicId,
    required this.topicType,
    required this.topicName,
    this.isSelfAutoHW = false,
    required this.homeworkId,
    required this.isOngoing,
    required this.type,
    this.isFromRoadMapResult = false,
  }) : super(key: key);
  final RetestResult? retestResult;
  final String? title;
  final String subjectId;
  final String chapterId;
  final String topicId;
  final String topicType;
  final String topicName;
  final bool isSelfAutoHW;
  final String homeworkId;
  final bool isOngoing;
  final ByHomeworkTypes type;
  final bool isFromRoadMapResult;

  @override
  State<AutoHWReTestConceptClear> createState() => _AutoHWReTestConceptClearState();
}

class _AutoHWReTestConceptClearState extends State<AutoHWReTestConceptClear> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());

  TabController? _tabController;
  final List<Tab> _tab = [];
  final List<Widget> _tabMenu = [];
  String? keyLearningId;
  String topicName = "-1";
  late LPQBType topicType;

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();
    topicName = widget.topicName;
    if (widget.topicType == 'topic') {
      topicType = LPQBType.topic;
    } else {
      topicType = LPQBType.concept;
    }
    (widget.retestResult?.keyLearnings ?? []).map((e) {
      if (e.cleared == false) {
        if (keyLearningId == null) {
          keyLearningId = (e.keyLearning?.id.toString() ?? "");
        } else {
          keyLearningId = '$keyLearningId' ',' + (e.keyLearning?.id.toString() ?? "");
        }
        _tab.add(Tab(
          text: (e.keyLearning?.name?.enUs.toString() ?? ""),
        ));

        _tabMenu.add(lessonPlan());
      }
    }).toList();

    _tabController = TabController(length: _tab.length, vsync: this);

    final split = keyLearningId!.split(',');
    List<String> keyLearningIds = [];
    for (int i = 0; i < split.length; i++) {
      keyLearningIds.add(split[i]);
    }
    _tabController?.addListener(() {
      if (_tabController?.indexIsChanging == false) {
        retestsController.getRetestClearDataByKeyLearnigId(keyLearningIds[(_tabController?.index) ?? 0], true);
      }
    });
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  void onResume() {
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  void reloadData() async {
    await retestsController.getRetestClearData(
        context: context,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        conceptId: (widget.retestResult?.concept?.id.toString() ?? ""),
        keyLearningId: keyLearningId.toString(),
        topicId: widget.topicId,
        type: widget.type);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                // color: loginScreenBackgroundColor,
                children: [
                  HeaderCard(
                    title: widget.title.toString(),
                    backEnabled: true,
                    onTap: _onBackPressed,
                  ),
                  SizedBox(
                    height: 60.h,
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      labelStyle: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.w600)),
                      labelColor: colorPurple,
                      unselectedLabelStyle: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.w600)),
                      unselectedLabelColor: colorText163Gray,
                      indicator: const OutlineIndicator(color: colorPurple, strokeWidth: 4, radius: Radius.circular(10)),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: _tab.map((e) => e).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _tabMenu.map((e) => e).toList(),
                      controller: _tabController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget lessonPlan() {
    return Obx(() => Container(
          // ignore: unrelated_type_equality_checks
          child: retestsController.loading == true
              ? const Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: LoadingSpinner(color: Colors.blue),
                    ),
                  ),
                )
              : Column(
                  children: [
                    (retestsController.lessonPlanListModal.value.lessonPlans ?? []).isEmpty
                        ? const Expanded(
                            child: NoDataCard(
                              title: "Oops...\n No Lessonplan found",
                              description: " No Lessonplan found \nkindly contact your teacher.",
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                cacheExtent: 1000,
                                itemCount: retestsController.lessonPlanListModal.value.lessonPlans?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var lessPlans = retestsController.lessonPlanListModal.value.lessonPlans?[index];
                                  String lang = retestsController.lessonPlanListModal.value.lang ?? "";
                                  return Container(
                                    width: getScreenWidth(context),
                                    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                    decoration: boxDecoration10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 5.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  lessPlans?.studentInstruction?[lang] ?? "",
                                                  style: textTitle14BoldStyle
                                                      .merge(const TextStyle(fontWeight: FontWeight.normal, color: colorBodyText)),
                                                ),
                                              ),
                                              ContentReportIcon(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ContentReportPage(
                                                        typeOfContent: ContentReportType.lessonplan,
                                                        lpContentReportdata: LpContentReportModal(
                                                          lang: retestsController.lessonPlanListModal.value.lang,
                                                          book: lessPlans?.book,
                                                          subject: widget.subjectId,
                                                          chapter: widget.chapterId,
                                                          // topics: widget.type == LPQBType.topic ? [widget.topicid] : [],
                                                          // concepts: widget.type == LPQBType.concept ? [widget.topicid] : [],
                                                          isPublisher: lessPlans?.isPublisher,
                                                          publisher: lessPlans?.publisher,
                                                          content: LPReportContent(
                                                            lessonPlan: lessPlans?.id,
                                                            forStudent: LPReportForStudent(
                                                              forStudent: true,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: (lessPlans?.descriptions ?? []).isNotEmpty ? 1 : 0,
                                          width: getScreenWidth(context),
                                          child: Container(
                                            color: colorText163Gray,
                                          ),
                                        ),
                                        Container(
                                          child: lessPlans?.descriptions != null
                                              ? (lessPlans?.descriptions ?? []).isNotEmpty
                                                  ? lessPlans != null
                                                      ? DescriptionSectionNew(
                                                          lessonPlanModal: retestsController.lessonPlanListModal.value,
                                                          lessonPlan: lessPlans,
                                                          lessonPlanIndex: index,
                                                          id: widget.topicId,
                                                          type: topicType,
                                                          subjectId: widget.subjectId,
                                                          chapterId: widget.chapterId,
                                                        )
                                                      : null
                                                  : null
                                              : null,
                                        ),
                                        SizedBox(
                                          height: lessPlans != null
                                              ? (lessPlans.words ?? []).isNotEmpty
                                                  ? 1
                                                  : 0
                                              : 0,
                                          width: getScreenWidth(context),
                                          child: Container(
                                            color: colorText163Gray,
                                          ),
                                        ),
                                        Container(
                                          child: lessPlans != null
                                              ? (lessPlans.words ?? []).isNotEmpty
                                                  ? WordSection(
                                                      lessonPlanModal: retestsController.lessonPlanListModal.value,
                                                      lessonPlan: lessPlans,
                                                      id: widget.topicId,
                                                      type: topicType,
                                                      subjectId: widget.subjectId,
                                                      chapterId: widget.chapterId,
                                                    )
                                                  : null
                                              : null,
                                        ),
                                        SizedBox(
                                          height: lessPlans != null
                                              ? ((lessPlans.images ?? []).isNotEmpty ||
                                                      (lessPlans.videos ?? []).isNotEmpty ||
                                                      (lessPlans.pdfs ?? []).isNotEmpty ||
                                                      (lessPlans.audio ?? []).isNotEmpty ||
                                                      (lessPlans.links ?? []).isNotEmpty ||
                                                      (lessPlans.simulations ?? []).isNotEmpty)
                                                  ? 1
                                                  : 0
                                              : 0,
                                          width: getScreenWidth(context),
                                          child: Container(
                                            color: colorText163Gray,
                                          ),
                                        ),
                                        Container(
                                          child: lessPlans != null
                                              ? (lessPlans.contentTypes ?? []).isNotEmpty
                                                  ? MediaSection(
                                                      lessonPlanModal: retestsController.lessonPlanListModal.value,
                                                      lessonPlan: lessPlans,
                                                      id: widget.topicId,
                                                      type: topicType,
                                                      subjectId: widget.subjectId,
                                                      chapterId: widget.chapterId,
                                                    )
                                                  : null
                                              : null,
                                        ),
                                        SizedBox(
                                          height: lessPlans != null
                                              ? (lessPlans.examples ?? []).isNotEmpty
                                                  ? 1
                                                  : 0
                                              : 0,
                                          width: getScreenWidth(context),
                                          child: Container(
                                            color: colorText163Gray,
                                          ),
                                        ),
                                        Container(
                                          child: lessPlans != null
                                              ? (lessPlans.examples ?? []).isNotEmpty
                                                  ? ExampleSectionNew(
                                                      lessonPlanModal: retestsController.lessonPlanListModal.value,
                                                      lessonPlan: lessPlans,
                                                      lessonPlanIndex: index,
                                                      id: widget.topicId,
                                                      type: topicType,
                                                      subjectId: widget.subjectId,
                                                      chapterId: widget.chapterId,
                                                    )
                                                  : null
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.isOngoing) {
                          showRetestSelectionDialog();
                        }
                      },
                      child: Container(
                        height: 36.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          // color: Colors.amber,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              color: colorDropShadowLight,
                              blurRadius: 1,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                          gradient: widget.isOngoing == true ? grayGradient : pinkGradient,
                        ),
                        //alignment: AlignmentDirectional.topStart,
                        child: Center(
                          child: Text(
                            "Retest",
                            style: textTitle18WhiteBoldStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    )
                  ],
                ),
        ));

    // return Obx(() => Container(
    //       // ignore: unrelated_type_equality_checks
    //       child: retestsController.loading == true
    //           ? const Align(
    //               alignment: Alignment.topCenter,
    //               child: SizedBox(
    //                 height: 100,
    //                 child: Center(
    //                   child: LoadingSpinner(color: Colors.blue),
    //                 ),
    //               ),
    //             )
    //           : (retestsController.lessonPlanModel.value.lessonPlans ?? []).isEmpty
    //               ? const Expanded(
    //                   child: NoDataCard(
    //                     title: "Oops...\n No Lessonplan found",
    //                     description: " No Lessonplan found \nkindly contact your teacher.",
    //                   ),
    //                 )
    //               : Column(
    //                   children: [
    //                     Expanded(
    //                       child: Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //                         child: ListView.builder(
    //                           cacheExtent: 1000,
    //                           itemCount: retestsController.lessonPlanModel.value.lessonPlans?.length,
    //                           itemBuilder: (BuildContext context, int index) {
    //                             var lessPlans = retestsController.lessonPlanModel.value.lessonPlans?[index];
    //                             String lang = retestsController.lessonPlanModel.value.lang ?? "";
    //                             return Container(
    //                               width: getScreenWidth(context),
    //                               margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
    //                               decoration: boxDecoration10,
    //                               child: Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 children: [
    //                                   Padding(
    //                                     padding: EdgeInsets.symmetric(
    //                                       horizontal: 10.w,
    //                                       vertical: 5.h,
    //                                     ),
    //                                     child: Row(
    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         Flexible(
    //                                           child: Text(
    //                                             lessPlans?.studentInstruction?[lang] ?? "",
    //                                             style:
    //                                                 textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.normal, color: colorBodyText)),
    //                                           ),
    //                                         ),
    //                                         ContentReportIcon(
    //                                           onTap: () {
    //                                             Navigator.push(
    //                                               context,
    //                                               MaterialPageRoute(
    //                                                 builder: (context) => ContentReportPage(
    //                                                   typeOfContent: ContentReportType.lessonplan,
    //                                                   lpContentReportdata: LpContentReportModal(
    //                                                     lang: retestsController.lessonPlanModel.value.lang,
    //                                                     book: lessPlans?.book,
    //                                                     subject: widget.subjectId,
    //                                                     chapter: widget.chapterId,
    //                                                     // topics: widget.type == LPQBType.topic ? [widget.topicid] : [],
    //                                                     // concepts: widget.type == LPQBType.concept ? [widget.topicid] : [],
    //                                                     isPublisher: lessPlans?.isPublisher,
    //                                                     publisher: lessPlans?.publisher,
    //                                                     content: LPReportContent(
    //                                                       lessonPlan: lessPlans?.id,
    //                                                       forStudent: LPReportForStudent(
    //                                                         forStudent: true,
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             );
    //                                           },
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   SizedBox(
    //                                     height: (lessPlans?.descriptions ?? []).isNotEmpty ? 1 : 0,
    //                                     width: getScreenWidth(context),
    //                                     child: Container(
    //                                       color: colorText163Gray,
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     child: lessPlans?.descriptions != null
    //                                         ? (lessPlans?.descriptions ?? []).isNotEmpty
    //                                             ? lessPlans != null
    //                                                 ? DescriptionSectionNew(
    //                                                     lessonPlanModal: retestsController.lessonPlanModel.value,
    //                                                     lessonPlan: lessPlans,
    //                                                     lessonPlanIndex: index,
    //                                                     id: topicName,
    //                                                     type: topicType,
    //                                                     subjectId: widget.subjectId,
    //                                                     chapterId: widget.chapterId,
    //                                                   )
    //                                                 : null
    //                                             : null
    //                                         : null,
    //                                   ),
    //                                   SizedBox(
    //                                     height: lessPlans != null
    //                                         ? (lessPlans.words ?? []).isNotEmpty
    //                                             ? 1
    //                                             : 0
    //                                         : 0,
    //                                     width: getScreenWidth(context),
    //                                     child: Container(
    //                                       color: colorText163Gray,
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     child: lessPlans != null
    //                                         ? (lessPlans.words ?? []).isNotEmpty
    //                                             ? WordSection(
    //                                                 lessonPlanModal: retestsController.lessonPlanModel.value,
    //                                                 lessonPlan: lessPlans,
    //                                                 id: topicName,
    //                                                 type: topicType,
    //                                                 subjectId: widget.subjectId,
    //                                                 chapterId: widget.chapterId,
    //                                               )
    //                                             : null
    //                                         : null,
    //                                   ),
    //                                   SizedBox(
    //                                     height: lessPlans != null
    //                                         ? ((lessPlans.images ?? []).isNotEmpty ||
    //                                                 (lessPlans.videos ?? []).isNotEmpty ||
    //                                                 (lessPlans.pdfs ?? []).isNotEmpty ||
    //                                                 (lessPlans.audio ?? []).isNotEmpty ||
    //                                                 (lessPlans.links ?? []).isNotEmpty ||
    //                                                 (lessPlans.simulations ?? []).isNotEmpty)
    //                                             ? 1
    //                                             : 0
    //                                         : 0,
    //                                     width: getScreenWidth(context),
    //                                     child: Container(
    //                                       color: colorText163Gray,
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     child: lessPlans != null
    //                                         ? (lessPlans.contentTypes ?? []).isNotEmpty
    //                                             ? MediaSection(
    //                                                 lessonPlanModal: retestsController.lessonPlanModel.value,
    //                                                 lessonPlan: lessPlans,
    //                                                 id: topicName,
    //                                                 type: topicType,
    //                                                 subjectId: widget.subjectId,
    //                                                 chapterId: widget.chapterId,
    //                                               )
    //                                             : null
    //                                         : null,
    //                                   ),
    //                                   SizedBox(
    //                                     height: lessPlans != null
    //                                         ? (lessPlans.examples ?? []).isNotEmpty
    //                                             ? 1
    //                                             : 0
    //                                         : 0,
    //                                     width: getScreenWidth(context),
    //                                     child: Container(
    //                                       color: colorText163Gray,
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     child: lessPlans != null
    //                                         ? (lessPlans.examples ?? []).isNotEmpty
    //                                             ? ExampleSectionNew(
    //                                                 lessonPlanModal: retestsController.lessonPlanModel.value,
    //                                                 lessonPlan: lessPlans,
    //                                                 lessonPlanIndex: index,
    //                                                 id: topicName,
    //                                                 type: topicType,
    //                                                 subjectId: widget.subjectId,
    //                                                 chapterId: widget.chapterId,
    //                                               )
    //                                             : null
    //                                         : null,
    //                                   ),
    //                                 ],
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {
    //                         if (!widget.isOngoing) {
    //                           showRetestSelectionDialog();
    //                         }
    //                       },
    //                       child: Container(
    //                         height: 46.h,
    //                         margin: EdgeInsets.symmetric(horizontal: 16.w),
    //                         decoration: BoxDecoration(
    //                           // color: Colors.amber,
    //                           borderRadius: const BorderRadius.all(Radius.circular(10)),
    //                           boxShadow: const [
    //                             BoxShadow(
    //                               color: colorDropShadowLight,
    //                               blurRadius: 1,
    //                               spreadRadius: 0,
    //                             ),
    //                             BoxShadow(
    //                               color: Colors.white,
    //                               offset: Offset(0.0, 0.0),
    //                               blurRadius: 0.0,
    //                               spreadRadius: 0.0,
    //                             ),
    //                           ],
    //                           gradient: widget.isOngoing == true ? grayGradient : pinkGradient,
    //                         ),
    //                         alignment: AlignmentDirectional.topStart,
    //                         child: Center(
    //                           child: Text(
    //                             "Retest",
    //                             style: textTitle18WhiteBoldStyle,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 64.h,
    //                     )
    //                   ],
    //                 ),
    //     ));
  }

  showRetestSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          backgroundColor: Colors.grey.shade200,
          insetPadding: const EdgeInsets.all(10),
          child: showClearRetestDialogScreen(
            retestResult: (widget.retestResult ?? RetestResult()),
            chapterId: widget.chapterId,
            homeworkId: widget.homeworkId,
            isSelfAutoHW: widget.isSelfAutoHW,
            subjectId: widget.subjectId,
            topicOrConcept: "concept",
            type: widget.type,
            isFromRoadMapResult: widget.isFromRoadMapResult,
          ),
        );
      },
    );
  }
}

// ignore: camel_case_types
class showClearRetestDialogScreen extends StatefulWidget {
  const showClearRetestDialogScreen({
    Key? key,
    required this.retestResult,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
    this.isSelfAutoHW = false,
    required this.topicOrConcept,
    required this.type,
    required this.isFromRoadMapResult,
  }) : super(key: key);
  final RetestResult retestResult;
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final bool isSelfAutoHW;
  final String topicOrConcept;
  final ByHomeworkTypes type;
  final bool isFromRoadMapResult;

  @override
  State<showClearRetestDialogScreen> createState() => _showClearRetestDialogScreenState();
}

// ignore: camel_case_types
class _showClearRetestDialogScreenState extends State<showClearRetestDialogScreen> {
  RetestResult? retestResult = RetestResult();
  String conceptChecked = "-1";
  List<RetestResult>? list = [];

  @override
  void initState() {
    super.initState();
    retestResult?.id = widget.retestResult.id;
    retestResult?.cleared = widget.retestResult.cleared;
    retestResult?.clarity = widget.retestResult.clarity;
    retestResult?.clearedAt = widget.retestResult.clearedAt;
    retestResult?.concept = widget.retestResult.concept;
    List<KeyLearning> keyLearningList = [];
    widget.retestResult.keyLearnings!.map((keyLearningData) {
      if (keyLearningData.cleared == false) {
        KeyLearning keyLearning = KeyLearning();
        keyLearning.id = keyLearningData.id;
        keyLearning.cleared = keyLearningData.cleared;
        keyLearning.clearedAt = keyLearningData.clearedAt;
        keyLearning.keyLearning = keyLearningData.keyLearning;
        keyLearningList.add(keyLearning);
      }
    }).toList();
    retestResult?.keyLearnings = keyLearningList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Column(
          children: [
            Container(
              width: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Color(0xffF9F6F8),
                  ),
                  alignment: Alignment.centerLeft,
                  height: 40.h,
                  child: Text(
                    'Select Keylearning',
                    style: textTitle18WhiteBoldStyle.merge(
                      const TextStyle(fontWeight: FontWeight.bold, color: sectionTitleColor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: colorGDTealLight.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    (retestResult?.concept?.name?.enUs.toString() ?? ""),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTitle18WhiteBoldStyle.merge(
                                      const TextStyle(fontWeight: FontWeight.bold, color: colorGDTealLight),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 10,
                                children: (retestResult?.keyLearnings ?? []).mapIndexed((i, item) {
                                  return Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(unselectedWidgetColor: colorPurple),
                                        child: Checkbox(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            value: item.cleared,
                                            activeColor: colorPurple,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                            onChanged: (val) {
                                              setState(() {
                                                item.cleared = val!;
                                                //retestResult?.cleared = val;
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Flexible(
                                        child: Text(
                                          (item.keyLearning?.name!.enUs.toString() ?? ""),
                                          style: textTitle14StyleMediumPoppins,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  );
                                }).toList()),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 35.h,
                        width: 100.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: colorBlue400.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          const Icon(
                            Icons.cancel,
                            color: colorBlueDark,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text('Cancel', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold, color: colorBlueDark)))
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((retestResult?.keyLearnings ?? []).where((element) => element.cleared == true).toList().isNotEmpty) {
                          retestResult?.cleared = true;
                          list?.clear();
                          list?.add((retestResult ?? RetestResult()));
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RetestConceptTopicList(
                                      homeworkId: widget.homeworkId,
                                      subjectId: widget.subjectId,
                                      chapterId: widget.chapterId,
                                      topicOrConcept: widget.topicOrConcept,
                                      isSelfAutoHW: widget.isSelfAutoHW,
                                      retestResultList: list,
                                      isFromRoadMapResult: widget.isFromRoadMapResult,
                                      type: widget.type,
                                      isFromRetestResult: true,
                                    )),
                          );
                        } else {
                          Fluttertoast.showToast(msg: "Select at-least one key-learning.");
                        }
                      },
                      child: Container(
                        height: 35.h,
                        width: 115.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: colorBlueDark,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          Text('Give Retest', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 10.w,
                          ),
                          SvgPicture.asset(
                            imageAssets + 'tests/start_rocket.svg',
                            height: 20,
                            width: 20,
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
