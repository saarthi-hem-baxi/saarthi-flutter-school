import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/milestone_widgets/homework_milestone.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/milestone_widgets/precap_milestone.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/milestone_widgets/preconcept_milestone.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/milestone_widgets/starting_point.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/milestone_widgets/topic_milestone.widget.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap_path.widget.dart';

class RoadmapLayout extends StatefulWidget {
  const RoadmapLayout({
    Key? key,
    required this.roadmapUserTrackFunc,
  }) : super(key: key);

  final VoidCallback roadmapUserTrackFunc;

  @override
  State<RoadmapLayout> createState() => _RoadmapLayoutState();
}

class _RoadmapLayoutState extends State<RoadmapLayout> {
  final roadMapController = Get.put(RoadmapController());
  final GlobalKey _masterContainerKey = GlobalKey();
  List<MilestoneKey> milestoneKeys = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Obx(() {
        if (roadMapController.milestones.isNotEmpty) {
          milestoneKeys = roadMapController.milestones
              .map(
                (m) => MilestoneKey(
                  type: m['type'],
                  key: GlobalKey(),
                  containerKey: GlobalKey(),
                  milestone: m,
                ),
              )
              .toList();
        }
        return roadMapController.milestones.isNotEmpty
            ? Container(
                alignment: Alignment.topCenter,
                key: _masterContainerKey,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20.h,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 65.w,
                            height: 97.h,
                            margin: EdgeInsets.only(right: 20.w, bottom: 20.h),
                            child: SvgPicture.asset(
                              imageAssets + 'roadmap/girl_with_book.svg',
                              // allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 400.h,
                      left: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 40.h,
                            height: 40.h,
                            margin: EdgeInsets.only(right: 20.w, bottom: 20.h),
                            child: SvgPicture.asset(
                              imageAssets + 'roadmap/b_block.svg',
                              // allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoadmapPath(
                      milestones: roadMapController.milestones,
                      milestoneKeys: milestoneKeys,
                      masterKey: _masterContainerKey,
                    ),
                    Column(
                      children: [
                        ...roadMapController.milestones.mapIndexed((index, milestone) {
                          int realIndex = roadMapController.milestones.length - index;
                          switch (milestone['type']) {
                            case "starting-point":
                              {
                                return StartingPointMileStone(
                                  milestoneKey: milestoneKeys[index].key,
                                  containerKey: milestoneKeys[index].containerKey,
                                );
                              }
                            case "precap":
                              {
                                return PrecapMilestone(
                                  mileStoneIndex: index,
                                  milestoneKey: milestoneKeys[index].key,
                                  containerKey: milestoneKeys[index].containerKey,
                                  alignment: realIndex % 2 > 0 ? MileStoneAlignment.left : MileStoneAlignment.right,
                                  precapDetails: milestone['precapDetails'],
                                );
                              }

                            case "preconcept":
                              {
                                return PreConceptMileStone(
                                  mileStoneIndex: index,
                                  milestoneKey: milestoneKeys[index].key,
                                  containerKey: milestoneKeys[index].containerKey,
                                  alignment: realIndex % 2 > 0 ? MileStoneAlignment.left : MileStoneAlignment.right,
                                  unclearPreConcept: milestone['unclearPreConcept'],
                                  chapterConfiguration: roadMapController.roadMapModel.value.data?.chapter,
                                  roadmapUserTrackFunc: widget.roadmapUserTrackFunc,
                                );
                              }
                            case "topic":
                              {
                                return TopicMilestone(
                                  mileStoneIndex: index,
                                  milestoneKey: milestoneKeys[index].key,
                                  containerKey: milestoneKeys[index].containerKey,
                                  alignment: realIndex % 2 > 0 ? MileStoneAlignment.left : MileStoneAlignment.right,
                                  topicData: milestone['topic'],
                                  chapterConfiguration: roadMapController.roadMapModel.value.data?.chapter,
                                  roadmapUserTrackFunc: widget.roadmapUserTrackFunc,
                                );
                              }
                            case "homework":
                              {
                                return HomeworkMilestone(
                                  mileStoneIndex: index,
                                  milestoneKey: milestoneKeys[index].key,
                                  containerKey: milestoneKeys[index].containerKey,
                                  alignment: realIndex % 2 > 0 ? MileStoneAlignment.left : MileStoneAlignment.right,
                                );
                              }
                            default:
                              {
                                return Container();
                              }
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              )
            : const Text('No content available. Come back again.');
      }),
    );
  }
}
