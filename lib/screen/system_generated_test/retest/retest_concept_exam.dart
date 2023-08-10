import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/retest_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/key_learning.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/mcq_option.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_exam_data.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';
import 'package:timelines/timelines.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/exam_webview_base_string.dart';
import '../../../model/content_report/question_content_report.modal.dart';
import '../../../model/system_generated_test_model/retest/retest_exam_model.dart';
import '../../../model/system_generated_test_model/topic.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/custom_webview.dart';
import '../../../widgets/exam/hint_solutions_widget.dart';
import '../../content_report/content_report_screen.dart';
import '../../homework/online_test_exam.dart';
import 'retest_concept_result.dart';

const kTileHeight = 50.0;
const completeColor = colorPurple;
const inProgressColor = colorPink;
const todoColor = Colors.black;

class RetestConceptBasedExamPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String homeworkId;
  final String retestHomeworkId;
  final bool isSelfAutoHW;

  const RetestConceptBasedExamPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    required this.homeworkId,
    required this.retestHomeworkId,
    required this.isSelfAutoHW,
  }) : super(key: key);

  @override
  State<RetestConceptBasedExamPage> createState() => _RetestConceptBasedExamPageState();
}

enum BoolOptions { isTrue, isFalse, isNone }

class _RetestConceptBasedExamPageState extends State<RetestConceptBasedExamPage> with SingleTickerProviderStateMixin {
  int _conceptIndex = 1;
  int _keyLearningIndex = 0;

  String topicConceptName = '';

  final ScrollController _scrollController = ScrollController();
  final retestsController = Get.put(ReTestController());

  McqOption? currentSelectedOption;
  bool? currentSelectedBool;
  RetestExamData? retestExamData;
  BoolOptions? _boolOptionValue = BoolOptions.isNone;
  List<bool> isWebViewOptionsInitialLoaded = [];
  RetestDetail? retestDetail;
  bool readyToGo = false;
  bool isPostProccesRunning = false;
  final precapController = Get.put(PrecapController());
  var isCountingPercentage = false;

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
    precapController.totalKeyLearnings = 0;
    precapController.totalKeylerningExamPer = 0.0;
    precapController.totalKeyLearningsPercentage = 0.0;

    percentageCounter();
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
        // retestExamData = null;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boolOptionValue = BoolOptions.isNone;
      var conceptId = retestsController.retestExamModel.value.data?.concept;
      var keylearningId = retestsController.retestExamModel.value.data?.keyLearning;

      if (conceptId != null) {
        int conceptIndex = retestDetail!.concepts!.indexWhere(
          (e) => e.concept!.id == conceptId,
        );
        int keyLearningIndex = retestDetail!.concepts![conceptIndex].keyLearnings!.indexWhere(
          (e) => e.keyLearning!.id == keylearningId,
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              MediaQuery.of(context).size.width * conceptIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
        if (isCountingPercentage) {
          if (_keyLearningIndex != keyLearningIndex) {
            precapController.totalKeylerningExamPer = precapController.totalKeylerningExamPer + precapController.totalKeyLearningsPercentage;
          } else {
            if (_conceptIndex != conceptIndex) {
              precapController.totalKeylerningExamPer = precapController.totalKeylerningExamPer + precapController.totalKeyLearningsPercentage;
            }
          }
        }

        setState(() {
          _conceptIndex = conceptIndex;
          _keyLearningIndex = keyLearningIndex;
          retestDetail = retestsController.retestDetailModel.value.data;
          retestExamData = retestsController.retestExamModel.value.data;
          topicConceptName = retestsController.retestDetailModel.value.data?.concepts?[conceptIndex].concept.name.enUs;
        });
      } else {
        setState(() {
          _conceptIndex = 0;
          _keyLearningIndex = 0;
          retestDetail = null;
          retestExamData = null;
        });
      }
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

  void onNextButtonTap() {
    if (hasChooseAnyOption == true && isAnsSubmitted == true) {
      if (retestsController.retestExamCompleted.isTrue) {
        retestsController.isFromExam = true;
        // Navigator.pop(context),
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RetestConceptBasedResultScreenPage(
              homeworkId: widget.homeworkId,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              retestHomeworkId: retestDetail!.id!,
              isSelfAutoHW: widget.isSelfAutoHW,
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

  void onSubmitBottomTap() {
    if (hasChooseAnyOption == false) {
      Fluttertoast.showToast(msg: 'Please select option !');
    } else {
      setState(() {
        isAnsSubmitted = true;
      });

      // if (!(retestsController.retestDetailModel.value.data?.completed?.status ?? false)) {
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
          }).then((value) {
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
            setState(() {
              isCountingPercentage = true;
              needToLoadQuestion = false;
            });

            if ((correntAnsIndexes ?? []).contains(userSelectedIndex)) {
              Future.delayed(const Duration(milliseconds: 100), () {
                onNextButtonTap();
              });
            }
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: retestsController.retestExamNoQueFound.isTrue && hasNoQuestionFound
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
                      child: !((isPostProccesRunning == true || retestsController.retestExamLoading.isTrue) && needToLoadQuestion == true)
                          ? !isAnsSubmitted
                              ? InkWell(
                                  onTap: onSubmitBottomTap,
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7.h),
                                          ),
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
                    ),
                  ],
                ),
              ),
            ),
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
                        // !(retestExamData == null && !(retestDetail?.completed?.status ?? false))
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
                        !(retestExamData == null && !(retestExamData?.completed?.status ?? false))
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
                            retestExamData != null
                                ? Container(
                                    // height: 205.h,
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
                                          title: "Retest",
                                          backEnabled: true,
                                          textColor: sectionTitleLightColor,
                                          onTap: () => {Navigator.pop(context)},
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
                                                  var keylearning = retestDetail?.concepts![index].keyLearnings;

                                                  // _processes[index]["keylearning"] as List<Map<String, String>>;
                                                  return SizedBox(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 10.h),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            retestDetail?.concepts![index].concept?.name?.enUs ?? "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
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
                                                                  children: keylearning!
                                                                      .map((valKeyLearning) => KeyLearningTimelineItem(
                                                                            keylearning: keylearning,
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
                                                                  retestDetail?.concepts?[index].cleared ?? false ? greenGradient : redGradient),
                                                          child: retestDetail?.concepts?[index].cleared ?? false
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
                                                itemCount: retestDetail?.concepts?.length ?? 0,
                                                addAutomaticKeepAlives: true),
                                          ),
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

                                                    // bool isTrueFalse = (retestExamData?.mcqOptions ?? []).isEmpty;
                                                    // int answerIndex = double.parse(message.message).round();
                                                    // userSelectedIndex = answerIndex;
                                                    // if (isTrueFalse) {
                                                    //   if (answerIndex == 0) {
                                                    //     _boolOptionValue = BoolOptions.isTrue;
                                                    //   }
                                                    //   if (answerIndex == 1) {
                                                    //     _boolOptionValue = BoolOptions.isFalse;
                                                    //   }
                                                    //   hasChooseAnyOption = true;
                                                    // } else {
                                                    //   if ((retestExamData?.mcqOptions ?? []).isNotEmpty) {
                                                    //     currentSelectedOption = retestExamData?.mcqOptions?[answerIndex];
                                                    //   }
                                                    //   hasChooseAnyOption = true;
                                                    // }

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

                                                    setState(() {});
                                                  },
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
    );
  }

  percentageCounter() {
    for (int i = 0; i < (retestDetail?.concepts ?? []).length; i++) {
      var totalKeylearning = retestDetail?.concepts![i].keyLearnings?.length;
      precapController.totalKeyLearnings = precapController.totalKeyLearnings + totalKeylearning!;
    }

    precapController.totalKeyLearningsPercentage = 100 / precapController.totalKeyLearnings;

    for (int j = 0; j < (retestDetail?.concepts ?? []).length; j++) {
      for (int i = 0; i <= (retestDetail?.concepts ?? [])[j].keyLearnings!.length - 1; i++) {
        if ((retestDetail?.concepts ?? [])[j].keyLearnings![i].cleared != null) {
          precapController.totalKeylerningExamPer = precapController.totalKeylerningExamPer + precapController.totalKeyLearningsPercentage;
        }
      }
    }
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
          valKeyLearning.keyLearning?.name?.enUs.toString() ?? "",
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
      ),
    );
  }
}
