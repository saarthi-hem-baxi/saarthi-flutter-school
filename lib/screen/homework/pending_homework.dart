import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/refresh_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/homeworks_cards.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

class PendingHomeWorkPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chapterData;
  final String topicOrConceptId;
  final ByHomeworkTypes type;

  const PendingHomeWorkPage({
    Key? key,
    required this.subjectData,
    required this.chapterData,
    required this.topicOrConceptId,
    required this.type,
  }) : super(key: key);

  @override
  State<PendingHomeWorkPage> createState() => _PendingHomeWorkPageState();
}

class _PendingHomeWorkPageState extends State<PendingHomeWorkPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  var homeWorkController = Get.put(HomeworkController());
  var refreshController = Get.put(RefreshController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(
      Duration.zero,
      () {
        _refreshData();
        _checkRefrshData();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    Get.delete<RefreshController>();
  }

  void onResume() {
    _refreshData();
  }

  _checkRefrshData() {
    refreshController.refreshHomeWork.listen((p0) {
      _refreshData();
    });
  }

  _refreshData() async {
    if (widget.type == ByHomeworkTypes.chapter) {
      await homeWorkController.getPendingHomeworkByChapter(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
      );
    } else if (widget.type == ByHomeworkTypes.topic) {
      await homeWorkController.getPendingHomeworkByTopic(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
        topicId: widget.topicOrConceptId,
      );
    } else if (widget.type == ByHomeworkTypes.concept) {
      await homeWorkController.getPendingHomeworkByConcept(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
        conceptId: widget.topicOrConceptId,
      );
    }
    savePendingHWID(homeWorkController.homeworkPendingModel.value.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => homeWorkController.pendingLoading.isTrue
            ? const Center(
                child: LoadingSpinner(),
              )
            : (homeWorkController.homeworkPendingModel.value.data ?? []).isEmpty
                ? const NoDataCard(
                    title: "Oops...\n No Homework found",
                    description: "No Homework found \nkindly contact your teacher.",
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...(homeWorkController.homeworkPendingModel.value.data ?? [])
                            .map(
                              (classworkData) => HomeworksCards(
                                homeworkDatum: classworkData,
                                subjectData: widget.subjectData,
                                chaptersData: widget.chapterData,
                                topicOrConceptId: widget.topicOrConceptId,
                                type: widget.type,
                                isPending: true,
                                refreshData: _refreshData,
                              ),
                            )
                            .toList(),
                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  void savePendingHWID(List<HomeworkDatum>? data) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ids = [];
    for (HomeworkDatum element in (data ?? [])) {
      if (element.type == 'system-generated') {
        ids.add(element.id ?? '');
      }
    }

    // dynamic autoHWIds = prefs.setStringList('autoHWIds', ids);

    // List<String>? list = prefs.getStringList('autoHWIds');
    // print('ids length ${list?.length}');
  }
}
