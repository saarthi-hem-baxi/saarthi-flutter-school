// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_network_image.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/media/media_utils.dart';
import '../../widgets/media/pdf_viewer.dart';
import '../../widgets/media/zoomable_image_view.dart';

class HomeworksSubmissionCards extends StatefulWidget {
  var homeWorkController = Get.put(HomeworkController());

  List<XFile> selectedFiles = [];

  HomeworksSubmissionCards({
    Key? key,
    required this.homeWorkController,
    required this.selectedFiles,
  }) : super(key: key);

  @override
  _HomeworksSubmissionCardsState createState() => _HomeworksSubmissionCardsState();
}

class _HomeworksSubmissionCardsState extends State<HomeworksSubmissionCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //New Selected Files

        widget.selectedFiles.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    child: Text(
                      DateFormat("dd MMM yyy").format(DateTime.now()).toString(),
                      style: textTitle14BoldStyle.merge(
                        const TextStyle(
                          color: colorBodyText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getScreenWidth(context) - 78,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (widget.selectedFiles
                            .map(
                              ((file) => Container(
                                    height: 100.h,
                                    width: 100.h,
                                    margin: EdgeInsets.only(top: 10.h, right: 10.h),
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: colorDropShadow, width: 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: isURLTypeImage(file.path)
                                        ? Image.file(File(file.path))
                                        : Container(
                                            height: 87,
                                            width: 87,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: colorPurpleLight,
                                            ),
                                            alignment: AlignmentDirectional.center,
                                            child: SizedBox(
                                              height: 53,
                                              width: 50,
                                              child: SvgPicture.asset(
                                                imageAssets + 'lessonplan/pdf_thumb.svg',
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                  )),
                            )
                            .toList()),
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    margin: EdgeInsets.only(top: 10.h, bottom: 10),
                    color: colorBodyText,
                  )
                ],
              )
            : Container(),

        // Already Submitted Files
        ...(widget.homeWorkController.homeworkDetailModel.value.data?.submissions ?? [])
            .groupBy((p0) => p0.date != null ? DateFormat("dd MMM yyy").format(p0.date!) : "-")
            .entries
            .map(
              ((submissionData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    submissionData.value.map((e) => (e.submission ?? []).length).reduce((value, element) => value + element).toInt() > 0
                        ? Text(
                            submissionData.key,
                            style: textTitle14BoldStyle.merge(
                              const TextStyle(
                                color: colorBodyText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: getScreenWidth(context) - 78,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (submissionData.value)
                                .map(
                                  (mappedSubmissionList) => Row(
                                      children: (mappedSubmissionList.submission ?? [])
                                          .map((submission) => Container(
                                                height: 100.h,
                                                width: 100.h,
                                                margin: EdgeInsets.only(top: 10.h, right: 10.h),
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: colorDropShadow, width: 1),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () => {
                                                    if (isURLTypeImage(submission))
                                                      {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ZoomableImageView(
                                                              imageUrl: submission,
                                                              title: "Question Paper",
                                                            ),
                                                          ),
                                                        )
                                                      }
                                                    else
                                                      {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => CustomPDFViewer(pdfUrl: submission, title: "PDF"),
                                                          ),
                                                        )
                                                      }
                                                  },
                                                  child: isURLTypeImage(submission)
                                                      ? CustomNetworkImage(imageUrl: submission)
                                                      : Container(
                                                          height: 87,
                                                          width: 87,
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(10),
                                                            ),
                                                            color: colorPurpleLight,
                                                          ),
                                                          alignment: AlignmentDirectional.center,
                                                          child: SizedBox(
                                                            height: 53,
                                                            width: 50,
                                                            child: SvgPicture.asset(
                                                              imageAssets + 'lessonplan/pdf_thumb.svg',
                                                              fit: BoxFit.fitHeight,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ))
                                          .toList()),
                                )
                                .toList(),
                          ),
                        )),
                  ],
                );
              }),
            )
            .toList()
            .reversed
      ],
    );
  }
}
