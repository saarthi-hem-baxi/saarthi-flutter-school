import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../../theme/style.dart';

class HomeworkMilestone extends StatefulWidget {
  final int mileStoneIndex;
  final GlobalKey milestoneKey;
  final GlobalKey containerKey;
  final MileStoneAlignment alignment;

  const HomeworkMilestone({
    Key? key,
    required this.mileStoneIndex,
    required this.milestoneKey,
    required this.containerKey,
    required this.alignment,
  }) : super(key: key);

  @override
  State<HomeworkMilestone> createState() => _HomeworkMilestoneState();
}

class _HomeworkMilestoneState extends State<HomeworkMilestone> {
  final roadMapController = Get.put(RoadmapController());

  onResume() {
    roadMapController.refreshRoadMapData(context);
  }

  @override
  Widget build(BuildContext context) {
    double minMileStoneWidth = getMinMilestoneWidth(context);
    var mileStoneIcon = SvgPicture.asset(
      imageAssets + 'roadmap/roadmap_cw.svg',
      height: iconSize,
      width: iconSize,
      fit: BoxFit.contain,
      key: widget.milestoneKey,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeWorkPage(
              subjectData: roadMapController.selectedSubjectData!,
              chapterData: roadMapController.selectedChaptersData!,
              topicOrConceptId: "-1",
              type: ByHomeworkTypes.chapter,
            ),
          ),
        ).then((value) => {onResume()});
      },
      child: Container(
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
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: minMileStoneWidth - iconSize - spacing,
                    child: Text(
                      "Homework",
                      style: textTitle16WhiteBoldStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ...(roadMapController.loadingHWCounts.isTrue
                      ? [
                          const Center(
                            child: LoadingSpinner(
                              color: Colors.white,
                            ),
                          ),
                        ]
                      : [
                          SizedBox(
                            child: Text(
                              '${roadMapController.roadMapModel.value.data?.homework?.complete ?? 0} / ${roadMapController.roadMapModel.value.data?.homework?.total ?? 0}',
                              style: textTitle16WhiteBoldStyle,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              width: 150.0,
                              lineHeight: 10.0,
                              percent: (roadMapController.roadMapModel.value.data?.homework?.complete ?? 0) /
                                  ((roadMapController.roadMapModel.value.data?.homework?.total ?? 1) > 0
                                      ? (roadMapController.roadMapModel.value.data?.homework?.total ?? 1)
                                      : 1),
                              backgroundColor: Colors.white,
                              barRadius: const Radius.circular(5),
                              linearGradient: purpleGradient,
                            ),
                          )
                        ]),
                ],
              ),
            ),
            ...(widget.alignment == MileStoneAlignment.right
                ? [
                    const SizedBox(width: spacing),
                    mileStoneIcon,
                  ]
                : []),
          ],
        ),
      ),
    );
  }
}
