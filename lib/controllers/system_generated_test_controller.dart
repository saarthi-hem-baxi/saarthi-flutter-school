import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_answer_key_model/system_generated_answer_key_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/data.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/system_generated_test_model.dart';

import '../model/homework_model/completed.dart';

class SystemGeneratedTestController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool loadingSelfAutoHW = false.obs;
  var systemGeneratedTestModel = SystemGeneratedTestModel().obs;
  var systemGeneratedTestModelTemp = SystemGeneratedTestModel().obs;

  RxBool systemGeneratedTestExamCompleted = false.obs;
  RxBool systemGeneratedTestNoQueFound = false.obs;
  RxBool systemGeneratedTestLoading = false.obs;

  var systemGeneratedAnswerKeyModel = SystemGeneratedAnswerKeyModel().obs;

  RxBool selfAutoHWTestLoading = false.obs;
  RxBool selfAutoHWTestExamCompleted = false.obs;
  RxBool selfAutoHWTestNoQueFound = false.obs;

  RxString strTopicType = ''.obs;

  Future<String> getSystemGeneratedTest({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required HomeworkDetail homeworkData,
    required Map map,
    bool isFirst = false,
  }) async {
    systemGeneratedTestLoading.value = true;
    strTopicType.value = '';
    systemGeneratedTestNoQueFound.value = false;
    systemGeneratedTestExamCompleted.value = false;
    Map<String, dynamic> jsonData;

    jsonData = map.isEmpty
        ? ((homeworkData.started?.status ?? false) == true && (homeworkData.completed?.status ?? false) == false)
            ? ({
                "lang": homeworkData.lang,
                "continueExam": true,
              })
            : ({
                "lang": homeworkData.lang,
              })
        : ({
            "lang": homeworkData.lang,
            "answer": map["answer"],
          });

    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/${homeworkData.id}/system-generate-test',
        data: jsonData,
      );

      if (response.statusCode == 200) {
        systemGeneratedTestLoading.value = false;
        if (response.data['data'] == null) {
          systemGeneratedTestNoQueFound.value = true;
        } else if (response.data['data']['completed'] == null || response.data['data']['completed']['status'] == false) {
          if (isFirst) {
            systemGeneratedTestModel.value = SystemGeneratedTestModel.fromJson(response.toString());
          } else {
            systemGeneratedTestModelTemp.value = SystemGeneratedTestModel.fromJson(response.toString());
          }
          if (map.isEmpty) {
            if ((homeworkData.concepts ?? []).isEmpty && (homeworkData.topics ?? []).isNotEmpty) {
              systemGeneratedTestLoading.value = false;
              strTopicType.value = homeworkData.topics?[0].type?.toLowerCase() ?? '';
            }
          }
        } else {
          SystemGeneratedTestModel systemGeneratedTestData = SystemGeneratedTestModel(
            data: SystemGeneratedTestData(
              completed: Completed(
                status: true,
                date: DateTime.parse(response.data['data']['completed']['date'] ?? ""),
              ),
            ),
          );
          systemGeneratedTestExamCompleted.value = true;

          if (isFirst) {
            systemGeneratedTestModel.value = systemGeneratedTestData;
          } else {
            systemGeneratedTestModelTemp.value = systemGeneratedTestData;
          }
        }
        // Future.delayed(const Duration(seconds: 1), () {
        //  To solve initially showing No Question Found
        systemGeneratedTestLoading.value = false;
        // });
      }

      return "done";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        systemGeneratedTestNoQueFound.value = true;
        Fluttertoast.showToast(msg: 'No Test Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      systemGeneratedTestLoading.value = false;
      return 'error';
    }
  }

  createSelfAutoHWTest({required String subjectId, required String chapterId, required String conceptId}) async {
    try {
      loadingSelfAutoHW.value = true;
      Map<String, dynamic> jsonData = {
        "conceptId": conceptId,
      };
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + "subject/$subjectId/chapter/$chapterId/homeworks/self-system-generate-test/",
        data: jsonData,
      );
      if (response.statusCode == 200) {
        return response.data?["data"];
      } else {
        return null;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot Generate AutoHW Test');
      return null;
    } finally {
      loadingSelfAutoHW.value = false;
    }
  }

  getSelfAutoHWTest({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required HomeworkDetail homeworkData,
    required Map map,
    bool isFirst = false,
  }) async {
    selfAutoHWTestLoading.value = true;
    selfAutoHWTestNoQueFound.value = false;
    selfAutoHWTestExamCompleted.value = false;
    Map<String, dynamic> jsonData;

    jsonData = map.isEmpty
        ? ((homeworkData.started?.status ?? false) == true && (homeworkData.completed?.status ?? false) == false)
            ? ({
                "lang": homeworkData.lang,
                "continueExam": true,
              })
            : ({
                "lang": homeworkData.lang,
              })
        : ({
            "lang": homeworkData.lang,
            "answer": map["answer"],
          });

    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/${homeworkData.id}/self-system-generate-test',
        data: jsonData,
      );

      if (response.statusCode == 200) {
        selfAutoHWTestLoading.value = false;
        if (response.data['data'] == null) {
          selfAutoHWTestNoQueFound.value = true;
        } else if (response.data['data']['completed'] == null || response.data['data']['completed']['status'] == false) {
          if (isFirst) {
            systemGeneratedTestModel.value = SystemGeneratedTestModel.fromJson(response.toString());
          } else {
            systemGeneratedTestModelTemp.value = SystemGeneratedTestModel.fromJson(response.toString());
          }
          if (map.isEmpty) {
            if ((homeworkData.concepts ?? []).isEmpty && (homeworkData.topics ?? []).isNotEmpty) {
              loading.value = false;
              return homeworkData.topics![0].type!.toLowerCase();
            }
          }
        } else {
          SystemGeneratedTestModel systemGeneratedTestData = SystemGeneratedTestModel(
            data: SystemGeneratedTestData(
              completed: Completed(
                status: true,
                date: DateTime.parse(response.data['data']['completed']['date'] ?? ""),
              ),
            ),
          );
          selfAutoHWTestExamCompleted.value = true;

          if (isFirst) {
            systemGeneratedTestModel.value = systemGeneratedTestData;
          } else {
            systemGeneratedTestModelTemp.value = systemGeneratedTestData;
          }
        }

        // Future.delayed(const Duration(seconds: 1), () {
        //  To solve initially showing No Question Found
        selfAutoHWTestLoading.value = false;
        // });
      }

      return "done";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        systemGeneratedTestNoQueFound.value = true;
        Fluttertoast.showToast(msg: 'No Test Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      selfAutoHWTestLoading.value = false;
    }
  }

  getPrecapSystemGeneratedAnswerKeyData({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
  }) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/answer-key',
      );

      if (response.statusCode == 200) {
        systemGeneratedAnswerKeyModel.value = SystemGeneratedAnswerKeyModel.fromJson(response.toString());
        loading.value = false;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Answer Key Not Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }
}
