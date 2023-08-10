import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_model_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/online_test.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_webview.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:timelines/timelines.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/exam_webview_base_string.dart';
import '../../model/content_report/question_content_report.modal.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

import '../../widgets/exam/hint_solutions_widget.dart';
import '../content_report/content_report_screen.dart';
import 'online_test_result.dart';

const kTileHeight = 50.0;

const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class HWOnlineTestExamPage extends StatefulWidget {
  const HWOnlineTestExamPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkDetailData,
    required this.langCode,
    required this.title,
    required this.noQuestion,
  }) : super(key: key);

  final String subjectId;
  final String chapterId;
  final HomeworkDetailModel homeworkDetailData;
  final String langCode;
  final String title;
  final bool noQuestion;

  @override
  State<HWOnlineTestExamPage> createState() => _HWOnlineTestExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _HWOnlineTestExamPageState extends State<HWOnlineTestExamPage> with SingleTickerProviderStateMixin {
  int _topicIndex = 1;
  String topicName = '';
  final ScrollController _scrollController = ScrollController();
  final homeworkController = Get.put(HomeworkController());
  McqOption? currentSelectedOption;
  bool? currentSelectedBool;
  HomeworkDetail? homeworkData;
  OnlineTestQuestionModal? onlineTestData;
  BoolOptions? _boolOptionValue = BoolOptions.isNone;
  bool readyToGo = true;
  bool showTimeLine = true;
  bool isPostProccesRunning = false;
  var perTopics = 0.0;
  var totalPercantage = 0.0;
  var isFirstTime = true;
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        apiPostProcessing(),
      },
    );
    if (isFirstTime) {
      needToLoadQuestion = true;
    }
  }

  void apiPostProcessing() {
    isPostProccesRunning = true;
    setState(
      () {
        currentSelectedOption = null;
        // onlineTestData = null;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;
      var topicId = homeworkController.onlineTestModal.value.topic ?? homeworkController.onlineTestModal.value.concept;
      if (topicId != null) {
        int topicIndex = widget.homeworkDetailData.data?.topics?.indexWhere(
              (element) => element.topic.id == topicId,
            ) ??
            -1;

        Future.delayed(const Duration(seconds: 1), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              MediaQuery.of(context).size.width * topicIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        setState(() {
          homeworkData = widget.homeworkDetailData.data;
          onlineTestData = homeworkController.onlineTestModal.value;
          perTopics = 100 /
              (homeworkData?.topics
                      ?.map((e) => e.questionCount ?? 0)
                      .reduce(
                        (value, element) => value + element,
                      )
                      .toInt() ??
                  0);
          if (isFirstTime) {
            for (int i = 0; i < (onlineTestData?.currentQuestion)!.toInt() - 1; i++) {
              totalPercantage = totalPercantage + perTopics;
            }
            isFirstTime = false;
          } else {
            totalPercantage = totalPercantage + perTopics;
          }
          readyToGo = true;
          showTimeLine = true;
          _topicIndex = topicIndex;
          topicName = homeworkData?.topics?[_topicIndex].topic.name.toString() ?? '';
        });
      } else {
        setState(() {
          _topicIndex = 0;
          homeworkData = null;
          onlineTestData = null;
        });
      }
    });
    setState(() {
      isPostProccesRunning = false;
      if (widget.noQuestion) {
        hasNoQuestionFound = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getColor(int index) {
    if (index == _topicIndex) {
      return inProgressColor;
    } else if (index < _topicIndex) {
      return completeColor;
    } else {
      return const Color.fromRGBO(224, 224, 224, 1);
    }
  }

  Color getColorTitle(int index) {
    if (index == _topicIndex) {
      return inProgressColor;
    } else if (index < _topicIndex) {
      return sectionTitleColor;
    } else {
      return Colors.black;
    }
  }

  void resetData() {
    correntAnsIndexes = [];
    wrongAnsIndex = null;
    hasChooseAnyOption = false;
    userSelectedIndex = null;
    if (homeworkController.onlineTestNoQuestionFound.isFalse) {
      isAnsSubmitted = false;
    }
  }

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (homeworkController.onlineTestExamCompleted.isTrue) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HWOnlineTestResultPage(
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              homeworkId: widget.homeworkDetailData.data?.id ?? "",
            ),
          ),
        );
      }
      homeworkController.onlineTestModal.value = homeworkController.onlineTestModalTemp.value; // assign next question data to Question data model
      homeworkController.onlineTestModalTemp.value = OnlineTestQuestionModal(); // clear temp data
      needToLoadQuestion = true;

      if (homeworkController.onlineTestNoQuestionFound.isFalse) {
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

      Map dataMap = {
        "lang": langCode,
        "answer": {
          "concept": onlineTestData?.concept ?? "",
          "topic": onlineTestData?.topic ?? "",
          "question": onlineTestData?.id ?? "",
          "answer": (onlineTestData?.mcqOptions ?? []).isEmpty ? "" : currentSelectedOption?.id,
          "orId": onlineTestData?.orId ?? "",
          "correct": (onlineTestData!.mcqOptions ?? []).isEmpty
              ? (_boolOptionValue == BoolOptions.isTrue) == onlineTestData?.trueFalseAns
              : currentSelectedOption?.correct,
          "startedAt": onlineTestData?.startedAt?.toUtc().toIso8601String(),
          "concepts": (onlineTestData?.concepts ?? []).isEmpty ? [] : onlineTestData?.concepts,
          "topics": onlineTestData?.topics?.map((e) => e.toJson()).toList(),
        }
      };
      homeworkController
          .getOnlineTestData(
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        homeworkId: homeworkData?.id ?? "",
        dataMap: dataMap,
        isFirst: false,
        isSubmitBtnPressed: true,
      )
          .then((value) {
        setState(() {
          needToLoadQuestion = false;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
            onNextButtonTap();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (widget.noQuestion || homeworkController.onlineTestNoQuestionFound.isTrue) && hasNoQuestionFound
          ? const SizedBox()
          : SafeArea(
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
                      child: !((isPostProccesRunning == true || homeworkController.onlineTestLoading.isTrue) && needToLoadQuestion == true)
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
            ),
      body: SafeArea(
        child: (widget.noQuestion || (homeworkController.onlineTestNoQuestionFound.isTrue && isAnsSubmitted == true)) && hasNoQuestionFound
            ? const NoDataCard(
                title: "Oops...\n No question found",
                description: "No question found for selected Homework\nkindly contact your teacher.",
                headerEnabled: true,
                backgroundColor: Colors.white,
              )
            : Obx(
                () => Stack(
                  children: [
                    Stack(
                      children: [
                        // const HalfRoundedCircle(),
                        !(onlineTestData == null && !(onlineTestData?.completed?.status ?? false))
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
                        !(onlineTestData == null && !(onlineTestData?.completed?.status ?? false))
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
                            onlineTestData != null && showTimeLine
                                ? Container(
                                    height: 205,
                                    padding: const EdgeInsets.only(top: 10),
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
                                                title: widget.title,
                                                backEnabled: true,
                                                textColor: sectionTitleLightColor,
                                                onTap: () => {Navigator.pop(context)},
                                              ),
                                            ),
                                            ExamProgressIndicator(totalPercantage: totalPercantage)
                                          ],
                                        ),
                                        //  put timline code here

                                        SizedBox(
                                          height: 125.h,
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
                                                nodePositionBuilder: (context, index) => 0.25,
                                                //Values are beetween 0 to 1
                                                contentsBuilder: (context, index) {
                                                  return SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            (homeworkData?.topics != null ? (homeworkData?.topics ?? [])[index].topic.name : ''),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: textTitle16WhiteBoldStyle.merge(const TextStyle(fontWeight: FontWeight.w600)),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 80,
                                                              width: MediaQuery.of(context).size.width / 1.5,
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.vertical,
                                                                child: Wrap(
                                                                  direction: Axis.horizontal,
                                                                  alignment: WrapAlignment.center,
                                                                  children: const [],
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
                                                  if (index < _topicIndex) {
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
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            // borderRadius: BorderRadius.all(
                                                            //   Radius.circular(15),
                                                            // ),
                                                            gradient: purpleGradient,
                                                          ),
                                                        ));
                                                  } else if (index == _topicIndex) {
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
                                                    if (index == _topicIndex) {
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
                                                itemCount: homeworkData?.topics?.length ?? 0,
                                                addAutomaticKeepAlives: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            onlineTestData != null
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
                                                questionString: onlineTestData?.question?.lang ?? "",
                                                isMcqBasedQuestion: (onlineTestData?.mcqOptions ?? []).isNotEmpty,
                                                mcqOptions: (onlineTestData?.mcqOptions ?? []).isNotEmpty
                                                    ? (onlineTestData?.mcqOptions ?? []).map((e) => e.option?.lang ?? "").toList()
                                                    : [],
                                                questionId: onlineTestData?.id ?? "",
                                                isShowHint: getfilteredVideoMedia(solutionMedia: (onlineTestData?.hint?.media ?? [])).isNotEmpty ||
                                                    (onlineTestData?.hint?.description?.enUs?.isNotEmpty ?? false),
                                                isShowSolutionBtn:
                                                    getfilteredVideoMedia(solutionMedia: (onlineTestData?.solution?.media ?? [])).isNotEmpty ||
                                                        (onlineTestData?.solution?.description?.enUs?.isNotEmpty ?? false),
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
                                                              book: onlineTestData?.book,
                                                              lang: onlineTestData?.lang,
                                                              isPublisher: onlineTestData?.isPublisher,
                                                              publisher: onlineTestData?.publisher,
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

                                                    if (onlineTestData?.type == 'true-or-false') {
                                                      if (userSelectedIndex == 0) {
                                                        _boolOptionValue = BoolOptions.isTrue;
                                                      }
                                                      if (userSelectedIndex == 1) {
                                                        _boolOptionValue = BoolOptions.isFalse;
                                                      }
                                                      hasChooseAnyOption = true;

                                                      correntAnsIndexes = [onlineTestData?.trueFalseAns == true ? 0 : 1];
                                                    } else if (onlineTestData?.type == 'mcq') {
                                                      if ((onlineTestData?.mcqOptions ?? []).isNotEmpty) {
                                                        currentSelectedOption = onlineTestData?.mcqOptions?[userSelectedIndex!];
                                                      }
                                                      hasChooseAnyOption = true;

                                                      onlineTestData?.mcqOptions?.forEach((element) {
                                                        if (element.correct == true) {
                                                          correntAnsIndexes ?? [].add(onlineTestData?.mcqOptions?.indexOf(element));
                                                        }
                                                      });

                                                      correntAnsIndexes = (onlineTestData?.mcqOptions ?? []).map((e) {
                                                        if (e.correct == true) {
                                                          return (onlineTestData?.mcqOptions ?? []).indexOf(e);
                                                        }
                                                      }).toList();

                                                      correntAnsIndexes?.removeWhere((e) => e == null);
                                                    }

                                                    if (!(correntAnsIndexes ?? []).contains(userSelectedIndex)) {
                                                      wrongAnsIndex = userSelectedIndex;
                                                    } //identify wrong and index

                                                    setState(() {});
                                                  },

                                                  //asd
                                                },
                                                {
                                                  "name": "HintHandler",
                                                  "callback": (JavascriptMessage message, bool fromPopup) async {
                                                    //open modal sheet for display hint webview
                                                    // hintBottomSheet();

                                                    HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                      context: context,
                                                      hintSolutionData: onlineTestData?.hint,
                                                      isHint: true,
                                                      topicName: topicName,
                                                    );
                                                  }
                                                },
                                                {
                                                  "name": "SolutionHandler",
                                                  "callback": (JavascriptMessage message, bool fromPopup) async {
                                                    //open modal sheet for display hint webview

                                                    HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                                      context: context,
                                                      hintSolutionData: onlineTestData?.solution,
                                                      isTestSolution: true,
                                                      topicName: topicName,
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
                        ((isPostProccesRunning == true || homeworkController.onlineTestLoading.isTrue) && needToLoadQuestion == true)
                            ? const LoadingUI()
                            : const SizedBox()
                      ],
                    ),
                    (widget.noQuestion || (homeworkController.onlineTestNoQuestionFound.isTrue && isAnsSubmitted == true)) && hasNoQuestionFound
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
    );
  }
}

class LoadingUI extends StatelessWidget {
  const LoadingUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScrenHeight(context),
      width: getScreenWidth(context),
      color: Colors.white.withOpacity(0.4),
      // margin: const EdgeInsets.all(20),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: LoadingSpinner(color: sectionTitleColor),
        ),
      ),
    );
  }
}

class HalfRoundedCircle extends StatelessWidget {
  const HalfRoundedCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -150,
      bottom: 20,
      child: Transform.rotate(
        angle: 0,
        child: Container(
          height: 250,
          width: 250,
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
              topLeft: Radius.circular(125),
              bottomLeft: Radius.circular(125),
            ),
          ),
        ),
      ),
    );
  }
}

class ExamProgressIndicator extends StatelessWidget {
  const ExamProgressIndicator({
    Key? key,
    required this.totalPercantage,
  }) : super(key: key);

  final double totalPercantage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 50.w,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            minimum: 0,
            maximum: 100,
            radiusFactor: 0.80,
            axisLineStyle: const AxisLineStyle(color: Color.fromRGBO(106, 110, 246, 0.2), thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
            pointers: <GaugePointer>[
              RangePointer(
                  value: totalPercantage,
                  cornerStyle: CornerStyle.bothCurve,
                  enableAnimation: true,
                  animationDuration: 1000,
                  animationType: AnimationType.ease,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: colorSky,
                  width: 0.1),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 0,
                  positionFactor: 0.1,
                  widget: Text(
                    "${totalPercantage.toInt().toString()}%",
                    style: textTitle10RegularStyle,
                  )),
            ],
          ),
        ],
      ),
    );

    // SizedBox(
    //   height: 50,
    //   width: 60,
    //   child: SfRadialGauge(
    //     axes: <RadialAxis>[
    //       RadialAxis(
    //         showLabels: false,
    //         showTicks: false,
    //         startAngle: 270,
    //         endAngle: 270,
    //         minimum: 0,
    //         maximum: 100,
    //         radiusFactor: 0.85,
    //         axisLineStyle: const AxisLineStyle(color: Color.fromRGBO(106, 110, 246, 0.2), thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
    //         pointers: <GaugePointer>[
    //           RangePointer(
    //               value: totalPercantage,
    //               cornerStyle: CornerStyle.bothCurve,
    //               enableAnimation: true,
    //               animationDuration: 1200,
    //               animationType: AnimationType.ease,
    //               sizeUnit: GaugeSizeUnit.factor,
    //               color: colorSky,
    //               width: 0.1),
    //         ],
    //         annotations: <GaugeAnnotation>[
    //           GaugeAnnotation(
    //             angle: 0,
    //             positionFactor: 1,
    //             widget: Row(
    //               children: <Widget>[
    //                 Container(
    //                   height: 50,
    //                   width: 60,
    //                   margin: EdgeInsets.only(left: totalPercantage.toString().length > 1 ? 0 : 5.w),
    //                   alignment: Alignment.centerLeft,
    //                   child: Text(
    //                     "${totalPercantage.toInt()}%",
    //                     style: textTitle10RegularStyle,
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
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
    return Container(
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
            ? valKeyLearning.cleared!
                ? colorGreenLight
                : colorRedLight
            : conceptIndex == index
                ? keyLearningIndex == keylearning.indexOf(valKeyLearning)
                    ? Colors.white
                    : colorgray249
                : colorgray249,
      ),
      child: Text(
        valKeyLearning.keyLearning?.name?.lang.toString() ?? "",
        style: textTitle12BoldStyle.merge(
          TextStyle(
            color: valKeyLearning.cleared != null
                ? valKeyLearning.cleared!
                    ? colorGreenDark
                    : colorRed
                : const Color.fromRGBO(163, 163, 163, 1),
          ),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
