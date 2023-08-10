import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/roadmap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/chapters_configuration.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/topics.dart';
import 'package:saarthi_pedagogy_studentapp/screen/homework/homework.dart';
import 'package:saarthi_pedagogy_studentapp/screen/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/measured_size.dart';
import '../../productvideotour/learn_introvideo_screen.dart';

class TopicMilestone extends StatefulWidget {
  final int mileStoneIndex;
  final GlobalKey milestoneKey;
  final GlobalKey containerKey;
  final MileStoneAlignment alignment;
  final Topics topicData;
  final ChaptersConfiguration? chapterConfiguration;
  final VoidCallback roadmapUserTrackFunc;

  const TopicMilestone({
    Key? key,
    required this.mileStoneIndex,
    required this.milestoneKey,
    required this.containerKey,
    required this.alignment,
    required this.topicData,
    this.chapterConfiguration,
    required this.roadmapUserTrackFunc,
  }) : super(key: key);

  @override
  State<TopicMilestone> createState() => _TopicMilestoneState();
}

class _TopicMilestoneState extends State<TopicMilestone> {
  final roadMapController = Get.put(RoadmapController());
  final dashBoardController = Get.put(LearnController());
  final authController = Get.put(AuthController());
  Size mileStoneWidthHeight = const Size(0, 0);

  onResume() {
    roadMapController.refreshRoadMapData(context);
    widget.roadmapUserTrackFunc();
    _checkisTourEnable();
  }

  bool showIsPageNo(Topics topics) {
    if (topics.topic?.startPageNumber != null) {
      return true;
    }
    return false;
  }

  String getPageNo(Topics topics) {
    String string = '';
    if (topics.topic?.startPageNumber != null && topics.topic?.endPageNumber != null) {
      string = '${topics.topic?.startPageNumber} - ${topics.topic?.endPageNumber}';
    } else if (topics.topic?.startPageNumber != null) {
      string = '${topics.topic?.startPageNumber}';
    }
    return string;
  }

  _checkisTourEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTourOnChapterScreen = prefs.getBool(isTourOnChapterScreenkey);
    isTourOnScreenEnabled = prefs.getBool(isTourOnScreenEnabledkey);
    dashBoardController.getIntroVideos(context, 'CHAPTER LIST').then((value) {
      setState(() {
        if (dashBoardController.introVideo.value.data!.videos!.isNotEmpty) {
          dashBoardController.tourvideoKey.value = isTourOnChapterScreenkey;
          dashBoardController.tourCode.value = 'CHAPTER LIST';
          if (isTourOnChapterScreen == null || isTourOnChapterScreen == false) {
            videoControl = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnIntroVideoScreen(),
              ),
            ).then((value) {
              if (isVideoComplete!) {
                dashBoardController.updateProductTourVideoStatus(
                    studentUserId: authController.currentUser.value.id!.toString(), tourCode: 'CHAPTER LIST', isView: true);
                prefs.setBool(isTourOnChapterScreenkey, true);
              }
            });
          }
        } else {
          isTourOnScreenEnabled = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double minMileStoneWidth = getMinMilestoneWidth(context);

    var mileStoneIcon = SvgPicture.asset(
      imageAssets + 'roadmap/roadmap_topic.svg',
      height: iconSize,
      width: iconSize,
      fit: BoxFit.contain,
      key: widget.milestoneKey,
    );

    return Container(
      key: widget.containerKey,
      width: getScreenWidth(context),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: milestoneMarginVertical,
        bottom: milestoneMarginVertical,
      ),
      child: Row(
        mainAxisAlignment: widget.alignment == MileStoneAlignment.right ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...(widget.alignment == MileStoneAlignment.left
              ? [
                  mileStoneIcon,
                  const SizedBox(width: spacing),
                ]
              : []),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: minMileStoneWidth - iconSize - spacing,
                child: Text(
                  widget.topicData.topic?.name ?? "",
                  style: textTitle16WhiteBoldStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              (widget.topicData.topic?.hasGrammar ?? false)
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                      margin: (widget.topicData.topic?.hasGrammar ?? false) ? EdgeInsets.only(top: 5.h, bottom: 2.h) : null,
                      decoration: BoxDecoration(
                        color: const Color(0xffEB4799),
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Text(
                        'Grammar',
                        style: textTitle12RegularStyle.merge(const TextStyle(fontWeight: FontWeight.w700)),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 5),
              Stack(
                children: [
                  showIsPageNo(widget.topicData)
                      ? PageNoWidget(
                          mileStoneWidthHeight: mileStoneWidthHeight,
                          pageNo: getPageNo(widget.topicData),
                        )
                      : const SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      boxShadow: [BoxShadow(blurRadius: 4, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.25))],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(cardRadius),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: MeasureSize(
                      onChange: ((size) => {
                            setState(() {
                              mileStoneWidthHeight = size;
                            })
                          }),
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            widget.topicData.topic?.status == "active"
                                ? GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LessonPlanPage(
                                            subjectId: roadMapController.selectedSubjectData?.id ?? "",
                                            chapterId: roadMapController.selectedChaptersData?.id ?? "",
                                            topicid: widget.topicData.topic?.id ?? "-1",
                                            title: widget.topicData.topic?.name ?? "",
                                            type: LPQBType.topic,
                                          ),
                                        ),
                                      ).then((value) => {onResume()})
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: SvgPicture.asset(
                                              imageAssets + 'brain.svg',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            'Learn',
                                            style: textTitle14BoldStyle.merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: colorWebPanelDarkText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            ...(widget.chapterConfiguration?.configuration?.homework == true ||
                                    widget.chapterConfiguration?.configuration?.autoHomework == true
                                ? [
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Color.fromRGBO(142, 142, 142, 0.20),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWorkPage(
                                              subjectData: roadMapController.selectedSubjectData!,
                                              chapterData: roadMapController.selectedChaptersData!,
                                              topicOrConceptId: widget.topicData.topic?.id ?? "-1",
                                              type: ByHomeworkTypes.topic,
                                            ),
                                          ),
                                        ).then((value) => {onResume()}),
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: SvgPicture.asset(
                                                imageAssets + 'hw_small.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              'Homework',
                                              style: textTitle14BoldStyle.merge(
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
                                  ]
                                : []),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ...(widget.alignment == MileStoneAlignment.right
              ? [
                  const SizedBox(width: spacing),
                  mileStoneIcon,
                ]
              : []),
        ],
      ),
    );
  }
}

class PageNoWidget extends StatelessWidget {
  const PageNoWidget({Key? key, required this.mileStoneWidthHeight, required this.pageNo}) : super(key: key);
  final Size mileStoneWidthHeight;
  final String pageNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mileStoneWidthHeight.width,
      height: mileStoneWidthHeight.height != 0 ? mileStoneWidthHeight.height + 20.h : 0,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xff43A4CB),
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Page No.',
              style: textTitle8BoldStyle.merge(
                const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextSpan(
              text: " $pageNo",
              style: textTitle14BoldStyle.merge(
                const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
