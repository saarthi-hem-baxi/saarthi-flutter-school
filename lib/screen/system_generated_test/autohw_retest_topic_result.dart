import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/system_generated_test/retest/retest_concept_topic_list.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../controllers/homework_controller.dart';
import '../../controllers/retest_controller.dart';
import '../../helpers/const.dart';
import '../../model/system_generated_test_model/retest/retest_detail.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/title_description.dart';
import '../home/bottom_footer_navigation.dart';
import '../homework/homework.dart';
import 'autohw_topic_result.dart';
import 'retest/retest_topic_exam.dart';
import 'retest/retest_topic_result.dart';

class AutoHWRetestTopicBasedResultScreenPage extends StatefulWidget {
  final String homeworkId;
  final String subjectId;
  final String chapterId;

  const AutoHWRetestTopicBasedResultScreenPage({Key? key, required this.homeworkId, required this.subjectId, required this.chapterId})
      : super(key: key);

  @override
  State<AutoHWRetestTopicBasedResultScreenPage> createState() => _AutoHWRetestTopicBasedResultScreenPageState();
}

class _AutoHWRetestTopicBasedResultScreenPageState extends State<AutoHWRetestTopicBasedResultScreenPage> with SingleTickerProviderStateMixin {
  final retestsController = Get.put(ReTestController());
  final homeworkController = Get.put(HomeworkController());
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onResume() {
    Future.delayed(Duration.zero, () {
      reloadData();
    });
  }

  void reloadData() async {
    await retestsController.getRetestResult(
      context: context,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
      homeworkId: widget.homeworkId,
    );
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);

    if (homeworkController.isFromNotification ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomFooterNavigation(
            selectedIndex: (homeworkController.isFromPending ?? false) ? 1 : 2,
          ),
        ),
      );
      homeworkController.isFromNotification = false;
    } else {
      // if (homeworkController.isFromPending ?? false) {
      //   Navigator.pop(context);
      // }
      if ((homeworkController.isFromTests ?? false)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomFooterNavigation(
              selectedIndex: (homeworkController.isFromPending ?? false) ? 1 : 2,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeWorkPage(
              subjectData: homeworkController.selectedSubjectData!,
              chapterData: homeworkController.selectedChapterData!,
              topicOrConceptId: homeworkController.selectedTopicOrConceptId!,
              type: homeworkController.selectedType!,
              tab: (homeworkController.isFromPending ?? false) ? 0 : 1,
            ),
          ),
        );
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => Stack(
            children: [
              Positioned(
                left: -125,
                child: Transform.rotate(
                  angle: 0,
                  child: Container(
                    height: 250.h,
                    width: 250.h,
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
                        topRight: Radius.circular(125),
                        bottomRight: Radius.circular(125),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -175,
                bottom: -175,
                child: Transform.rotate(
                  angle: 0,
                  child: Container(
                    height: 250.h,
                    width: 250.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color.fromRGBO(97, 0, 224, 0.2), Color.fromRGBO(97, 0, 224, 0)],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5.h, left: 16.w, bottom: 10.h),
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          "Result",
                          style: sectionTitleTextStyle,
                        ),
                      ),
                      Container(
                        height: 26.h,
                        width: 26.h,
                        margin: EdgeInsets.only(right: 16.w),
                        alignment: AlignmentDirectional.center,
                        decoration: boxDecoration10,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                          ),
                          iconSize: 14.h,
                          color: Colors.black,
                          onPressed: _onBackPressed,
                        ),
                      ),
                    ],
                  ),
                  retestsController.loading.isTrue || retestsController.retestListModel.value.data == null
                      ? const Center(
                          child: LoadingSpinner(color: Colors.blue),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: getScreenWidth(context),
                                  margin: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Topic",
                                        style: sectionTitleTextStyle.merge(
                                          const TextStyle(fontSize: 16, color: sectionTitleColor),
                                        ),
                                      ),
                                      Container(
                                        width: getScreenWidth(context),
                                        height: 47,
                                        margin: const EdgeInsets.only(top: 5),
                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                        decoration: boxDecoration14,
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          retestsController.retestListModel.value.data!.retestDetail?[0].topics?[0].topic?.name ?? "",
                                          style:
                                              textTitle16WhiteBoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      OnlineAutoHwTestCard(
                                        retestData: (retestsController.retestListModel.value.data?.retestDetail ?? [])[0],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AutoHWTopicBasedResultScreenPage(
                                                  homeworkId: widget.homeworkId,
                                                  subjectId: widget.subjectId,
                                                  chapterId: widget.chapterId,
                                                  fromRetestList: true),
                                            ),
                                          ).then(
                                            (value) => {onResume()},
                                          );
                                        },
                                      ),
                                      ...(retestsController.retestListModel.value.data?.retestDetail ?? []).reversed.toList().mapIndexed(
                                        (index, item) {
                                          var retestData = item;
                                          return index == (retestsController.retestListModel.value.data?.retestDetail ?? []).length - 1
                                              ? const SizedBox()
                                              : RetestListItem(
                                                  retestData: retestData,
                                                  onTap: () {
                                                    if (retestData.topicStatus == null) {
                                                      retestsController
                                                          .getRetestDetail(
                                                        context: context,
                                                        subjectId: widget.subjectId,
                                                        chapterId: widget.chapterId,
                                                        homeworkId: widget.homeworkId,
                                                        retestHomeworkId: retestData.id!,
                                                      )
                                                          .then((value) {
                                                        retestsController
                                                            .getReTest(
                                                          context: context,
                                                          subjectId: widget.subjectId,
                                                          chapterId: widget.chapterId,
                                                          homeworkId: widget.homeworkId,
                                                          retestDetail: retestData,
                                                          lang: retestsController.retestListModel.value.data?.lang ?? "",
                                                          map: {},
                                                          isFirst: true,
                                                        )
                                                            .then(
                                                          (value) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ResTestTopicWiseExamPage(
                                                                  //This is Concept Based Exam
                                                                  subjectId: widget.subjectId,
                                                                  chapterId: widget.chapterId,
                                                                  homeworkId: widget.homeworkId,
                                                                  retestHomeworkId: retestData.id!,
                                                                ),
                                                              ),
                                                            ).then((value) => {onResume()});
                                                          },
                                                        );
                                                      });
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => RetestTopicBasedResultScreenPage(
                                                            homeworkId: widget.homeworkId,
                                                            subjectId: widget.subjectId,
                                                            chapterId: widget.chapterId,
                                                            retestHomeworkId: retestData.id!,
                                                          ),
                                                        ),
                                                      ).then(
                                                        (value) => {onResume()},
                                                      );
                                                    }
                                                  },
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 64.h),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              !retestsController.loading.isTrue || retestsController.retestListModel.value.data != null
                  ? (retestsController.retestListModel.value.data!
                              .retestDetail![retestsController.retestListModel.value.data!.retestDetail!.length - 1].topicStatus !=
                          "cleared")
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          width: getScreenWidth(context),
                          child: SafeArea(
                            top: false,
                            child: Container(
                              color: Colors.white,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => {
                                  if (!isOnGoing())
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RetestConceptTopicList(
                                            homeworkId: widget.homeworkId,
                                            subjectId: widget.subjectId,
                                            chapterId: widget.chapterId,
                                            topicOrConcept: "topic",
                                          ),
                                        ),
                                      ).then((value) {
                                        onResume();
                                      })
                                    }
                                },
                                child: Container(
                                  height: 46.h,
                                  margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
                                  decoration: BoxDecoration(
                                    // color: Colors.amber,
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: colorDropShadowLight,
                                        blurRadius: 1,
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                    gradient: isOnGoing() ? grayGradient : pinkGradient,
                                  ),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Center(
                                    child: Text(
                                      "Retest",
                                      style: textTitle18WhiteBoldStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bool isOnGoing() {
    var retestData = (retestsController.retestListModel.value.data?.retestDetail ?? []);
    return ((retestData[retestData.length - 1].started?.status ?? false) && !(retestData[retestData.length - 1].completed?.status ?? false) ||
        !(retestData[retestData.length - 1].started?.status ?? false) && !(retestData[retestData.length - 1].completed?.status ?? false));
  }
}

class RetestListItem extends StatelessWidget {
  final RetestDetail retestData;
  final VoidCallback onTap;
  const RetestListItem({
    Key? key,
    required this.retestData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        width: getScreenWidth(context),
        decoration: boxDecoration14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      retestData.name ?? "",
                      style: textTitle18WhiteBoldStyle.merge(
                        const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: colorWebPanelDarkText,
                        ),
                      ),
                    ),
                    ((retestData.started?.status ?? false) && (retestData.completed?.status ?? false))
                        ? Text(
                            retestData.clearedTopicConceptCount.toString() + " / " + retestData.totalTopicConceptCount.toString() + " Cleared",
                            style: sectionTitleTextStyle.merge(
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                            ),
                          )
                        : const SizedBox(),
                    (retestData.started?.status ?? false) == true && !(retestData.completed?.status ?? false)
                        ? Text(
                            "Ongoing",
                            style: sectionTitleTextStyle.merge(
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorWebPanelDarkText),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                (retestData.started?.status ?? false) && !(retestData.completed?.status ?? false)
                    ? Column(
                        children: [
                          Container(
                            height: 48.h,
                            width: 48.h,
                            padding: EdgeInsets.all(13.h),
                            decoration: BoxDecoration(
                              gradient: purpleGradient,
                              borderRadius: BorderRadius.all(
                                Radius.circular(24.h),
                              ),
                            ),
                            child: SvgPicture.asset(
                              imageAssets + 'tests/continueprecap.svg',
                              height: 23,
                              width: 23,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Resume",
                              style: textTitle10BoldStyle.merge(
                                const TextStyle(color: sectionTitleColor),
                              ),
                            ),
                          ),
                        ],
                      )
                    : !(retestData.started?.status ?? false) && !(retestData.completed?.status ?? false)
                        ? Column(
                            children: [
                              Container(
                                height: 48.h,
                                width: 48.h,
                                padding: EdgeInsets.all(13.h),
                                decoration: BoxDecoration(
                                  gradient: purpleGradient,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24.h),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  imageAssets + 'tests/start_rocket.svg',
                                  height: 23,
                                  width: 23,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Start",
                                  style: textTitle10BoldStyle.merge(
                                    const TextStyle(color: sectionTitleColor),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : retestData.topicStatus?.toLowerCase() == "uncleared"
                            ? Container(
                                height: 48.h,
                                width: 48.h,
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                  gradient: redGradient,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24.h),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                  iconSize: 24.h,
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              )
                            : retestData.topicStatus?.toLowerCase() == "cleared"
                                ? Container(
                                    height: 48.h,
                                    width: 48.h,
                                    alignment: AlignmentDirectional.center,
                                    decoration: BoxDecoration(
                                      gradient: greenGradient,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24.h),
                                      ),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.done,
                                      ),
                                      iconSize: 24.h,
                                      color: Colors.white,
                                      onPressed: () {},
                                    ),
                                  )
                                : SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: LiquidCircularProgressIndicator(
                                      value: (((retestData.clearedTopicConceptCount ?? 0) * 100) / (retestData.concepts?.length ?? 1)) /
                                          100, // Defaults to 0.5.
                                      valueColor: const AlwaysStoppedAnimation(colorSky), // Defaults to the current Theme's accentColor.
                                      backgroundColor: colorgray249, // Defaults to the current Theme's backgroundColor.

                                      // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                    ),
                                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnlineAutoHwTestCard extends StatelessWidget {
  final RetestDetail retestData;
  final VoidCallback onTap;
  const OnlineAutoHwTestCard({Key? key, required this.retestData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        width: getScreenWidth(context),
        decoration: boxDecoration14,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                retestData.name ?? "",
                                style: textTitle18WhiteBoldStyle.merge(
                                  const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: colorWebPanelDarkText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      retestData.type == "system-generated" || retestData.type == "online-test"
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 5.w,
                                right: 5.w,
                              ),
                              height: 22.h,
                              padding: EdgeInsets.all(5.h),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: colorPurpleLight,
                              ),
                              child: Text(
                                getTypeDesc((retestData.type ?? "").toLowerCase()) == 'Auto HW' ? 'Auto HW' : 'Online Test',
                                style: textTitle12BoldStyle.merge(
                                  const TextStyle(
                                    color: colorPurple,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Expanded(
                        child: Wrap(children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 5.w,
                              right: 5.w,
                            ),
                            padding: EdgeInsets.all(5.h),
                            child: TitleDescription(
                              title: "Assign",
                              desc: retestData.assigned?.date != null ? DateFormat("d MMM").format(retestData.assigned!.date!) : "-",
                              titleStyle: textTitle8BoldStyle.merge(
                                const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                              ),
                              descStyle: textTitle12BoldStyle.merge(
                                const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          retestData.completed?.date != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: 5.w,
                                    right: 5.w,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: TitleDescription(
                                    title: "Attend",
                                    desc: retestData.completed?.date != null ? DateFormat("d MMM").format(retestData.completed!.date!) : "-",
                                    titleStyle: textTitle8BoldStyle.merge(
                                      const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal),
                                    ),
                                    descStyle: textTitle12BoldStyle.merge(
                                      const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 48.h,
                  width: 48.h,
                  padding: EdgeInsets.all(13.h),
                  decoration: BoxDecoration(
                    gradient: retestData.completed?.status ?? false
                        ? pinkGradient
                        : retestData.started?.status == true
                            ? pinkGradient
                            : purpleGradient,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.h),
                    ),
                  ),
                  child: SvgPicture.asset(
                    imageAssets +
                        ((retestData.completed?.status ?? false)
                            ? 'tests/result.svg'
                            : retestData.started?.status == true
                                ? 'tests/continueprecap.svg'
                                : 'tests/start_rocket.svg'),
                    height: 23,
                    width: 23,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    (retestData.completed?.status ?? false)
                        ? "Result"
                        : retestData.started?.status == true
                            ? "Resume"
                            : "Start",
                    style: textTitle10BoldStyle.merge(
                      const TextStyle(color: sectionTitleColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
