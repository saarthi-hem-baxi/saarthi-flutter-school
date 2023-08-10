// To parse this JSON data, do
//
//     final loMeterDetailsChapterModal = loMeterDetailsChapterModalFromJson(jsonString);

import 'dart:convert';

LoMeterDetailsChapterModal loMeterDetailsChapterModalFromJson(str) => LoMeterDetailsChapterModal.fromJson(str);

String loMeterDetailsChapterModalToJson(LoMeterDetailsChapterModal data) => json.encode(data.toJson());

class LoMeterDetailsChapterModal {
  LoMeterDetailsChapterModal({
    this.chartData,
    this.subjectName,
  });

  List<ChartDatum>? chartData;
  String? subjectName;

  factory LoMeterDetailsChapterModal.fromJson(Map<String, dynamic>? json) => LoMeterDetailsChapterModal(
        chartData: List<ChartDatum>.from(json?["chartData"]?.map((x) => ChartDatum.fromJson(x)) ?? []),
        subjectName: json?["subjectName"],
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
        "subjectName": subjectName,
      };
}

class ChartDatum {
  ChartDatum({
    this.name,
    this.subjectId,
    this.chapterId,
    this.value,
    this.chapterNumber,
  });

  String? name;
  String? subjectId;
  String? chapterId;
  num? value;
  num? chapterNumber;

  factory ChartDatum.fromJson(Map<String, dynamic>? json) => ChartDatum(
      name: json?["name"],
      subjectId: json?["subjectId"],
      chapterId: json?["chapterId"],
      value: json?["value"],
      chapterNumber: json?["chapterNumber"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "subjectId": subjectId,
        "chapterId": chapterId,
        "value": value,
        "chapterNumber": chapterNumber,
      };
}
