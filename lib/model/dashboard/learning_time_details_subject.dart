// To parse this JSON data, do
//
//     final learningTimeDetailsSubjects = learningTimeDetailsSubjectsFromJson(jsonString);

import 'dart:convert';

LearningTimeDetailsSubjectsModal learningTimeDetailsSubjectsFromJson(str) => LearningTimeDetailsSubjectsModal.fromJson(str);

String learningTimeDetailsSubjectsToJson(LearningTimeDetailsSubjectsModal data) => json.encode(data.toJson());

class LearningTimeDetailsSubjectsModal {
  LearningTimeDetailsSubjectsModal({
    this.chartData,
  });

  List<LearningTimeSubjectData>? chartData;

  factory LearningTimeDetailsSubjectsModal.fromJson(Map<String, dynamic>? json) => LearningTimeDetailsSubjectsModal(
        chartData: List<LearningTimeSubjectData>.from(json?["chartData"]?.map((x) => LearningTimeSubjectData.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class LearningTimeSubjectData {
  LearningTimeSubjectData({
    this.name,
    this.subjectId,
    this.duration,
  });

  String? name;
  String? subjectId;
  num? duration;

  factory LearningTimeSubjectData.fromJson(Map<String, dynamic>? json) => LearningTimeSubjectData(
        name: json?["name"],
        subjectId: json?["subjectId"],
        duration: json?["duration"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subjectId": subjectId,
        "duration": duration,
      };
}
