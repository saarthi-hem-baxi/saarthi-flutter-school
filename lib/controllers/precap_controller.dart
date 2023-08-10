import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_answer_key_model/precap_answer_key_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_exam_model/precap_exam_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/precap_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/precapdata.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';

class PrecapController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool precapLoading = false.obs;
  var preCapModel = PrecapModel().obs;
  var precapExamModel = PrecapExamModel().obs;
  var precapExamModelTemp = PrecapExamModel().obs;
  var precapAnswerKeyModel = PrecapAnswerKeyModel().obs;
  Datum subjectData = Datum();
  ChaptersDatum chaptersData = ChaptersDatum();
  VoidCallback? testsRefreshData;
  bool? isFromPending;
  var totalKeyLearnings = 0;
  var totalKeyLearningsPercentage = 0.0;
  var totalKeylerningExamPer = 0.0;
  var isKeylearningScreen = true;
  // bool? isFromTests;

  RxBool precapTestExamCompleted = false.obs;
  RxBool precapTestNoQueFound = false.obs;
  RxBool precapTestLoading = false.obs;

  getPrecapData({required Datum subjectData, required ChaptersDatum chaptersData}) async {
    precapLoading.value = true;
    preCapModel.value = PrecapModel();
    this.subjectData = subjectData;
    this.chaptersData = chaptersData;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapter/${chaptersData.id}/precap',
      );

      if (response.statusCode == 200) {
        preCapModel.value = PrecapModel.fromJson(response.toString());
        chaptersData.name = (preCapModel.value.precapData?.chapter?.name ?? "");

        return "done";
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Precap Data Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      precapLoading.value = false;
    }
  }

  getPrecapExamData({
    required BuildContext context,
    required PrecapData precapData,
    required Map map,
    bool isFirst = false,
  }) async {
    precapTestLoading.value = true;
    precapTestNoQueFound.value = false;
    precapTestExamCompleted.value = false;

    Map<String, dynamic> jsonData;

    jsonData = map.isEmpty
        ? (precapData.examStarted?.status == true && precapData.examCompleted?.status == false)
            ? ({
                "lang": precapData.lang,
                "continueExam": true,
              })
            : ({
                "lang": precapData.lang,
              })
        : ({
            "lang": precapData.lang,
            "answer": map["answer"],
          });

    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapter/${chaptersData.id}/precap/${precapData.id}/exam',
        data: jsonData,
      );

      if (response.statusCode == 200) {
        if (response.data['data'] == null) {
          precapTestNoQueFound.value = true;
        } else if (response.data['data']['examCompleted'] == null || response.data['data']['examCompleted']['status'] == false) {
          if (isFirst) {
            precapExamModel.value = PrecapExamModel();
            precapExamModel.value = PrecapExamModel.fromJson(response.toString());
          } else {
            precapExamModelTemp.value = PrecapExamModel.fromJson(response.toString());
          }
        } else {
          precapTestExamCompleted.value = true;
        }

        Future.delayed(const Duration(seconds: 1), () {
          //  To solve initially showing No Question Found
          precapTestLoading.value = false;
        });
        precapTestLoading.value = false;
      }

      return "done";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        precapTestNoQueFound.value = true;
        Fluttertoast.showToast(msg: 'Cannot Load Exam Data');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      precapTestLoading.value = false;
    }
  }

  getPrecapAnswerKeyData({
    required BuildContext context,
    required PrecapData precapData,
  }) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapter/${chaptersData.id}/precap/${precapData.id}/answer-key',
      );

      if (response.statusCode == 200) {
        precapAnswerKeyModel.value = PrecapAnswerKeyModel.fromJson(response.toString());
        loading.value = false;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Cannot load Answer Key');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }
}
