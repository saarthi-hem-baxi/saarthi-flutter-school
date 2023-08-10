import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/chapters_configuration.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/unclear_pre_concept.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework.dart';
import 'package:saarthi_pedagogy_studentapp/screen/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../system_generated_test/self_autohw/self_autohw_concept_keylearning_list.dart';

class PreConceptMileStone extends StatefulWidget {
  final int mileStoneIndex;
  final GlobalKey milestoneKey;
  final GlobalKey containerKey;
  final MileStoneAlignment alignment;
  final UnclearPreConcept unclearPreConcept;
  final ChaptersConfiguration? chapterConfiguration;
  final VoidCallback roadmapUserTrackFunc;

  const PreConceptMileStone({
    Key? key,
    required this.mileStoneIndex,
    required this.milestoneKey,
    required this.containerKey,
    required this.alignment,
    required this.unclearPreConcept,
    this.chapterConfiguration,
    required this.roadmapUserTrackFunc,
  }) : super(key: key);

  @override
  State<PreConceptMileStone> createState() => _PreConceptMileStoneState();
}

class _PreConceptMileStoneState extends State<PreConceptMileStone> {
  final roadMapController = Get.put(RoadmapController());

  String get lang => roadMapController.roadMapModel.value.data?.lang ?? "";

  onResume() {
    roadMapController.refreshRoadMapData(context);
    widget.roadmapUserTrackFunc();
  }

  @override
  Widget build(BuildContext context) {
    double minMileStoneWidth = getMinMilestoneWidth(context);

    var mileStoneIcon = SvgPicture.asset(
      imageAssets + 'roadmap/roadmap_preconcept.svg',
      height: iconSize,
      width: iconSize,
      fit: BoxFit.contain,
      key: widget.milestoneKey,
    );

    return Container(
      key: widget.containerKey,
      width: getScreenWidth(context),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: milestoneMarginVertical,
        bottom: milestoneMarginVertical,
      ),
      child: Row(
        mainAxisAlignment: widget.alignment == MileStoneAlignment.right ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...(widget.alignment == MileStoneAlignment.left
              ? [
                  mileStoneIcon,
                  const SizedBox(width: spacing),
                ]
              : []),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: minMileStoneWidth - iconSize - spacing,
                child: Text(
                  (widget.unclearPreConcept.preConcept?.name?[lang] == null || widget.unclearPreConcept.preConcept?.name?[lang]?.isEmpty == true)
                      ? (widget.unclearPreConcept.preConcept?.name?['en_US'] ?? "")
                      : widget.unclearPreConcept.preConcept?.name?[lang] ?? "",
                  style: textTitle16WhiteBoldStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(121, 206, 75, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Center(
                      child: Text(
                        'Preconcept',
                        style: textTitle12RegularStyle.merge(
                          const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  (widget.unclearPreConcept.preConcept?.hasGrammar ?? false)
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                          margin: EdgeInsets.only(
                            left: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffEB4799),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Text(
                            'Grammar',
                            style: textTitle12RegularStyle.merge(const TextStyle(fontWeight: FontWeight.w700)),
                            textAlign: TextAlign.start,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              SizedBox(height: 5.h),
              (widget.unclearPreConcept.clarity != null
                  ? Text(
                      '${widget.unclearPreConcept.clarity?.toInt() ?? 0}% Clarity',
                      style: textTitle12BoldStyle,
                    )
                  : Container()),
              const SizedBox(height: 5),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(cardRadius),
                  ),
                ),
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: Column(
                    children: [
                      widget.unclearPreConcept.preConcept?.status == "active"
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonPlanPage(
                                      subjectId: roadMapController.selectedSubjectData?.id ?? "",
                                      chapterId: roadMapController.selectedChaptersData?.id ?? "",
                                      topicid: widget.unclearPreConcept.preConcept?.id ?? "-1",
                                      title: widget.unclearPreConcept.preConcept?.name?[lang] ?? "",
                                      type: LPQBType.concept,
                                    ),
                                  ),
                                ).then((value) => {onResume()})
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: SvgPicture.asset(
                                        imageAssets + 'brain.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Learn',
                                      style: textTitle14BoldStyle.merge(
                                        const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: colorWebPanelDarkText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      ...(!(widget.unclearPreConcept.isSelfAutoHomework ?? false)
                          ? widget.chapterConfiguration?.configuration?.homework == true ||
                                  widget.chapterConfiguration?.configuration?.autoHomework == true
                              ? [
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color: Color.fromRGBO(142, 142, 142, 0.20),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeWorkPage(
                                            subjectData: roadMapController.selectedSubjectData!,
                                            chapterData: roadMapController.selectedChaptersData!,
                                            topicOrConceptId: widget.unclearPreConcept.preConcept?.id ?? "-1",
                                            type: ByHomeworkTypes.concept,
                                          ),
                                        ),
                                      ).then((value) => {onResume()})
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: SvgPicture.asset(
                                              imageAssets + 'hw_small.svg',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            'Homework',
                                            style: textTitle14BoldStyle.merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: colorWebPanelDarkText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]
                              : []
                          : []),
                      ...(widget.unclearPreConcept.isSelfAutoHomework ?? false)
                          ? [
                              const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: Color.fromRGBO(142, 142, 142, 0.20),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelfAutoHWConceptkeyLearningPage(
                                        subjectId: roadMapController.selectedSubjectData!.id!,
                                        chapterId: roadMapController.selectedChaptersData!.id!,
                                        conceptId: widget.unclearPreConcept.preConcept?.id ?? "-1",
                                        selfAutoHomeworkId: (widget.unclearPreConcept.selfAutoHomeworkId ?? ""),
                                      ),
                                    ),
                                  ).then((value) => {onResume()}),
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: SvgPicture.asset(
                                          imageAssets + 'hw_small.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        'Self Auto Homework',
                                        style: textTitle14BoldStyle.merge(
                                          const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: colorWebPanelDarkText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          : []
                    ],
                  ),
                ),
              ),
            ],
          ),
          ...(widget.alignment == MileStoneAlignment.right
              ? [
                  const SizedBox(width: spacing),
                  mileStoneIcon,
                ]
              : []),
        ],
      ),
    );
  }
}
