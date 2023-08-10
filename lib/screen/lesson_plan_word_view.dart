// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/lessonplan_controller.dart';
import '../helpers/const.dart';
import '../helpers/utils.dart';
import '../model/content_report/lp_content_report.modal.dart';
import '../model/lessplan/lesson_plan.dart';
import '../theme/colors.dart';
import '../theme/style.dart';
import '../widgets/common/loading_spinner.dart';
import '../widgets/lessonplans/lessplan_one_word_media_section.dart';
import 'content_report/content_report_icon.dart';
import 'content_report/content_report_screen.dart';
import 'lesson_plan.dart';

// import 'package:video_player/video_player.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_tex/flutter_tex.dart';

class LessonPlanWordViewPage extends StatefulWidget {
  const LessonPlanWordViewPage({
    Key? key,
    required this.title,
    required this.word,
    required this.dialogContext,
    required this.lessonPlan,
    required this.type,
    required this.id,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final String title;
  final Word word;
  final BuildContext dialogContext;
  final LessonPlan? lessonPlan;
  final LPQBType type;
  final String id;
  final String subjectId;
  final String chapterId;
  @override
  State<LessonPlanWordViewPage> createState() => _LessonPlanWordViewPageState();
}

class _LessonPlanWordViewPageState extends State<LessonPlanWordViewPage> with SingleTickerProviderStateMixin {
  final lessonPlanController = Get.put(LessonPlanController());

  bool apiCalled = false;

  double progress = 0;

  get controller => null;

  String get lang => lessonPlanController.lessonPlanListData.value.lang ?? "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Obx(
            () => lessonPlanController.loading.isTrue
                ? const Center(
                    child: LoadingSpinner(),
                  )
                : Container(
                    height: 300,
                    padding: const EdgeInsets.all(10),
                    width: getScreenWidth(context),
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: boxDecoration10,
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.word.word?[lang] ?? "",
                                      style: sectionTitleTextStyle.merge(
                                        const TextStyle(color: sectionTitleColor),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {Navigator.pop(context)},
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      alignment: AlignmentDirectional.center,
                                      decoration: const BoxDecoration(
                                        color: colorBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(13),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        imageAssets + 'closebutton.svg',
                                        //allowDrawingOutsideViewBox: true,
                                        height: 13,
                                        width: 13,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.word.meaning?[lang] ?? "",
                                        style: textTitle14BoldStyle.merge(
                                          const TextStyle(fontWeight: FontWeight.w700, color: colorWebPanelDarkText),
                                        ),
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
                                                lang: lang,
                                                book: widget.lessonPlan?.book,
                                                subject: widget.subjectId,
                                                chapter: widget.chapterId,
                                                isPublisher: widget.lessonPlan?.isPublisher,
                                                publisher: widget.lessonPlan?.publisher,
                                                content: LPReportContent(
                                                  lessonPlan: widget.lessonPlan?.id,
                                                  word: LPReportWord(
                                                    contentId: widget.word.id,
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
                            ),
                            OneWordMediaSection(
                              word: widget.word,
                              lessonPlan: widget.lessonPlan,
                              type: widget.type,
                              id: widget.id,
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
