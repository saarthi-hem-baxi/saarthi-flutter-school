import 'dart:convert';
import '../tests_model/hint_solution_model.dart';

OnlineTestAnswerKeyModal onlineTestAnswerKeyModalFromJson(String str) => OnlineTestAnswerKeyModal.fromJson(json.decode(str));

String onlineTestAnswerKeyModalToJson(OnlineTestAnswerKeyModal data) => json.encode(data.toJson());

String? langCode;

class OnlineTestAnswerKeyModal {
  OnlineTestAnswerKeyModal({
    this.id,
    this.lang,
    this.questions,
  });

  String? id;
  String? lang;
  List<Questions>? questions;

  factory OnlineTestAnswerKeyModal.fromJson(Map<String, dynamic>? json) {
    langCode = json?['lang'] ?? "en_US";
    return OnlineTestAnswerKeyModal(
      id: json?["_id"],
      questions: List<Questions>.from(json?["questions"].map((x) => Questions.fromJson(x))),
      lang: json?["lang"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "questions": List<dynamic>.from(questions?.map((x) => x.toJson()) ?? []),
        "lang": lang,
      };
}

class Questions {
  Questions({
    this.qus,
    this.topicName,
    this.answer,
    this.orId,
    this.correct,
    this.concepts,
    this.keyLearnings,
    this.topics,
    this.timeTaken,
    this.startedAt,
    this.endAt,
    this.id,
    this.conceptName,
  });

  SingleQuesion? qus;
  Topic? topicName;
  String? answer;
  String? orId;
  bool? correct;
  List<String>? concepts;
  List<dynamic>? keyLearnings;
  List<String>? topics;
  int? timeTaken;
  DateTime? startedAt;
  DateTime? endAt;
  String? id;
  Concept? conceptName;

  factory Questions.fromJson(Map<String, dynamic>? json) => Questions(
        qus: json?["question"] == null ? null : SingleQuesion.fromJson(json?["question"]),
        topicName: json?["topic"] == null ? null : Topic.fromJson(json?["topic"]),
        answer: json?["answer"],
        orId: json?["orId"],
        correct: json?["correct"],
        concepts: json?["concepts"] == null ? null : List<String>.from(json?["concepts"].map((x) => x) ?? []),
        keyLearnings: json?["keyLearnings"] == null ? null : List<dynamic>.from(json?["keyLearnings"].map((x) => x) ?? []),
        topics: json?["topics"] == null ? null : List<String>.from(json?["topics"].map((x) => x) ?? []),
        timeTaken: json?["timeTaken"],
        startedAt: json?["startedAt"] == null ? null : DateTime.parse(json?["startedAt"]),
        endAt: json?["endAt"] == null ? null : DateTime.parse(json?["endAt"]),
        id: json?["_id"],
        conceptName: json?["concept"] == null ? null : Concept.fromJson(json?["concept"], langCode),
      );

  Map<String, dynamic> toJson() => {
        "question": qus?.toJson(),
        "topic": topicName,
        "answer": answer,
        "orId": orId,
        "correct": correct,
        "concepts": List<dynamic>.from(concepts?.map((x) => x) ?? []),
        "keyLearnings": List<dynamic>.from(keyLearnings?.map((x) => x) ?? []),
        "topics": List<dynamic>.from(topics?.map((x) => x) ?? []),
        "timeTaken": timeTaken,
        "startedAt": startedAt?.toIso8601String(),
        "endAt": endAt?.toIso8601String(),
        "_id": id,
      };
}

class SingleQuesion {
  SingleQuesion({
    this.id,
    this.type,
    this.question,
    this.mcqOptions,
    this.trueFalseAns,
    this.solution,
  });

  String? id;
  String? type;
  Name? question;
  List<McqOption>? mcqOptions;
  bool? trueFalseAns;
  Solution? solution;

  factory SingleQuesion.fromJson(Map<String, dynamic>? json) {
    langCode = langCode;
    return SingleQuesion(
      id: json?["_id"],
      type: json?["type"],
      question: Name.fromJson(json?["question"]),
      mcqOptions: List<McqOption>.from(json?["mcqOptions"].map((x) => McqOption.fromJson(x)) ?? []),
      trueFalseAns: json?["trueFalseAns"],
      solution: json?["solution"] == null ? null : Solution.fromJson(json?["solution"], langCode ?? 'en_US'),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "question": question?.toJson(),
        "mcqOptions": List<dynamic>.from(mcqOptions?.map((x) => x.toJson()) ?? []),
        "trueFalseAns": trueFalseAns,
        "solution": solution?.toJson(),
      };
}

class McqOption {
  McqOption({
    this.option,
    this.correct,
    this.id,
  });

  Name? option;
  bool? correct;
  String? id;

  factory McqOption.fromJson(Map<String, dynamic>? json) => McqOption(
        option: Name.fromJson(json?["option"]),
        correct: json?["correct"],
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "option": option?.toJson(),
        "correct": correct,
        "_id": id,
      };
}

class Concept {
  Concept({
    this.id,
    this.name,
  });

  String? id;
  TopicConceptName? name;

  factory Concept.fromJson(Map<String, dynamic> json, String? langCode) => Concept(
        id: json["_id"],
        name: json["name"] == null ? null : TopicConceptName.fromJson(json["name"], langCode),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name?.toJson(),
      };
}

class Topic {
  Topic({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Name {
  Name({
    this.lang,
  });

  String? lang;

  factory Name.fromJson(Map<String, dynamic>? json) => Name(
        lang: json?[langCode],
      );

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}

class TopicConceptName {
  TopicConceptName({
    this.lang,
  });

  String? lang;

  factory TopicConceptName.fromJson(Map<String, dynamic>? json, String? langCode) => TopicConceptName(
        lang: json?[langCode],
      );

  Map<String, dynamic> toJson() => {
        "$langCode": lang,
      };
}
