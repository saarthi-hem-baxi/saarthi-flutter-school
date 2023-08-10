import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/mcq_option.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controllers/retest_controller.dart';
import '../../../helpers/exam_webview_base_string.dart';
import '../../../model/content_report/question_content_report.modal.dart';
import '../../../model/system_generated_test_model/retest/retest_detail.dart';
import '../../../model/system_generated_test_model/retest/retest_exam_data.dart';
import '../../../model/system_generated_test_model/retest/retest_exam_model.dart';
import '../../../model/system_generated_test_model/topic.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/custom_webview.dart';
import '../../../widgets/exam/hint_solutions_widget.dart';
import '../../content_report/content_report_screen.dart';
import '../../homework/online_test_exam.dart';
import 'retest_topic_result.dart';

const kTileHeight = 50.0;

const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class ResTestTopicWiseExamPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String homeworkId;
  final String retestHomeworkId;

  const ResTestTopicWiseExamPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkId,
    required this.retestHomeworkId,
  }) : super(key: key);

  @override
  State<ResTestTopicWiseExamPage> createState() => _ResTestTopicWiseExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _ResTestTopicWiseExamPageState extends State<ResTestTopicWiseExamPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());

  String topicConceptName = '';

  McqOption? currentSelectedOption;
  bool? currentSelectedBool;
  RetestDetail? retestDetail;
  RetestExamData? retestExamData;
  BoolOptions? _boolOptionValue = BoolOptions.isNone;
  List<bool> isWebViewOptionsInitialLoaded = [];
  bool readyToGo = true;
  bool isPostProccesRunning = false;

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
    retestDetail = retestsController.retestDetailModel.value.data;
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
        retestExamData = null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;
      setState(() {
        retestDetail = retestsController.retestDetailModel.value.data;
        retestExamData = retestsController.retestExamModel.value.data;
      });
      readyToGo = true;
    });
    setState(() {
      isPostProccesRunning = false;
      topicConceptName = (retestDetail?.topics ?? []).isNotEmpty ? retestDetail?.topics![0].topic.name : "";
    });
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

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (retestsController.retestExamCompleted.isTrue) {
        retestsController.isFromExam = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RetestTopicBasedResultScreenPage(
              homeworkId: widget.homeworkId,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              retestHomeworkId: retestDetail!.id!,
            ),
          ),
        );
      }

      retestsController.retestExamModel.value = retestsController.retestExamModelTemp.value; // assign next question data to Question data model
      retestsController.retestExamModelTemp.value = RetestExamModel(); // clear temp data
      needToLoadQuestion = true;

      if (retestsController.retestExamNoQueFound.isFalse) {
        resetData(); // Reset all flags and variable for manage states
        apiPostProcessing(); // Process on Question data
      } else {
        setState(() {
          hasNoQuestionFound = true;
        });
      }
    }
  }

  void resetData() {
    correntAnsIndexes = null;
    wrongAnsIndex = null;
    hasChooseAnyOption = false;
    userSelectedIndex = null;
    if (retestsController.retestExamNoQueFound.isFalse) {
      isAnsSubmitted = false;
    }
    setState(() {});
  }

  void onSubmitButtonTap() {
    if (hasChooseAnyOption == false) {
      Fluttertoast.showToast(msg: 'Please select option !');
    } else {
      setState(() {
        isAnsSubmitted = true;
      });
      retestsController
          .getRetestDetail(
        context: context,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        homeworkId: widget.homeworkId,
        retestHomeworkId: widget.retestHomeworkId,
      )
          .then(
        (value) {
          retestsController.getReTest(
              context: context,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              homeworkId: widget.homeworkId,
              retestDetail: retestDetail!,
              map: {
                "answer": {
                  "concept": retestExamData!.concept,
                  "keyLearning": retestExamData!.keyLearning,
                  "topic": retestExamData!.topic ?? "",
                  "question": retestExamData!.id,
                  "answer": retestExamData!.mcqOptions!.isEmpty ? "" : currentSelectedOption?.id,
                  "orId": retestExamData!.orId,
                  "correct": retestExamData!.mcqOptions!.isEmpty
                      ? (_boolOptionValue == BoolOptions.isTrue) == retestExamData!.trueFalseAns
                      : currentSelectedOption?.correct,
                  "startedAt": retestExamData!.startedAt,
                  "keyLearnings": retestExamData!.keyLearnings,
                  "concepts": retestExamData!.concepts,
                  "topics": (retestExamData!.topics?.isNotEmpty ?? [].isNotEmpty) ? (retestExamData!.topics?[0].toMap()) : []

                  //jsonEncode(retestExamData!.topics)
                }
              }).then(
            (value) {
              setState(() {
                needToLoadQuestion = false;
              });

              if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  onNextButtonTap();
                });
              }
            },
          );
        },
      );
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
            () => (retestExamData == null || (retestsController.retestExamNoQueFound.isTrue && isAnsSubmitted == true)) && hasNoQuestionFound
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
                          !(retestExamData == null && !(retestDetail?.completed?.status ?? false))
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
                          !(retestExamData == null && !(retestDetail?.completed?.status ?? false))
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
                              retestDetail != null
                                  ? Container(
                                      height: 205,
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
                                            textColor: sectionTitleLightColor,
                                            backEnabled: true,
                                            onTap: () => {Navigator.pop(context)},
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
                                                (retestDetail?.topics ?? []).isNotEmpty ? retestDetail?.topics![0].topic.name : "",
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
                              retestExamData != null
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
                                                  questionString: retestExamData?.question?.enUs ?? "",
                                                  isMcqBasedQuestion: (retestExamData?.mcqOptions ?? []).isNotEmpty,
                                                  mcqOptions: (retestExamData?.mcqOptions ?? []).isNotEmpty
                                                      ? (retestExamData?.mcqOptions ?? []).map((e) => e.option?.enUs ?? "").toList()
                                                      : [],
                                                  questionId: retestExamData?.id ?? "",
                                                  isShowHint: getfilteredVideoMedia(solutionMedia: (retestExamData?.hint?.media ?? [])).isNotEmpty ||
                                                      (retestExamData?.hint?.description?.enUs?.isNotEmpty ?? false),
                                                  isShowSolutionBtn:
                                                      getfilteredVideoMedia(solutionMedia: (retestExamData?.solution?.media ?? [])).isNotEmpty ||
                                                          (retestExamData?.solution?.description?.enUs?.isNotEmpty ?? false),
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
                                                              book: retestExamData?.book,
                                                              lang: retestExamData?.lang,
                                                              isPublisher: retestExamData?.isPublisher,
                                                              publisher: retestExamData?.publisher,
                                                              content: QuestionReportContent(question: questionId),
                                                            ),
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

                                                      if (retestExamData?.type == 'true-or-false') {
                                                        if (userSelectedIndex == 0) {
                                                          _boolOptionValue = BoolOptions.isTrue;
                                                        }
                                                        if (userSelectedIndex == 1) {
                                                          _boolOptionValue = BoolOptions.isFalse;
                                                        }
                                                        hasChooseAnyOption = true;

                                                        correntAnsIndexes = [retestExamData?.trueFalseAns == true ? 0 : 1];
                                                      } else if (retestExamData?.type == 'mcq') {
                                                        if ((retestExamData?.mcqOptions ?? []).isNotEmpty) {
                                                          currentSelectedOption = retestExamData?.mcqOptions?[userSelectedIndex!];
                                                        }
                                                        hasChooseAnyOption = true;

                                                        retestExamData?.mcqOptions?.forEach((element) {
                                                          if (element.correct == true) {
                                                            correntAnsIndexes ?? [].add(retestExamData?.mcqOptions?.indexOf(element));
                                                          }
                                                        });

                                                        correntAnsIndexes = (retestExamData?.mcqOptions ?? []).map((e) {
                                                          if (e.correct == true) {
                                                            return (retestExamData?.mcqOptions ?? []).indexOf(e);
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
                                                      //open modal sheet for display hint webview
                                                      // hintBottomSheet();
                                                      HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                        context: context,
                                                        hintSolutionData: retestExamData?.hint,
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
                                                        hintSolutionData: retestExamData?.solution,
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
                          (isPostProccesRunning == true || retestsController.retestExamLoading.isTrue) ? const LoadingUI() : Container()
                        ],
                      ),
                      (retestsController.retestExamNoQueFound.isTrue && isAnsSubmitted == true) && hasNoQuestionFound
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
