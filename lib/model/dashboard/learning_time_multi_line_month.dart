import 'dart:convert';

LearningTimeMultiLineChartMonthModal learningTimeMultiLineChartMonthModalFromJson(String str) =>
    LearningTimeMultiLineChartMonthModal.fromJson(json.decode(str));

String learningTimeMultiLineChartMonthModalToJson(LearningTimeMultiLineChartMonthModal data) => json.encode(data.toJson());

class LearningTimeMultiLineChartMonthModal {
  LearningTimeMultiLineChartMonthModal({
    this.chartData,
  });

  List<ChartMonthDatum>? chartData;

  factory LearningTimeMultiLineChartMonthModal.fromJson(Map<String, dynamic>? json) => LearningTimeMultiLineChartMonthModal(
        chartData: List<ChartMonthDatum>.from(json?["chartData"]?.map((x) => ChartMonthDatum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<dynamic>.from(chartData?.map((x) => x.toJson()) ?? []),
      };
}

class ChartMonthDatum {
  ChartMonthDatum({
    this.subjectName,
    this.subjectId,
    this.value,
  });

  String? subjectName;
  String? subjectId;
  List<MonthValue>? value;

  factory ChartMonthDatum.fromJson(Map<String, dynamic>? json) => ChartMonthDatum(
        subjectName: json?["subjectName"],
        subjectId: json?["subjectId"],
        value: List<MonthValue>.from(json?["value"]?.map((x) => MonthValue.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "subjectId": subjectId,
        "value": List<dynamic>.from(value?.map((x) => x.toJson()) ?? []),
      };
}

class MonthValue {
  MonthValue({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  num? jan;
  num? feb;
  num? mar;
  num? apr;
  num? may;
  num? jun;
  num? jul;
  num? aug;
  num? sep;
  num? oct;
  num? nov;
  num? dec;

  factory MonthValue.fromJson(Map<String, dynamic>? json) => MonthValue(
      jan: json?["Jan"],
      feb: json?["Feb"],
      mar: json?["Mar"],
      apr: json?["Apr"],
      may: json?["May"],
      jun: json?["Jun"],
      jul: json?["Jul"],
      aug: json?["Aug"],
      sep: json?["Sep"],
      oct: json?["Oct"],
      nov: json?["Nov"],
      dec: json?["Dec"]);

  Map<String, dynamic> toJson() => {
        "Jan": jan,
        "Feb": feb,
        "Mar": mar,
        "Apr": apr,
        "May": may,
        "Jun": jun,
        "Jul": jul,
        "Aug": aug,
        "Sep": sep,
        "Oct": oct,
        "Nov": nov,
        "Dec": dec
      };
}
