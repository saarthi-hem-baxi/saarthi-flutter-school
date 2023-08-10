import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/model/lessplan/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/lessonplan_controller.dart';
import '../../model/content_report/lp_content_report.modal.dart';
import '../../screen/content_report/content_report_screen.dart';
import '../../screen/lesson_plan.dart';

class ExampleSectionNew extends StatefulWidget {
  const ExampleSectionNew({
    Key? key,
    required this.lessonPlanModal,
    required this.lessonPlan,
    required this.lessonPlanIndex,
    required this.type,
    required this.id,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final LessonPlanListModal? lessonPlanModal;
  final LessonPlan? lessonPlan;
  final int lessonPlanIndex;
  final LPQBType type;
  final String id;
  final String subjectId;
  final String chapterId;

  @override
  State<ExampleSectionNew> createState() => _ExampleSectionNewState();
}

class _ExampleSectionNewState extends State<ExampleSectionNew> {
  // ignore: unused_field
  WebViewController? _webViewController;
  double height = 1;
  bool isWebviewLoading = true;

  final lessonPlanController = Get.put(LessonPlanController());

  @override
  void initState() {
    super.initState();
  }

  bool isShowExample(LessonPlanItem example) {
    if (widget.type == LPQBType.topic) {
      if (widget.lessonPlan?.isPublisher == true) {
        int index = (example.topics ?? []).indexWhere((element) => element.topic == widget.id);
        if (index != -1) {
          return true;
        }
      } else {
        //for when lesson plan is saarthi's lesson plan
        for (var concept in example.concepts ?? []) {
          bool isContainInGlobalConcepts = (widget.lessonPlanModal?.concepts ?? []).contains(concept);
          if (isContainInGlobalConcepts) {
            return true;
          }
        }
      }
      return false;
    } else {
      bool isContain = (example.concepts ?? []).contains(widget.id);
      return isContain;
    }
  }

  bool isShowExampleCard() {
    bool show = false;
    for (var example in widget.lessonPlan?.examples ?? []) {
      if (isShowExample(example)) {
        show = true;
        break;
      }
    }
    return show;
  }

  String getExampleString(List<LessonPlanItem>? examples) {
    String string = '';
    int count = 1;

    String lang = widget.lessonPlanModal?.lang ?? "";

    List<LessonPlanItem> getData(List<LessonPlanItem>? data) {
      return (data ?? [])
          .where((element) =>
              (element.lang ?? []).contains(lang) &&
              element.description?.containsKey(lang) == true &&
              (element.description?[lang]?.isNotEmpty ?? false))
          .toList();
    } // get examples where examples's languages are match with lessonplan's language also check selected language are field is present in description map

    for (LessonPlanItem exampleItem in getData(examples)) {
      if (isShowExample(exampleItem)) {
        string = string +
            '''<div class="question-cell px-10">
        <div class="mb-10">
              <div class="question align-item-top mb-10">
                <div class="qustion-left">
                    <div class="sky-blue-badge">
                      <div class="sky-blue-badge-text">Example $count</div>
                    </div>
                </div>
                <div class="question-right">
                  <i class="material-icons info-icon" onclick="handleOnReport('example',['example','${exampleItem.id}',])">info</i>
                </div>
              </div>
              <div class="question">
                <div class="qustion-left">
                  <div class="question-text">
                    ${exampleItem.description?[lang] ?? ""}
                  </div>
                </div>
              </div>
            </div>
        </div>''';
        count = count + 1;
      }
    }

    return _getHTMLContent(string);
  }

  @override
  Widget build(BuildContext context) {
    String lang = widget.lessonPlanModal?.lang ?? "";
    return Container(
      child: widget.lessonPlan?.examples != null
          ? (widget.lessonPlan?.examples ?? []).isNotEmpty
              ? isShowExampleCard()
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: CustomWebView(
                        htmlString: getExampleString(widget.lessonPlan?.examples),
                        headElements: _getStyling(),
                        needHorizotalGestureRecognizer: true,
                        readMore: true,
                        javascriptChannels: {
                          {
                            "name": "ParamsHandler",
                            "callback": (JavascriptMessage message, bool fromPopup) {
                              String msg = message.message;
                              List<String> splitMsg = msg.split("/");
                              String exampleId = splitMsg[2];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContentReportPage(
                                    typeOfContent: ContentReportType.lessonplan,
                                    lpContentReportdata: LpContentReportModal(
                                      lang: lang,
                                      book: widget.lessonPlan?.book,
                                      subject: widget.subjectId,
                                      chapter: widget.chapterId,
                                      isPublisher: widget.lessonPlan?.isPublisher,
                                      publisher: widget.lessonPlan?.publisher,
                                      content: LPReportContent(
                                        lessonPlan: widget.lessonPlan?.id,
                                        example: LPReportItem(contentId: exampleId),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    )
                  : const SizedBox()
              : Container()
          : Container(),
    );
  }
}

String _getStyling() {
  return '''<style>
      body {
        margin: 0;
      }
      .content-part {
          background-color: #f9fafb;
          padding: 16px;
      }
      .card .card-header {
          background: #fdeded;
          border-radius: 10px 10px 0 0;
          display: flex;
          justify-content: space-between;
          align-items: center;
      }
      .info-icon {
          color: #0C9FDA;
          font-size: 13;
      }
      .ml-5{
        margin-left: 5px;
      }
      .card .card-body {
          padding: 0px ;
          margin : 0px:
          background-color: #fff;
          border-radius: 0 0 10px 10px;
      }
      .question{
        display: flex;
        justify-content:space-between;
        align-items: center;
      }
      .qustion-left{
          display: flex;
      }
      .question-text{
          word-wrap: break-word;
          word-break: break-word;
          font-size: 14px;
          line-height: 19px;
          color: #444444;
          font-family: "Nunito", sans-serif;
      }
      .question-text *:first-child{
        margin-top: 0;
        margin-bottom: 0;
      }
      .px-10{
        padding-left: 10px !important;
        padding-right: 10px !important;
      }
      .align-item-top{
        align-items: flex-start !important;
      }
      .que-separate-line{
        width: 100%;
        border: none;
        border-bottom:#DAE3E7 solid 1px;
        margin-top: 0;
        margin-bottom: 0;
      }
      .py-20{
        padding-top: 20px;
        padding-bottom: 20px;
      }
      .mb-10{
        margin-bottom: 10px;
      }
      .mr-5{
        margin-right: 5px;
      }
      .sky-blue-badge{
        background-color: #EBFAFE;
        border-radius: 6px;
        padding: 3px 6px;
      }
      .sky-blue-badge-text{
        font-size: 12px;
        line-height: 1.3;
        color: #0C9FDA;
        font-family: "Nunito", sans-serif;
        font-weight: 700;
        word-break: break-word;
        word-wrap: break-word;
      }
    </style>''';
}

String _getHTMLContent(String content) {
  return '''
  ${_getStyling()}
  <div class="card px-10">
        <div class="card-body">
          $content
      </div>
  </div>
      ''';
}
