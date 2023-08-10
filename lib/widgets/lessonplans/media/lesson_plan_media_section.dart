import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/model/lessplan/lesson_plan.dart';

import '../../../screen/lesson_plan.dart';
import 'lesson_plan_audios.dart';
import 'lesson_plan_documents.dart';
import 'lesson_plan_images.dart';
import 'lesson_plan_links.dart';
import 'lesson_plan_pdfs.dart';
import 'lesson_plan_simulations.dart';
import 'lesson_plan_videos.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({
    Key? key,
    required this.lessonPlanModal,
    required this.lessonPlan,
    required this.id,
    required this.type,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final LessonPlanListModal? lessonPlanModal;
  final LessonPlan? lessonPlan;
  final LPQBType type;
  final String id;
  final String subjectId;
  final String chapterId;

  bool isAnyMediaAvailable({required LessonPlan? lessonPlan}) {
    if ((lessonPlan?.images ?? []).isNotEmpty ||
        (lessonPlan?.videos ?? []).isNotEmpty ||
        (lessonPlan?.pdfs ?? []).isNotEmpty ||
        (lessonPlan?.audio ?? []).isNotEmpty ||
        (lessonPlan?.links ?? []).isNotEmpty ||
        (lessonPlan?.simulations ?? []).isNotEmpty ||
        (lessonPlan?.documents ?? []).isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: isAnyMediaAvailable(lessonPlan: lessonPlan)
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Images
                  LessonPlanImages(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  // Videos
                  LessonPlanVideos(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  //PDFS
                  LessonPlanPdfs(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  //Documents
                  LessonPlanDocuments(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  //Audios
                  LessonPlanAudios(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  //Links
                  LessonPlanLinks(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),

                  //Simulations
                  LessonPlanSimulations(
                    lessonPlanModal: lessonPlanModal,
                    lessonPlan: lessonPlan,
                    id: id,
                    type: type,
                    subjectId: subjectId,
                    chapterId: chapterId,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
