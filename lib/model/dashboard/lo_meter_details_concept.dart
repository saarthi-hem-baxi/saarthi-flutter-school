// To parse this JSON data, do
//
//     final loMeterDetailsConceptModal = loMeterDetailsConceptModalFromJson(jsonString);

import 'dart:convert';

LoMeterDetailsConceptModal loMeterDetailsConceptModalFromJson(str) => LoMeterDetailsConceptModal.fromJson(str);

String loMeterDetailsConceptModalToJson(LoMeterDetailsConceptModal data) => json.encode(data.toJson());

class LoMeterDetailsConceptModal {
  LoMeterDetailsConceptModal({
    this.conceptData,
    this.chapterName,
  });

  List<ConceptDatum>? conceptData;
  String? chapterName;

  factory LoMeterDetailsConceptModal.fromJson(Map<String, dynamic>? json) => LoMeterDetailsConceptModal(
        conceptData: List<ConceptDatum>.from(json?["conceptData"].map((x) => ConceptDatum.fromJson(x)) ?? []),
        chapterName: json?["chapterName"],
      );

  Map<String, dynamic> toJson() => {
        "conceptData": List<dynamic>.from(conceptData?.map((x) => x.toJson()) ?? []),
        "chapterName": chapterName,
      };
}

class ConceptDatum {
  ConceptDatum({
    this.concept,
    this.avgClassCleared,
    this.status,
    this.date,
  });

  String? concept;
  num? avgClassCleared;
  bool? status;
  DateTime? date;

  factory ConceptDatum.fromJson(Map<String, dynamic>? json) => ConceptDatum(
        concept: json?["concept"],
        avgClassCleared: json?["avgClassCleared"],
        status: json?["status"],
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "concept": concept,
        "avgClassCleared": avgClassCleared,
        "status": status,
        "date": date?.toIso8601String(),
      };
}
