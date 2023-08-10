import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/system_generated_test_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/data.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/mcq_option.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

import 'package:timelines/timelines.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/exam_webview_base_string.dart';
import '../../../model/content_report/question_content_report.modal.dart';
import '../../../model/system_generated_test_model/system_generated_test_model.dart';
import '../../../model/system_generated_test_model/topic.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/custom_webview.dart';
import '../../../widgets/exam/hint_solutions_widget.dart';
import '../../content_report/content_report_screen.dart';
import '../../homework/online_test_exam.dart';
import '../autohw_concept_result.dart';

const kTileHeight = 50.0;

const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class SelfAutoHWTestConceptBasedExamPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String homeworkId;

  // final HomeworkDatum homeworkData;

  const SelfAutoHWTestConceptBasedExamPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkId,
    // required this.homeworkData,
  }) : super(key: key);

  @override
  State<SelfAutoHWTestConceptBasedExamPage> createState() => _SelfAutoHWTestConceptBasedExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _SelfAutoHWTestConceptBasedExamPageState extends State<SelfAutoHWTestConceptBasedExamPage> with SingleTickerProviderStateMixin {
  int _conceptIndex = 1;
  int _keyLearningIndex = 0;

  String topicConceptName = '';

  final ScrollController _scrollController = ScrollController();
  final systemGeneratedTestsController = Get.put(SystemGeneratedTestController());
  final homeworkController = Get.put(HomeworkController());
  List<String> alphabet = "abcdefghijklmnopqrstuvwxyz".split("");
  final testsController = Get.put(PrecapController());
  McqOption? currentSelectedOption;
  bool? currentSelectedBool;

  HomeworkDetail? homeworkData;
  SystemGeneratedTestData? systemGeneratedTestData;

  BoolOptions? _boolOptionValue = BoolOptions.isNone;
  List<bool> isWebViewOptionsInitialLoaded = [];

  bool readyToGo = true;
  bool isPostProccesRunning = false;
  var isPercentageCounting = false;

  bool needToLoadQuestion = false;

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
    homeworkData = homeworkController.homeworkDetailModel.value.data;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        apiPostProcessing(),
      },
    );

    testsController.totalKeyLearningsPercentage = (100 / testsController.totalKeyLearnings);
  }

  apiPostProcessing() {
    isPostProccesRunning = true;
    if (mounted) {
      setState(
        () {
          currentSelectedOption = null;
          // systemGeneratedTestData = null;
        },
      );
    }

    // Timer(Duration(seconds: 5), () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;
      var conceptId = systemGeneratedTestsController.systemGeneratedTestModel.value.data?.concept;
      var keylearningId = systemGeneratedTestsController.systemGeneratedTestModel.value.data?.keyLearning;

      if (conceptId != null) {
        int conceptIndex = (homeworkController.homeworkDetailModel.value.data?.concepts ?? []).indexWhere((e) => e.concept.id == conceptId);

        int keyLearningIndex = (homeworkController.homeworkDetailModel.value.data?.concepts?[conceptIndex].keyLearnings ?? []).indexWhere(
          (e) => e.keyLearning.id == keylearningId,
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
        if (isPercentageCounting) {
          if (!testsController.isKeylearningScreen) {
            if (_keyLearningIndex != keyLearningIndex) {
              testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
            } else {
              if (_conceptIndex != conceptIndex) {
                testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
              }
            }
          }
        }
        setState(() {
          _conceptIndex = conceptIndex;
          _keyLearningIndex = keyLearningIndex;
          homeworkData = homeworkController.homeworkDetailModel.value.data;
          systemGeneratedTestData = systemGeneratedTestsController.systemGeneratedTestModel.value.data;

          topicConceptName = homeworkController.homeworkDetailModel.value.data?.concepts?[conceptIndex].concept.name.enUs;
        });
      } else {
        setState(() {
          _conceptIndex = 0;
          _keyLearningIndex = 0;
          homeworkData = null;
          systemGeneratedTestData = null;
        });
      }
      readyToGo = true;
    });
    setState(() {
      isPostProccesRunning = false;
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

  List<String> getTopicsIdsFromTopic({required List<Topic> topics}) {
    List<String> topicsString = [];

    for (Topic item in topics) {
      if (item.topic.runtimeType != Map) {
        topicsString.add(item.topic);
      }
    }
    return topicsString;
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, homeworkData?.id);
    return true;
  }

  void resetData() {
    correntAnsIndexes = null;
    wrongAnsIndex = null;
    hasChooseAnyOption = false;
    userSelectedIndex = null;
    if (systemGeneratedTestsController.selfAutoHWTestNoQueFound.isFalse) {
      isAnsSubmitted = false;
    }
    setState(() {});
  }

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (systemGeneratedTestsController.selfAutoHWTestExamCompleted.isTrue) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AutoHWConceptBasedResultScreenPage(
              homeworkId: widget.homeworkId,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              isSelfAutoHW: true,
            ),
          ),
        );
      }
      systemGeneratedTestsController.systemGeneratedTestModel.value =
          systemGeneratedTestsController.systemGeneratedTestModelTemp.value; // assign next question data to Question data model
      systemGeneratedTestsController.systemGeneratedTestModelTemp.value = SystemGeneratedTestModel(); // clear temp data
      needToLoadQuestion = true;

      if (systemGeneratedTestsController.selfAutoHWTestNoQueFound.isFalse) {
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

      // homeworkController
      //     .getHomeworkDetail(
      //         context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: homeworkData!.id!, isSelfAutoHW: true)
      //     .then(
      //   (value) {
      systemGeneratedTestsController
          .getSelfAutoHWTest(context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkData: homeworkData!, map: {
        "answer": {
          "concept": systemGeneratedTestData?.concept,
          "keyLearning": systemGeneratedTestData?.keyLearning,
          "topic": systemGeneratedTestData?.topic ?? "",
          "question": systemGeneratedTestData?.id,
          "answer": (systemGeneratedTestData?.mcqOptions ?? []).isEmpty ? "" : currentSelectedOption?.id,
          "orId": systemGeneratedTestData?.orId,
          "correct": (systemGeneratedTestData?.mcqOptions ?? []).isEmpty
              ? (_boolOptionValue == BoolOptions.isTrue) == systemGeneratedTestData?.trueFalseAns
              : currentSelectedOption?.correct,
          "startedAt": systemGeneratedTestData?.startedAt,
          "keyLearnings": systemGeneratedTestData?.keyLearnings,
          "concepts": systemGeneratedTestData?.concepts,
          "topics": (systemGeneratedTestData?.topics?.isNotEmpty ?? [].isNotEmpty) ? (systemGeneratedTestData?.topics?[0].toMap()) : []

          //jsonEncode(systemGeneratedTestData!.topics)
        }
      }).then((value) {
        homeworkController
            .getHomeworkDetail(
                context: context,
                subjectId: widget.subjectId,
                chapterId: widget.chapterId,
                homeworkId: (homeworkData!.id!).isNotEmpty
                    ? homeworkData!.id!
                    : widget.homeworkId.isNotEmpty
                        ? widget.homeworkId
                        : '',
                isSelfAutoHW: true)
            .then(
          (value) {
            isPercentageCounting = true;
            Future.delayed(const Duration(milliseconds: 800), () {
              apiPostProcessing();
            });
          },
        );

        if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
          Future.delayed(const Duration(milliseconds: 100), () {
            onNextButtonTap();
          });
        }
      });
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: systemGeneratedTestsController.selfAutoHWTestLoading.isFalse && !hasNoQuestionFound
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
                          child: systemGeneratedTestsController.selfAutoHWTestLoading.isFalse && isAnsSubmitted
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
                              : InkWell(
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
                          // : const SizedBox(),
                          )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        body: SafeArea(
          child: Obx(
            () => (systemGeneratedTestData == null || (systemGeneratedTestsController.selfAutoHWTestNoQueFound.isTrue && isAnsSubmitted == true)) &&
                    hasNoQuestionFound
                ? const NoDataCard(
                    title: "Oops...\n No question found",
                    description: "No question found for selected Homework\nkindly contact your teacher.",
                    headerEnabled: true,
                    backgroundColor: Colors.white,
                  )
                : Stack(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // !(systemGeneratedTestData == null && !(homeworkData?.completed?.status ?? false))
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
                          !(systemGeneratedTestData == null && !(homeworkData?.completed?.status ?? false))
                              ? Positioned(
                                  left: -60,
                                  top: 20,
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
                                )
                              : Container(),
                          !(systemGeneratedTestData == null && !(homeworkData?.completed?.status ?? false))
                              ? Positioned(
                                  right: -120,
                                  bottom: -60,
                                  child: Transform.rotate(
                                    angle: 0,
                                    child: Container(
                                      height: 209.h,
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
                                )
                              : Container(),
                          Column(
                            children: [
                              systemGeneratedTestData != null
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
                                            title: "Auto Homework",
                                            backEnabled: true,
                                            textColor: sectionTitleLightColor,
                                            isExamScreenHeader: true,
                                            onTap: () => {Navigator.pop(context, homeworkData?.id)},
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
                                                    var keylearning = homeworkData?.concepts?[index].keyLearnings;
                                                    // _processes[index]["keylearning"] as List<Map<String, String>>;
                                                    return SizedBox(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              homeworkData?.concepts?[index].concept?.name?.enUs ?? "",
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: textTitle16WhiteBoldStyle.merge(
                                                                TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
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
                                                                    homeworkData?.concepts?[index].cleared ?? false ? greenGradient : redGradient),
                                                            child: homeworkData?.concepts?[index].cleared ?? false
                                                                ? SvgPicture.asset(
                                                                    imageAssets + 'donebutton.svg',
                                                                    // allowDrawingOutsideViewBox: true,
                                                                    height: 14,
                                                                    width: 14,
                                                                    fit: BoxFit.contain,
                                                                  )
                                                                : SvgPicture.asset(
                                                                    imageAssets + 'closebutton.svg',
                                                                    // allowDrawingOutsideViewBox: true,
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
                                                  itemCount: homeworkData?.concepts?.length ?? 0,
                                                  addAutomaticKeepAlives: true),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              systemGeneratedTestData != null
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
                                                  questionString: systemGeneratedTestData?.question?.enUs ?? "",
                                                  isMcqBasedQuestion: (systemGeneratedTestData?.mcqOptions ?? []).isNotEmpty,
                                                  mcqOptions: (systemGeneratedTestData?.mcqOptions ?? []).isNotEmpty
                                                      ? (systemGeneratedTestData?.mcqOptions ?? []).map((e) => e.option?.enUs ?? "").toList()
                                                      : [],
                                                  questionId: systemGeneratedTestData?.id ?? "",
                                                  isShowHint:
                                                      getfilteredVideoMedia(solutionMedia: (systemGeneratedTestData?.hint?.media ?? [])).isNotEmpty ||
                                                          (systemGeneratedTestData?.hint?.description?.enUs?.isNotEmpty ?? false),
                                                  isShowSolutionBtn:
                                                      getfilteredVideoMedia(solutionMedia: (systemGeneratedTestData?.solution?.media ?? []))
                                                              .isNotEmpty ||
                                                          (systemGeneratedTestData?.solution?.description?.enUs?.isNotEmpty ?? false),
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
                                                                subject: widget.subjectId,
                                                                chapter: widget.chapterId,
                                                                book: systemGeneratedTestData?.book,
                                                                lang: systemGeneratedTestData?.lang,
                                                                isPublisher: systemGeneratedTestData?.isPublisher,
                                                                publisher: systemGeneratedTestData?.publisher,
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

                                                      if (systemGeneratedTestData?.type == 'true-or-false') {
                                                        if (userSelectedIndex == 0) {
                                                          _boolOptionValue = BoolOptions.isTrue;
                                                        }
                                                        if (userSelectedIndex == 1) {
                                                          _boolOptionValue = BoolOptions.isFalse;
                                                        }
                                                        hasChooseAnyOption = true;

                                                        correntAnsIndexes = [systemGeneratedTestData?.trueFalseAns == true ? 0 : 1];
                                                      } else if (systemGeneratedTestData?.type == 'mcq') {
                                                        if ((systemGeneratedTestData?.mcqOptions ?? []).isNotEmpty) {
                                                          currentSelectedOption = systemGeneratedTestData?.mcqOptions?[userSelectedIndex!];
                                                        }
                                                        hasChooseAnyOption = true;

                                                        systemGeneratedTestData?.mcqOptions?.forEach((element) {
                                                          if (element.correct == true) {
                                                            correntAnsIndexes ?? [].add(systemGeneratedTestData?.mcqOptions?.indexOf(element));
                                                          }
                                                        });

                                                        correntAnsIndexes = (systemGeneratedTestData?.mcqOptions ?? []).map((e) {
                                                          if (e.correct == true) {
                                                            return (systemGeneratedTestData?.mcqOptions ?? []).indexOf(e);
                                                          }
                                                        }).toList();

                                                        correntAnsIndexes?.removeWhere((e) => e == null);
                                                      }
                                                      if (!(correntAnsIndexes ?? []).contains(userSelectedIndex)) {
                                                        wrongAnsIndex = userSelectedIndex;
                                                      } //identify wrong and index
                                                      setState(() {});
                                                      // print("====answer index $userSelectedIndex ");
                                                      // print("====answer db index $correntAnsIndexes ");
                                                    }
                                                  },
                                                  {
                                                    "name": "HintHandler",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      //open modal sheet for display hint webview

                                                      HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                        context: context,
                                                        hintSolutionData: systemGeneratedTestData?.hint,
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
                                                        hintSolutionData: systemGeneratedTestData?.solution,
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
                                  : Container(),
                            ],
                          ),
                          (isPostProccesRunning == true || systemGeneratedTestsController.selfAutoHWTestLoading.isTrue)
                              ? const LoadingUI()
                              : Container()
                        ],
                      ),
                      (systemGeneratedTestsController.selfAutoHWTestNoQueFound.isTrue && isAnsSubmitted == true) && hasNoQuestionFound
                          ? const NoDataCard(
                              title: "Oops...\n No question found",
                              description: "No question found for selected Homework\nkindly contact your teacher.",
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
}

class KeyLearningTimelineItem extends StatelessWidget {
  final KeyLearnings valKeyLearning;
  final List<KeyLearnings> keylearning;
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
    return Padding(
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
                        offset: Offset(0.0, 2.0),
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
              ? valKeyLearning.cleared
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
                  ? valKeyLearning.cleared
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
