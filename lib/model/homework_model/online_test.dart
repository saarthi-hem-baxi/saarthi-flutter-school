// To parse this JSON data, do
//
//     final onlineTestQuestionModal = onlineTestQuestionModalFromJson(jsonString);

import 'dart:convert';

import '../../helpers/list_operation.dart';
import '../tests_model/hint_solution_model.dart';

OnlineTestQuestionModal onlineTestQuestionModalFromJson(data) => OnlineTestQuestionModal.fromJson(data);

String onlineTestQuestionModalToJson(OnlineTestQuestionModal data) => json.encode(data.toJson());

String langCode = 'en_US';

class OnlineTestQuestionModal {
  OnlineTestQuestionModal({
    this.id,
    this.lang,
    this.type,
    this.orId,
    this.completed,
    this.keyLearnings,
    this.concepts,
    this.tags,
    this.topics,
    this.book,
    this.publisher,
    this.askedInExams,
    this.question,
    this.answer,
    this.mcqOptions,
    this.comprehension,
    this.trueFalseAns,
    this.difficulty,
    this.blooms,
    this.skills,
    this.hint,
    this.solution,
    this.isPublisher,
    this.verify,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.showBookQuestion,
    this.topic,
    this.concept,
    this.startedAt,
    this.currentQuestion,
    this.isRandom,
  });

  String? id;
  String? lang;
  String? type;
  String? orId;
  Completed? completed;
  List<dynamic>? keyLearnings;
  List<String>? concepts;
  List<dynamic>? tags;
  List<Topic>? topics;
  String? book;
  String? publisher;
  List<dynamic>? askedInExams;
  Name? question;
  Name? answer;
  List<McqOption>? mcqOptions;
  Comprehension? comprehension;
  bool? trueFalseAns;
  String? difficulty;
  List<String>? blooms;
  List<String>? skills;
  Solution? hint;
  Solution? solution;
  bool? isPublisher;
  Verify? verify;
  String? createdBy;
  String? updatedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? showBookQuestion;
  String? topic;
  String? concept;
  DateTime? startedAt;
  int? currentQuestion;
  bool? isRandom;

  factory OnlineTestQuestionModal.fromJson(Map<String, dynamic>? json) {
    langCode = json?['lang'] ?? "en_US";
    return OnlineTestQuestionModal(
      id: json?["_id"],
      lang: json?["lang"],
      type: json?["type"],
      orId: json?["orId"],
      completed: Completed.fromJson(json?["completed"]),
      keyLearnings: json?["keyLearnings"] == null ? null : List<dynamic>.from(json?["keyLearnings"].map((x) => x) ?? []),
      concepts: List<String>.from(json?["concepts"]?.map((x) => x) ?? []),
      tags: json?["tags"] == null ? null : List<dynamic>.from(json?["tags"].map((x) => x) ?? []),
      topics: json?["topics"] == null ? null : List<Topic>.from(json?["topics"].map((x) => Topic.fromJson(x)) ?? []),
      book: json?["book"],
      publisher: json?["publisher"],
      askedInExams: json?["askedInExams"] == null ? null : List<dynamic>.from(json?["askedInExams"].map((x) => x) ?? []),
      question: Name.fromJson(json?["question"], langCode),
      answer: Name.fromJson(json?["answer"], langCode),
      mcqOptions: json?["mcqOptions"] == null
          ? null
          : (json?['isRandom'] ?? false)
              ? listShuffle(List<McqOption>.from(json?["mcqOptions"].map((x) => McqOption.fromJson(x)) ?? [])).cast<McqOption>()
              : List<McqOption>.from(json?["mcqOptions"].map((x) => McqOption.fromJson(x)) ?? []),
      trueFalseAns: json?["trueFalseAns"],
      difficulty: json?["difficulty"],
      blooms: json?["blooms"] == null ? null : List<String>.from(json?["blooms"].map((x) => x) ?? []),
      skills: json?["skills"] == null ? null : List<String>.from(json?["skills"].map((x) => x) ?? []),
      hint: json?["hint"] == null ? null : Solution.fromJson(json?["hint"], langCode),
      solution: json?["solution"] == null ? null : Solution.fromJson(json?["solution"], langCode),
      isPublisher: json?["isPublisher"],
      verify: Verify.fromJson(json?["verify"]),
      createdBy: json?["createdBy"],
      updatedBy: json?["updatedBy"],
      status: json?["status"],
      createdAt: json?["createdAt"] == null ? null : DateTime.parse(json?["createdAt"]),
      updatedAt: json?["updatedAt"] == null ? null : DateTime.parse(json?["updatedAt"]),
      showBookQuestion: json?["showBookQuestion"],
      topic: json?["topic"],
      concept: json?["concept"],
      startedAt: json?["startedAt"] == null ? null : DateTime.parse(json?["startedAt"]),
      currentQuestion: json?["currentQuestion"] as int?,
      isRandom: json?['isRandom'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lang": lang,
        "type": type,
        "orId": orId,
        "completed": completed?.toJson(),
        "keyLearnings": List<dynamic>.from(keyLearnings?.map((x) => x) ?? []),
        "concepts": List<dynamic>.from(concepts?.map((x) => x) ?? []),
        "tags": List<dynamic>.from(tags?.map((x) => x) ?? []),
        "topics": List<dynamic>.from(topics?.map((x) => x.toJson()) ?? []),
        "book": book,
        "publisher": publisher,
        "askedInExams": List<dynamic>.from(askedInExams?.map((x) => x) ?? []),
        "question": question?.toJson(),
        "answer": answer?.toJson(),
        "mcqOptions": List<dynamic>.from(mcqOptions?.map((x) => x.toJson()) ?? []),
        "comprehension": comprehension?.toJson(),
        "trueFalseAns": trueFalseAns,
        "difficulty": difficulty,
        "blooms": List<dynamic>.from(blooms?.map((x) => x) ?? []),
        "skills": List<dynamic>.from(skills?.map((x) => x) ?? []),
        "hint": hint?.toJson(),
        "solution": solution?.toJson(),
        "isPublisher": isPublisher,
        "verify": verify?.toJson(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "showBookQuestion": showBookQuestion,
        "topic": topic,
        "concept": concept,
        "startedAt": startedAt?.toIso8601String(),
        "currentQuestion": currentQuestion,
        'isRandom': isRandom,
      };
}

class Name {
  Name({
    this.lang,
  });

  String? lang;

  factory Name.fromJson(Map<String, dynamic>? json, String? langCode) => Name(
        lang: json?[langCode] ?? json?["en_US"],
      );

  Map<String, dynamic> toJson() => {
        "en_US": lang,
      };
}

class Comprehension {
  Comprehension({
    this.lang,
    this.paragraph,
    this.queAns,
  });

  List<dynamic>? lang;
  Name? paragraph;
  List<dynamic>? queAns;

  factory Comprehension.fromJson(Map<String, dynamic>? json) => Comprehension(
        lang: List<dynamic>.from(json?["lang"].map((x) => x) ?? []),
        paragraph: Name.fromJson(json?["paragraph"] ?? [], langCode),
        queAns: List<dynamic>.from(json?["queAns"].map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "lang": List<dynamic>.from(lang?.map((x) => x) ?? []),
        "paragraph": paragraph?.toJson(),
        "queAns": List<dynamic>.from(queAns?.map((x) => x) ?? []),
      };
}

class Completed {
  Completed({this.status, this.date});

  bool? status;
  DateTime? date;

  factory Completed.fromJson(Map<String, dynamic>? json) => Completed(
        status: json?["status"],
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "date": date?.toIso8601String(),
      };
}

// class Hint {
//   Hint({
//     this.description,
//     this.media,
//     this.thumb,
//   });
//
//   Name? description;
//   Name? media;
//   Name? thumb;
//
//   factory Hint.fromJson(Map<String, dynamic>? json) => Hint(
//         description: Name.fromJson(json?["description"], langCode),
//         media: Name.fromJson(json?["media"], langCode),
//         thumb: Name.fromJson(json?["thumb"], langCode),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "description": description?.toJson(),
//         "media": media?.toJson(),
//         "thumb": thumb?.toJson(),
//       };
// }

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
        option: Name.fromJson(json?["option"], langCode),
        correct: json?["correct"],
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "option": option?.toJson(),
        "correct": correct,
        "_id": id,
      };
}

class Topic {
  Topic({
    this.topic,
    this.chapter,
    this.id,
  });

  String? topic;
  String? chapter;
  String? id;

  factory Topic.fromJson(Map<String, dynamic>? json) => Topic(
        topic: json?["topic"],
        chapter: json?["chapter"],
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "chapter": chapter,
        "_id": id,
      };
}

class Verify {
  Verify({
    this.verified,
    this.verifiedAt,
    this.verifiedBy,
  });

  bool? verified;
  DateTime? verifiedAt;
  String? verifiedBy;

  factory Verify.fromJson(Map<String, dynamic>? json) => Verify(
        verified: json?["verified"],
        verifiedAt: json?["verifiedAt"] == null ? null : DateTime.parse(json?["verifiedAt"]),
        verifiedBy: json?["verifiedBy"],
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "verifiedAt": verifiedAt?.toIso8601String(),
        "verifiedBy": verifiedBy,
      };
}
