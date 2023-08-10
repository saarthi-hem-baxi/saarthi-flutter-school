// To parse this JSON data, do
//
//     final learningOutcomeTopicConceptModal = learningOutcomeTopicConceptModalFromJson(jsonString);

import 'dart:convert';

LearningOutcomeTopicConceptModal learningOutcomeTopicConceptModalFromJson(str) => LearningOutcomeTopicConceptModal.fromJson(str);

String learningOutcomeTopicConceptModalToJson(LearningOutcomeTopicConceptModal data) => json.encode(data.toJson());

String? _langCode;

class LearningOutcomeTopicConceptModal {
  LearningOutcomeTopicConceptModal({
    this.topicTable,
    this.chapterName,
    this.lang,
  });

  List<TopicTable>? topicTable;
  String? chapterName;
  String? lang;

  factory LearningOutcomeTopicConceptModal.fromJson(Map<String, dynamic>? json) {
    _langCode = json?['lang'] ?? 'en_US';
    return LearningOutcomeTopicConceptModal(
      topicTable: List<TopicTable>.from(json?["topicTable"]?.map((x) => TopicTable.fromJson(x)) ?? []),
      chapterName: json?["chapterName"],
      lang: json?["lang"],
    );
  }

  Map<String, dynamic> toJson() => {
        "topicTable": List<dynamic>.from(topicTable?.map((x) => x.toJson()) ?? []),
        "chapterName": chapterName,
        "lang": lang,
      };
}

class TopicTable {
  TopicTable({
    this.id,
    this.name,
    this.concepts,
    this.type,
    this.cleared,
    this.clearedAt,
    this.classClearity,
  });

  String? id;
  String? name;
  List<ConceptTableConcept>? concepts;
  String? type;
  bool? cleared;
  DateTime? clearedAt;
  num? classClearity;

  factory TopicTable.fromJson(Map<String, dynamic>? json) => TopicTable(
        id: json?["id"],
        name: json?["type"] == "topic" ? (json?["name"]) : (json?['name'][_langCode]),
        concepts: List<ConceptTableConcept>.from(json?["concepts"]?.map((x) => ConceptTableConcept.fromJson(x)) ?? []),
        type: json?["type"],
        cleared: json?["cleared"],
        clearedAt: json?["clearedAt"] == null ? null : DateTime.parse(json?["clearedAt"]).toLocal(),
        classClearity: json?["classClearity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "concepts": List<dynamic>.from(concepts?.map((x) => x.toJson()) ?? []),
        "type": type,
        "cleared": cleared,
        "clearedAt": clearedAt,
        "classClearity": classClearity,
      };
}

class ConceptTableConcept {
  ConceptTableConcept({
    this.id,
    this.name,
    this.cleared,
    this.clearedAt,
    this.classClearity,
    this.type,
  });

  String? id;
  String? name;
  bool? cleared;
  DateTime? clearedAt;
  num? classClearity;
  String? type;

  factory ConceptTableConcept.fromJson(Map<String, dynamic>? json) => ConceptTableConcept(
        id: json?["id"],
        name: json?["name"][_langCode],
        cleared: json?["cleared"],
        clearedAt: json?["clearedAt"] == null ? null : DateTime.parse(json?["clearedAt"]).toLocal(),
        classClearity: json?["classClearity"],
        type: json?["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cleared": cleared,
        "clearedAt": clearedAt,
        "classClearity": classClearity,
        "type": type,
      };
}
