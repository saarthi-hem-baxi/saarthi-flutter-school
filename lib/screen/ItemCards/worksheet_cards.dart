import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework_submission.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/title_description.dart';

import '../../model/worksheet_model/homework_model_new.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/linear_gradient_mask.dart';
import '../../widgets/media/media_utils.dart';
import '../../widgets/media/pdf_viewer.dart';
import '../../widgets/media/zoomable_image_view.dart';

class WorksheetCards extends StatefulWidget {
  final Worksheet worksheetData;
  final bool isPending;
  final VoidCallback? refreshData;

  const WorksheetCards({
    Key? key,
    required this.worksheetData,
    required this.isPending,
    required this.refreshData,
  }) : super(key: key);

  @override
  _WorksheetCardsState createState() => _WorksheetCardsState();
}

class _WorksheetCardsState extends State<WorksheetCards> {
  var homeWorkController = Get.put(HomeworkController());

  @override
  void initState() {
    super.initState();
  }

  onResume() {
    debugPrint("onResume Called");
    widget.refreshData!();
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
        onTap: () {
          navigateToSubmissionsPage(widget.worksheetData);
        },
        child: Container(
          padding: EdgeInsets.all(10.h),
          decoration: boxDecoration10,
          child: WorksheeetCard(
            worksheetData: widget.worksheetData,
            onResume: onResume,
          ),
        ),
      ),
    );
  }

  navigateToSubmissionsPage(Worksheet worksheetData) {
    homeWorkController.selectedSubjectData = worksheetData.subject;
    homeWorkController.selectedChapterData = worksheetData.chapter;
    homeWorkController.selectedTopicOrConceptId = "-1";
    homeWorkController.selectedType = ByHomeworkTypes.chapter;

    switch (getType(worksheetData)) {
      case TestType.hw:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeWorkSubmissionPage(
              subjectId: worksheetData.subject!.id!,
              chapterId: worksheetData.chapter!.id!,
              homeworkId: worksheetData.id!,
            ),
          ),
        ).then((value) => {onResume()});
        break;

      default:
    }
  }
}

TestType getType(Worksheet worksheetData) {
  if ((worksheetData.worksheet ?? "") == "classwork") {
    return TestType.cw;
  } else {
    return TestType.hw;
  }
}

class WorkSheetTypeIconData {
  final Color textColor;
  final Color bgColor;
  final String text;
  final String iconPath;

  WorkSheetTypeIconData({required this.textColor, required this.bgColor, required this.text, required this.iconPath});
}

class WorksheeetCard extends StatelessWidget {
  final Worksheet? worksheetData;
  final VoidCallback onResume;
  const WorksheeetCard({
    Key? key,
    required this.worksheetData,
    required this.onResume,
  }) : super(key: key);

  WorkSheetTypeIconData getData(TestType type) {
    WorkSheetTypeIconData data;
    switch (type) {
      case TestType.cw:
        data = WorkSheetTypeIconData(text: "WS", textColor: colorGreenDark, bgColor: colorGreenLight, iconPath: 'cw.svg');
        break;
      case TestType.hw:
        data = WorkSheetTypeIconData(text: "WS", textColor: colorPurple, bgColor: colorPurpleLight, iconPath: 'hw.svg');
        break;
      default:
        data = WorkSheetTypeIconData(text: "WS", textColor: colorPurple, bgColor: colorPurpleLight, iconPath: 'hw.svg');
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    WorkSheetTypeIconData testTypeIconData = getData(getType(worksheetData!));
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
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          (worksheetData?.name ?? ""),
                          style: textTitle18WhiteBoldStyle.merge(
                            const TextStyle(fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                          ),
                        ),
                        Row(
                          children: [
                            worksheetData?.chapter?.orderNumber != null
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
                                      color: colorSkyLight,
                                    ),
                                    child: Text(
                                      'CH ${worksheetData?.chapter?.orderNumber ?? ""}',
                                      style: textTitle12BoldStyle.merge(
                                        const TextStyle(
                                          color: colorSky,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Flexible(
                              child: Text(
                                worksheetData?.chapter?.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTitle14BoldStyle.merge(
                                  const TextStyle(fontWeight: FontWeight.normal, color: colorBodyText),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          worksheetData?.subject?.name ?? "",
                          style: textTitle12BoldStyle.merge(
                            const TextStyle(fontWeight: FontWeight.w700, color: colorDisable),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            if (isURLTypeImage(worksheetData?.questionPdf ?? ""))
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ZoomableImageView(
                                      imageUrl: worksheetData?.questionPdf ?? "",
                                      title: "Worksheet",
                                    ),
                                  ),
                                ).then((value) => onResume())
                              }
                            else
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomPDFViewer(
                                        pdfUrl: worksheetData?.questionPdf ?? "", title: "Worksheet" //lessonplanspdfs.name?.enUs! ?? "",
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
                        // (((worksheetData?.shareAnswerKey ?? false) &&
                        //             (worksheetData?.hasSubmission ?? false) &&
                        //             (worksheetData?.submissions?.isNotEmpty ?? false)) ||
                        //         ((worksheetData?.shareAnswerKey ?? false) && (worksheetData?.completed?.status ?? false)))
                        isshowAnswerKey(worksheetData)
                            ? GestureDetector(
                                onTap: () => {
                                  if (isURLTypeImage(worksheetData?.answerPdf ?? ""))
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ZoomableImageView(
                                            imageUrl: worksheetData?.answerPdf ?? "",
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
                                          builder: (context) => CustomPDFViewer(
                                              pdfUrl: worksheetData?.answerPdf ?? "", title: "Answer Paper" //lessonplanspdfs.name?.enUs! ?? "",
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
                            : const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.w,
                      right: 5.w,
                    ),
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      color: testTypeIconData.bgColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 14.h,
                          width: 14.h,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.h),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: SvgPicture.asset(
                              imageAssets + testTypeIconData.iconPath,
                              color: testTypeIconData.textColor,
                            ),
                          ),
                        ),
                        Text(
                          testTypeIconData.text,
                          style: textTitle12BoldStyle.merge(
                            TextStyle(
                              color: testTypeIconData.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (worksheetData?.hasSubmission == true) && !(worksheetData?.completed?.status ?? false)
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
                      : const SizedBox(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.w,
                      right: 5.w,
                    ),
                    padding: EdgeInsets.all(5.h),
                    child: TitleDescription(
                      title: "Assign",
                      desc: (getType(worksheetData!) == TestType.precap)
                          ? worksheetData?.assigned?.date != null
                              ? DateFormat("d MMM").format(worksheetData!.assigned!.date!)
                              : "-"
                          : worksheetData?.assigned?.date != null
                              ? DateFormat("d MMM").format(worksheetData!.assigned!.date!)
                              : "-",
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
                      desc: worksheetData?.submissionDate != null ? DateFormat("d MMM").format(worksheetData!.submissionDate!) : "-",
                      titleStyle: textTitle8BoldStyle.merge(
                        const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                      ),
                      descStyle: textTitle12BoldStyle.merge(
                        const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  (worksheetData?.completed?.status ?? false)
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 5.w,
                            right: 5.w,
                          ),
                          padding: EdgeInsets.all(5.h),
                          child: TitleDescription(
                            title: "Attend",
                            desc: (getType(worksheetData!) == TestType.precap)
                                ? worksheetData?.completed?.date != null
                                    ? DateFormat("d MMM").format(worksheetData!.completed!.date!)
                                    : "-"
                                : worksheetData?.completed?.date != null
                                    ? DateFormat("d MMM").format(worksheetData!.completed!.date!)
                                    : "-",
                            titleStyle: textTitle8BoldStyle.merge(
                              const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                            ),
                            descStyle: textTitle12BoldStyle.merge(
                              const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.w,
                      right: 5.w,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: TitleDescription(
                      title: "Marks",
                      desc: (worksheetData?.completed?.status ?? false)
                          ? worksheetData?.obtainedMarks != null && worksheetData?.totalMarks != null
                              ? (worksheetData?.obtainedMarks ?? "-").toString() + '/' + (worksheetData?.totalMarks ?? "").toString()
                              : "-"
                          : worksheetData?.totalMarks != null
                              ? (worksheetData?.totalMarks ?? "").toString()
                              : "-",
                      titleStyle: textTitle8BoldStyle.merge(
                        const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                      ),
                      descStyle: textTitle12BoldStyle.merge(
                        const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isshowAnswerKey(Worksheet? data) {
    // (((homeWorkController.homeworkDetailModel.value.data?.shareAnswerKey ?? false) &&
    //                                                         (homeWorkController.homeworkDetailModel.value.data?.hasSubmission ?? false) &&
    //                                                         (homeWorkController.homeworkDetailModel.value.data?.submissions?.isNotEmpty ?? false)) ||
    //                                                     ((homeWorkController.homeworkDetailModel.value.data?.shareAnswerKey ?? false) &&
    //                                                         (homeWorkController.homeworkDetailModel.value.data?.submitted?.status ?? false)))

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
}
