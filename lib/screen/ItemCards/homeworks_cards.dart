import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework_submission.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_retest_concept_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_retest_topic_result.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/linear_gradient_mask.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/title_description.dart';

import '../../controllers/homework_controller.dart';
import '../../model/subject_model/datum.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/media/media_utils.dart';
import '../../widgets/media/pdf_viewer.dart';
import '../../widgets/media/zoomable_image_view.dart';
import '../homework/online_test_result.dart';
import '../homework/online_test_topic_concept.dart';
import '../system_generated_test/autohw_concept_keylearning_list.dart';
import '../system_generated_test/autohw_concept_result.dart';
import '../system_generated_test/autohw_topic_keylearning_list.dart';
import '../system_generated_test/autohw_topic_result.dart';
import '../system_generated_test/self_autohw/self_autohw_concept_keylearning_list.dart';

class HomeworksCards extends StatefulWidget {
  final HomeworkDatum homeworkDatum;
  final Datum subjectData;
  final ChaptersDatum chaptersData;
  final String topicOrConceptId;
  final ByHomeworkTypes type;
  final bool isPending;
  final VoidCallback? refreshData;

  const HomeworksCards({
    Key? key,
    required this.homeworkDatum,
    required this.subjectData,
    required this.chaptersData,
    required this.topicOrConceptId,
    required this.type,
    required this.isPending,
    required this.refreshData,
  }) : super(key: key);

  @override
  _HomeworksCardsState createState() => _HomeworksCardsState();
}

class _HomeworksCardsState extends State<HomeworksCards> {
  @override
  void initState() {
    super.initState();
  }

  onResume() {
    widget.refreshData!();
  }

  var homeWorkController = Get.put(HomeworkController());

  _handleCardNavigation() {
    homeWorkController.selectedSubjectData = widget.subjectData;
    homeWorkController.selectedChapterData = widget.chaptersData;
    homeWorkController.selectedTopicOrConceptId = widget.topicOrConceptId;
    homeWorkController.selectedType = widget.type;
    homeWorkController.isFromTests = false;
    homeWorkController.isFromPending = widget.isPending;

    if (widget.homeworkDatum.type == "system-generated") {
      if (!(widget.homeworkDatum.completed?.status ?? false)) {
        if (widget.homeworkDatum.topics![0].type!.toLowerCase() == "topic") {
          if ((widget.homeworkDatum.concepts ?? []).isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoHWTopickeyLearningPage(
                  homeworkId: widget.homeworkDatum.id!,
                  subjectId: widget.subjectData.id!,
                  chapterId: widget.chaptersData.id!,
                ),
              ),
            ).then((value) => {onResume()});
          } else {
            navigateToConceptKeylearning();
          }
        } else {
          navigateToConceptKeylearning();
        }
      } else {
        if (widget.homeworkDatum.topics![0].type!.toLowerCase() == "topic") {
          if ((widget.homeworkDatum.concepts ?? []).isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (widget.homeworkDatum.cleared ?? false)
                    ? AutoHWTopicBasedResultScreenPage(
                        homeworkId: widget.homeworkDatum.id!,
                        subjectId: widget.subjectData.id!,
                        chapterId: widget.chaptersData.id!,
                      )
                    : (widget.homeworkDatum.clearedRetest ?? false)
                        ? AutoHWRetestTopicBasedResultScreenPage(
                            homeworkId: widget.homeworkDatum.id!,
                            subjectId: widget.subjectData.id!,
                            chapterId: widget.chaptersData.id!,
                          )
                        : AutoHWRetestTopicBasedResultScreenPage(
                            homeworkId: widget.homeworkDatum.id!,
                            subjectId: widget.subjectData.id!,
                            chapterId: widget.chaptersData.id!,
                          ),
              ),
            ).then((value) => {onResume()});
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (widget.homeworkDatum.cleared ?? false)
                    ? AutoHWConceptBasedResultScreenPage(
                        homeworkId: widget.homeworkDatum.id!,
                        subjectId: widget.subjectData.id!,
                        chapterId: widget.chaptersData.id!,
                      )
                    : (widget.homeworkDatum.clearedRetest ?? false)
                        ? AutoHWRetestConceptBasedResultScreenPage(
                            homeworkId: widget.homeworkDatum.id!,
                            subjectId: widget.subjectData.id!,
                            chapterId: widget.chaptersData.id!,
                            type: widget.type,
                            isFromRoadMapResult: true,
                          )
                        : AutoHWRetestConceptBasedResultScreenPage(
                            homeworkId: widget.homeworkDatum.id!,
                            subjectId: widget.subjectData.id!,
                            chapterId: widget.chaptersData.id!,
                            type: widget.type,
                            isFromRoadMapResult: true,
                          ),
              ),
            ).then(
              (value) => {onResume()},
            );

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => (widget.homeworkDatum.cleared ?? false)
            //         ? AutoHWConceptBasedResultScreenPage(
            //             homeworkId: widget.homeworkDatum.id!,
            //             subjectId: widget.subjectData.id!,
            //             chapterId: widget.chaptersData.id!,
            //           )
            //         : (widget.homeworkDatum.clearedRetest ?? false)
            //             ? AutoHWConceptBasedResultScreenPage(
            //                 homeworkId: widget.homeworkDatum.id!,
            //                 subjectId: widget.subjectData.id!,
            //                 chapterId: widget.chaptersData.id!,
            //               )
            //             : AutoHWConceptBasedResultScreenPage(
            //                 homeworkId: widget.homeworkDatum.id!,
            //                 subjectId: widget.subjectData.id!,
            //                 chapterId: widget.chaptersData.id!,
            //               ),
            //   ),
            // ).then(
            //   (value) => {onResume()},
            // );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (widget.homeworkDatum.cleared ?? false)
                  ? AutoHWConceptBasedResultScreenPage(
                      homeworkId: widget.homeworkDatum.id!,
                      subjectId: widget.subjectData.id!,
                      chapterId: widget.chaptersData.id!,
                    )
                  : (widget.homeworkDatum.clearedRetest ?? false)
                      ? AutoHWRetestConceptBasedResultScreenPage(
                          homeworkId: widget.homeworkDatum.id!,
                          subjectId: widget.subjectData.id!,
                          chapterId: widget.chaptersData.id!,
                          type: widget.type,
                          isFromRoadMapResult: true,
                        )
                      : AutoHWRetestConceptBasedResultScreenPage(
                          homeworkId: widget.homeworkDatum.id!,
                          subjectId: widget.subjectData.id!,
                          chapterId: widget.chaptersData.id!,
                          type: widget.type,
                          isFromRoadMapResult: true,
                        ),
            ),
          ).then((value) => {onResume()});
        }
      }
    } else if (widget.homeworkDatum.type == "online-test") {
      if (widget.homeworkDatum.completed?.status == true) {
        // TYPE == ONLINE TEST && COMPLETED == TRUE => ONLINE TEST RESULT
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestResultPage(
              homeworkId: widget.homeworkDatum.id ?? "",
              subjectId: widget.subjectData.id!,
              chapterId: widget.chaptersData.id!,
            ),
          ),
        ).then((value) => {onResume()});
      } else {
        // TYPE == ONLINE TEST && COMPLETED == FALSE => ONLINE TEST TOPIC/CONCEPT
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestTopicsPage(
              title: widget.homeworkDatum.name ?? "",
              homeworkId: widget.homeworkDatum.id ?? "",
              subjectId: widget.subjectData.id!,
              chapterId: widget.chaptersData.id!,
            ),
          ),
        ).then((value) => {onResume()});
      }
    } else {
      // TYPE == NOT SYSTEM GENERATED && ONLINE TEST => HOMEWORK SUBMISSION
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWorkSubmissionPage(
            homeworkId: widget.homeworkDatum.id ?? "",
            subjectId: widget.subjectData.id!,
            chapterId: widget.chaptersData.id!,
          ),
        ),
      ).then((value) => {onResume()});
    }
  }

  void navigateToConceptKeylearning() {
    if (widget.homeworkDatum.isSelfSystemGenerated ?? false) {
      if (widget.homeworkDatum.started?.status ?? false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfAutoHWConceptkeyLearningPage(
              subjectId: widget.subjectData.id!,
              chapterId: widget.chaptersData.id!,
              selfAutoHomeworkId: widget.homeworkDatum.id!,
              conceptId: widget.homeworkDatum.concepts?[0].id ?? "",
            ),
          ),
        ).then((value) => {onResume()});
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AutoHWConceptkeyLearningPage(
              homeworkId: widget.homeworkDatum.id!,
              subjectId: widget.subjectData.id!,
              chapterId: widget.chaptersData.id!,
            ),
          ),
        ).then((value) => {onResume()});
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AutoHWConceptkeyLearningPage(
            homeworkId: widget.homeworkDatum.id!,
            subjectId: widget.subjectData.id!,
            chapterId: widget.chaptersData.id!,
          ),
        ),
      ).then((value) => {onResume()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
      ),
      child: GestureDetector(
        onTap: _handleCardNavigation,
        child: Container(
            padding: EdgeInsets.all(10.h),
            decoration: boxDecoration10,
            child: (widget.homeworkDatum.type ?? "").toLowerCase() == "online-test" ||
                    (widget.homeworkDatum.type ?? "").toLowerCase() == "system-generated"
                ? OnlineAutoHwTestCard(homeworkData: widget.homeworkDatum, subjectName: widget.subjectData.name!)
                : WorksheetCard(homeworkData: widget.homeworkDatum, subjectName: widget.subjectData.name!, onResume: onResume)),
      ),
    );
  }
}

class OnlineAutoHwTestCard extends StatelessWidget {
  final HomeworkDatum? homeworkData;
  final String subjectName;
  const OnlineAutoHwTestCard({Key? key, required this.homeworkData, required this.subjectName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            homeworkData?.name ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTitle18WhiteBoldStyle.merge(
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
                ],
              ),
              Row(
                children: [
                  homeworkData?.type == "system-generated" || homeworkData?.type == "online-test"
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          height: 22.h,
                          padding: EdgeInsets.all(5.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            color: colorPurpleLight,
                          ),
                          child: Text(
                            getTypeDesc((homeworkData?.type ?? "").toLowerCase()) == 'Auto HW' ? 'Auto HW' : 'Online Test',
                            style: textTitle12BoldStyle.merge(
                              const TextStyle(
                                color: colorPurple,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Wrap(children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 5.w,
                          right: 5.w,
                        ),
                        padding: EdgeInsets.all(5.h),
                        child: TitleDescription(
                          title: "Assign",
                          desc: homeworkData?.assigned?.date != null ? DateFormat("d MMM").format(homeworkData!.assigned!.date!) : "-",
                          titleStyle: textTitle8BoldStyle.merge(
                            const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                          ),
                          descStyle: textTitle12BoldStyle.merge(
                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      (homeworkData?.type ?? "") == "online-test"
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 5.w,
                                right: 5.w,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: TitleDescription(
                                title: "Due",
                                desc: homeworkData?.dueDate != null ? DateFormat("d MMM").format(homeworkData!.dueDate!) : "-",
                                titleStyle: textTitle8BoldStyle.merge(
                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                ),
                                descStyle: textTitle12BoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      homeworkData?.completed?.date != null
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 5.w,
                                right: 5.w,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: TitleDescription(
                                title: "Attend",
                                desc: homeworkData?.completed?.date != null ? DateFormat("d MMM").format(homeworkData!.completed!.date!) : "-",
                                titleStyle: textTitle8BoldStyle.merge(
                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                ),
                                descStyle: textTitle12BoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      (homeworkData?.type ?? "") == "system-generated"
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 5.w,
                                right: 5.w,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: TitleDescription(
                                title: "Concept/Topic",
                                desc: (homeworkData?.concepts ?? []).isNotEmpty
                                    ? (homeworkData?.concepts ?? []).length.toString()
                                    : (homeworkData?.topics ?? []).length.toString(),
                                titleStyle: textTitle8BoldStyle.merge(
                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                ),
                                descStyle: textTitle12BoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                top: 5.w,
                                right: 5.w,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: TitleDescription(
                                title: "Marks",
                                desc: (homeworkData?.completed?.status ?? false)
                                    ? homeworkData!.correct == null && homeworkData!.attempts == null ||
                                            homeworkData!.correct == 0 && homeworkData!.attempts == 0
                                        ? "-"
                                        : homeworkData!.correct.toString() + "/" + homeworkData!.attempts.toString()
                                    : "${homeworkData?.topics?.map((e) => e.questionCount ?? 0).reduce(
                                          (value, element) => value + element,
                                        )}",
                                titleStyle: textTitle8BoldStyle.merge(
                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                ),
                                descStyle: textTitle12BoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 48.h,
              width: 48.h,
              padding: EdgeInsets.all(13.h),
              decoration: BoxDecoration(
                gradient: homeworkData?.completed?.status ?? false
                    ? pinkGradient
                    : homeworkData?.started?.status == true
                        ? pinkGradient
                        : purpleGradient,
                borderRadius: BorderRadius.all(
                  Radius.circular(24.h),
                ),
              ),
              child: SvgPicture.asset(
                imageAssets +
                    ((homeworkData?.completed?.status ?? false)
                        ? 'tests/result.svg'
                        : homeworkData?.started?.status == true
                            ? 'tests/continueprecap.svg'
                            : 'tests/start_rocket.svg'),
                height: 23,
                width: 23,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                (homeworkData?.completed?.status ?? false)
                    ? "Result"
                    : homeworkData?.started?.status == true
                        ? "Resume"
                        : "Start",
                style: textTitle10BoldStyle.merge(
                  const TextStyle(color: sectionTitleColor),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class WorksheetCard extends StatelessWidget {
  final HomeworkDatum? homeworkData;
  final VoidCallback onResume;
  final String subjectName;
  const WorksheetCard({Key? key, required this.homeworkData, required this.subjectName, required this.onResume}) : super(key: key);

  bool isshowAnswerKey(HomeworkDatum? data) {
    if (data?.shareAnswerKey == true && data?.hasSubmission == false && data?.hasMarking == false && data?.completed?.status == true) {
      return true;
    } else if (data?.shareAnswerKey == true && data?.hasSubmission == true && data?.completed?.status == true) {
      return true;
    } else if (data?.shareAnswerKey == true && data?.hasMarking == true && data?.submitted?.status == true) {
      return true;
    } else if (data?.shareAnswerKey == true && data?.hasSubmission == true && data?.hasMarking == true && data?.completed?.status == true) {
      return true;
    } else if (data?.shareAnswerKey == true && data?.hasSubmission == false && data?.hasMarking == true && data?.completed?.status == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                  homeworkData?.name ?? "",
                  style: textTitle18WhiteBoldStyle.merge(
                    const TextStyle(fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.w,
                      right: 5.w,
                    ),
                    height: 22.h,
                    padding: EdgeInsets.all(5.h),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      color: colorPurpleLight,
                    ),
                    child: Text(
                      'WS',
                      style: textTitle12BoldStyle.merge(
                        const TextStyle(
                          color: colorPurple,
                        ),
                      ),
                    ),
                  ),
                  (homeworkData?.hasSubmission == true && !(homeworkData?.completed?.status ?? false))
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          padding: EdgeInsets.all(5.h),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              gradient: greenGradient),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 14.h,
                                width: 14.h,
                                child: Icon(
                                  Icons.upload_rounded,
                                  size: 10.h,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Submission",
                                style: textTitle12BoldStyle.merge(
                                  const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          padding: EdgeInsets.all(5.h),
                          child: TitleDescription(
                            title: "Assign",
                            desc: DateFormat("d MMM").format(homeworkData!.assigned!.date!),
                            titleStyle: textTitle8BoldStyle.merge(
                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                            ),
                            descStyle: textTitle12BoldStyle.merge(
                              const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: TitleDescription(
                            title: "Submission",
                            desc: homeworkData?.submissionDate != null ? DateFormat("d MMM").format(homeworkData!.submissionDate!) : "-",
                            titleStyle: textTitle8BoldStyle.merge(
                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                            ),
                            descStyle: textTitle12BoldStyle.merge(
                              const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        homeworkData?.completed?.date != null
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: 5.w,
                                  right: 5.w,
                                ),
                                padding: EdgeInsets.all(5.h),
                                child: TitleDescription(
                                  title: "Attend",
                                  desc: homeworkData?.completed?.date != null ? DateFormat("d MMM").format(homeworkData!.completed!.date!) : "-",
                                  titleStyle: textTitle8BoldStyle.merge(
                                    const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                  ),
                                  descStyle: textTitle12BoldStyle.merge(
                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: TitleDescription(
                            title: "Marks",
                            desc: (homeworkData?.completed?.status ?? false)
                                ? homeworkData?.obtainedMarks != null && homeworkData?.totalMarks != null
                                    ? (homeworkData?.obtainedMarks ?? "-").toString() + '/' + (homeworkData?.totalMarks ?? "").toString()
                                    : "-"
                                : homeworkData?.totalMarks != null
                                    ? (homeworkData?.totalMarks ?? "").toString()
                                    : "-",
                            titleStyle: textTitle8BoldStyle.merge(
                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                            ),
                            descStyle: textTitle12BoldStyle.merge(
                              const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => {
                if (isURLTypeImage(homeworkData?.questionPdf ?? ""))
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZoomableImageView(
                          imageUrl: homeworkData?.questionPdf ?? "",
                          title: "Worksheet",
                        ),
                      ),
                    ).then((value) => {onResume()})
                  }
                else
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomPDFViewer(pdfUrl: homeworkData?.questionPdf ?? "", title: "Worksheet" //lessonplanspdfs.name?.enUs! ?? "",
                                ),
                      ),
                    ).then((value) => {onResume()})
                  }
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                margin: EdgeInsets.only(right: 10.w),
                child: LinearGradientMask(
                  colors: const [colorGDSkyLight, colorGDSkyDark],
                  child: SvgPicture.asset(
                    imageAssets + 'question.svg',
                    allowDrawingOutsideViewBox: true,
                    color: Colors.white,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            isshowAnswerKey(homeworkData)
                ? GestureDetector(
                    onTap: () => {
                      if (isURLTypeImage(homeworkData?.answerPdf ?? ""))
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZoomableImageView(
                                imageUrl: homeworkData?.answerPdf ?? "",
                                title: "Answer Paper",
                              ),
                            ),
                          ).then((value) => {onResume()})
                        }
                      else
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomPDFViewer(pdfUrl: homeworkData?.answerPdf ?? "", title: "Answer Paper" //lessonplanspdfs.name?.enUs! ?? "",
                                      ),
                            ),
                          ).then((value) => {onResume()})
                        }
                    },
                    child: SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: LinearGradientMask(
                        colors: const [colorGDSkyLight, colorGDSkyDark],
                        child: SvgPicture.asset(
                          imageAssets + 'answer.svg',
                          allowDrawingOutsideViewBox: true,
                          color: Colors.white,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
