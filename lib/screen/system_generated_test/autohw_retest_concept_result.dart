import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_concept_result.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/autohw_retest_concept_clear.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_exam.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_topic_list.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/homework_controller.dart';
import '../../controllers/retest_controller.dart';
import '../../model/system_generated_test_model/retest/retest_detail.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/title_description.dart';
import '../home/bottom_footer_navigation.dart';
import '../homework/homework.dart';
import 'retest/retest_concept_result.dart';

class AutoHWRetestConceptBasedResultScreenPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final bool isSelfAutoHW;
  final ByHomeworkTypes type;
  final bool isFromRetestResult;
  final bool isFromRoadMapResult;

  const AutoHWRetestConceptBasedResultScreenPage({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
    this.isSelfAutoHW = false,
    this.type = ByHomeworkTypes.concept,
    this.isFromRetestResult = false,
    this.isFromRoadMapResult = false,
  }) : super(key: key);

  @override
  State<AutoHWRetestConceptBasedResultScreenPage> createState() => _AutoHWRetestConceptBasedResultScreenPageState();
}

class _AutoHWRetestConceptBasedResultScreenPageState extends State<AutoHWRetestConceptBasedResultScreenPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());
  final homeworkController = Get.put(HomeworkController());
  int touchedIndex = -1;
  int dialogshowCount = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  void reloadData() async {
    await retestsController.getRetestResult(
      context: context,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
    );

    if (mounted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? idsList = prefs.getStringList('autoHWIds');
      setState(() {});
      Iterable<RetestResult> list = retestsController.retestListModel.value.data!.retestResult!.where((element) => element.cleared == false);
      if (list.isEmpty) {
        if (checkShowDialog(idsList)) {
          idsList?.removeWhere((element) => element == widget.homeworkId);
          prefs.setStringList('autoHWIds', idsList ?? []);
          showCompleteAllKeylearningDialog();
        }
      }
    }
  }

  bool checkShowDialog(List<String>? idsList) {
    bool isFound = false;
    isFound = (idsList ?? []).contains(widget.homeworkId);
    return isFound;
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    if (homeworkController.isFromNotification ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomFooterNavigation(),
        ),
      );
      homeworkController.isFromNotification = false;
    } else {
      // if (homeworkController.isFromPending ?? false) {
      //   Navigator.pop(context);
      // }
      if ((homeworkController.isFromTests ?? false)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomFooterNavigation(
              selectedIndex: (homeworkController.isFromPending ?? false) ? 1 : 2,
            ),
          ),
        );
      } else {
        if (!widget.isSelfAutoHW) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeWorkPage(
                subjectData: homeworkController.selectedSubjectData!,
                chapterData: homeworkController.selectedChapterData!,
                topicOrConceptId: homeworkController.selectedTopicOrConceptId!,
                type: homeworkController.selectedType!,
                tab: (homeworkController.isFromPending ?? false) ? 0 : 1,
              ),
            ),
          );
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Obx(
            () => Stack(
              children: [
                Positioned(
                  left: -125,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 250.h,
                      width: 250.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color.fromRGBO(247, 110, 178, 0.2),
                            Color.fromRGBO(247, 110, 178, 0),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(125),
                          bottomRight: Radius.circular(125),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -175,
                  bottom: -175,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 250.h,
                      width: 250.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color.fromRGBO(97, 0, 224, 0.2), Color.fromRGBO(97, 0, 224, 0)],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(125),
                          bottomLeft: Radius.circular(125),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5.h, left: 16.w, bottom: 10.h),
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Result",
                            style: sectionTitleTextStyle,
                          ),
                        ),
                        Container(
                          height: 26.h,
                          width: 26.h,
                          margin: EdgeInsets.only(right: 16.w),
                          alignment: AlignmentDirectional.center,
                          decoration: boxDecoration10,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.close,
                            ),
                            iconSize: 14.h,
                            color: Colors.black,
                            onPressed: _onBackPressed,
                          ),
                        ),
                      ],
                    ),
                    retestsController.loading.isTrue || retestsController.retestListModel.value.data == null
                        ? const Center(
                            child: LoadingSpinner(color: Colors.blue),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: (retestsController.retestListModel.value.data!.retestResult ?? []).isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: ((MediaQuery.of(context).size.width - 45) / 2),
                                                height: 54.h,
                                                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                decoration: boxDecoration14,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 10.w),
                                                      child: Text(
                                                        (retestsController.retestListModel.value.data!.retestResult ?? []).isNotEmpty
                                                            ? (retestsController.retestListModel.value.data!.retestResult ?? [])
                                                                .where((e) => e.cleared == true)
                                                                .length
                                                                .toString()
                                                                .padLeft(2, '0')
                                                            : "0",
                                                        style: textTitle26WhiteBoldStyle.merge(
                                                          const TextStyle(color: colorGreenDark),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "Cleared Concept",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // alignment: AlignmentDirectional.center,
                                                width: ((MediaQuery.of(context).size.width - 45) / 2),
                                                height: 54.h,
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                decoration: boxDecoration14,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 10.w),
                                                      child: Text(
                                                        (retestsController.retestListModel.value.data!.retestResult ?? []).isNotEmpty
                                                            ? (retestsController.retestListModel.value.data!.retestResult ?? [])
                                                                .map((e) => e.keyLearnings!.where((element) => element.cleared == true).length)
                                                                .reduce((value, element) => value + element)
                                                                .toString()
                                                                .padLeft(2, '0')
                                                            : "0",
                                                        style: textTitle26WhiteBoldStyle.merge(
                                                          const TextStyle(color: colorGreenDark),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "Cleared Keylearning",
                                                        style: textTitle14BoldStyle.merge(
                                                          const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 10.h,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: (MediaQuery.of(context).size.width - 45) / 2,
                                                  height: 54.h,
                                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                  decoration: boxDecoration14,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 10.w),
                                                        child: Text(
                                                          (retestsController.retestListModel.value.data!.retestResult ?? []).isNotEmpty
                                                              ? (retestsController.retestListModel.value.data!.retestResult ?? [])
                                                                  .where((e) => e.cleared == false)
                                                                  .length
                                                                  .toString()
                                                                  .padLeft(2, '0')
                                                              : "0",
                                                          style: textTitle26WhiteBoldStyle.merge(
                                                            const TextStyle(color: colorRed),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Uncleared Concept",
                                                          style: textTitle14BoldStyle.merge(
                                                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: (MediaQuery.of(context).size.width - 45) / 2,
                                                  height: 54.h,
                                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                  decoration: boxDecoration14,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 10.w),
                                                        child: Text(
                                                          (retestsController.retestListModel.value.data!.retestResult ?? []).isNotEmpty
                                                              ? (retestsController.retestListModel.value.data!.retestResult ?? [])
                                                                  .map((e) => e.keyLearnings!.where((element) => element.cleared == false).length)
                                                                  .reduce((value, element) => value + element)
                                                                  .toString()
                                                                  .padLeft(2, '0')
                                                              : "0",
                                                          style: textTitle26WhiteBoldStyle.merge(
                                                            const TextStyle(color: colorRed),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Uncleared Keylearning",
                                                          style: textTitle14BoldStyle.merge(
                                                            const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 10.h,
                                            ),
                                            width: getScreenWidth(context),
                                            child: Text(
                                              "Concepts",
                                              style: textTitle18WhiteBoldStyle.merge(
                                                const TextStyle(color: sectionTitleColor),
                                              ),
                                            ),
                                          ),
                                          ...retestsController.retestListModel.value.data!.retestResult!
                                              .mapIndexed(
                                                (position, result) => Container(
                                                  // height: 78,
                                                  width: getScreenWidth(context),
                                                  margin: EdgeInsets.only(
                                                    top: 10.h,
                                                  ),
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration: boxDecoration14,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    result.concept?.name?.enUs?.toString() ?? "",
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: textTitle16WhiteBoldStyle.merge(
                                                                      TextStyle(
                                                                        color: result.cleared == true ? colorGreen : colorRed,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Wrap(
                                                                    direction: Axis.horizontal,
                                                                    spacing: 10,
                                                                    children: result.keyLearnings!
                                                                        .map(
                                                                          (keyLearningData) => Container(
                                                                            margin: EdgeInsets.only(top: 5.h),
                                                                            padding: const EdgeInsets.all(5),
                                                                            width: ((getScreenWidth(context) - 100) / 2).w,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(14),
                                                                              ),
                                                                              border: Border.all(color: const Color(0xfff0f0f0)),
                                                                              // color: keyLearningData.cleared == true ? colorGreenLight : colorRedLight,
                                                                              color: colorgray249,
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  height: 16.h,
                                                                                  width: 16.h,
                                                                                  margin: EdgeInsets.only(right: 5.w),
                                                                                  alignment: AlignmentDirectional.center,
                                                                                  child: keyLearningData.cleared == true
                                                                                      ? SvgPicture.asset(
                                                                                          imageAssets + 'donebutton.svg',
                                                                                          height: 10.h,
                                                                                          width: 10.h,
                                                                                          color: colorGDGreenDark,
                                                                                        )
                                                                                      : SvgPicture.asset(imageAssets + 'closebutton.svg',
                                                                                          height: 8.h, width: 8.h, color: colorGDRedDark),
                                                                                ),
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    keyLearningData.keyLearning?.name?.enUs ?? "",
                                                                                    style: textTitle12BoldStyle.merge(const TextStyle(
                                                                                        color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              height: 16.h,
                                                              width: 16.h,
                                                              margin: EdgeInsets.only(right: 5.w),
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                gradient: result.cleared == true ? greenGradient : redGradient,
                                                              ),
                                                              child: result.cleared == true
                                                                  ? SvgPicture.asset(
                                                                      imageAssets + 'donebutton.svg',
                                                                      // allowDrawingOutsideViewBox: true,
                                                                      height: 10.h,
                                                                      width: 10.h,
                                                                    )
                                                                  : SvgPicture.asset(
                                                                      imageAssets + 'closebutton.svg',
                                                                      // allowDrawingOutsideViewBox: true,
                                                                      height: 8.h,
                                                                      width: 8.h,
                                                                      // fit: BoxFit.contain,
                                                                    ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text('Clarity ${result.clarity}%',
                                                                textAlign: TextAlign.center,
                                                                style: textTitle12BoldStyle.merge(const TextStyle(
                                                                  fontSize: 12,
                                                                  color: colorWebPanelDarkText,
                                                                  fontWeight: FontWeight.w600,
                                                                ))),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            result.cleared == false
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => AutoHWReTestConceptClear(
                                                                            retestResult: (retestsController
                                                                                    .retestListModel.value.data?.retestResult?[position] ??
                                                                                RetestResult()),
                                                                            title: result.concept?.name?.enUs?.toString(),
                                                                            chapterId: widget.chapterId,
                                                                            subjectId: widget.subjectId,
                                                                            topicId: retestsController
                                                                                .retestListModel.value.data!.retestDetail![0].topics![0].topic.id,
                                                                            topicType: retestsController
                                                                                .retestListModel.value.data!.retestDetail![0].topics![0].type
                                                                                .toString(),
                                                                            topicName: retestsController
                                                                                .retestListModel.value.data!.retestDetail![0].topics![0].topic.name,
                                                                            homeworkId: widget.homeworkId,
                                                                            isSelfAutoHW: widget.isSelfAutoHW,
                                                                            isOngoing: isOnGoing(),
                                                                            type: widget.type,
                                                                            isFromRoadMapResult: widget.isFromRoadMapResult,
                                                                          ),
                                                                        ),
                                                                      ).then(
                                                                        (value) {
                                                                          onResume();
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      height: 22.h,
                                                                      decoration: const BoxDecoration(
                                                                        color: colorPurple,
                                                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                      ),
                                                                      alignment: AlignmentDirectional.topStart,
                                                                      child: Center(
                                                                          child: Padding(
                                                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                                                        child: Row(
                                                                          children: [
                                                                            Text("Clear Now", style: textTitle12BoldStyle),
                                                                            const SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            const Icon(
                                                                              Icons.arrow_forward,
                                                                              color: Colors.white,
                                                                              size: 16,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ])
                                                    ],
                                                  ),
                                                  // child: Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Column(
                                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //       children: [
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //           children: [
                                                  //             Text(
                                                  //               result.concept?.name?.enUs?.toString() ?? "",
                                                  //               style: textTitle16WhiteBoldStyle.merge(
                                                  //                 TextStyle(
                                                  //                     color: result.cleared == true ? colorGreen : colorRed,
                                                  //                     fontWeight: FontWeight.normal),
                                                  //               ),
                                                  //             ),
                                                  //           ],
                                                  //         ),
                                                  //         Wrap(
                                                  //           direction: Axis.horizontal,
                                                  //           spacing: 10,
                                                  //           children: result.keyLearnings!
                                                  //               .map(
                                                  //                 (keyLearningData) => Container(
                                                  //                   margin: EdgeInsets.only(top: 5.h),
                                                  //                   padding: const EdgeInsets.all(5),
                                                  //                   width: ((getScreenWidth(context) - 83) / 3).w,
                                                  //                   decoration: BoxDecoration(
                                                  //                     borderRadius: const BorderRadius.all(
                                                  //                       Radius.circular(14),
                                                  //                     ),
                                                  //                     color: keyLearningData.cleared == true ? colorGreenLight : colorRedLight,
                                                  //                   ),
                                                  //                   child: Row(
                                                  //                     mainAxisAlignment: MainAxisAlignment.start,
                                                  //                     children: [
                                                  //                       Container(
                                                  //                         height: 16.h,
                                                  //                         width: 16.h,
                                                  //                         margin: EdgeInsets.only(right: 5.w),
                                                  //                         alignment: AlignmentDirectional.center,
                                                  //                         decoration: BoxDecoration(
                                                  //                           borderRadius: const BorderRadius.all(
                                                  //                             Radius.circular(8),
                                                  //                           ),
                                                  //                           gradient: keyLearningData.cleared == true ? greenGradient : redGradient,
                                                  //                         ),
                                                  //                         child: keyLearningData.cleared == true
                                                  //                             ? SvgPicture.asset(
                                                  //                                 imageAssets + 'donebutton.svg',
                                                  //                                 // allowDrawingOutsideViewBox: true,
                                                  //                                 height: 10.h,
                                                  //                                 width: 10.h,
                                                  //                               )
                                                  //                             : SvgPicture.asset(
                                                  //                                 imageAssets + 'closebutton.svg',
                                                  //                                 // allowDrawingOutsideViewBox: true,
                                                  //                                 height: 8.h,
                                                  //                                 width: 8.h,
                                                  //                                 // fit: BoxFit.contain,
                                                  //                               ),
                                                  //                       ),
                                                  //                       Flexible(
                                                  //                         child: Text(
                                                  //                           keyLearningData.keyLearning?.name?.enUs ?? "",
                                                  //                           style: textTitle12BoldStyle.merge(const TextStyle(
                                                  //                               // color: keyLearningData.cleared != null
                                                  //                               //     ? keyLearningData.cleared!
                                                  //                               //         ? colorGreen
                                                  //                               //         : colorPink
                                                  //                               //     : colorBodyText,
                                                  //                               color: colorWebPanelDarkText,
                                                  //                               fontWeight: FontWeight.w600)),
                                                  //                           maxLines: 2,
                                                  //                           overflow: TextOverflow.ellipsis,
                                                  //                         ),
                                                  //                       ),
                                                  //                     ],
                                                  //                   ),
                                                  //                 ),
                                                  //               )
                                                  //               .toList(),
                                                  //         )
                                                  //       ],
                                                  //     ),
                                                  //     Column(
                                                  //       children: [Text('Clarity 25%')],
                                                  //     )
                                                  //   ],
                                                  // )
                                                ),
                                              )
                                              .toList(),
                                          OnlineAutoHwTestCard(
                                            retestData: (retestsController.retestListModel.value.data?.retestDetail ?? [])[0],
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AutoHWConceptBasedResultScreenPage(
                                                      homeworkId: widget.homeworkId,
                                                      subjectId: widget.subjectId,
                                                      chapterId: widget.chapterId,
                                                      fromRetestList: true,
                                                      isSelfAutoHW: widget.isSelfAutoHW),
                                                ),
                                              ).then(
                                                (value) => {onResume()},
                                              );
                                            },
                                          ),
                                          ...(retestsController.retestListModel.value.data?.retestDetail ?? []).reversed.toList().mapIndexed(
                                            (index, item) {
                                              var retestData = item;
                                              return index == (retestsController.retestListModel.value.data?.retestDetail ?? []).length - 1
                                                  ? const SizedBox()
                                                  : RetestListItem(
                                                      retestData: retestData,
                                                      onTap: () {
                                                        if (retestData.topicStatus == null) {
                                                          retestsController
                                                              .getRetestDetail(
                                                            context: context,
                                                            subjectId: widget.subjectId,
                                                            chapterId: widget.chapterId,
                                                            homeworkId: widget.homeworkId,
                                                            retestHomeworkId: retestData.id!,
                                                          )
                                                              .then((value) {
                                                            retestsController
                                                                .getReTest(
                                                              context: context,
                                                              subjectId: widget.subjectId,
                                                              chapterId: widget.chapterId,
                                                              homeworkId: widget.homeworkId,
                                                              retestDetail: retestData,
                                                              lang: retestsController.retestListModel.value.data?.lang ?? "",
                                                              map: {},
                                                              isFirst: true,
                                                            )
                                                                .then(
                                                              (value) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => RetestConceptBasedExamPage(
                                                                      //This is Concept Based Exam
                                                                      subjectId: widget.subjectId,
                                                                      chapterId: widget.chapterId,
                                                                      homeworkId: widget.homeworkId,
                                                                      retestHomeworkId: retestData.id!,
                                                                      isSelfAutoHW: widget.isSelfAutoHW,
                                                                    ),
                                                                  ),
                                                                ).then(
                                                                  (value) => {
                                                                    onResume(),
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          });
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => RetestConceptBasedResultScreenPage(
                                                                homeworkId: widget.homeworkId,
                                                                subjectId: widget.subjectId,
                                                                chapterId: widget.chapterId,
                                                                retestHomeworkId: retestData.id!,
                                                                isSelfAutoHW: widget.isSelfAutoHW,
                                                              ),
                                                            ),
                                                          ).then(
                                                            (value) => {onResume()},
                                                          );
                                                        }
                                                      },
                                                    );
                                            },
                                          ).toList(),
                                          SizedBox(height: 80.h),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                  ],
                ),
                !retestsController.retestExamLoading.isTrue
                    ? retestsController.retestListModel.value.data != null
                        ? retestsController.retestListModel.value.data!.retestResult!.where((element) => element.cleared == false).toList().isNotEmpty
                            ? Positioned(
                                bottom: 10,
                                left: 0,
                                width: getScreenWidth(context),
                                child: SafeArea(
                                  top: false,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => {
                                      if (!isOnGoing()) {showRetestSelectionDialog()}
                                    },
                                    child: Container(
                                      height: 36.h,
                                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: colorDropShadowLight,
                                            blurRadius: 1,
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                        gradient: isOnGoing() ? grayGradient : pinkGradient,
                                      ),
                                      alignment: AlignmentDirectional.topStart,
                                      child: Center(
                                        child: Text(
                                          "Retest",
                                          style: textTitle18WhiteBoldStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showRetestSelectionDialog() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          backgroundColor: Colors.grey.shade200,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: showClearRetestDialogScreen(
            retestResult: (retestsController.retestListModel.value.data?.retestDetail?[0].retestResultList ?? []),
            chapterId: widget.chapterId,
            homeworkId: widget.homeworkId,
            isSelfAutoHW: widget.isSelfAutoHW,
            subjectId: widget.subjectId,
            topicOrConcept: "concept",
            type: widget.type,
            isFromRoadMapResult: widget.isFromRoadMapResult,
            callResume: onResume,
          ),
        );
      },
    );
  }

  showCompleteAllKeylearningDialog() {
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 16,
            backgroundColor: Colors.grey.shade200,
            insetPadding: const EdgeInsets.all(10),
            child: const ShowCompleteAllKeylearningDialogScreen(),
          );
        },
      );
    });
  }

  bool isOnGoing() {
    var retestData = (retestsController.retestListModel.value.data?.retestDetail ?? []);
    return ((retestData[retestData.length - 1].started?.status ?? false) && !(retestData[retestData.length - 1].completed?.status ?? false) ||
        !(retestData[retestData.length - 1].started?.status ?? false) && !(retestData[retestData.length - 1].completed?.status ?? false));
  }
}

class RetestListItem extends StatelessWidget {
  final RetestDetail retestData;
  final VoidCallback onTap;
  const RetestListItem({
    Key? key,
    required this.retestData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        width: getScreenWidth(context),
        decoration: boxDecoration14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      retestData.name ?? "",
                      style: textTitle18WhiteBoldStyle.merge(
                        const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: colorWebPanelDarkText,
                        ),
                      ),
                    ),
                    ((retestData.started?.status ?? false) && (retestData.completed?.status ?? false))
                        ? Text(
                            retestData.clearedTopicConceptCount.toString() + " / " + retestData.totalTopicConceptCount.toString() + " Cleared",
                            style: sectionTitleTextStyle.merge(
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                            ),
                          )
                        : const SizedBox(),
                    (retestData.started?.status ?? false) == true && !(retestData.completed?.status ?? false)
                        ? Text(
                            "Ongoing",
                            style: sectionTitleTextStyle.merge(
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                (retestData.started?.status ?? false) && !(retestData.completed?.status ?? false)
                    ? Column(
                        children: [
                          Container(
                            height: 48.h,
                            width: 48.h,
                            padding: EdgeInsets.all(13.h),
                            decoration: BoxDecoration(
                              gradient: purpleGradient,
                              borderRadius: BorderRadius.all(
                                Radius.circular(24.h),
                              ),
                            ),
                            child: SvgPicture.asset(
                              imageAssets + 'tests/continueprecap.svg',
                              height: 23,
                              width: 23,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Resume",
                              style: textTitle10BoldStyle.merge(
                                const TextStyle(color: sectionTitleColor),
                              ),
                            ),
                          ),
                        ],
                      )
                    : !(retestData.started?.status ?? false) && !(retestData.completed?.status ?? false)
                        ? Column(
                            children: [
                              Container(
                                height: 48.h,
                                width: 48.h,
                                padding: EdgeInsets.all(13.h),
                                decoration: BoxDecoration(
                                  gradient: purpleGradient,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24.h),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  imageAssets + 'tests/start_rocket.svg',
                                  height: 23,
                                  width: 23,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Start",
                                  style: textTitle10BoldStyle.merge(
                                    const TextStyle(color: sectionTitleColor),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : retestData.topicStatus?.toLowerCase() == "uncleared"
                            ? Container(
                                height: 48.h,
                                width: 48.h,
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                  gradient: redGradient,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24.h),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                  iconSize: 24.h,
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              )
                            : retestData.topicStatus?.toLowerCase() == "cleared"
                                ? Container(
                                    height: 48.h,
                                    width: 48.h,
                                    alignment: AlignmentDirectional.center,
                                    decoration: BoxDecoration(
                                      gradient: greenGradient,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24.h),
                                      ),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.done,
                                      ),
                                      iconSize: 24.h,
                                      color: Colors.white,
                                      onPressed: () {},
                                    ),
                                  )
                                : SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: LiquidCircularProgressIndicator(
                                      value: (((retestData.clearedTopicConceptCount ?? 0) * 100) / (retestData.concepts?.length ?? 1)) /
                                          100, // Defaults to 0.5.
                                      valueColor: const AlwaysStoppedAnimation(colorSky), // Defaults to the current Theme's accentColor.
                                      backgroundColor: colorgray249, // Defaults to the current Theme's backgroundColor.

                                      // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                    ),
                                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnlineAutoHwTestCard extends StatelessWidget {
  final RetestDetail retestData;
  final VoidCallback onTap;
  const OnlineAutoHwTestCard({Key? key, required this.retestData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        width: getScreenWidth(context),
        decoration: boxDecoration14,
        child: Row(
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
                                //retestData.name ?? "",
                                retestData.topics?[0].topic.name.toString() ?? "",
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
                      retestData.type == "system-generated" || retestData.type == "online-test"
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
                                getTypeDesc((retestData.type ?? "").toLowerCase()) == 'Auto HW' ? 'Auto HW' : 'Online Test',
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
                              desc: retestData.assigned?.date != null ? DateFormat("d MMM").format(retestData.assigned!.date!) : "-",
                              titleStyle: textTitle8BoldStyle.merge(
                                const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                              ),
                              descStyle: textTitle12BoldStyle.merge(
                                const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          retestData.completed?.date != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: 5.w,
                                    right: 5.w,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: TitleDescription(
                                    title: "Attend",
                                    desc: retestData.completed?.date != null ? DateFormat("d MMM").format(retestData.completed!.date!) : "-",
                                    titleStyle: textTitle8BoldStyle.merge(
                                      const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                    ),
                                    descStyle: textTitle12BoldStyle.merge(
                                      const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
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
                    gradient: retestData.completed?.status ?? false
                        ? pinkGradient
                        : retestData.started?.status == true
                            ? pinkGradient
                            : purpleGradient,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.h),
                    ),
                  ),
                  child: SvgPicture.asset(
                    imageAssets +
                        ((retestData.completed?.status ?? false)
                            ? 'tests/result.svg'
                            : retestData.started?.status == true
                                ? 'tests/continueprecap.svg'
                                : 'tests/start_rocket.svg'),
                    height: 23,
                    width: 23,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    (retestData.completed?.status ?? false)
                        ? "Result"
                        : retestData.started?.status == true
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
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class showClearRetestDialogScreen extends StatefulWidget {
  const showClearRetestDialogScreen(
      {Key? key,
      required this.retestResult,
      required this.homeworkId,
      required this.subjectId,
      required this.chapterId,
      required this.isSelfAutoHW,
      required this.topicOrConcept,
      required this.type,
      required this.isFromRoadMapResult,
      required this.callResume})
      : super(key: key);
  final List<RetestResult>? retestResult;
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final bool isSelfAutoHW;
  final String topicOrConcept;
  final ByHomeworkTypes type;
  final bool isFromRoadMapResult;
  final Function callResume;

  @override
  State<showClearRetestDialogScreen> createState() => _showClearRetestDialogScreenState();
}

// ignore: camel_case_types
class _showClearRetestDialogScreenState extends State<showClearRetestDialogScreen> {
  List<RetestResult>? retestResultList = [];
  List<String>? isAllConceptCheckedList = [];

  @override
  void initState() {
    super.initState();

    (widget.retestResult ?? []).map((retestData) {
      if (retestData.cleared == false) {
        RetestResult retestResult = RetestResult();
        retestResult.id = retestData.id;
        retestResult.cleared = retestData.cleared;
        retestResult.concept = retestData.concept;
        retestResult.clarity = retestData.clarity;
        retestResult.clearedAt = retestData.clearedAt;
        List<KeyLearning> keyLearningList = [];
        (retestData.keyLearnings ?? []).map((keyLearningData) {
          if (keyLearningData.cleared == false) {
            KeyLearning keyLearning = KeyLearning();
            keyLearning.id = keyLearningData.id;
            keyLearning.cleared = keyLearningData.cleared;
            keyLearning.clearedAt = keyLearningData.clearedAt;
            keyLearning.keyLearning = keyLearningData.keyLearning;
            keyLearningList.add(keyLearning);
          }
        }).toList();
        retestResult.keyLearnings = keyLearningList;
        retestResultList?.add(retestResult);
        isAllConceptCheckedList?.add("-1");
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Column(
          children: [
            Container(
              width: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Color(0xffF9F6F8),
                  ),
                  height: 40.h,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Concept & Keylearning',
                    style: textTitle18WhiteBoldStyle.merge(
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sectionTitleColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: (retestResultList?.length ?? 0),
                      itemBuilder: ((context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: colorGDTealLight.withOpacity(0.1),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (isAllConceptCheckedList?[index] == "-1") {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = true;
                                                retestResultList?[index].cleared = true;
                                                isAllConceptCheckedList?[index] = "1";
                                              });
                                            }).toList();
                                          } else if (isAllConceptCheckedList?[index] == "0") {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = true;
                                                retestResultList?[index].cleared = true;
                                                isAllConceptCheckedList?[index] = "1";
                                              });
                                            }).toList();
                                          } else {
                                            (retestResultList?[index].keyLearnings ?? []).mapIndexed((position, item) {
                                              setState(() {
                                                item.cleared = false;
                                                retestResultList?[index].cleared = false;
                                                isAllConceptCheckedList?[index] = "-1";
                                              });
                                            }).toList();
                                          }
                                        },
                                        child: Icon(
                                            isAllConceptCheckedList?[index] == "1"
                                                ? Icons.check_box
                                                : isAllConceptCheckedList?[index] == "0"
                                                    ? Icons.indeterminate_check_box
                                                    : Icons.crop_square,
                                            color: colorGDTealLight),
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          (retestResultList?[index].concept?.name?.enUs.toString() ?? ""),
                                          style: textTitle18WhiteBoldStyle.merge(
                                            const TextStyle(fontWeight: FontWeight.bold, color: colorGDTealLight),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 26.w),
                                  child: Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: (retestResultList?[index].keyLearnings ?? []).mapIndexed((i, item) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Row(
                                            children: [
                                              Theme(
                                                data: ThemeData(unselectedWidgetColor: colorPurple),
                                                child: Checkbox(
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    value: item.cleared,
                                                    activeColor: colorPurple,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        item.cleared = val!;
                                                      });

                                                      Iterable<KeyLearning> list =
                                                          (retestResultList?[index].keyLearnings ?? []).where((element) => element.cleared! == false);

                                                      if (list.isEmpty) {
                                                        setState(() {
                                                          retestResultList?[index].cleared = true;
                                                          isAllConceptCheckedList![index] = "1";
                                                        });
                                                      } else if (list.length == retestResultList?[index].keyLearnings?.length) {
                                                        setState(() {
                                                          retestResultList?[index].cleared = false;
                                                          isAllConceptCheckedList?[index] = "-1";
                                                        });
                                                      } else {
                                                        setState(() {
                                                          retestResultList?[index].cleared = true;
                                                          isAllConceptCheckedList?[index] = "0";
                                                        });
                                                      }
                                                    }),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  (retestResultList?[index].keyLearnings?[i].keyLearning?.name?.enUs.toString() ?? ""),
                                                  style: textTitle14StyleMediumPoppins,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                )
                              ],
                            ),
                          ],
                        );
                      })),
                )
              ]),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 35.h,
                        width: 100.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: colorBlue400.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          const Icon(
                            Icons.cancel,
                            color: colorBlueDark,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text('Cancel', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold, color: colorBlueDark)))
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((isAllConceptCheckedList ?? []).where((element) => element == "1" || element == "0").toList().isNotEmpty) {
                          //Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RetestConceptTopicList(
                                    homeworkId: widget.homeworkId,
                                    subjectId: widget.subjectId,
                                    chapterId: widget.chapterId,
                                    topicOrConcept: widget.topicOrConcept,
                                    isSelfAutoHW: widget.isSelfAutoHW,
                                    retestResultList: retestResultList,
                                    isFromRoadMapResult: widget.isFromRoadMapResult,
                                    type: widget.type,
                                    isFromRetestResult: true)),
                          ).then((value) => {
                                widget.callResume(),
                              });
                        } else {
                          Fluttertoast.showToast(msg: "Select at-least one key-learning.");
                        }
                      },
                      child: Container(
                        height: 35.h,
                        width: 115.w,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: colorBlueDark,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          Text('Give Retest', style: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 10.w,
                          ),
                          SvgPicture.asset(
                            imageAssets + 'tests/start_rocket.svg',
                            height: 20,
                            width: 20,
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShowCompleteAllKeylearningDialogScreen extends StatefulWidget {
  const ShowCompleteAllKeylearningDialogScreen({Key? key}) : super(key: key);

  @override
  State<ShowCompleteAllKeylearningDialogScreen> createState() => _ShowCompleteAllKeylearningDialogScreenState();
}

class _ShowCompleteAllKeylearningDialogScreenState extends State<ShowCompleteAllKeylearningDialogScreen> with TickerProviderStateMixin {
  int seconds = 0;
  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.slowMiddle);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.elasticIn);

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds < 3) {
          setState(() {
            seconds = seconds + 1;
          });
        }
      },
    );

    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });

    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  late final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    double circleSize = 140;
    double iconSize = 108;
    return Container(
      height: 300,
      width: 300,
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  height: circleSize,
                  width: circleSize,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(53, 194, 135, 1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: checkAnimation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Center(
                child: Icon(Icons.check, color: Colors.white, size: iconSize),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        seconds == 3
            ? FadeInDown(
                animate: true,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Congratulations...!!',
                  style: textTitle26WhiteBoldStyle.merge(
                    TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: 5,
        ),
        seconds == 3
            ? FadeIn(
                animate: true,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'You cleared all concepts with Saarthi',
                  style: textTitle14RegularStyle.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: colorWebPanelDarkText,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
