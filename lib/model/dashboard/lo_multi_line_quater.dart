import 'dart:convert';

LoMultiLineChartQuaterModal loMultiLineChartWeekModalFromJson(String str) => LoMultiLineChartQuaterModal.fromJson(json.decode(str));

String loMultiLineChartWeekModalToJson(LoMultiLineChartQuaterModal? data) => json.encode(data?.toJson());

class LoMultiLineChartQuaterModal {
  LoMultiLineChartQuaterModal({
    this.chartData,
  });

  List<ChartQuaterDatum>? chartData;

  factory LoMultiLineChartQuaterModal.fromJson(Map<String, dynamic>? json) => LoMultiLineChartQuaterModal(
        chartData: List<ChartQuaterDatum>.from(json?["chartData"]?.map((x) => ChartQuaterDatum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class ChartQuaterDatum {
  ChartQuaterDatum({
    this.subjectName,
    this.subjectId,
    this.value,
  });

  String? subjectName;
  String? subjectId;
  List<QuaterValue>? value;

  factory ChartQuaterDatum.fromJson(Map<String, dynamic>? json) => ChartQuaterDatum(
        subjectName: json?["subjectName"],
        subjectId: json?["subjectId"],
        value: List<QuaterValue>.from(json?["value"].map((x) => QuaterValue.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "subjectId": subjectId,
        "value": List<dynamic>.from(value?.map((x) => x.toJson()) ?? []),
      };
}

class QuaterValue {
  QuaterValue({
    this.q1,
    this.q2,
    this.q3,
    this.q4,
  });

  num? q1;
  num? q2;
  num? q3;
  num? q4;

  factory QuaterValue.fromJson(Map<String, dynamic>? json) => QuaterValue(
        q1: json?["Q1"],
        q2: json?["Q2"],
        q3: json?["Q3"],
        q4: json?["Q4"],
      );

  Map<String, dynamic> toJson() => {
        "Q1": q1,
        "Q2": q2,
        "Q3": q3,
        "Q4": q4,
      };
}
