import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/model/lessplan/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_widget.dart';

import '../../../model/content_report/lp_content_report.modal.dart';
import '../../../screen/content_report/content_report_icon.dart';
import '../../../screen/content_report/content_report_screen.dart';
import '../../../screen/lesson_plan.dart';
import '../../media/media_utils.dart';

class LessonPlanAudios extends StatelessWidget {
  const LessonPlanAudios({
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

  String get lang => lessonPlanModal?.lang ?? "";

  bool isShowMedia(LessonPlanItem audio) {
    if (type == LPQBType.topic) {
      if (lessonPlan?.isPublisher == true) {
        int index = (audio.topics ?? []).indexWhere((element) => element.topic == id);
        if (index != -1) {
          return true;
        }
      } else {
        //for when lesson plan is saarthi's lesson plan
        for (var concept in audio.concepts ?? []) {
          bool isContainInGlobalConcepts = (lessonPlanModal?.concepts ?? []).contains(concept);
          if (isContainInGlobalConcepts) {
            return true;
          }
        }
      }
      return false;
    } else {
      bool isContain = (audio.concepts ?? []).contains(id);
      return isContain;
    }
  }

  List<LessonPlanItem> getData(List<LessonPlanItem> data) {
    return data
        .where(
            (element) => (element.lang ?? []).contains(lang) && element.name?.containsKey(lang) == true && (element.name?[lang]?.isNotEmpty ?? false))
        .toList();
  } // get media where media language contains lessonplan's language & also contains media's name contains lessonplan language field also has value

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (lessonPlan?.audio ?? []).isNotEmpty
          ? Row(
              children: getData(lessonPlan?.audio ?? []).map(
                (lessonplansaudio) {
                  if (isShowMedia(lessonplansaudio)) {
                    return Stack(
                      children: [
                        AppMediaWidget(
                          mediaUrl: lessonplansaudio.url?[lang] ?? "",
                          title: lessonplansaudio.name?[lang] ?? "",
                          margin: EdgeInsets.only(left: 16.w),
                          mediaType: MediaTypes.audio,
                        ),
                        Positioned(
                          right: 0,
                          child: ContentReportIcon(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContentReportPage(
                                    typeOfContent: ContentReportType.lessonplan,
                                    lpContentReportdata: LpContentReportModal(
                                      lang: lang,
                                      book: lessonPlan?.book,
                                      subject: subjectId,
                                      chapter: chapterId,
                                      isPublisher: lessonPlan?.isPublisher,
                                      publisher: lessonPlan?.publisher,
                                      content: LPReportContent(
                                        lessonPlan: lessonPlan?.id,
                                        audio: LPReportItem(contentId: lessonplansaudio.id ?? ""),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ).toList(),
            )
          : null,
    );
  }
}
