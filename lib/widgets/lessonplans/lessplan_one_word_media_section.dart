import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/lessonplan_controller.dart';
import '../../model/content_report/lp_content_report.modal.dart';
import '../../model/lessplan/lesson_plan.dart';
import '../../screen/content_report/content_report_icon.dart';
import '../../screen/content_report/content_report_screen.dart';
import '../../screen/lesson_plan.dart';
import '../media/media_widget.dart';

class OneWordMediaSection extends StatelessWidget {
  OneWordMediaSection({
    Key? key,
    required this.word,
    required this.lessonPlan,
    required this.type,
    required this.id,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final LessonPlanController learnController = Get.put(LessonPlanController());

  final Word word;
  final LessonPlan? lessonPlan;
  final LPQBType type;
  final String id;
  final String subjectId;
  final String chapterId;

  String get lang => learnController.lessonPlanListData.value.lang ?? "";

  List<Media> getData(List<Media> data) {
    return data
        .where((mediaItem) =>
            (word.lang ?? []).contains(lang) && mediaItem.name?.containsKey(lang) == true && (mediaItem.name?[lang]?.isNotEmpty ?? false))
        .toList();
  } // get lesson plan word media where contains lesson plan's language data

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getData(word.media ?? [])
              .map<Widget>(
                (media) => WordMediaWidget(
                  lessonPlan: lessonPlan,
                  chapterId: chapterId,
                  subjectId: subjectId,
                  wordId: word.id ?? "",
                  media: media,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class WordMediaWidget extends StatelessWidget {
  WordMediaWidget({
    Key? key,
    required this.lessonPlan,
    required this.subjectId,
    required this.chapterId,
    required this.wordId,
    required this.media,
  }) : super(key: key);

  final LessonPlan? lessonPlan;
  final String subjectId;
  final String chapterId;
  final String wordId;
  final Media media;

  final LessonPlanController learnController = Get.put(LessonPlanController());
  String get lang => learnController.lessonPlanListData.value.lang ?? "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppMediaWidget(
          mediaUrl: media.url?[lang] ?? "",
          thumbUrl: media.thumb?[lang] ?? "",
          title: media.name?[lang] ?? "",
          margin: EdgeInsets.only(left: 16.w),
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
                        word: LPReportWord(
                          contentId: wordId,
                          media: LPReportItem(contentId: media.uniqueId ?? ""),
                        ),
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
  }
}
