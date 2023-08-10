import 'dart:convert';

LearningTimeTempChartModal learningTimeTempChartFromJson(str) => LearningTimeTempChartModal.fromJson(str);

String learningTimeTempChartToJson(LearningTimeTempChartModal data) => json.encode(data.toJson());

class LearningTimeTempChartModal {
  LearningTimeTempChartModal({
    this.chartData,
  });

  List<LearningTimeTempChartData>? chartData;

  factory LearningTimeTempChartModal.fromJson(Map<String, dynamic>? json) => LearningTimeTempChartModal(
        chartData: List<LearningTimeTempChartData>.from(json?["chartData"]?.map((x) => LearningTimeTempChartData.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class LearningTimeTempChartData {
  LearningTimeTempChartData({
    this.date,
    this.value,
  });

  DateTime? date;
  num? value;

  factory LearningTimeTempChartData.fromJson(Map<String, dynamic>? json) => LearningTimeTempChartData(
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]).toLocal(),
        value: json?["value"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "value": value,
      };
}
