import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/data.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/road_map_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/topics.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/unclear_pre_concept.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/work.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap.dart';

class RoadmapController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  RxBool loadingCWCounts = false.obs;
  RxBool loadingHWCounts = false.obs;

  var roadMapModel = RoadMapModel().obs;
  RxList<dynamic> milestones = [].obs;
  RoadmapIds roadmapIds = RoadmapIds();

  Datum? selectedSubjectData;
  ChaptersDatum? selectedChaptersData;
  RxBool loadingConceptMapAuth = false.obs;
  RxString conceptMapAuthToken = "".obs;

  refreshRoadMapData(BuildContext context) async {
    return await getRoadMap(
      context: context,
      subjectData: selectedSubjectData!,
      chapterData: selectedChaptersData!,
    );
  }

  getRoadMap({
    required BuildContext context,
    required Datum subjectData,
    required ChaptersDatum chapterData,
  }) async {
    if (selectedSubjectData?.id != subjectData.id || selectedChaptersData?.id != chapterData.id) {
      loading.value = true;
      roadMapModel.value = RoadMapModel();
      milestones.value = [];
    }

    selectedSubjectData = subjectData;
    selectedChaptersData = chapterData;

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapter/${chapterData.id}/roadmap',
      );

      if (response.statusCode == 200) {
        roadMapModel.value = RoadMapModel.fromJson(response.toString());

        if (roadMapModel.value.data!.topics!.isNotEmpty) {
          roadMapModel.value.data?.topics?[0].started = true;
        }

        roadmapIds.roadmapId = roadMapModel.value.data?.id;

        getHomeworkCountByChapter(
          subjectId: selectedSubjectData?.id ?? "",
          chapterId: selectedChaptersData?.id ?? "",
        );

        prepareMilestones();
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Cannot Get Chapter Information');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    } finally {
      loading.value = false;
    }
  }

  prepareMilestones() {
    milestones.clear();
    milestones.add({
      "type": "starting-point",
    });

    RoadMapModel roadMapmodel = roadMapModel.value;
    if (roadMapmodel.data?.chapter?.configuration?.precap ?? false) {
      milestones.add(
        {
          "type": "precap",
          "precapDetails": roadMapmodel.data?.precapDetails,
        },
      );
    }

    if (roadMapmodel.data?.topics != null) {
      List<Topics> topics = (roadMapmodel.data?.topics ?? []).map((v) => Topics.fromJson(v.toJson(), roadMapmodel.data?.lang)).toList()
        ..sort((a, b) {
          if (a.order != null && b.order != null) {
            return a.order! > b.order! ? 1 : -1;
          } else {
            return 0;
          }
        });
      List<UnclearPreConcept> unclearPreConcepts =
          (roadMapmodel.data?.unclearPreConcepts ?? []).map((v) => UnclearPreConcept.fromJson(v.toJson(), roadMapmodel.data?.lang)).toList();

      for (Topics topic in topics) {
        if (unclearPreConcepts.isNotEmpty) {
          List<String> preConceptIds = unclearPreConcepts
              .where((c) => c.topics != null && topic.topic?.id != null ? c.topics!.contains(topic.topic!.id) : false)
              .map((c) => c.preConcept?.id ?? "")
              .where((c) => c.isNotEmpty)
              .toList();
          List<UnclearPreConcept> preConcepts = [];
          for (String conceptId in preConceptIds) {
            int conceptIndex = unclearPreConcepts.indexWhere((c) => c.preConcept?.id == conceptId);
            preConcepts.add(unclearPreConcepts[conceptIndex]);
            unclearPreConcepts.removeAt(conceptIndex);
          }
          if (preConcepts.isNotEmpty) {
            for (UnclearPreConcept preConcept in preConcepts) {
              milestones.add(
                {
                  "type": "preconcept",
                  "unclearPreConcept": preConcept,
                },
              );
            }
          }
        }
        milestones.add(
          {
            "type": "topic",
            "topic": topic,
          },
        );
      }
    }
    if (roadMapmodel.data?.chapter?.configuration?.homework == true || roadMapmodel.data?.chapter?.configuration?.autoHomework == true) {
      milestones.add(
        {
          "type": "homework",
          "homework": roadMapmodel.data?.homework,
        },
      );
    }
    milestones.value = milestones.reversed.toList();
  }

  doDeleteRoadMap(
      {required BuildContext context, required RoadMapData roadMapData, required Datum subjectData, required ChaptersDatum chaptersData}) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.deleteData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapter/${chaptersData.id}/roadmap/${roadMapData.id}',
      );

      if (response.statusCode == 200) {
        loading.value = false;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapPage(
              subjectData: subjectData,
              chaptersData: chaptersData,
            ),
          ),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Somethings went wrong, Try Again');
      loading.value = false;
    }
  }

  getHomeworkCountByChapter({
    required String subjectId,
    required String chapterId,
  }) async {
    try {
      loadingHWCounts.value = true;
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + "subject/$subjectId/chapter/$chapterId/homeworks/count",
      );
      if (response.statusCode == 200) {
        roadMapModel.value.data?.homework = Work.fromJson(response.data?['data']);
        return response.data;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get Homework Information.');
    } finally {
      loadingHWCounts.value = false;
    }
  }

  Future<bool> getClassConceptMapAuthToken({required Map<String, dynamic> data}) async {
    try {
      dio.Response response = await apiClient.postData(url: APIUrls().analyticsUrl + "concept-map-auth", data: data);
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          if (response.data['data']['token'] != null) {
            conceptMapAuthToken.value = response.data['data']['token'];
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cannot get concept map token');
      return false;
    }
  }
}
