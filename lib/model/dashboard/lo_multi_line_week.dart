import 'dart:convert';

LoMultiLineChartWeekModal loMultiLineChartWeekModalFromJson(String str) => LoMultiLineChartWeekModal.fromJson(json.decode(str));

String loMultiLineChartWeekModalToJson(LoMultiLineChartWeekModal? data) => json.encode(data?.toJson());

class LoMultiLineChartWeekModal {
  LoMultiLineChartWeekModal({
    this.chartData,
  });

  List<ChartWeekDatum>? chartData;

  factory LoMultiLineChartWeekModal.fromJson(Map<String, dynamic>? json) => LoMultiLineChartWeekModal(
        chartData: List<ChartWeekDatum>.from(json?["chartData"]?.map((x) => ChartWeekDatum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class ChartWeekDatum {
  ChartWeekDatum({
    this.subjectName,
    this.subjectId,
    this.value,
  });

  String? subjectName;
  String? subjectId;
  List<WeekValue>? value;

  factory ChartWeekDatum.fromJson(Map<String, dynamic>? json) => ChartWeekDatum(
        subjectName: json?["subjectName"],
        subjectId: json?["subjectId"],
        value: List<WeekValue>.from(json?["value"].map((x) => WeekValue.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "subjectId": subjectId,
        "value": List<dynamic>.from(value?.map((x) => x.toJson()) ?? []),
      };
}

class WeekValue {
  WeekValue({this.w1, this.w2, this.w3, this.w4, this.w5});

  num? w1;
  num? w2;
  num? w3;
  num? w4;
  num? w5;

  factory WeekValue.fromJson(Map<String, dynamic>? json) => WeekValue(
        w1: json?["W1"],
        w2: json?["W2"],
        w3: json?["W3"],
        w4: json?["W4"],
        w5: json?["W5"],
      );

  Map<String, dynamic> toJson() => {
        "W1": w1,
        "W2": w2,
        "W3": w3,
        "W4": w4,
        "W5": w5,
      };
}
