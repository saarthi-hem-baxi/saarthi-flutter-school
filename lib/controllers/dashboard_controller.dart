import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:saarthi_pedagogy_studentapp/model/dashboard/learn_o_meter_modal.dart';
import 'package:saarthi_pedagogy_studentapp/model/dashboard/learning_outcome_subject.dart';
import 'package:saarthi_pedagogy_studentapp/model/dashboard/learning_time_details_subject.dart';
import 'package:saarthi_pedagogy_studentapp/model/dashboard/lo_multi_line_month.dart';
import 'package:saarthi_pedagogy_studentapp/model/dashboard/lo_multi_line_quater.dart';
import 'package:saarthi_pedagogy_studentapp/model/dashboard/lo_multi_line_week.dart';

import '../helpers/network.dart';
import '../helpers/urls.dart';
import '../model/dashboard/learnig_time_temp_modal.dart';
import '../model/dashboard/learning_outcome_topic_concept.dart';
import '../model/dashboard/learning_time.dart';
import '../model/dashboard/learning_time_details_chapters.dart';
import '../model/dashboard/learning_time_multi_line_month.dart';
import '../model/dashboard/learning_time_multi_line_quater.dart';
import '../model/dashboard/learning_time_multi_line_week.dart';
import '../model/dashboard/lo_meter_details_chapter.modal.dart';
import '../model/dashboard/lo_meter_details_concept.dart';
import '../model/dashboard/lo_meter_details_subjects.modal.dart';

class DashboardController extends GetxController {
  APIClient apiClient = APIClient();

  Rx<bool> loMSubjectsLoading = false.obs;
  Rx<bool> loMChapterLoading = false.obs;
  Rx<bool> loMConceptLoading = false.obs;
  Rx<bool> isLoSubjectLoaded = false.obs;
  Rx<bool> isLoChapterLoaded = false.obs;
  Rx<bool> loMultiChartLoading = false.obs;
  Rx<bool> learningTimeMultiChartLoading = false.obs;
  Rx<bool> learningTimeSubjectsLoading = false.obs;
  Rx<bool> learningTimeChaptersLoading = false.obs;
  Rx<bool> isLearningTimeSubjectLoaded = false.obs;
  Rx<bool> isLearningTimeChapterLoaded = false.obs;
  Rx<bool> learningTimeLoading = false.obs;
  Rx<bool> learningTimeTempLoading = false.obs;

  Rx<LearnOMeterModal> learnOMeterModal = LearnOMeterModal().obs;
  Rx<LearningOutcomeSubjectModal> learningOutComeModal = LearningOutcomeSubjectModal().obs;
  Rx<LoMeterDetailsSubjectModal> loMDetailsSubjectsData = LoMeterDetailsSubjectModal().obs;
  Rx<LoMeterDetailsChapterModal> loMDetailsChapterData = LoMeterDetailsChapterModal().obs;
  Rx<LoMeterDetailsConceptModal> loMDetailsConceptData = LoMeterDetailsConceptModal().obs;
  Rx<LearningOutcomeTopicConceptModal> learningOutcomeConceptData = LearningOutcomeTopicConceptModal().obs;
  Rx<LoMultiLineChartWeekModal> loMultiLineWeekData = LoMultiLineChartWeekModal().obs;
  Rx<LoMultiLineChartQuaterModal> loMultiLineQuaterData = LoMultiLineChartQuaterModal().obs;
  Rx<LoMultiLineChartMonthModal> loMultiLineMonthData = LoMultiLineChartMonthModal().obs;
  Rx<LearningTimeMultiLineChartWeekModal> learningTimeMultiLineWeekData = LearningTimeMultiLineChartWeekModal().obs;
  Rx<LearningTimeMultiLineChartQuaterModal> learningTimeMultiLineQuaterData = LearningTimeMultiLineChartQuaterModal().obs;
  Rx<LearningTimeMultiLineChartMonthModal> learningTimeMultiLineMonthData = LearningTimeMultiLineChartMonthModal().obs;
  Rx<LearningTimeDetailsSubjectsModal> learningTimeSubjectData = LearningTimeDetailsSubjectsModal().obs;
  Rx<LearningTimeDetailsChaptersModal> learningTimeChapterData = LearningTimeDetailsChaptersModal().obs;
  Rx<LearningTimeChartModal> learningTimeData = LearningTimeChartModal().obs;
  Rx<LearningTimeTempChartModal> learningTimeTempData = LearningTimeTempChartModal().obs;

  getLearnOMeterData() async {
    try {
      dio.Response response = await apiClient.getData(url: APIUrls().dashboardUrl + 'learn-o-meter');

      if (response.statusCode == 200) {
        learnOMeterModal.value = LearnOMeterModal.fromJson(response.data['data']);
        return learnOMeterModal.value;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learn-O-meter data');
    }
  }

  getLearningOutCome() async {
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'lo-subject-chart',
      );

      if (response.statusCode == 200) {
        learningOutComeModal.value = LearningOutcomeSubjectModal.fromJson(response.data['data']);
        return learningOutComeModal.value;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome data');
    }
  }

  getLOMeterDetailsSubjects() async {
    loMSubjectsLoading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'lo-subject-sort-chart',
      );

      if (response.statusCode == 200) {
        loMDetailsSubjectsData.value = LoMeterDetailsSubjectModal.fromJson(response.data['data']);
        loMSubjectsLoading.value = false;
        isLoSubjectLoaded.value = true;
        if (loMDetailsSubjectsData.value.chartData != null && (loMDetailsSubjectsData.value.chartData ?? []).isNotEmpty) {
          getLOMeterDetailsChapters(subjectId: loMDetailsSubjectsData.value.chartData?.first.subjectId ?? "");
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome subject data');
    }
  }

  getLOMeterDetailsChapters({required String subjectId}) async {
    loMChapterLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'lo-chapter-chart/subject/$subjectId',
      );

      if (response.statusCode == 200) {
        loMDetailsChapterData.value = LoMeterDetailsChapterModal.fromJson(response.data['data']);
        isLoChapterLoaded.value = true;
        loMChapterLoading.value = false;

        if (loMDetailsChapterData.value.chartData != null && (loMDetailsChapterData.value.chartData ?? []).isNotEmpty) {
          getLOMeterDetailsConceptsTable(
            chapterId: loMDetailsChapterData.value.chartData?.first.chapterId ?? "",
            subjectId: loMDetailsChapterData.value.chartData?.first.subjectId ?? "",
          );
        }
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome chapter data');
    }
  }

  getLOMeterDetailsConceptsTable({required String subjectId, required String chapterId}) async {
    loMConceptLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'lo-concept-tabel/subject/$subjectId/chapter/$chapterId',
      );

      if (response.statusCode == 200) {
        learningOutcomeConceptData.value = LearningOutcomeTopicConceptModal.fromJson(response.data['data']);
        loMConceptLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome concept data');
    }
  }
  // getLOMeterDetailsConceptsTable({required String subjectId, required String chapterId}) async {
  //   loMConceptLoading.value = true;
  //   try {
  //     dio.Response response = await apiClient.getData(
  //       url: APIUrls().dashboardUrl + 'learning-outcome-subject-chapter-concept-detail/subject/$subjectId/chapter/$chapterId',
  //     );

  //     if (response.statusCode == 200) {
  //       loMDetailsConceptData.value = LoMeterDetailsConceptModal.fromJson(response.data['data']);
  //       loMConceptLoading.value = false;
  //     } else {}
  //   } catch (error) {
  //     Fluttertoast.showToast(msg: 'Cannot get learning outcome concept data');
  //   }
  // }

  Future getLOMultiLineChartWeekWise() async {
    loMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-outcome-growth-chart/week',
      );

      if (response.statusCode == 200) {
        loMultiLineWeekData.value = LoMultiLineChartWeekModal.fromJson(response.data['data']);
        loMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome week wise data');
    }
  }

  Future getLOMultiLineChartQuaterWise() async {
    loMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-outcome-growth-chart/quarterly',
      );

      if (response.statusCode == 200) {
        loMultiLineQuaterData.value = LoMultiLineChartQuaterModal.fromJson(response.data['data']);
        loMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome quater wise data');
    }
  }

  Future getLOMultiLineChartMonthWise() async {
    loMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-outcome-growth-chart/month',
      );

      if (response.statusCode == 200) {
        loMultiLineMonthData.value = LoMultiLineChartMonthModal.fromJson(response.data['data']);
        loMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome quater wise data');
    }
  }

  Future getLearningTimeMultiLineChartWeekWise() async {
    learningTimeMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-time-growth-chart/week',
      );

      if (response.statusCode == 200) {
        learningTimeMultiLineWeekData.value = LearningTimeMultiLineChartWeekModal.fromJson(response.data['data']);
        learningTimeMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome week wise data');
    }
  }

  Future getLearningTimeMultiLineChartQuaterWise() async {
    learningTimeMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-time-growth-chart/quarterly',
      );

      if (response.statusCode == 200) {
        learningTimeMultiLineQuaterData.value = LearningTimeMultiLineChartQuaterModal.fromJson(response.data['data']);
        learningTimeMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome quater wise data');
    }
  }

  Future getLeaningTimeMultiLineChartMonthWise() async {
    learningTimeMultiChartLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-time-growth-chart/month',
      );

      if (response.statusCode == 200) {
        learningTimeMultiLineMonthData.value = LearningTimeMultiLineChartMonthModal.fromJson(response.data['data']);
        learningTimeMultiChartLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning outcome quater wise data');
    }
  }

  Future getLearningTimeDetailsSubjects() async {
    learningTimeSubjectsLoading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'subject-learning-time',
      );

      if (response.statusCode == 200) {
        learningTimeSubjectData.value = LearningTimeDetailsSubjectsModal.fromJson(response.data['data']);
        learningTimeSubjectsLoading.value = false;
        isLearningTimeSubjectLoaded.value = true;
        if (learningTimeSubjectData.value.chartData != null && (learningTimeSubjectData.value.chartData ?? []).isNotEmpty) {
          getLearningTimeDetailsChapters(subjectId: learningTimeSubjectData.value.chartData?.first.subjectId ?? "");
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning time subject data');
    }
  }

  Future getLearningTimeDetailsChapters({required String subjectId}) async {
    learningTimeChaptersLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'chapter-learning-time/subject/$subjectId',
      );

      if (response.statusCode == 200) {
        learningTimeChapterData.value = LearningTimeDetailsChaptersModal.fromJson(response.data['data']);
        learningTimeChaptersLoading.value = false;
        isLearningTimeChapterLoaded.value = true;
        // if (loMDetailsChapterData.value.chartData != null && (loMDetailsChapterData.value.chartData ?? []).isNotEmpty) {
        //   getLOMeterDetailsConceptsTable(
        //     chapterId: loMDetailsChapterData.value.chartData?.first.chapterId ?? "",
        //     subjectId: loMDetailsChapterData.value.chartData?.first.subjectId ?? "",
        //   );
        // }
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning time chapter data');
    }
  }

  Future getLearningTime() async {
    learningTimeLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-time-line-chart',
      );

      if (response.statusCode == 200) {
        learningTimeData.value = LearningTimeChartModal.fromJson(response.data['data']);
        learningTimeLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get learning time data');
    }
  }

  Future getLearningTimeTempChart() async {
    learningTimeTempLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().dashboardUrl + 'learning-time-bar-chart',
      );

      if (response.statusCode == 200) {
        learningTimeTempData.value = LearningTimeTempChartModal.fromJson(response.data['data']);
        learningTimeTempLoading.value = false;
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get chart data');
    }
  }
}
