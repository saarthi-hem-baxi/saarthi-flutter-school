import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';

import '../model/lessplan/lesson_plan.dart';

class LessonPlanController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  Rx<LessonPlanListModal> lessonPlanListData = LessonPlanListModal().obs;

  getLessonPlanByTopic(
      {required BuildContext context, required String subjectId, required String chapterId, required String topicId, required String type}) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/$type/$topicId/lesson-plans/learn',
      );

      if (response.statusCode == 200) {
        lessonPlanListData.value = LessonPlanListModal.fromJson(response.data['data']);
        loading.value = false;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Lesson Plan Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }
}
