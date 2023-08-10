import 'dart:convert';

LearnOMeterModal learnOMeterModalFromJson(str) => LearnOMeterModal.fromJson(str);

String learnOMeterModalToJson(LearnOMeterModal data) => json.encode(data.toJson());

class LearnOMeterModal {
  LearnOMeterModal({this.gainedValue, this.totalValue, this.diffrenceValue, this.isValueUp, this.clarity});

  num? gainedValue;
  num? totalValue;
  num? diffrenceValue;
  bool? isValueUp;
  num? clarity;

  factory LearnOMeterModal.fromJson(Map<String, dynamic>? json) => LearnOMeterModal(
      gainedValue: json?["gainedValue"],
      totalValue: json?["totalValue"],
      diffrenceValue: json?["differenceValue"],
      isValueUp: json?["isValueUp"],
      clarity: json?['clarity']);

  Map<String, dynamic>? toJson() => {
        "gainedValue": gainedValue,
        "totalValue": totalValue,
        "differenceValue": diffrenceValue,
        "isValueUp": isValueUp,
        "clarity": clarity,
      };
}
