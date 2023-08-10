// ignore_for_file: unused_field
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/content_report/question_content_report.modal.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_exam_model/mcq_option.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_exam_model/precap_exam_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_exam_model/precapexamdata.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/key_learning_list.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/precapdata.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/result_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:timelines/timelines.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helpers/exam_webview_base_string.dart';
import '../theme/colors.dart';
import '../theme/style.dart';
import '../widgets/common/custom_webview.dart';
import '../widgets/exam/hint_solutions_widget.dart';
import 'content_report/content_report_screen.dart';
import 'homework/online_test_exam.dart';

const kTileHeight = 50.0;
const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class ExamPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chaptersData;
  final bool isFromTests;

  const ExamPage({Key? key, required this.subjectData, required this.chaptersData, this.isFromTests = false}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _ExamPageState extends State<ExamPage> with SingleTickerProviderStateMixin {
  int _conceptIndex = 1;
  int _keyLearningIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final testsController = Get.put(PrecapController());
  List<String> alphabet = "abcdefghijklmnopqrstuvwxyz".split("");

  // PreCapExamData? preCapExamData;

  McqOption? currentSelectedOption;
  bool? currentSelectedBool;

  PrecapData? precapData;
  PreCapExamData? preCapExamData;

  List<double> mcqOptionHeight = [];

  List<WebViewController>? optionWebViewController;
  WebViewController? questionWebViewController;
  Uint8List? screenshotBytes;

  BoolOptions? _boolOptionValue = BoolOptions.isNone;

  bool readyToGo = true;

  bool needToLoadQuestion = false;

  String topicConceptName = '';

  /// index mechanism of Exam
  /// For MCQ assign actual index of option
  /// For true false index = 0 -> true, index = 1 -> false
  List<int?>? correntAnsIndexes; // to store index of currect answer of Question after User submit answer.
  int? wrongAnsIndex; // to store index of wrong answer of Question after User submit answer.
  bool isAnsSubmitted = false; // for check user submit answer or not
  bool hasChooseAnyOption = false; // for check user select any option or not
  int? userSelectedIndex; // to store index of answer which is submited by user

  bool hasNoQuestionFound = false; // for check has Question

  @override
  void initState() {
    super.initState();
    apiPostProcessing();
    // startTimer();
    testsController.totalKeyLearningsPercentage = 100 / testsController.totalKeyLearnings;
  }

  apiPostProcessing() {
    setState(
      () {
        currentSelectedOption = null;
        // preCapExamData = null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;
      var conceptId = testsController.precapExamModel.value.preCapExamData?.concept;
      var keylearningId = testsController.precapExamModel.value.preCapExamData?.keyLearning;

      if (conceptId != null) {
        int conceptIndex = (testsController.preCapModel.value.precapData?.preConcepts ?? []).indexWhere(
          (e) => e.concept?.id == conceptId,
        );

        int keyLearningIndex = (testsController.preCapModel.value.precapData?.preConcepts?[conceptIndex].keyLearnings ?? []).indexWhere(
          (e) => e.keyLearning?.id == keylearningId,
        );

        Future.delayed(const Duration(seconds: 2), () {
          testsController.isKeylearningScreen = false;
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              MediaQuery.of(context).size.width * conceptIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        if (!testsController.isKeylearningScreen) {
          if (_keyLearningIndex != keyLearningIndex) {
            testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
          } else {
            if (_conceptIndex != conceptIndex) {
              testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
            }
          }
        }
        setState(() {
          _conceptIndex = conceptIndex;
          _keyLearningIndex = keyLearningIndex;
          precapData = testsController.preCapModel.value.precapData;
          preCapExamData = testsController.precapExamModel.value.preCapExamData;
          mcqOptionHeight = List<double>.generate(preCapExamData?.mcqOptions?.length ?? 0, (int index) => 1);
          topicConceptName = (testsController.preCapModel.value.precapData?.preConcepts ?? [])[conceptIndex].concept?.name?.enUs ?? '';
        });
      } else {
        setState(() {
          mcqOptionHeight = [];
          _conceptIndex = 0;
          _keyLearningIndex = 0;
          precapData = null;
          preCapExamData = null;
          hasNoQuestionFound = true;
        });
      }
      readyToGo = true;
    });
  }

  Color getColor(int index) {
    if (index == _conceptIndex) {
      return inProgressColor;
    } else if (index < _conceptIndex) {
      return completeColor;
    } else {
      return const Color.fromRGBO(224, 224, 224, 1);
    }
  }

  Color getColorTitle(int index) {
    if (index == _conceptIndex) {
      return inProgressColor;
    } else if (index < _conceptIndex) {
      return sectionTitleColor;
    } else {
      return Colors.black;
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    Navigator.pop(context);

    return true;
  }

  void resetData() {
    correntAnsIndexes = null;
    wrongAnsIndex = null;
    hasChooseAnyOption = false;
    userSelectedIndex = null;
    if (testsController.precapTestNoQueFound.isFalse) {
      isAnsSubmitted = false;
    }
    setState(() {});
  }

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (testsController.precapTestExamCompleted.isTrue) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreenPage(
              subjectData: widget.subjectData,
              chaptersData: widget.chaptersData,
              isFromTests: widget.isFromTests,
            ),
          ),
        );
      }
      testsController.precapExamModel.value = testsController.precapExamModelTemp.value;
      testsController.precapExamModelTemp.value = PrecapExamModel();
      needToLoadQuestion = true;

      if (testsController.precapTestNoQueFound.isFalse) {
        resetData(); // Reset all flags and variable for manage states
        apiPostProcessing(); // Process on Question data
      } else {
        setState(() {
          hasNoQuestionFound = true;
        });
      }
    }
  }

  void onSubmitButtonTap() {
    if (hasChooseAnyOption == false) {
      Fluttertoast.showToast(msg: 'Please select option !');
    } else {
      setState(() {
        isAnsSubmitted = true;
      });
      testsController
          .getPrecapData(
        subjectData: testsController.subjectData,
        chaptersData: testsController.chaptersData,
      )
          .then(
        (value) {
          debugPrint('$value ${testsController.preCapModel.value.precapData?.examCompleted?.status}');

          if (!(testsController.preCapModel.value.precapData?.examCompleted?.status ?? false)) {
            testsController.getPrecapExamData(context: context, precapData: testsController.preCapModel.value.precapData ?? PrecapData(), map: {
              "answer": {
                "concept": preCapExamData?.concept,
                "keyLearning": preCapExamData?.keyLearning,
                "question": preCapExamData?.id,
                "answer": (preCapExamData?.mcqOptions ?? []).isEmpty ? "" : currentSelectedOption?.id,
                "orId": preCapExamData?.orId,
                "correct": (preCapExamData?.mcqOptions ?? []).isEmpty
                    ? (_boolOptionValue == BoolOptions.isTrue) == preCapExamData?.trueFalseAns
                    : currentSelectedOption?.correct,
                "startedAt": preCapExamData?.startedAt,
                "keyLearnings": preCapExamData?.keyLearnings,
                "concepts": preCapExamData?.concepts,
                "topics": []
              }
            }).then((value) {
              // testsController.precapExamModel.value.preCapExamData !=
              //         null // this code is to refresh the keylearning in timeline immediately after all question of perticular keylearning is given
              //     ?
              testsController
                  .getPrecapData(
                subjectData: testsController.subjectData,
                chaptersData: testsController.chaptersData,
              )
                  .then((value) {
                // Future.delayed(const Duration(seconds: 10), () {
                if (!(testsController.preCapModel.value.precapData?.examCompleted?.status ?? false)) {
                  apiPostProcessing();
                }
              });

              setState(() {
                needToLoadQuestion = false;
              });
              if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  onNextButtonTap();
                });
              }
            });
          } else {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreenPage(
                  subjectData: widget.subjectData,
                  chaptersData: widget.chaptersData,
                  isFromTests: widget.isFromTests,
                ),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          // (systemGeneratedTestController.systemGeneratedTestNoQueFound.isTrue) && hasNoQuestionFound
          //     ? const SizedBox()
          !hasNoQuestionFound
              ? SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 18.h,
                    ),
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: Container(
                        //     height: 46.h,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(7.h),
                        //       ),
                        //       boxShadow: const [
                        //         BoxShadow(
                        //           color: Color(0x108E8E1A),
                        //           offset: Offset(
                        //             0.2,
                        //             0.5,
                        //           ),
                        //           blurRadius: 1.0,
                        //           spreadRadius: .0,
                        //         ),
                        //       ],
                        //     ),
                        //     child: Text('Skip'),
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            height: 46.h,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: !(testsController.precapTestLoading.isTrue && needToLoadQuestion == true)
                              ? !isAnsSubmitted
                                  ? InkWell(
                                      onTap: onSubmitButtonTap,
                                      child: Container(
                                        height: 46.h,
                                        decoration: BoxDecoration(
                                          color: hasChooseAnyOption ? null : colorGrey400,
                                          gradient: hasChooseAnyOption ? greenGradient : null,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7.h),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Submit',
                                          style: textTitle18WhiteBoldStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: hasChooseAnyOption ? Colors.white : colorDarkText,
                                          ),
                                        ),
                                      ),
                                    )
                                  : (!(correntAnsIndexes ?? []).contains(userSelectedIndex))
                                      ? InkWell(
                                          onTap: onNextButtonTap,
                                          child: Container(
                                            height: 46.h,
                                            decoration: BoxDecoration(
                                              color: hasChooseAnyOption ? null : colorGrey400,
                                              gradient: hasChooseAnyOption ? greenGradient : null,
                                              borderRadius: BorderRadius.circular(7.h),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Next',
                                              style: textTitle18WhiteBoldStyle.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                              : const SizedBox(),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Obx(
            () => (preCapExamData == null || (testsController.precapTestNoQueFound.isTrue && isAnsSubmitted == true)) && hasNoQuestionFound
                ? const NoDataCard(
                    title: "Oops...\n No question found",
                    description: "No question found for selected precap\nkindly contact your teacher.",
                    headerEnabled: true,
                    backgroundColor: Colors.white,
                  )
                : Stack(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // !(preCapExamData == null && !(precapData?.examCompleted?.status ?? false))
                          //     ? SizedBox(
                          //         width: double.infinity,
                          //         height: double.infinity,
                          //         child: SvgPicture.asset(
                          //           imageAssets + 'exam_new.svg',
                          //           allowDrawingOutsideViewBox: true,
                          //           fit: BoxFit.fill,
                          //         ),
                          //       )
                          //     : Container(),
                          Positioned(
                            left: -60,
                            top: 50,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                height: 250.w,
                                width: 250.w,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[Color.fromRGBO(97, 0, 224, 0.2), Color.fromRGBO(97, 0, 224, 0)],
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
                            right: -120,
                            bottom: -60,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                height: 209.w,
                                width: 209.w,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color.fromARGB(24, 244, 106, 170),
                                      Color.fromARGB(7, 255, 109, 182),
                                    ],
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
                              preCapExamData != null
                                  ? Container(
                                      height: 205.h,
                                      // padding: EdgeInsets.only(top: 10),
                                      decoration: const BoxDecoration(
                                        color: sectionTitleColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(14),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorDropShadowLight,
                                            offset: Offset(
                                              1.0,
                                              1.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          HeaderCard(
                                            title: widget.chaptersData.name ?? "",
                                            backEnabled: true,
                                            onTap: _onBackPressed,
                                            textColor: sectionTitleLightColor,
                                            isExamScreenHeader: true,
                                          ),
                                          SizedBox(
                                            height: 155.h,
                                            child: Timeline.tileBuilder(
                                              controller: _scrollController,
                                              theme: TimelineThemeData(
                                                direction: Axis.horizontal,
                                                connectorTheme: const ConnectorThemeData(
                                                  // space: 30.0, // space beetween text and indicator
                                                  thickness: 5.0,
                                                ),
                                              ),
                                              builder: TimelineTileBuilder.connected(
                                                  connectionDirection: ConnectionDirection.before,
                                                  itemExtent: MediaQuery.of(context).size.width,
                                                  nodePositionBuilder: (context, index) => 0,
                                                  //Values are beetween 0 to 1
                                                  contentsBuilder: (context, index) {
                                                    var keylearning = precapData?.preConcepts?[index].keyLearnings;

                                                    // _processes[index]["keylearning"] as List<Map<String, String>>;
                                                    return SizedBox(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              precapData?.preConcepts?[index].concept?.name?.enUs ?? "",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: textTitle16WhiteBoldStyle.merge(
                                                                TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 80.h,
                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Wrap(
                                                                    direction: Axis.horizontal,
                                                                    alignment: WrapAlignment.center,
                                                                    children: (keylearning ?? [])
                                                                        .map((valKeyLearning) => KeyLearningTimelineItem(
                                                                              keylearning: keylearning ?? [],
                                                                              valKeyLearning: valKeyLearning,
                                                                              conceptIndex: _conceptIndex,
                                                                              index: index,
                                                                              keyLearningIndex: _keyLearningIndex,
                                                                            ))
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  indicatorBuilder: (_, index) {
                                                    if (index < _conceptIndex) {
                                                      // completed process
                                                      return Container(
                                                        margin: EdgeInsets.only(top: 6.h),
                                                        height: 40,
                                                        width: 40,
                                                        alignment: AlignmentDirectional.center,
                                                        decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            alignment: AlignmentDirectional.center,
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(
                                                                  Radius.circular(15),
                                                                ),
                                                                gradient:
                                                                    precapData?.preConcepts?[index].cleared ?? false ? greenGradient : redGradient),
                                                            child: precapData?.preConcepts?[index].cleared ?? false
                                                                ? SvgPicture.asset(
                                                                    imageAssets + 'donebutton.svg',
                                                                    // allowDrawingOutsideViewBox: true,
                                                                    height: 14,
                                                                    width: 14,
                                                                    fit: BoxFit.contain,
                                                                  )
                                                                : SvgPicture.asset(
                                                                    imageAssets + 'closebutton.svg',
                                                                    height: 14,
                                                                    width: 14,
                                                                    fit: BoxFit.contain,
                                                                  )),
                                                      );
                                                    } else if (index == _conceptIndex) {
                                                      // Current process
                                                      return Container(
                                                        margin: EdgeInsets.only(top: 6.h),
                                                        height: 40,
                                                        width: 40,
                                                        alignment: AlignmentDirectional.center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                          border: Border.all(color: colorPink, width: 1),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color.fromRGBO(250, 209, 229, 1),
                                                              blurRadius: 10,
                                                              spreadRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(15),
                                                            ),
                                                            gradient: pinkGradient,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color.fromRGBO(250, 209, 229, 1),
                                                                blurRadius: 10,
                                                                spreadRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Align(
                                                            child: SvgPicture.asset(
                                                              imageAssets + 'active_brain.svg',
                                                              height: 15,
                                                              width: 15,
                                                              // fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        margin: EdgeInsets.only(top: 6.h),
                                                        height: 40,
                                                        width: 40,
                                                        alignment: AlignmentDirectional.center,
                                                        decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(15),
                                                              ),
                                                              gradient: grayGradient),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  connectorBuilder: (_, index, type) {
                                                    if (index > 0) {
                                                      if (index == _conceptIndex) {
                                                        return Container(
                                                          margin: EdgeInsets.only(top: 6.h),
                                                          child: const DecoratedLineConnector(
                                                            decoration: BoxDecoration(
                                                              gradient: purpleGradient,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          margin: EdgeInsets.only(top: 6.h),
                                                          child: SolidLineConnector(
                                                            color: getColor(index),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  itemCount: precapData?.preConcepts?.length ?? 0,
                                                  addAutomaticKeepAlives: true),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              preCapExamData != null
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: getScrenHeight(context) - 310.h,
                                              child: CustomWebView(
                                                readMore: false,
                                                bodyBgColor: "rgba(255, 255, 128, 0);",
                                                htmlString: getExamWebViewBaseString(
                                                  correntAnsIndexes: correntAnsIndexes,
                                                  wrongAnsIndex: wrongAnsIndex,
                                                  isAnsSubmitted: isAnsSubmitted,
                                                  userSelectedIndex: userSelectedIndex,
                                                  questionString: preCapExamData?.question?.enUs ?? "",
                                                  isMcqBasedQuestion: (preCapExamData?.mcqOptions ?? []).isNotEmpty,
                                                  mcqOptions: (preCapExamData?.mcqOptions ?? []).isNotEmpty
                                                      ? (preCapExamData?.mcqOptions ?? []).map((e) => e.option?.enUs ?? "").toList()
                                                      : [],
                                                  questionId: preCapExamData?.id ?? "",
                                                  isShowHint: getfilteredVideoMedia(solutionMedia: (preCapExamData?.hint?.media ?? [])).isNotEmpty ||
                                                      (preCapExamData?.hint?.description?.enUs?.isNotEmpty ?? false),
                                                  isShowSolutionBtn:
                                                      getfilteredVideoMedia(solutionMedia: (preCapExamData?.solution?.media ?? [])).isNotEmpty ||
                                                          (preCapExamData?.solution?.description?.enUs?.isNotEmpty ?? false),
                                                ),
                                                headElements: getExamWebViewStyling(),
                                                scripts: getExamWebViewScripting(),
                                                javascriptChannels: {
                                                  {
                                                    "name": "ParamsHandler",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      String msg = message.message;

                                                      List<String> splitMsg = msg.split("/");
                                                      String questionId = splitMsg[2];
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ContentReportPage(
                                                            typeOfContent: ContentReportType.questions,
                                                            questionContentReportModal: QuestionContentReportModal(
                                                                subject: widget.subjectData.id,
                                                                chapter: widget.chaptersData.id,
                                                                book: preCapExamData?.book,
                                                                lang: preCapExamData?.lang,
                                                                isPublisher: preCapExamData?.isPublisher,
                                                                publisher: preCapExamData?.publisher,
                                                                content: QuestionReportContent(question: questionId)),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  {
                                                    "name": "OptionsAnswer",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      userSelectedIndex = double.parse(message.message)
                                                          .round(); // index of options or true false where selected by users

                                                      if (preCapExamData?.type == 'true-or-false') {
                                                        if (userSelectedIndex == 0) {
                                                          _boolOptionValue = BoolOptions.isTrue;
                                                        }
                                                        if (userSelectedIndex == 1) {
                                                          _boolOptionValue = BoolOptions.isFalse;
                                                        }
                                                        hasChooseAnyOption = true;

                                                        correntAnsIndexes = [preCapExamData?.trueFalseAns == true ? 0 : 1];
                                                      } else if (preCapExamData?.type == 'mcq') {
                                                        if ((preCapExamData?.mcqOptions ?? []).isNotEmpty) {
                                                          currentSelectedOption = preCapExamData?.mcqOptions?[userSelectedIndex!];
                                                        }
                                                        hasChooseAnyOption = true;

                                                        preCapExamData?.mcqOptions?.forEach((element) {
                                                          if (element.correct == true) {
                                                            correntAnsIndexes ?? [].add(preCapExamData?.mcqOptions?.indexOf(element));
                                                          }
                                                        });

                                                        correntAnsIndexes = (preCapExamData?.mcqOptions ?? []).map((e) {
                                                          if (e.correct == true) {
                                                            return (preCapExamData?.mcqOptions ?? []).indexOf(e);
                                                          }
                                                        }).toList();

                                                        correntAnsIndexes?.removeWhere((e) => e == null);
                                                      }
                                                      if (!(correntAnsIndexes ?? []).contains(userSelectedIndex)) {
                                                        wrongAnsIndex = userSelectedIndex;
                                                      } //identify wrong and index
                                                      setState(() {});
                                                    },
                                                  },
                                                  {
                                                    "name": "HintHandler",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      //open modal sheet for display hint

                                                      HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                        context: context,
                                                        hintSolutionData: preCapExamData?.hint,
                                                        isHint: true,
                                                        topicName: topicConceptName,
                                                      );
                                                    }
                                                  },
                                                  {
                                                    "name": "SolutionHandler",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      //open modal sheet for display hint webview

                                                      HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                        context: context,
                                                        hintSolutionData: preCapExamData?.solution,
                                                        isTestSolution: true,
                                                        topicName: topicConceptName,
                                                      );
                                                    }
                                                  },
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          testsController.precapTestLoading.isTrue ? const LoadingUI() : Container()
                        ],
                      ),
                      (testsController.precapTestNoQueFound.isTrue && isAnsSubmitted == true) && hasNoQuestionFound
                          ? const NoDataCard(
                              title: "Oops...\n No question found",
                              description: "No question found for selected precap\nkindly contact your teacher.",
                              headerEnabled: true,
                              backgroundColor: Colors.white,
                            )
                          : const SizedBox(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // late Timer _timer;
  // int _start = 10;
  // int _start1 = 0;

  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //           _start1++;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }
}

class KeyLearningTimelineItem extends StatelessWidget {
  final KeyLearningList valKeyLearning;
  final List<KeyLearningList> keylearning;
  final int conceptIndex;
  final int index;
  final int keyLearningIndex;

  const KeyLearningTimelineItem({
    Key? key,
    required this.keylearning,
    required this.valKeyLearning,
    required this.conceptIndex,
    required this.index,
    required this.keyLearningIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        top: 5.h,
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 5,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
          border: Border.all(
              color: conceptIndex == index
                  ? keyLearningIndex == keylearning.indexOf(valKeyLearning)
                      ? colorPink
                      : Colors.white
                  : Colors.white),
          boxShadow: conceptIndex == index
              ? keyLearningIndex == keylearning.indexOf(valKeyLearning)
                  ? const [
                      BoxShadow(
                        color: Color.fromRGBO(250, 209, 229, 1),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: colorDropShadow,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 5,
                        spreadRadius: 0,
                      ),
                    ]
              : const [
                  BoxShadow(
                    color: colorDropShadow,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
          color: valKeyLearning.cleared != null
              ? (valKeyLearning.cleared ?? false)
                  ? colorGreenLight
                  : colorRedLight
              : conceptIndex == index
                  ? keyLearningIndex == keylearning.indexOf(valKeyLearning)
                      ? Colors.white
                      : colorgray249
                  : colorgray249,
        ),
        child: Text(
          valKeyLearning.keyLearning?.name?.enUs.toString() ?? "",
          style: textTitle12BoldStyle.merge(
            TextStyle(
              color: valKeyLearning.cleared != null
                  ? (valKeyLearning.cleared ?? false)
                      ? colorGreenDark
                      : colorRed
                  : const Color.fromRGBO(163, 163, 163, 1),
            ),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
