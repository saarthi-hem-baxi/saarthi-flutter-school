import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/exam_key_answer_webview_string.dart';
import '../../model/homework_model/online_test_answer_key.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/custom_webview.dart';
import '../../widgets/exam/hint_solutions_widget.dart';

class HWOnlineTestAnswerKey extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;

  const HWOnlineTestAnswerKey({
    Key? key,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<HWOnlineTestAnswerKey> createState() => _HWOnlineTestAnswerKeyState();
}

class _HWOnlineTestAnswerKeyState extends State<HWOnlineTestAnswerKey> with SingleTickerProviderStateMixin {
  final homeworkController = Get.put(HomeworkController());

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      homeworkController.getOnlineTestAnswerKey(
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        homeworkId: widget.homeworkId,
      );
    });
  }

  List<AnswerKeyWebViewStringModal> getAnswerKeyData({required List<Questions> questions}) {
    List<AnswerKeyWebViewStringModal> data = [];
    List<int?>? correntAnsIndexes;
    for (Questions item in questions) {
      correntAnsIndexes = (item.qus?.mcqOptions ?? []).map((e) {
        if (e.correct == true) {
          return (item.qus?.mcqOptions ?? []).indexOf(e);
        }
      }).toList();
      correntAnsIndexes.removeWhere((e) => e == null);
      data.add(
        AnswerKeyWebViewStringModal(
          isMCQtypeQuestion: item.qus?.type == "mcq",
          question: item.qus?.question?.lang ?? "",
          mcqOptions: item.qus?.type == "mcq" ? (item.qus?.mcqOptions ?? []).map((e) => e.option?.lang ?? "").toList() : [],
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
          () => homeworkController.onlineTestAnswerLoading.isTrue
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
                                questions: homeworkController.onlineTestAnswerKeyModal.value.questions ?? [],
                              ),
                            ),
                            scripts: getExamAnswerKeyWebViewScripting(),
                            javascriptChannels: {
                              {
                                "name": "SolutionHandler",
                                "callback": (JavascriptMessage message, bool fromPopup) async {
                                  //open modal sheet for display hint webview

                                  Questions? questionData =
                                      homeworkController.onlineTestAnswerKeyModal.value.questions?[(int.tryParse(message.message) ?? 0)];

                                  HintSolutionBottomSheetHandler.openHintSolutionSheet(
                                    context: context,
                                    hintSolutionData: questionData?.qus?.solution,
                                    isAnswerKeySolution: true,
                                    topicName: questionData?.topicName?.name != null && (questionData?.topicName?.name ?? '').isNotEmpty
                                        ? questionData?.topicName?.name
                                        : questionData?.conceptName?.name?.lang != null && (questionData?.conceptName?.name?.lang ?? '').isNotEmpty
                                            ? questionData?.conceptName?.name?.lang
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
