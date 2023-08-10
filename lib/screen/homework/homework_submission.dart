import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/refresh_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/homework_submission_cards.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/topic_concept_list_title.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/linear_gradient_mask.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/title_description.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/media/media_utils.dart';
import '../../widgets/media/pdf_viewer.dart';
import '../../widgets/media/zoomable_image_view.dart';

class HomeWorkSubmissionPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;

  const HomeWorkSubmissionPage({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<HomeWorkSubmissionPage> createState() => _HomeWorkSubmissionPageState();
}

class _HomeWorkSubmissionPageState extends State<HomeWorkSubmissionPage> with SingleTickerProviderStateMixin {
  var homeWorkController = Get.put(HomeworkController());
  var refreshController = Get.put(RefreshController());
  double progress = 0;

  List<XFile> selectedFiles = [];

  XFile? tempCameraCaptureImage;
  XFile? tempGalleryCaptureImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      refreshData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    Future.delayed(Duration.zero, () {
      refreshData();
    });
  }

  bool isshowAnswerKey(HomeworkDetail? data) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => homeWorkController.loading.isTrue
              ? const Center(
                  child: LoadingSpinner(color: Colors.blue),
                )
              : Stack(
                  children: [
                    const Positioned(
                      left: -150,
                      child: GradientCircle(
                        gradient: circleOrangeGradient,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(125),
                          bottomRight: Radius.circular(125),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -100.h,
                      bottom: -80.h,
                      child: const GradientCircle(
                        gradient: circlePurpleGradient,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(125),
                          bottomLeft: Radius.circular(125),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        HeaderCard(
                          title: 'Submission',
                          backEnabled: true,
                          onTap: () {
                            refreshController.refreshHomeworkkData;
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SafeArea(
                              top: false,
                              bottom: true,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h, top: 10.h),
                                    padding: EdgeInsets.all((16.h)),
                                    width: getScreenWidth(context),
                                    decoration: boxDecoration14,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Worksheet Details",
                                          style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: sectionTitleColor)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20.h),
                                          child: TitleDescription(
                                            title: "Worksheet Name",
                                            desc: homeWorkController.homeworkDetailModel.value.data?.name ?? "",
                                            titleStyle: textTitle12BoldStyle.merge(
                                              const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                            ),
                                            descStyle: textTitle14BoldStyle.merge(
                                              const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: TitleDescription(
                                            title: "Description",
                                            desc: homeWorkController.homeworkDetailModel.value.data?.description ?? "",
                                            titleStyle: textTitle12BoldStyle.merge(
                                              const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                            ),
                                            descStyle: textTitle14BoldStyle.merge(
                                              const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TitleDescription(
                                                title: "Class / Section",
                                                desc:
                                                    "${homeWorkController.homeworkDetailModel.value.data?.classData?.name ?? ''}${homeWorkController.homeworkDetailModel.value.data?.section?.name ?? ''}",
                                                titleStyle: textTitle12BoldStyle.merge(
                                                  const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                                ),
                                                descStyle: textTitle14BoldStyle.merge(
                                                  const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70.w,
                                            ),
                                            Flexible(
                                              child: TitleDescription(
                                                title: "Subject",
                                                desc: (homeWorkController.homeworkDetailModel.value.data?.subject?.name ?? ""),
                                                titleStyle: textTitle12BoldStyle.merge(
                                                  const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                                ),
                                                descStyle: textTitle14BoldStyle.merge(
                                                  const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TitleDescription(
                                          title: "Chapter",
                                          desc:
                                              "${homeWorkController.homeworkDetailModel.value.data?.chapter?.orderNumber ?? ""}. ${capitalize(homeWorkController.homeworkDetailModel.value.data?.chapter?.name ?? "")}",
                                          titleStyle: textTitle12BoldStyle.merge(
                                            const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                          ),
                                          descStyle: textTitle14BoldStyle.merge(
                                            const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        (homeWorkController.homeworkDetailModel.value.data?.type ?? "") != ""
                                            ? SizedBox(
                                                child: TitleDescription(
                                                  title: "Type",
                                                  desc: "HW",
                                                  titleStyle: textTitle12BoldStyle.merge(
                                                    const TextStyle(fontWeight: FontWeight.w600, color: colorBodyText),
                                                  ),
                                                  descStyle: textTitle14BoldStyle.merge(
                                                    const TextStyle(fontWeight: FontWeight.w600, color: colorWebPanelDarkText),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 5.w,
                                                right: 5.w,
                                              ),
                                              padding: EdgeInsets.all(5.h),
                                              child: TitleDescription(
                                                title: "Assign",
                                                desc: homeWorkController.homeworkDetailModel.value.data?.assigned?.date != null
                                                    ? DateFormat("d MMM").format(homeWorkController.homeworkDetailModel.value.data!.assigned!.date!)
                                                    : "-",
                                                titleStyle: textTitle12BoldStyle.merge(
                                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                ),
                                                descStyle: textTitle14BoldStyle.merge(
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
                                                desc: homeWorkController.homeworkDetailModel.value.data?.submissionDate != null
                                                    ? DateFormat("d MMM").format(homeWorkController.homeworkDetailModel.value.data!.submissionDate!)
                                                    : "-",
                                                titleStyle: textTitle12BoldStyle.merge(
                                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                ),
                                                descStyle: textTitle14BoldStyle.merge(
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
                                                title: "Marks",
                                                desc: (homeWorkController.homeworkDetailModel.value.data?.completed?.status ?? false)
                                                    ? homeWorkController.homeworkDetailModel.value.data?.obtainedMarks != null &&
                                                            homeWorkController.homeworkDetailModel.value.data?.totalMarks != null
                                                        ? (homeWorkController.homeworkDetailModel.value.data?.obtainedMarks ?? "-").toString() +
                                                            '/' +
                                                            (homeWorkController.homeworkDetailModel.value.data?.totalMarks ?? "").toString()
                                                        : "-"
                                                    : homeWorkController.homeworkDetailModel.value.data?.totalMarks != null
                                                        ? (homeWorkController.homeworkDetailModel.value.data?.totalMarks ?? "").toString()
                                                        : "-",
                                                titleStyle: textTitle12BoldStyle.merge(
                                                  const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                ),
                                                descStyle: textTitle14BoldStyle.merge(
                                                  const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        homeWorkController.homeworkDetailModel.value.data?.completed?.status ?? false
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                  top: 5.w,
                                                  right: 5.w,
                                                ),
                                                padding: EdgeInsets.all(5.h),
                                                child: TitleDescription(
                                                  title: "Attend",
                                                  desc: homeWorkController.homeworkDetailModel.value.data?.completed?.date != null
                                                      ? DateFormat("d MMM")
                                                          .format(homeWorkController.homeworkDetailModel.value.data!.completed!.date!)
                                                      : "-",
                                                  titleStyle: textTitle12BoldStyle.merge(
                                                    const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                                  ),
                                                  descStyle: textTitle14BoldStyle.merge(
                                                    const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10, bottom: 10),
                                          child: Divider(height: 1, color: colorWebPanelDarkText),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Topics/Concepts",
                                              style: textError16WhiteBoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                                            ),
                                            Text(
                                              "${(homeWorkController.homeworkDetailModel.value.data?.topics ?? []).length}",
                                              style: textError16WhiteBoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            ...(homeWorkController.homeworkDetailModel.value.data?.topics ?? []).map(
                                              (item) {
                                                return TopicConceptListTile(name: item.topic.name ?? "", type: item.type ?? "");
                                              },
                                            ).toList(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h),
                                    padding: EdgeInsets.all((16.h)),
                                    width: getScreenWidth(context),
                                    decoration: boxDecoration14,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Worksheet",
                                          style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: sectionTitleColor)),
                                        ),
                                        Row(
                                          children: [
                                            homeWorkController.homeworkDetailModel.value.data?.questionPdf == null
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () => {
                                                      if (isURLTypeImage(homeWorkController.homeworkDetailModel.value.data?.questionPdf ?? ""))
                                                        {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ZoomableImageView(
                                                                imageUrl: homeWorkController.homeworkDetailModel.value.data?.questionPdf ?? "",
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
                                                              builder: (context) => CustomPDFViewer(
                                                                  pdfUrl: homeWorkController.homeworkDetailModel.value.data?.questionPdf ?? "",
                                                                  title: "Worksheet" //lessonplanspdfs.name?.enUs! ?? "",
                                                                  ),
                                                            ),
                                                          ).then((value) => {onResume()})
                                                        }
                                                    },
                                                    child: Container(
                                                      height: 105.h,
                                                      width: 100.h,
                                                      margin: EdgeInsets.only(top: 10.h),
                                                      padding: const EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: colorGDPurpleDark, width: 1),
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          gradient: purpleLightGradient),
                                                      child: LinearGradientMask(
                                                        colors: const [colorGDPurpleLight, colorGDPurpleDark],
                                                        child: SvgPicture.asset(
                                                          imageAssets + 'question.svg',
                                                          allowDrawingOutsideViewBox: true,
                                                          color: Colors.white,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            homeWorkController.homeworkDetailModel.value.data?.answerPdf == null
                                                ? Container()
                                                : isshowAnswerKey(homeWorkController.homeworkDetailModel.value.data)
                                                    ? GestureDetector(
                                                        onTap: () => {
                                                          if (isURLTypeImage(homeWorkController.homeworkDetailModel.value.data?.answerPdf ?? ""))
                                                            {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ZoomableImageView(
                                                                    imageUrl: homeWorkController.homeworkDetailModel.value.data?.answerPdf ?? "",
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
                                                                      pdfUrl: homeWorkController.homeworkDetailModel.value.data?.answerPdf ?? "",
                                                                      title: "Answer Paper" //lessonplanspdfs.name?.enUs! ?? "",
                                                                      ),
                                                                ),
                                                              ).then((value) => {onResume()})
                                                            }
                                                        },
                                                        child: Container(
                                                          height: 105.h,
                                                          width: 100.h,
                                                          margin: EdgeInsets.only(top: 10.h, left: 30.w),
                                                          padding: const EdgeInsets.all(15),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: colorGDTealDark, width: 1),
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(10),
                                                              ),
                                                              gradient: tealLightGradient),
                                                          child: LinearGradientMask(
                                                            colors: const [colorGDTealLight, colorGDTealDark],
                                                            child: SvgPicture.asset(
                                                              imageAssets + 'answer.svg',
                                                              allowDrawingOutsideViewBox: true,
                                                              color: Colors.white,
                                                              fit: BoxFit.fitHeight,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  (homeWorkController.homeworkDetailModel.value.data?.hasSubmission ?? false)
                                      ? Container(
                                          margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h),
                                          padding: EdgeInsets.all((16.h)),
                                          width: getScreenWidth(context),
                                          decoration: boxDecoration14,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Submission",
                                                    style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: sectionTitleColor)),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5.w,
                                                      left: 5.w,
                                                    ),
                                                    padding: EdgeInsets.all(5.h),
                                                    decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(6),
                                                        ),
                                                        color: colorExtraBlueLight),
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior.opaque,
                                                      onTap: () async {
                                                        openBottomSheet();
                                                        // setState(() {
                                                        //   selectedFiles = [];
                                                        // });
                                                        // FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                        //   allowMultiple: true,
                                                        //   type: FileType.custom,
                                                        //   allowedExtensions: [
                                                        //     'jpg',
                                                        //     'png',
                                                        //     'jpeg',
                                                        //     'pdf',
                                                        //   ],
                                                        // );

                                                        // if (result != null) {
                                                        //   selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());

                                                        //   setState(() {});

                                                        //   selectedFiles.map((e) => debugPrint(e.path));
                                                        // } else {
                                                        //   // User canceled the picker
                                                        // }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 14.h,
                                                            width: 14.h,
                                                            child: Icon(
                                                              Icons.add_circle,
                                                              size: 10.h,
                                                              color: colorBlue,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Submission",
                                                            style: textTitle14BoldStyle.merge(
                                                              const TextStyle(color: colorBlue),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              HomeworksSubmissionCards(homeWorkController: homeWorkController, selectedFiles: selectedFiles),
                                              selectedFiles.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        await homeWorkController.putSubmitHomework(
                                                            context: context,
                                                            subjectId: widget.subjectId,
                                                            chapterId: widget.chapterId,
                                                            homeworkId: widget.homeworkId,
                                                            file: selectedFiles);
                                                        setState(() {
                                                          selectedFiles = [];
                                                        });
                                                        refreshController.refreshHomeworkkData();
                                                        refreshData();
                                                      },
                                                      child: Container(
                                                        // alignment: AlignmentDirectional.topEnd,

                                                        margin: EdgeInsets.only(
                                                          top: 16.h,
                                                          bottom: 10.h,
                                                        ),
                                                        child: Container(
                                                          // height: iconSize36,
                                                          // width: iconSize36,
                                                          height: 38.sp,
                                                          width: getScreenWidth(context),
                                                          alignment: AlignmentDirectional.center,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8.h),
                                                            ),
                                                            gradient: blueDarkGradient,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              const Icon(
                                                                Icons.check_circle,
                                                                color: Colors.white,
                                                                size: 15,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(left: 5.w),
                                                                child: Text("Submit",
                                                                    style: textTitle16WhiteBoldStyle.merge(TextStyle(fontSize: 16.sp))),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  (!(homeWorkController.homeworkDetailModel.value.data?.completed?.status ?? false) &&
                                          !(homeWorkController.homeworkDetailModel.value.data?.hasSubmission ?? false) &&
                                          !(homeWorkController.homeworkDetailModel.value.data?.submitted?.status ?? false))
                                      ? GestureDetector(
                                          onTap: () async {
                                            await homeWorkController.doHomeworkComplete(
                                                context: context,
                                                subjectId: widget.subjectId,
                                                chapterId: widget.chapterId,
                                                homeworkId: widget.homeworkId);

                                            refreshData();
                                          },
                                          child: Container(
                                            // alignment: AlignmentDirectional.topEnd,

                                            margin: EdgeInsets.only(
                                              left: 16.h,
                                              right: 16.h,
                                              bottom: 10.h,
                                            ),
                                            child: Container(
                                              // height: iconSize36,
                                              // width: iconSize36,
                                              height: 38.sp,
                                              width: getScreenWidth(context),
                                              alignment: AlignmentDirectional.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.h),
                                                ),
                                                gradient: blueDarkGradient,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 5.w),
                                                    child: Text("Complete", style: textTitle16WhiteBoldStyle.merge(TextStyle(fontSize: 16.sp))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    progress > 0
                        ? Container(
                            height: getScrenHeight(context),
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                height: 150.h,
                                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                                child: AlertDialog(
                                  title: Text(progress.toStringAsFixed(0) + "% Opening... Wait For a while",
                                      style: sectionTitleTextStyle.merge(TextStyle(fontSize: 16.sp))),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
        ),
      ),
    );
  }

  void openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InkWell(
                          child: ClipOval(
                            child: Container(
                              color: colorSkyLight,
                              width: 88.w,
                              height: 88.w,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    imageAssets + 'gallery_icon.svg',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            handleImageUpload(ImageSource.gallery);
                            Navigator.of(context).pop();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Gallery',
                        style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                          child: ClipOval(
                            child: Container(
                              color: colorSkyLight,
                              width: 88.w,
                              height: 88.w,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    imageAssets + 'folder_icon.svg',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            handleFilesUpload();
                            Navigator.of(context).pop();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'File Manager',
                        style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                          child: ClipOval(
                            child: Container(
                              color: colorSkyLight,
                              width: 88.w,
                              height: 88.w,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    imageAssets + 'camera_icon.svg',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            handleImageUpload(ImageSource.camera);
                            Navigator.of(context).pop();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Camera',
                        style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 60.h,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleImageUpload(ImageSource imageOption) async {
    try {
      if (imageOption == ImageSource.camera) {
        tempCameraCaptureImage = null;
        tempCameraCaptureImage = await _picker.pickImage(source: ImageSource.camera);

        if (tempCameraCaptureImage != null) {
          // checking file size : if file data will be more than 100 mb data will not added.

          List<XFile>? xFiles = [XFile(tempCameraCaptureImage?.path ?? '')];

          List<XFile> tempMediaList = [...selectedFiles, ...xFiles];

          double temp = 0.0;
          double sizeInMb = 0.0;
          bool isValidSize = false;
          for (int i = 0; i < tempMediaList.length; i++) {
            int size = await tempMediaList[i].length();
            temp = size / (1024 * 1024);
            sizeInMb = sizeInMb + temp;
            if (sizeInMb > 100) {
              isValidSize = false;
              Fluttertoast.showToast(msg: 'Maximum total files upload size - 100MB');
              break;
            } else {
              isValidSize = true;
            }
          }

          if (isValidSize) {
            setState(() {
              selectedFiles = [...selectedFiles, ...xFiles];
              selectedFiles.map((e) => debugPrint(e.path));
            });
          }
        } else {
          debugPrint('Fail: User Cancelled');
        }
      } else {
        List<XFile>? tempGalleryCaptureImage = await _picker.pickMultiImage();
        if (tempGalleryCaptureImage != null) {
          List<XFile> tempMediaList = [...selectedFiles, ...tempGalleryCaptureImage];
          double temp = 0.0;
          double sizeInMb = 0.0;
          bool isValidSize = false;
          for (int i = 0; i < tempMediaList.length; i++) {
            int size = await tempMediaList[i].length();
            temp = size / (1024 * 1024);
            sizeInMb = sizeInMb + temp;
            if (sizeInMb > 100) {
              isValidSize = false;
              Fluttertoast.showToast(msg: 'Maximum total files upload size - 100MB');
              break;
            } else {
              isValidSize = true;
            }
          }
          if (isValidSize) {
            setState(() {
              selectedFiles = [...selectedFiles, ...tempGalleryCaptureImage];

              selectedFiles.map((e) => debugPrint(e.path));
            });
          }
        } else {
          debugPrint('Fail: User Cancelled');
        }
      }
    } catch (e) {
      debugPrint('error: ${e.toString()}');
    }
  }

  Future<void> handleFilesUpload() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      dialogTitle: 'Choose Files',
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'heic', 'JPG', 'PNG', 'JPEG', 'PDF', 'HEIC'],
    );

    if (result != null) {
      List<String> _allowedFileListData = [];

      String _getFileExt(String path) {
        var _fileExt = path.split('.').last;
        return _fileExt.toLowerCase();
      }

      for (var item in result.paths) {
        if (imageTypes.contains(_getFileExt(item!)) || 'pdf'.contains(_getFileExt(item))) {
          _allowedFileListData.add(item);
        }
      }

      List<XFile> tempMediaList = [
        ...selectedFiles,
        ..._allowedFileListData.map((path) {
          return XFile(path);
        }).toList()
      ];

      double temp = 0.0;
      double sizeInMb = 0.0;
      bool isValidSize = false;
      for (int i = 0; i < tempMediaList.length; i++) {
        int size = await File(tempMediaList[i].path).length();
        temp = size / (1024 * 1024);
        sizeInMb = sizeInMb + temp;
        if (sizeInMb > 100) {
          isValidSize = false;
          debugPrint('Maximum total files upload size - 100MB');
          Fluttertoast.showToast(msg: 'Maximum total files upload size - 100MB');
          break;
        } else {
          isValidSize = true;
        }
      }

      if (isValidSize) {
        // add selected files to list
        selectedFiles = [
          ...selectedFiles,
          ...result.paths.map((path) {
            return XFile(path ?? '');
          })
        ];
        // selectedAllFiles = filterData;
        setState(() {});
      }
    } else {
      debugPrint('Fail: User Cancelled');
    }
  }

  refresh() {
    setState(() {});
  }

  updateDownloadUI(double prg) {
    if (prg == 100) {
      setState(() {
        progress = 0;
      });
    } else {
      setState(() {
        progress = prg;
      });
    }
  }

  void refreshData() async {
    await homeWorkController.getHomeworkDetail(
        context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: widget.homeworkId);
    setState(() {});
  }
}
