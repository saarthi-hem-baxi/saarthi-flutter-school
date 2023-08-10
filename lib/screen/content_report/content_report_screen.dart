import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/model/content_report/question_content_report.modal.dart';

import '../../controllers/content_report_controller.dart';
import '../../helpers/const.dart';
import '../../helpers/media_picker.dart';
import '../../helpers/utils.dart';
import '../../model/content_report/lp_content_report.modal.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/sidebar_widget_input.dart';
import '../../widgets/media/media_utils.dart';
import '../../widgets/media/zoomable_image_view.dart';

enum ContentReportType {
  lessonplan,
  questions,
}

class ContentReportPage extends StatefulWidget {
  const ContentReportPage({
    Key? key,
    this.lpContentReportdata,
    this.questionContentReportModal,
    required this.typeOfContent,
  }) : super(key: key);

  final LpContentReportModal? lpContentReportdata;
  final QuestionContentReportModal? questionContentReportModal;
  final ContentReportType typeOfContent;

  @override
  State<ContentReportPage> createState() => _ContentReportPageState();
}

class _ContentReportPageState extends State<ContentReportPage> {
  final TextEditingController _textEditingController = TextEditingController(text: "");

  final ContentReportController _contentReportController = Get.put(ContentReportController());

  final ScrollController _multiLineInputScrollController = ScrollController();

  List<String> pickedFiles = [];

  Future<String> getCompressFile(String path) async {
    try {
      File compressedImg = await FlutterNativeImage.compressImage(
        path,
        quality: 40,
      );
      return compressedImg.path;
    } catch (e) {
      debugPrint("Compress Error $e");
      return "";
    }
  }

  void onBack() {
    if (_contentReportController.lpReportLoading.isTrue) {
      _contentReportController.lpReportLoading.value = false;
    }
    Navigator.pop(context);
  }

  void onSubmit() async {
    //prepare lesson plan data for sending content report
    if (widget.typeOfContent == ContentReportType.lessonplan) {
      LpContentReportModal lpContentReportModal = widget.lpContentReportdata!;
      Map<String, dynamic> data = lpContentReportModal.toJson();

      if (_textEditingController.text.trim() != "") {
        data.removeWhere((key, value) => value == null); // remove null value from map
        data['content'].removeWhere((key, value) => value == null);
        if (data['content'].containsKey("word")) {
          data['content']['word'].removeWhere((key, value) => value == null);
        }

        doDataPostProcess(data: data, isLessonPlanReport: true);
      } else {
        Fluttertoast.showToast(msg: "Please enter message");
      }
    }

    // prepare question data for sending content report
    if (widget.typeOfContent == ContentReportType.questions) {
      QuestionContentReportModal questionContentReportModal = widget.questionContentReportModal!;
      Map<String, dynamic> data = questionContentReportModal.toJson();

      if (_textEditingController.text.trim() != "") {
        data.removeWhere((key, value) => (value == null) || (value == "null") || (value == [])); // remove null value from map
        data['content'].removeWhere((key, value) => (value == null) || (value == "null"));

        doDataPostProcess(data: data, isLessonPlanReport: false);
      } else {
        Fluttertoast.showToast(msg: "Please enter message");
      }
    }
  }

  void doDataPostProcess({required Map<String, dynamic> data, required isLessonPlanReport}) async {
    data.addAll({
      "message": {
        "description": _textEditingController.text.trim(),
        "media": pickedFiles.map((e) => {"url": "", "thumbUrl": ""}).toList(), //for only backend purpose
      },
    });

    Map<String, dynamic> dataMap = {"data": jsonEncode(data)};

    for (var i = 0; i < pickedFiles.length; i++) {
      String mediaPath = pickedFiles[i];
      String thumbPath = await getCompressFile(pickedFiles[i]);
      dataMap['media-$i'] = await dio.MultipartFile.fromFile(
        mediaPath,
        filename: mediaPath.split("/").last,
      );
      if (thumbPath != "") {
        dataMap['thumb-$i'] = await dio.MultipartFile.fromFile(
          thumbPath,
          filename: thumbPath.split("/").last,
        );
      }
    }

    dio.FormData formData = dio.FormData.fromMap(dataMap);
    _contentReportController.sendLPContentReport(formData: formData, isLessonPlanReport: isLessonPlanReport).then((value) => onBack());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorScreenBg1Purple,
        bottomNavigationBar: IntrinsicHeight(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onBack,
                    child: Container(
                      height: 46.h,
                      width: getScreenWidth(context) / 2.2,
                      padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 5.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 0,
                            color: colorDropShadow.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Text(
                        "Cancel",
                        style: textTitle18WhiteBoldStyle.merge(
                          const TextStyle(
                            color: colorWebPanelDarkText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Obx(() {
                    return InkWell(
                      onTap: _contentReportController.lpReportLoading.isTrue ? () {} : onSubmit,
                      child: Container(
                        height: 46.h,
                        width: getScreenWidth(context) / 2.2,
                        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 5.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                          color: colorHeaderTextColor,
                        ),
                        child: Text(
                          _contentReportController.lpReportLoading.isTrue ? "Loading..." : "Submit",
                          style: textTitle18WhiteBoldStyle.merge(
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SvgPicture.asset(
                imageAssets + "screen_bg.svg",
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  HeaderCard(
                    title: "Report",
                    backEnabled: true,
                    onTap: () => {Navigator.pop(context)},
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                imageAssets + "feedback_icon.png",
                                width: 95.h,
                                height: 95.h,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.w),
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorDropShadow,
                                    offset: Offset(0, 1),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Share Feedback",
                                    style: textTitle14BoldStyle.merge(
                                      const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: colorHeaderTextColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Kindly let us know what mistake you identified and help us serve you better.",
                                    style: textTitle14BoldStyle.merge(
                                      const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: colorHeaderTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.w),
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorDropShadow,
                                    offset: Offset(0, 1),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Scrollbar(
                                controller: _multiLineInputScrollController,
                                child: TextFormField(
                                  controller: _textEditingController,
                                  style: textFormTitleStyle.merge(
                                    const TextStyle(
                                      color: colorWebPanelDarkText,
                                    ),
                                  ),
                                  scrollController: _multiLineInputScrollController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type your message",
                                    hintStyle: textTitle14BoldStyle.merge(
                                      const TextStyle(
                                        color: colorWebPanelDarkText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Attach File",
                              style: textTitle12RegularStyle.merge(
                                const TextStyle(color: colorBodyText),
                              ),
                            ),
                            SideBarWidgetInput(
                              text: "Only image files supported",
                              sideWidget: Text(
                                "Browse",
                                style: textTitle14BoldStyle.merge(
                                  const TextStyle(
                                    color: colorSkyDark,
                                  ),
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                MediaPicker(
                                  context: context,
                                  allowMultiple: true,
                                  allowFileTypes: [MediaPickerFileTypes.images],
                                  getBackAllFiles: true,
                                  prevPickedFiles: pickedFiles,
                                  callBack: (filePaths) async {
                                    pickedFiles = filePaths.map((e) => e!).toList().reversed.toList();
                                    pickedFiles.removeWhere((e) => imageTypes.contains(e.split('.').last) == false);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: pickedFiles.length,
                              padding: EdgeInsets.zero,
                              reverse: false,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, itemIndex) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ZoomableImageView(
                                          imageUrl: pickedFiles[itemIndex],
                                          title: "",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.w),
                                          child: Container(
                                            padding: EdgeInsets.all(5.w),
                                            margin: EdgeInsets.all(2.w),
                                            width: 100.w,
                                            height: 100.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: colorExtraLightGreybg),
                                              borderRadius: BorderRadius.circular(10.w),
                                            ),
                                            child: Image.file(
                                              File(pickedFiles[itemIndex]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                          onTap: () {
                                            pickedFiles.removeAt(itemIndex);
                                            setState(() {});
                                          },
                                          child: SvgPicture.asset(imageAssets + 'close_icon.svg'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class ContentPageRoute extends PageRouteBuilder {
//   ContentPageRoute()
//       : super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => const ContentReportPage());

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     var begin = const Offset(0.0, 1.0);
//     var end = const Offset(0, 0);
//     return SlideTransition(
//       position: Tween<Offset>(begin: begin, end: end).animate(controller!),
//       child: const ContentReportPage(),
//     );
//   }
// }
