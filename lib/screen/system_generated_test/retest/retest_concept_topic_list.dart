import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/system_generated_test_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_retest_concept_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_exam.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_topic_exam.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import '../../../controllers/retest_controller.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../autohw_retest_topic_result.dart';

class RetestConceptTopicList extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final String topicOrConcept;
  final bool isSelfAutoHW;
  final List<RetestResult>? retestResultList;
  final bool isFromRoadMapResult;
  final ByHomeworkTypes type;
  final bool isFromRetestResult;

  const RetestConceptTopicList({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
    required this.topicOrConcept,
    this.isSelfAutoHW = false,
    this.retestResultList,
    this.isFromRoadMapResult = false,
    this.type = ByHomeworkTypes.concept,
    this.isFromRetestResult = false,
  }) : super(key: key);

  @override
  State<RetestConceptTopicList> createState() => _RetestConceptTopicListState();
}

class _RetestConceptTopicListState extends State<RetestConceptTopicList> with SingleTickerProviderStateMixin {
  var systemGeneratedTestController = Get.put(SystemGeneratedTestController());
  final retestsController = Get.put(ReTestController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    Future.delayed(
      Duration.zero,
      () => {
        // apicall();
      },
    );
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Navigator.pop(context);
    if (!widget.isFromRoadMapResult) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.topicOrConcept == "topic"
              ? AutoHWRetestTopicBasedResultScreenPage(
                  homeworkId: widget.homeworkId,
                  subjectId: widget.subjectId,
                  chapterId: widget.chapterId,
                )
              : AutoHWRetestConceptBasedResultScreenPage(
                  homeworkId: widget.homeworkId,
                  subjectId: widget.subjectId,
                  chapterId: widget.chapterId,
                  isSelfAutoHW: widget.isSelfAutoHW,
                ),
        ),
      ).then((value) {});
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(
            children: [
              const Positioned(
                left: -100,
                child: GradientCircle(
                  gradient: circleOrangeGradient,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(125),
                    bottomRight: Radius.circular(125),
                  ),
                ),
              ),
              Column(
                children: [
                  HeaderCard(
                    title: "Retest",
                    backEnabled: true,
                    onTap: () {
                      _onBackPressed();
                    },
                  ),
                  Container(
                    width: getScreenWidth(context),
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unclear Concepts / Topic",
                          style: sectionTitleTextStyle.merge(
                            const TextStyle(fontSize: 16, color: sectionTitleColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: (getScreenWidth(context) - 30),
                            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: (widget.retestResultList ?? []).isNotEmpty
                                ? Column(
                                    children: (widget.retestResultList ?? []).map<Widget>((result) {
                                      if (result.cleared == true) {
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          width: (getScreenWidth(context) - 30),
                                          decoration: boxDecoration14,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                result.concept!.name!.enUs.toString(),
                                                style: textTitle16WhiteBoldStyle.merge(
                                                  const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                children: (result.keyLearnings ?? []).map((keyLearning) {
                                                  if (keyLearning.cleared == true) {
                                                    return Container(
                                                      margin: const EdgeInsets.only(bottom: 5, right: 10),
                                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(25),
                                                        ),
                                                        color: colorGrey200,
                                                      ),
                                                      child: Text(
                                                        keyLearning.keyLearning!.name!.enUs.toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: textTitle12RegularStyle.merge(
                                                          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }).toList(),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 5, right: 10),
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: boxDecoration14,
                                    child: Text(
                                      retestsController.retestListModel.value.data?.retestDetail?[0].name ?? '',
                                      style: textTitle12RegularStyle.merge(
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      retestsController
                          .createTest(
                              context: context,
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
                              homeworkId: widget.homeworkId,
                              retestResult: (widget.retestResultList ?? []))
                          .then((retestHomeworkId) => {
                                retestsController
                                    .getRetestDetail(
                                  context: context,
                                  subjectId: widget.subjectId,
                                  chapterId: widget.chapterId,
                                  homeworkId: widget.homeworkId,
                                  retestHomeworkId: retestHomeworkId,
                                )
                                    .then((value) {
                                  retestsController
                                      .getReTest(
                                    context: context,
                                    subjectId: widget.subjectId,
                                    chapterId: widget.chapterId,
                                    homeworkId: widget.homeworkId,
                                    retestDetail: retestsController.retestDetailModel.value.data!,
                                    map: {},
                                    isFirst: true,
                                  )
                                      .then(
                                    (value) {
                                      if (widget.topicOrConcept == 'topic') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ResTestTopicWiseExamPage(
                                              //This is Concept Based Exam
                                              subjectId: widget.subjectId,
                                              chapterId: widget.chapterId,
                                              homeworkId: widget.homeworkId,
                                              retestHomeworkId: retestHomeworkId,
                                            ),
                                          ),
                                        ).then((value) => {Navigator.pop(context)});
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RetestConceptBasedExamPage(
                                              //This is Concept Based Exam
                                              subjectId: widget.subjectId,
                                              chapterId: widget.chapterId,
                                              homeworkId: widget.homeworkId,
                                              retestHomeworkId: retestHomeworkId,
                                              isSelfAutoHW: widget.isSelfAutoHW,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (widget.isFromRoadMapResult) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AutoHWRetestConceptBasedResultScreenPage(
                                                  homeworkId: widget.homeworkId,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                  isSelfAutoHW: widget.isSelfAutoHW,
                                                  type: widget.type,
                                                  isFromRetestResult: true,
                                                ),
                                              ),
                                            ).then((value) {
                                              if (widget.isFromRetestResult) {
                                                Navigator.pop(context);
                                              }
                                            });
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    },
                                  );
                                })
                              });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      height: 46,
                      width: getScreenWidth(context),
                      padding: const EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration: const BoxDecoration(
                        gradient: pinkGradient,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Text("Give Retest", style: textTitle18WhiteBoldStyle),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class ReTestConceptListItem extends StatelessWidget {
//   final UnclearTopicsConcept? conceptData;
//   const ReTestConceptListItem({
//     Key? key,
//     required this.conceptData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 10),
//       padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
//       width: getScreenWidth(context),
//       decoration: boxDecoration14,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             (conceptData?.type ?? "") == "topic" ? conceptData?.topic?.name ?? "" : conceptData?.concept?.name?.enUs ?? "",
//             style: sectionTitleTextStyle.merge(
//               const TextStyle(fontSize: 16, color: colorWebPanelDarkText),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ReTestConceptListItem extends StatelessWidget {
  final String? keyLearningName;
  const ReTestConceptListItem({
    Key? key,
    required this.keyLearningName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      width: getScreenWidth(context),
      decoration: boxDecoration14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            keyLearningName.toString(),
            style: sectionTitleTextStyle.merge(
              const TextStyle(fontSize: 16, color: colorWebPanelDarkText),
            ),
          ),
        ],
      ),
    );
  }
}
