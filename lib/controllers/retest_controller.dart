import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/completed.dart';
import 'package:saarthi_pedagogy_studentapp/model/lessplan/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_answer_key_model/system_generated_answer_key_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_detail.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_detail_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_exam_data.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_list/retest_list.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';

import '../model/system_generated_test_model/retest/retest_concept_topic_data.dart';
import '../model/system_generated_test_model/retest/retest_exam_model.dart';

class ReTestController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  var retestExamModel = RetestExamModel().obs;
  var retestExamModelTemp = RetestExamModel().obs;
  var retestDetailModel = RetestDetailModel().obs;
  var systemGeneratedAnswerKeyModel = SystemGeneratedAnswerKeyModel().obs;
  var retestConceptTopicData = RetestConceptTopicData().obs;
  var retestListModel = RetestListModel().obs;
  var lessonPlanModel = LessonPlanListModal().obs;
  var lessonPlanListModal = LessonPlanListModal().obs;
  bool? isFromExam;

  RxBool retestExamCompleted = false.obs;
  RxBool retestExamNoQueFound = false.obs;
  RxBool retestExamLoading = false.obs;

  createTest(
      {required BuildContext context,
      required String subjectId,
      required String chapterId,
      required String homeworkId,
      required List<RetestResult> retestResult}) async {
    // {{host}}/v1/student/subject/6260e4ea3595b100d0618345/chapter/6260e552261432b8c54b702d/homeworks/62bd63d45a311401ec6d970a/system-generate-test/retest
    log('Create Test');
    loading.value = true;
    // Map<String, dynamic> jsonData = {
    //   "studentHomeworkId": homeworkId,
    // };
    List<Map<String, dynamic>> conceptsList = [];
    List<Map<String, dynamic>> keyLearningsList = [];

    retestResult.map((e) {
      keyLearningsList = [];
      if (e.cleared == true) {
        e.keyLearnings!.map((data) {
          if (data.cleared == true) {
            Map<String, dynamic> jsonData = {
              "keyLearning": (data.keyLearning?.id.toString() ?? ""),
            };
            keyLearningsList.add(jsonData);
          }
        }).toList();
        Map<String, dynamic> jsonData = {"concept": (e.concept?.id.toString() ?? ""), "keyLearnings": keyLearningsList};
        conceptsList.add(jsonData);
      }
    }).toList();

    Map<String, dynamic> jsonData = {"studentHomeworkId": homeworkId, "concepts": conceptsList};

    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/system-generate-test/retest',
        data: jsonEncode(jsonData),
      );
      log('Create Test URL: ${APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/system-generate-test/retest'}');
      log('Create Test Param: ${jsonEncode(jsonData)}');
      log('Create Test Response: ${response.toString()}');
      if (response.statusCode == 200) {
        // systemGeneratedAnswerKeyModel.value = SystemGeneratedAnswerKeyModel.fromJson(response.toString());
        loading.value = false;

        debugPrint("responsecreate-retest = ${response.data["data"].toString()}");
        return response.data["data"]["retestHomeworkId"];
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong try again');
      loading.value = false;
      return null;
    }
  }

  Future getUnclearTopicConcepts({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
  }) async {
    loading.value = true;
    retestConceptTopicData.value = RetestConceptTopicData();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/unclear/topic/concepts';
    log('URL: $urlHomework');
    try {
      dio.Response response = await apiClient.getData(url: urlHomework);
      log('Unclear Topic Response: ${response.toString()}');
      if (response.statusCode == 200) {
        retestConceptTopicData.value = RetestConceptTopicData.fromJson(response.data["data"]);
        loading.value = false;
      }
    } on dio.DioError {
      // if (error.response?.statusCode == 404) {
      //   Fluttertoast.showToast(msg: 'No Homework Found');
      // } else {
      //   Fluttertoast.showToast(msg: 'Something went wrong try again');
      // }
      loading.value = false;
    }
  }

  Future getRetestResult({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
  }) async {
    loading.value = true;
    retestListModel.value = RetestListModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/retests';
    log('Get Retest Result');
    try {
      dio.Response response = await apiClient.getData(url: urlHomework);
      log('Retest Result URL: $urlHomework');
      log('Retest Result Response: ${response.toString()}');
      if (response.statusCode == 200) {
        retestListModel.value = RetestListModel.fromJson(response.toString());
        loading.value = false;
        return "done";
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        // Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }

  Future getRetestDetail({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
    required String retestHomeworkId,
  }) async {
    loading.value = true;
    retestDetailModel.value = RetestDetailModel();
    String urlHomework = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/retests/$retestHomeworkId';
    log('Get Retest Detail');
    try {
      dio.Response response = await apiClient.getData(url: urlHomework);
      log('Retest Detail URL: $urlHomework');
      log('Retest Detail Param: ${response.data}');
      log('Retest Detail Response: ${response.toString()}');
      if (response.statusCode == 200) {
        retestDetailModel.value = RetestDetailModel.fromJson(response.toString());
        loading.value = false;
        return "done";
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        // Fluttertoast.showToast(msg: 'No Homework Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }

  Future getReTest({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
    required RetestDetail retestDetail,
    String lang = "",
    required Map map,
    bool isFirst = false,
  }) async {
    retestExamLoading.value = true;
    retestExamNoQueFound.value = false;
    retestExamCompleted.value = false;
    Map<String, dynamic> jsonData;
    log('Get Re Test');
    jsonData = map.isEmpty
        ? ((retestDetail.started?.status ?? false) == true && (retestDetail.completed?.status ?? false) == false)
            ? ({
                "lang": lang.isNotEmpty ? lang : retestDetail.lang,
                "continueExam": true,
              })
            : ({
                "lang": lang.isNotEmpty ? lang : retestDetail.lang,
              })
        : ({
            "lang": lang.isNotEmpty ? lang : retestDetail.lang,
            "answer": map["answer"],
          });

    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/system-generate-test/retest/${retestDetail.id}',
        data: jsonData,
      );
      log('Re Test URL: ${APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/system-generate-test/retest/${retestDetail.id}'}');
      log('Re Test Param: $jsonData');
      log('Re Test Response: ${response.toString()}');
      if (response.statusCode == 200) {
        retestExamLoading.value = false;

        if (response.data['data'] == null) {
          retestExamNoQueFound.value = true;
        } else if (response.data['data']['completed'] == null || response.data['data']['completed']['status'] == false) {
          if (isFirst) {
            // retestExamModel.value = RetestExamModel();
            retestExamModel.value = RetestExamModel.fromJson(response.toString());
          } else {
            retestExamModelTemp.value = RetestExamModel.fromJson(response.toString());
          }

          if (map.isEmpty) {
            if ((retestDetail.concepts ?? []).isEmpty && (retestDetail.topics ?? []).isNotEmpty) {
              retestExamLoading.value = false;
              return retestDetail.topics![0].type!.toLowerCase();
            }
          }
        } else {
          RetestExamModel retestExamData = RetestExamModel(
              data: RetestExamData(
                  completed: Completed(
            status: true,
            date: DateTime.parse(response.data['data']['completed']['date'] ?? ""),
          )));
          retestExamCompleted.value = true;

          if (isFirst) {
            retestExamModel.value = retestExamData;
          } else {
            retestExamModelTemp.value = retestExamData;
          }
        }

        // Future.delayed(const Duration(seconds: 1), () {
        //  To solve initially showing No Question Found
        retestExamLoading.value = false;
        // });
      }

      return "done";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        retestExamNoQueFound.value = true;
        Fluttertoast.showToast(msg: 'No Test Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      retestExamLoading.value = false;
    }
  }

  Future getRetestAnswerKeyData({
    required BuildContext context,
    required String subjectId,
    required String chapterId,
    required String homeworkId,
    required String retestHomeworkId,
  }) async {
    loading.value = true;
    log('Get Retest Answer Key Data');
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/retest/$retestHomeworkId/answer-key',
      );
      log('Get Retest Answer Key Data URL: ${APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/homeworks/$homeworkId/retest/$retestHomeworkId/answer-key'}');
      log('Get Retest Answer Key Data Response: ${response.toString()}');

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

  getRetestClearData(
      {required BuildContext context,
      required String subjectId,
      required String chapterId,
      required String conceptId,
      required String keyLearningId,
      required String topicId,
      required ByHomeworkTypes type}) async {
    loading.value = true;
    log('Get Retest Clear Data');
    log('Get Retest Clear TYpe: $type');
    String url = APIUrls().baseUrl + 'subject/$subjectId/chapter/$chapterId/concept/$conceptId/key-learnings/lesson-plans/learn';
    final split = keyLearningId.split(',');
    List<String> keyLearningIds = [];
    for (int i = 0; i < split.length; i++) {
      keyLearningIds.add(split[i]);
    }
    try {
      dio.Response response = await apiClient.postData(
        url: url,
        data: type == ByHomeworkTypes.topic || type == ByHomeworkTypes.chapter
            ? jsonEncode({"keyLearnings": keyLearningIds, "topic": topicId})
            : jsonEncode({"keyLearnings": keyLearningIds}),
      );
      log('----------------');
      log('Get Retest Clear Data URL: $url');
      //log('Get Retest Clear Data Param: ${response.requestOptions.data}');
      //log('Get Retest Clear Data Response: ${response.toString()}');
      //log('----------------');
      if (response.statusCode == 200) {
        lessonPlanModel.value = LessonPlanListModal.fromJson(response.data['data']);
        getRetestClearDataByKeyLearnigId(keyLearningIds[0], false);
        // Future.delayed(const Duration(seconds: 1), () {
        //   //  To solve initially showing No Question Found
        //   loading.value = false;
        // });
      }

      return "done";
    } on dio.DioError catch (error) {
      log('Error: ${error.toString()}');
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Cannot Load Exam Data');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }

  getRetestClearDataByKeyLearnigId(String keyLearningId, bool isLoading) {
    if (isLoading) {
      loading.value = true;
    }
    List<LessonPlan> lessonPlanList = [];
    lessonPlanListModal.value.lang = lessonPlanModel.value.lang;
    lessonPlanListModal.value.concepts = lessonPlanModel.value.concepts;
    lessonPlanModel.value.lessonPlans!.map((lessonPlan) {
      List<LessonPlanItem> descriptionCheckList =
          (lessonPlan.descriptions ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> videoCheckList =
          (lessonPlan.videos ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> imageCheckList =
          (lessonPlan.images ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> pdfCheckList =
          (lessonPlan.pdfs ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> documentCheckList =
          (lessonPlan.documents ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> audioCheckList =
          (lessonPlan.audio ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> exampleCheckList =
          (lessonPlan.examples ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> simulationCheckList =
          (lessonPlan.simulations ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<LessonPlanItem> linkCheckList =
          (lessonPlan.links ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      List<Word> wordCheckList = (lessonPlan.words ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();

      if (descriptionCheckList.isNotEmpty ||
          videoCheckList.isNotEmpty ||
          imageCheckList.isNotEmpty ||
          pdfCheckList.isNotEmpty ||
          documentCheckList.isNotEmpty ||
          audioCheckList.isNotEmpty ||
          exampleCheckList.isNotEmpty ||
          simulationCheckList.isNotEmpty ||
          linkCheckList.isNotEmpty ||
          wordCheckList.isNotEmpty) {
        LessonPlan _lessonPlan = LessonPlan();
        _lessonPlan.id = lessonPlan.id;
        _lessonPlan.studentInstruction = lessonPlan.studentInstruction;
        _lessonPlan.teacherInstruction = lessonPlan.teacherInstruction;
        _lessonPlan.verify = lessonPlan.verify;
        _lessonPlan.lang = lessonPlan.lang;
        _lessonPlan.concepts = lessonPlan.concepts;
        _lessonPlan.forStudent = lessonPlan.forStudent;
        _lessonPlan.forTeacher = lessonPlan.forTeacher;
        _lessonPlan.contentTypes = lessonPlan.contentTypes;
        _lessonPlan.tags = lessonPlan.tags;
        List<LessonPlanItem> descriptionList =
            (lessonPlan.descriptions ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.descriptions = descriptionList;
        List<LessonPlanItem> videoList =
            (lessonPlan.videos ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.videos = videoList;
        List<LessonPlanItem> imageList =
            (lessonPlan.images ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.images = imageList;
        List<LessonPlanItem> pdfList = (lessonPlan.pdfs ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.pdfs = pdfList;
        List<LessonPlanItem> documentList =
            (lessonPlan.documents ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.documents = documentList;
        List<LessonPlanItem> audioList =
            (lessonPlan.audio ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.audio = audioList;
        List<LessonPlanItem> exampleList =
            (lessonPlan.examples ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.examples = exampleList;
        List<LessonPlanItem> simulationList =
            (lessonPlan.simulations ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.simulations = simulationList;
        List<LessonPlanItem> linkList =
            (lessonPlan.links ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.links = linkList;
        List<Word> wordList = (lessonPlan.words ?? []).where((element) => (element.keyLearnings?.contains(keyLearningId) ?? false)).toList();
        _lessonPlan.words = wordList;
        _lessonPlan.isPublisher = lessonPlan.isPublisher;
        _lessonPlan.createdBy = lessonPlan.createdBy;
        _lessonPlan.updatedBy = lessonPlan.updatedBy;
        _lessonPlan.status = lessonPlan.status;
        _lessonPlan.topics = lessonPlan.topics;
        _lessonPlan.createdAt = lessonPlan.createdAt;
        _lessonPlan.updatedAt = lessonPlan.updatedAt;
        lessonPlanList.add(_lessonPlan);
      }
    }).toList();
    lessonPlanListModal.value.lessonPlans = lessonPlanList;
    Future.delayed(const Duration(seconds: 1), () {
      //  To solve initially showing No Question Found
      loading.value = false;
    });
  }
}
