import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/refresh_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/homeworks_cards.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

class CompletedHomeWorkPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chapterData;
  final String topicOrConceptId;
  final ByHomeworkTypes type;
  const CompletedHomeWorkPage({
    Key? key,
    required this.subjectData,
    required this.chapterData,
    required this.topicOrConceptId,
    required this.type,
  }) : super(key: key);

  @override
  State<CompletedHomeWorkPage> createState() => _CompletedHomeWorkPageState();
}

class _CompletedHomeWorkPageState extends State<CompletedHomeWorkPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  var homeWorkController = Get.put(HomeworkController());
  var refreshController = Get.put(RefreshController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration.zero, () {
      _refreshData();
      _checkRefrshData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    Get.delete<RefreshController>();
  }

  _checkRefrshData() {
    refreshController.refreshHomeWork.listen((p0) {
      _refreshData();
    });
  }

  _refreshData() {
    if (widget.type == ByHomeworkTypes.chapter) {
      homeWorkController.getCompletedHomeworkByChapter(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
      );
    } else if (widget.type == ByHomeworkTypes.topic) {
      homeWorkController.getCompletedHomeworkByTopic(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
        topicId: widget.topicOrConceptId,
      );
    } else if (widget.type == ByHomeworkTypes.concept) {
      homeWorkController.getCompletedHomeworkByConcept(
        subjectId: widget.subjectData.id!,
        chapterId: widget.chapterData.id!,
        conceptId: widget.topicOrConceptId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => homeWorkController.completedLoading.isTrue
            ? const Center(
                child: LoadingSpinner(),
              )
            : (homeWorkController.homeworkCompletedModel.value.data ?? []).isEmpty
                ? const NoDataCard(
                    title: "Oops...\n No Homework found",
                    description: "No Homework found \nkindly contact your teacher.",
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...homeWorkController.homeworkCompletedModel.value.data!
                            .map((homeworkData) => HomeworksCards(
                                homeworkDatum: homeworkData,
                                subjectData: widget.subjectData,
                                chaptersData: widget.chapterData,
                                topicOrConceptId: widget.topicOrConceptId,
                                type: widget.type,
                                isPending: false,
                                refreshData: _refreshData))
                            .toList(),
                        SizedBox(height: 70.h)
                      ],
                    ),
                  ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
