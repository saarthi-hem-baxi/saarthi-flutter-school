import 'dart:convert';

LearningOutcomeSubjectModal learningOutcomeSubjectModalFromJson(str) => LearningOutcomeSubjectModal.fromJson(str);

String learningOutcomeSubjectModalToJson(LearningOutcomeSubjectModal data) => json.encode(data.toJson());

class LearningOutcomeSubjectModal {
  LearningOutcomeSubjectModal({
    this.chartData,
  });

  List<ChartDatum>? chartData;

  factory LearningOutcomeSubjectModal.fromJson(Map<String, dynamic>? json) => LearningOutcomeSubjectModal(
        chartData: List<ChartDatum>.from(json?["chartData"]?.map((x) => ChartDatum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class ChartDatum {
  ChartDatum({
    this.name,
    this.value,
    this.subjectId,
  });

  String? name;
  num? value;
  String? subjectId;

  factory ChartDatum.fromJson(Map<String, dynamic>? json) => ChartDatum(
        name: json?["name"],
        value: json?["value"],
        subjectId: json?["subjectId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "subjectId": subjectId,
      };
}
