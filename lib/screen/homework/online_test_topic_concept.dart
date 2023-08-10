import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found_text.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../widgets/common/gradient_circle.dart';
import '../../widgets/common/header.dart';
import 'online_test_exam.dart';
import 'online_test_result.dart';

class HWOnlineTestTopicsPage extends StatefulWidget {
  const HWOnlineTestTopicsPage({
    Key? key,
    required this.title,
    required this.homeworkId,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final String title;
  final String homeworkId;
  final String subjectId;
  final String chapterId;

  @override
  State<HWOnlineTestTopicsPage> createState() => _HWOnlineTestTopicsPageState();
}

class _HWOnlineTestTopicsPageState extends State<HWOnlineTestTopicsPage> {
  String type = "concept";
  var homeWorkController = Get.put(HomeworkController());
  final testsController = Get.put(PrecapController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      refreshData();
    });
  }

  void onResume() {
    refreshData();
  }

  void refreshData() async {
    testsController.isKeylearningScreen = true;
    testsController.totalKeyLearnings = 0;
    testsController.totalKeylerningExamPer = 0.0;
    testsController.totalKeyLearningsPercentage = 0.0;

    await homeWorkController.getHomeworkDetail(
      context: context,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: Obx(
            () => Stack(
              children: [
                const Positioned(
                  left: -150,
                  child: GradientCircle(
                    gradient: circleOrangeGradient,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(125),
                      bottomRight: Radius.circular(125),
                    ),
                  ),
                ),
                Positioned(
                  right: -100.h,
                  bottom: -80.h,
                  child: const GradientCircle(
                    gradient: circlePurpleGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(125),
                      bottomLeft: Radius.circular(125),
                    ),
                  ),
                ),
                SizedBox(
                  height: getScrenHeight(context),
                ),
                homeWorkController.loading.isTrue
                    ? SizedBox(
                        width: getScreenWidth(context),
                        height: getScrenHeight(context),
                        child: const Center(child: LoadingSpinner()),
                      )
                    : Column(
                        children: [
                          HeaderCard(
                            title: widget.title,
                            backEnabled: true,
                            onTap: () => {Navigator.pop(context)},
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          homeWorkController.homeworkDetailModel.value.data == null ||
                                  homeWorkController.homeworkDetailModel.value.data?.topics == null
                              ? const SizedBox()
                              : homeWorkController.homeworkDetailModel.value.data!.topics!.isEmpty
                                  ? const Center(child: NoDataFoundText(title: "No Topic/Concept Found !"))
                                  : Container(
                                      margin: EdgeInsets.all(16.w),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorDropShadow,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: homeWorkController.homeworkDetailModel.value.data?.topics
                                                ?.mapIndexed(
                                                  (index, item) => TopicConceptListTile(
                                                    type: item.type ?? "",
                                                    name: item.topic?.name ?? "",
                                                    isLastItem: index == homeWorkController.homeworkDetailModel.value.data!.topics!.length - 1,
                                                  ),
                                                )
                                                .toList() ??
                                            [],
                                      ),
                                    )
                        ],
                      )
              ],
            ),
          )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(
          () => homeWorkController.loading.isTrue
              ? const SizedBox()
              : GestureDetector(
                  onTap: () {
                    bool continueExam = homeWorkController.homeworkDetailModel.value.data?.started?.status == true &&
                        (homeWorkController.homeworkDetailModel.value.data?.completed?.status == null ||
                            homeWorkController.homeworkDetailModel.value.data?.completed?.status == false);

                    homeWorkController.getOnlineTestData(
                        subjectId: widget.subjectId,
                        chapterId: widget.chapterId,
                        isFirst: true,
                        isSubmitBtnPressed: false,
                        homeworkId: homeWorkController.homeworkDetailModel.value.data?.id ?? "",
                        dataMap: {
                          "lang": homeWorkController.homeworkDetailModel.value.data?.lang ?? "",
                          "continueExam": continueExam,
                        }).then((value) {
                      if (value == HWTestResposponseAction.next || value == HWTestResposponseAction.noQuestion) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HWOnlineTestExamPage(
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
                              homeworkDetailData: homeWorkController.homeworkDetailModel.value,
                              title: widget.title,
                              langCode: homeWorkController.homeworkDetailModel.value.data?.lang ?? "en_US",
                              noQuestion: value == HWTestResposponseAction.noQuestion,
                            ),
                          ),
                        ).then((value) => {onResume()});
                      }

                      if (value == HWTestResposponseAction.completed) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HWOnlineTestResultPage(
                              subjectId: widget.subjectId,
                              chapterId: widget.chapterId,
                              homeworkId: widget.homeworkId,
                            ),
                          ),
                        ).then((value) => {onResume()});
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    height: 46,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: homeWorkController.homeworkDetailModel.value.data?.started?.status == true ? pinkGradient : purpleGradient,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homeWorkController.homeworkDetailModel.value.data?.started?.status == true ? "Continue Homework" : "Start Homework",
                          style: textTitle18WhiteBoldStyle,
                        ),
                        SvgPicture.asset(
                          imageAssets +
                              (homeWorkController.homeworkDetailModel.value.data?.started?.status == true
                                  ? "tests/continueprecap.svg"
                                  : "tests/start_rocket.svg"),
                          height: 23,
                          width: 23,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class TopicConceptListTile extends StatelessWidget {
  const TopicConceptListTile({Key? key, required this.type, required this.name, required this.isLastItem}) : super(key: key);

  final String type;
  final String name;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                ),
              ),
              type != "topic"
                  ? Container(
                      width: 25.w,
                      height: 25.w,
                      padding: EdgeInsets.all(3.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: type == "topic" ? colorTealLight : colorOrangeLight,
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Text(
                        type == "topic" ? "" : "C",
                        style: textTitle16WhiteBoldStyle.merge(TextStyle(color: type == "topic" ? colorTeal : colorOrange)),
                      ),
                    )
                  : SizedBox(
                      height: 25.w,
                    ),
            ],
          ),
        ),
        isLastItem
            ? const SizedBox()
            : Divider(
                height: 0.h,
              ),
      ],
    );
  }
}
