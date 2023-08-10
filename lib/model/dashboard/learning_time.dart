import 'dart:convert';

LearningTimeChartModal learningTimeChartModalFromJson(str) => LearningTimeChartModal.fromJson(str);

String learningTimeChartModalToJson(LearningTimeChartModal data) => json.encode(data.toJson());

class LearningTimeChartModal {
  LearningTimeChartModal({
    this.chartData,
    this.totalDuration,
    this.differenceValue,
    this.isValueUp,
  });

  List<LearningTimeChartData>? chartData;
  num? totalDuration;
  num? differenceValue;
  bool? isValueUp;

  factory LearningTimeChartModal.fromJson(Map<String, dynamic>? json) => LearningTimeChartModal(
        chartData: List<LearningTimeChartData>.from(json?["chartData"]?.map((x) => LearningTimeChartData.fromJson(x)) ?? []),
        totalDuration: json?["totalDuration"],
        differenceValue: json?["differenceValue"],
        isValueUp: json?["isValueUp"],
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
        "totalDuration": totalDuration,
        "differenceValue": differenceValue,
        "isValueUp": isValueUp,
      };
}

class LearningTimeChartData {
  LearningTimeChartData({
    this.date,
    this.value,
  });

  DateTime? date;
  num? value;

  factory LearningTimeChartData.fromJson(Map<String, dynamic>? json) => LearningTimeChartData(
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]).toLocal(),
        value: json?["value"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "value": value,
      };
}
