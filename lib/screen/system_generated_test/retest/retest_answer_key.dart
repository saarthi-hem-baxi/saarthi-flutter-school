// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controllers/retest_controller.dart';
import '../../../helpers/exam_key_answer_webview_string.dart';
import '../../../model/system_generated_answer_key_model/question.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/custom_webview.dart';
import '../../../widgets/exam/hint_solutions_widget.dart';

class RetestAnswerKeyPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;
  final String retestHomeworkId;

  const RetestAnswerKeyPage({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
    required this.retestHomeworkId,
  }) : super(key: key);

  @override
  State<RetestAnswerKeyPage> createState() => _RetestAnswerKeyPageState();
}

class _RetestAnswerKeyPageState extends State<RetestAnswerKeyPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());
  double height = 1;

  WebViewController? webViewController;
  WebViewController? optionWebViewController;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () {
        retestsController.getRetestAnswerKeyData(
          context: context,
          subjectId: widget.subjectId,
          chapterId: widget.chapterId,
          homeworkId: widget.homeworkId,
          retestHomeworkId: widget.retestHomeworkId,
        );
      },
    );
  }

  List<AnswerKeyWebViewStringModal> getAnswerKeyData({required List<Questions> questions}) {
    List<AnswerKeyWebViewStringModal> data = [];
    List<int?>? correntAnsIndexes;
    for (var item in questions) {
      correntAnsIndexes = (item.qus?.mcqOptions ?? []).map((e) {
        if (e.correct == true) {
          return (item.qus?.mcqOptions ?? []).indexOf(e);
        }
      }).toList();
      correntAnsIndexes.removeWhere((e) => e == null);
      data.add(
        AnswerKeyWebViewStringModal(
          isMCQtypeQuestion: item.qus?.type == "mcq",
          question: item.qus?.qusSubsubsub?.enUs ?? "",
          mcqOptions: item.qus?.type == "mcq" ? (item.qus?.mcqOptions ?? []).map((e) => e.option?.enUs ?? "").toList() : [],
          ansOptionIndex: item.qus?.type == "mcq" ? (item.qus?.mcqOptions ?? []).indexWhere((option) => option.id == item.answer) : 0,
          correctOptionIndex: correntAnsIndexes,
          isCorrectMCQ: item.correct,
          isTrueAns: item.correct,
          trueFalseAns: item.qus?.trueFalseAns ?? false,
          solution: item.qus?.solution,
          userSelectedIndex: item.qus?.mcqOptions?.indexWhere(
            (element) => element.id == item.answer,
          ),
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => retestsController.loading.isTrue || retestsController.systemGeneratedAnswerKeyModel.value.data == null
              ? const Center(
                  child: LoadingSpinner(color: Colors.blue),
                )
              : Stack(
                  children: [
                    Positioned(
                      left: -100,
                      child: Transform.rotate(
                        angle: 0,
                        child: Container(
                          height: 250.h,
                          width: 250.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[Color.fromRGBO(255, 126, 70, 0.2), Color.fromRGBO(255, 126, 70, 0)],
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
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16.h, top: 10.h),
                          margin: EdgeInsets.only(bottom: 10.h),
                          width: double.infinity,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  Navigator.pop(context),
                                },
                                child: Container(
                                  height: 32.h,
                                  width: 32.h,
                                  margin: EdgeInsets.only(right: 20.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_outlined,
                                    size: 18.h,
                                    color: sectionTitleColor,
                                  ),
                                ),
                              ),
                              Text(
                                "Answer Key",
                                style: sectionTitleTextStyle.merge(
                                  const TextStyle(color: sectionTitleColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: CustomWebView(
                            readMore: false,
                            bodyBgColor: "rgba(255, 255, 128, 0);",
                            headElements: getExamAnswerKeyWebviewStyling(),
                            htmlString: getExamAnswerKeyWebViewString(
                              answerKeyData: getAnswerKeyData(
                                questions: retestsController.systemGeneratedAnswerKeyModel.value.data?.questions ?? [],
                              ),
                            ),
                            scripts: getExamAnswerKeyWebViewScripting(),
                            javascriptChannels: {
                              {
                                "name": "SolutionHandler",
                                "callback": (JavascriptMessage message, bool fromPopup) async {
                                  //open modal sheet for display Video

                                  // hintBottomSheet(
                                  //   retestsController.systemGeneratedAnswerKeyModel.value.data?.questions?[(int.tryParse(message.message) ?? 0)],
                                  // );
                                  Questions? autoHWRetestQuestionData =
                                      retestsController.systemGeneratedAnswerKeyModel.value.data?.questions?[(int.tryParse(message.message) ?? 0)];
                                  HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                    context: context,
                                    hintSolutionData: autoHWRetestQuestionData?.qus?.solution,
                                    isAnswerKeySolution: true,
                                    topicName: autoHWRetestQuestionData?.topicName?.name != null &&
                                            (autoHWRetestQuestionData?.topicName?.name ?? '').isNotEmpty
                                        ? autoHWRetestQuestionData?.topicName?.name
                                        : autoHWRetestQuestionData?.concept?.name?.enUs != null &&
                                                (autoHWRetestQuestionData?.concept?.name?.enUs ?? '').isNotEmpty
                                            ? autoHWRetestQuestionData?.concept?.name?.enUs
                                            : '',
                                  );
                                }
                              },
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
