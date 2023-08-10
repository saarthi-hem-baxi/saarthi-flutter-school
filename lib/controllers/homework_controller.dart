import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_model_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';

import '../helpers/const.dart';
import '../model/homework_model/online_test.dart';
import '../model/homework_model/online_test_answer_key.dart';
import '../model/system_generated_test_model/selfautohw/selfautohw.dart';

class HomeworkController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool pendingLoading = false.obs;
  RxBool completedLoading = false.obs;
  RxBool onlineTestLoading = false.obs;
  RxBool onlineTestAnswerLoading = false.obs;
  RxBool onlineTestNoQuestionFound = false.obs;
  RxBool onlineTestExamCompleted = false.obs;

  var homeworkDetailModel = HomeworkDetailModel().obs;

  var homeworkPendingModel = HomeworkModel().obs;
  var homeworkCompletedModel = HomeworkModel().obs;
  var onlineTestModal = OnlineTestQuestionModal().obs;
  var onlineTestModalTemp = OnlineTestQuestionModal().obs;
  var onlineTestAnswerKeyModal = OnlineTestAnswerKeyModal().obs;
  var selfAutoHWDetailModel = SelfAutoHWDetailModel().obs;

  Datum? selectedSubjectData;
  ChaptersDatum? selectedChapterData;
  String? selectedTopicOrConceptId;
  ByHomeworkTypes? selectedType;
  bool? isFromTests;
  bool? isFromPending;
  bool? isFromNotification;

  //Pending Homework By Chapter
  getPendingHomeworkByChapter({
    required String subjectId,
    required String chapterId,
  }) async {
    pendingLoading.value = true;
    homeworkPendingModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/pending';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkPendingModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      pendingLoading.value = false;
    }
  }

  //Completed Homework By Chapter
  getCompletedHomeworkByChapter({
    required String subjectId,
    required String chapterId,
  }) async {
    completedLoading.value = true;
    homeworkCompletedModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/completed';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkCompletedModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      completedLoading.value = false;
    }
  }

  //Pending Homework By Topic
  getPendingHomeworkByTopic({required String subjectId, required String chapterId, required String topicId}) async {
    pendingLoading.value = true;
    homeworkPendingModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/topic/$topicId/homeworks/pending';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkPendingModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      pendingLoading.value = false;
    }
  }

  //Completed Homework By Topic
  getCompletedHomeworkByTopic({required String subjectId, required String chapterId, required String topicId}) async {
    completedLoading.value = true;
    homeworkCompletedModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/topic/$topicId/homeworks/completed';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkCompletedModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      completedLoading.value = false;
    }
  }

  //Pending Homework By Concept
  getPendingHomeworkByConcept({required String subjectId, required String chapterId, required String conceptId}) async {
    pendingLoading.value = true;
    homeworkPendingModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/concept/$conceptId/homeworks/pending';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkPendingModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      pendingLoading.value = false;
    }
  }

  //Completed Homework By Concept
  getCompletedHomeworkByConcept({required String subjectId, required String chapterId, required String conceptId}) async {
    completedLoading.value = true;
    homeworkCompletedModel.value = HomeworkModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/concept/$conceptId/homeworks/completed';

    try {
      dio.Response response = await apiClient.getData(
        url: urlHomework,
      );

      if (response.statusCode == 200) {
        homeworkCompletedModel.value = HomeworkModel.fromJson(response.toString());
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      completedLoading.value = false;
    }
  }

  Future getHomeworkDetail(
      {required BuildContext context,
      required String subjectId,
      required String chapterId,
      required String homeworkId,
      bool isSelfAutoHW = false}) async {
    loading.value = true;
    homeworkDetailModel.value = HomeworkDetailModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId';
    log('Get Home Detail URL: $urlHomework');
    try {
      dio.Response response = await apiClient.getData(url: urlHomework);
      log('Get Home Detail Response: ${response.toString()})');
      if (response.statusCode == 200) {
        homeworkDetailModel.value = HomeworkDetailModel.fromJson(response.toString());
        if (!isSelfAutoHW) {
          if (!(homeworkDetailModel.value.data?.hasOpened?.status ?? false) || (homeworkDetailModel.value.data?.hasOpened?.status) == null) {
            doHomeworkOpenStatus(context: context, subjectId: subjectId, chapterId: chapterId, homeworkId: homeworkId);
          }
        }
        loading.value = false;
        return "done";
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }

  doHomeworkOpenStatus({required BuildContext context, required String subjectId, required String chapterId, required String homeworkId}) async {
    loading.value = true;

    String urlOpenStatus = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/open';
    log('Do Homework Open Status URL: $urlOpenStatus');
    try {
      dio.Response response = await apiClient.postData(
        url: urlOpenStatus,
        data: jsonEncode(
          {"hasOpened": true},
        ),
      );
      log('Do Homework Open Status Response: ${response.toString()}');
      if (response.statusCode == 200) {
        loading.value = false;
      }
    } catch (error) {
      loading.value = false;
    }
  }

  doHomeworkComplete({required BuildContext context, required String subjectId, required String chapterId, required String homeworkId}) async {
    loading.value = true;

    String urlComplete = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/complete';

    try {
      String data = jsonEncode(
        {"studentHomeworkId": homeworkId},
      );

      dio.Response response = await apiClient.postData(
        url: urlComplete,
        data: data,
      );

      if (response.statusCode == 200) {
        loading.value = false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot Complete Homework , Try Again');
      loading.value = false;
    }
  }

  putSubmitHomework(
      {required BuildContext context,
      required String subjectId,
      required String chapterId,
      required String homeworkId,
      required List<XFile> file}) async {
    loading.value = true;

    String urlSubmitHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/submit';

    List<dio.MultipartFile> submissionFiles = [];
    for (var fl in file) {
      String fileName = fl.path.split('/').last;

      submissionFiles.add(await dio.MultipartFile.fromFile(fl.path, filename: fileName));
    }

    Map<String, dynamic> finalMap = {
      "data": {"studentHomeworkId": homeworkId},
      "submissions": submissionFiles
    };

    dio.FormData formData = dio.FormData.fromMap(finalMap);

    try {
      dio.Response response = await apiClient.postData(url: urlSubmitHomework, data: formData);

      if (response.statusCode == 200) {
        loading.value = false;
        Fluttertoast.showToast(msg: "Submission Successfully Submitted");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error in submitting Data, Try Again');
      loading.value = false;
    }
  }

  Future<HWTestResposponseAction> getOnlineTestData({
    required String subjectId,
    required String chapterId,
    required String homeworkId,
    required Map dataMap,
    required bool isSubmitBtnPressed,
    required bool isFirst,
  }) async {
    onlineTestLoading.value = true;
    onlineTestNoQuestionFound.value = false;
    onlineTestExamCompleted.value = false;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/online-test',
        data: dataMap,
      );

      if (response.statusCode == 200) {
        onlineTestLoading.value = false;
        if (response.data == null || response.data['data'] == null) {
          onlineTestNoQuestionFound.value = true;
          onlineTestModalTemp.value = OnlineTestQuestionModal();
          return HWTestResposponseAction.noQuestion;
        }

        if (response.data['data']['completed'] == null || response.data['data']['completed']['status'] == false) {
          OnlineTestQuestionModal onlineTestData = OnlineTestQuestionModal.fromJson(response.data['data']);
          if (isFirst) {
            onlineTestModal.value = onlineTestData;
          } else {
            onlineTestModalTemp.value = onlineTestData;
          }
          return HWTestResposponseAction.next;
        } else {
          OnlineTestQuestionModal onlineTestData = OnlineTestQuestionModal(
            completed: Completed(
              status: true,
              date: DateTime.parse(response.data['data']['completed']['date'] ?? ""),
            ),
          );
          onlineTestExamCompleted.value = true;

          if (isFirst) {
            onlineTestModal.value = onlineTestData;
          } else {
            onlineTestModalTemp.value = onlineTestData;
          }

          return HWTestResposponseAction.completed;
        }
      }

      onlineTestLoading.value = false;
      return HWTestResposponseAction.failed;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get online test data, Try Again');
      return HWTestResposponseAction.failed;
    }
  }

  getOnlineTestAnswerKey({
    required String subjectId,
    required String chapterId,
    required String homeworkId,
  }) async {
    onlineTestAnswerLoading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/answer-key',
      );

      if (response.statusCode == 200) {
        onlineTestAnswerKeyModal.value = OnlineTestAnswerKeyModal.fromJson(response.data['data']);
      }

      onlineTestAnswerLoading.value = false;
      return true;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get answer key data, Try Again');
    }
  }

  getSelfAutoHWDetail({required BuildContext context, required String subjectId, required String chapterId, required String conceptId}) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/concept/$conceptId/self-system-generate/details',
      );

      if (response.statusCode == 200) {
        selfAutoHWDetailModel.value = SelfAutoHWDetailModel.fromJson(response.toString());

        loading.value = false;
        return "";
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Test Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }
}
