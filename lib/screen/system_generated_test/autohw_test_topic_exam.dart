import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/system_generated_test_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/data.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/mcq_option.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_webview.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/exam_webview_base_string.dart';
import '../../model/content_report/question_content_report.modal.dart';
import '../../model/system_generated_test_model/system_generated_test_model.dart';
import '../../model/system_generated_test_model/topic.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

import '../../widgets/exam/hint_solutions_widget.dart';
import '../content_report/content_report_screen.dart';
import '../homework/online_test_exam.dart';
import 'autohw_topic_result.dart';

const kTileHeight = 50.0;

const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class AutoHWTestTopicWiseExamPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String homeworkId;

  const AutoHWTestTopicWiseExamPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkId,
  }) : super(key: key);

  @override
  State<AutoHWTestTopicWiseExamPage> createState() => _AutoHWTestTopicWiseExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _AutoHWTestTopicWiseExamPageState extends State<AutoHWTestTopicWiseExamPage> with SingleTickerProviderStateMixin {
  final systemGeneratedTestsController = Get.put(SystemGeneratedTestController());
  final homeworkController = Get.put(HomeworkController());
  McqOption? currentSelectedOption;
  bool? currentSelectedBool;
  HomeworkDetail? homeworkData;
  SystemGeneratedTestData? systemGeneratedTestData;
  BoolOptions? _boolOptionValue = BoolOptions.isNone;
  List<bool> isWebViewOptionsInitialLoaded = [];
  bool readyToGo = true;
  bool isPostProccesRunning = false;

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
    homeworkData = homeworkController.homeworkDetailModel.value.data;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        apiPostProcessing(),
      },
    );
  }

  apiPostProcessing() {
    isPostProccesRunning = true;
    setState(
      () {
        currentSelectedOption = null;
        systemGeneratedTestData = null;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;

      setState(() {
        homeworkData = homeworkController.homeworkDetailModel.value.data;
        systemGeneratedTestData = systemGeneratedTestsController.systemGeneratedTestModel.value.data;

        topicConceptName = (homeworkData?.topics ?? []).isNotEmpty ? homeworkData?.topics![0].topic.name : "";
      });

      readyToGo = true;
    });
    setState(() {
      isPostProccesRunning = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;
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

  void onSubmitButtonTap() {
    if (hasChooseAnyOption == false) {
      Fluttertoast.showToast(msg: 'Please select option !');
    } else {
      setState(() {
        isAnsSubmitted = true;
      });

      homeworkController
          .getHomeworkDetail(context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkId: homeworkData!.id!)
          .then(
        (value) {
          systemGeneratedTestsController
              .getSystemGeneratedTest(context: context, subjectId: widget.subjectId, chapterId: widget.chapterId, homeworkData: homeworkData!, map: {
            "answer": {
              "concept": systemGeneratedTestData!.concept,
              "keyLearning": systemGeneratedTestData!.keyLearning,
              "topic": systemGeneratedTestData!.topic ?? "",
              "question": systemGeneratedTestData!.id,
              "answer": systemGeneratedTestData!.mcqOptions!.isEmpty ? "" : currentSelectedOption?.id,
              "orId": systemGeneratedTestData!.orId,
              "correct": systemGeneratedTestData!.mcqOptions!.isEmpty
                  ? (_boolOptionValue == BoolOptions.isTrue) == systemGeneratedTestData!.trueFalseAns
                  : currentSelectedOption?.correct,
              "startedAt": systemGeneratedTestData!.startedAt,
              "keyLearnings": systemGeneratedTestData!.keyLearnings,
              "concepts": systemGeneratedTestData!.concepts,
              "topics": (systemGeneratedTestData!.topics?.isNotEmpty ?? [].isNotEmpty) ? (systemGeneratedTestData!.topics?[0].toMap()) : []

              //jsonEncode(systemGeneratedTestData!.topics)
            }
          }).then((value) {
            setState(() {
              needToLoadQuestion = false;
            });

            if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
              Future.delayed(const Duration(milliseconds: 100), () {
                onNextButtonTap();
              });
            }
          });
        },
      );
    }
  }

  void resetData() {
    correntAnsIndexes = null;
    wrongAnsIndex = null;
    hasChooseAnyOption = false;
    userSelectedIndex = null;
    if (systemGeneratedTestsController.systemGeneratedTestNoQueFound.isFalse) {
      isAnsSubmitted = false;
    }
    setState(() {});
  }

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (systemGeneratedTestsController.systemGeneratedTestExamCompleted.isTrue) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AutoHWTopicBasedResultScreenPage(
              homeworkId: widget.homeworkId,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
            ),
          ),
        );
      }
      systemGeneratedTestsController.systemGeneratedTestModel.value =
          systemGeneratedTestsController.systemGeneratedTestModelTemp.value; // assign next question data to Question data model
      systemGeneratedTestsController.systemGeneratedTestModelTemp.value = SystemGeneratedTestModel(); // clear temp data
      needToLoadQuestion = true;

      if (systemGeneratedTestsController.systemGeneratedTestNoQueFound.isFalse) {
        resetData(); // Reset all flags and variable for manage states
        apiPostProcessing(); // Process on Question data
      } else {
        setState(() {
          hasNoQuestionFound = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                              child:
                                  // ((isPostProccesRunning == false || systemGeneratedTestController.systemGeneratedTestLoading.isFalse) &&
                                  //         needToLoadQuestion == false)
                                  //     ?
                                  isAnsSubmitted
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
            () => (systemGeneratedTestData == null ||
                        (systemGeneratedTestsController.systemGeneratedTestNoQueFound.isTrue && isAnsSubmitted == true)) &&
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
                                  right: -150,
                                  bottom: 0,
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
                                            Color.fromRGBO(247, 110, 178, 0.2),
                                            Color.fromRGBO(247, 110, 178, 0),
                                          ],
                                          // stops: [1.0, 0.0],
                                          // tileMode: TileMode.mirror,
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
                                      height: 205,
                                      padding: EdgeInsets.only(bottom: 10.h),
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
                                          Row(
                                            children: [
                                              Flexible(
                                                child: HeaderCard(
                                                  title: "Auto Homework",
                                                  backEnabled: true,
                                                  textColor: sectionTitleLightColor,
                                                  onTap: () => {Navigator.pop(context)},
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                margin: const EdgeInsets.only(bottom: 10),
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
                                              ),
                                              Text(
                                                (homeworkData?.topics ?? []).isNotEmpty ? homeworkData?.topics![0].topic.name : "",
                                                style: textTitle16WhiteBoldStyle.merge(
                                                  const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    // color: sectionTitleColor,
                                                  ),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
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

                                                      // bool isTrueFalse = (systemGeneratedTestData?.mcqOptions ?? []).isEmpty;
                                                      // int answerIndex = double.parse(message.message).round();
                                                      // userSelectedIndex = answerIndex;
                                                      // print("answer index $answerIndex ");

                                                      // int? dbCorrectAnsIndex;

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
                                                    }
                                                  },
                                                  {
                                                    "name": "HintHandler",
                                                    "callback": (JavascriptMessage message, bool fromPopup) async {
                                                      //open modal sheet for display hint
                                                      // hintBottomSheet();

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
                          (isPostProccesRunning == true || systemGeneratedTestsController.systemGeneratedTestLoading.isTrue)
                              ? const LoadingUI()
                              : Container()
                        ],
                      ),
                      (systemGeneratedTestsController.systemGeneratedTestNoQueFound.isTrue && isAnsSubmitted == true) && hasNoQuestionFound
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
