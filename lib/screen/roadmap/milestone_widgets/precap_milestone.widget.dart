import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/precap_details.dart';
import 'package:saarthi_pedagogy_studentapp/screen/result_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../precap_concept_key_learning_screen.dart';

class PrecapMilestone extends StatefulWidget {
  final int mileStoneIndex;
  final GlobalKey milestoneKey;
  final GlobalKey containerKey;
  final MileStoneAlignment alignment;
  final PrecapDetails precapDetails;

  const PrecapMilestone({
    Key? key,
    required this.mileStoneIndex,
    required this.milestoneKey,
    required this.containerKey,
    required this.alignment,
    required this.precapDetails,
  }) : super(key: key);

  @override
  State<PrecapMilestone> createState() => _PrecapMilestoneState();
}

class _PrecapMilestoneState extends State<PrecapMilestone> {
  final roadMapController = Get.put(RoadmapController());
  final testsController = Get.put(PrecapController());

  refreshData() {
    roadMapController.refreshRoadMapData(context);
  }

  onResume() {
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    double minMileStoneWidth = getMinMilestoneWidth(context);
    bool isCompleted = widget.precapDetails.completed ?? false;

    return GestureDetector(
      onTap: () {
        testsController
            .getPrecapData(
          subjectData: roadMapController.selectedSubjectData!,
          chaptersData: roadMapController.selectedChaptersData!,
        )
            .then((value) {
          if (testsController.preCapModel.value.precapData!.examStarted!.status! &&
              testsController.preCapModel.value.precapData!.examCompleted!.status!) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreenPage(
                  subjectData: roadMapController.selectedSubjectData!,
                  chaptersData: roadMapController.selectedChaptersData!,
                ),
              ),
            ).then(
              (value) => {
                onResume(),
              },
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrecapConceptkeyLearningPage(
                  subjectData: roadMapController.selectedSubjectData!,
                  chaptersData: roadMapController.selectedChaptersData!,
                  isFromTests: true,
                ),
              ),
            ).then((value) => {onResume()});
          }
        });
      },
      child: Obx(
        () => Container(
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
                      SvgPicture.asset(
                        imageAssets +
                            'roadmap/${(roadMapController.roadMapModel.value.data?.precapDetails?.completed ?? false) ? 'roadmap_complete.svg' : 'roadmap_initiate.svg'}',
                        height: isCompleted ? iconSize : iconLgSize,
                        width: isCompleted ? iconSize : iconLgSize,
                        fit: BoxFit.contain,
                        key: widget.milestoneKey,
                      ),
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
                      "Precap",
                      style: textTitle16WhiteBoldStyle.merge(
                        const TextStyle(
                          color: colorYellow,
                          fontSize: 26,
                        ),
                      ),
                      textAlign: widget.alignment == MileStoneAlignment.left ? TextAlign.start : TextAlign.end,
                    ),
                  ),
                ],
              ),
              ...(widget.alignment == MileStoneAlignment.right
                  ? [
                      const SizedBox(width: spacing),
                      SvgPicture.asset(
                        imageAssets +
                            'roadmap/${roadMapController.roadMapModel.value.data?.precapDetails?.completed ?? false ? 'roadmap_complete.svg' : 'roadmap_initiate.svg'}',
                        height: isCompleted ? iconSize : iconLgSize,
                        width: isCompleted ? iconSize : iconLgSize,
                        fit: BoxFit.contain,
                        key: widget.milestoneKey,
                      ),
                    ]
                  : []),
            ],
          ),
        ),
      ),
    );
  }
}
