import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/helpers/list_operation.dart';

import '../tests_model/hint_solution_model.dart';
import 'answer.dart';
import 'comprehension.dart';
import 'mcq_option.dart';
import 'question.dart';

String langCode = 'en_US';

class PreCapExamData {
  String? id;
  String? lang;
  String? type;
  String? orId;
  List<String>? keyLearnings;
  List<String>? concepts;
  List<dynamic>? tags;
  List<Topic>? topics;
  List<String>? askedInExams;
  Question? question;
  Answer? answer;
  List<McqOption>? mcqOptions;
  Comprehension? comprehension;
  Solution? hint;
  Solution? solution;
  String? difficulty;
  List<String>? blooms;
  List<String>? skills;
  String? createdBy;
  String? updatedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? isPublisher;
  String? publisher;
  String? book;
  bool? trueFalseAns;
  String? concept;
  String? keyLearning;
  String? startedAt;
  bool? previousConceptCleared;
  bool? previouskeyLearningCleared;
  bool? isRandom;

  PreCapExamData({
    this.id,
    this.lang,
    this.type,
    this.orId,
    this.keyLearnings,
    this.concepts,
    this.tags,
    this.topics,
    this.askedInExams,
    this.question,
    this.answer,
    this.mcqOptions,
    this.comprehension,
    this.hint,
    this.solution,
    this.difficulty,
    this.blooms,
    this.skills,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isPublisher,
    this.publisher,
    this.book,
    this.trueFalseAns,
    this.concept,
    this.keyLearning,
    this.startedAt,
    this.previousConceptCleared,
    this.previouskeyLearningCleared,
    this.isRandom,
  });

  @override
  String toString() {
    return 'Data(id: $id, lang: $lang, type: $type, orId: $orId, keyLearnings: $keyLearnings, concepts: $concepts, tags: $tags, askedInExams: $askedInExams, question: $question, answer: $answer, mcqOptions: $mcqOptions, comprehension: $comprehension,  solution: $solution, hint: $hint, difficulty: $difficulty, blooms: $blooms, skills: $skills, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, isPublisher: $isPublisher, publisher : $publisher, book : $book, trueFalseAns : $trueFalseAns, concept: $concept, keyLearning: $keyLearning, startedAt: $startedAt,previousConceptCleared: $previousConceptCleared,previouskeyLearningCleared: $previouskeyLearningCleared,isRandom: $isRandom)';
  }

  factory PreCapExamData.fromMap(Map<String, dynamic>? data) {
    langCode = data?['lang'] ?? "en_US";
    return PreCapExamData(
      id: data?['_id'] as String?,
      lang: data?['lang'] as String?,
      type: data?['type'] as String?,
      orId: data?['orId'] as String?,
      keyLearnings: data?['keyLearnings']?.cast<String>(),
      concepts: List<String>.from(data?["concepts"]?.map((x) => x) ?? []),
      tags: data?['tags'] as List<dynamic>?,
      topics: List<Topic>.from(data?["topics"]?.map((x) => Topic.fromJson(x)) ?? []),
      askedInExams: data?['askedInExams']?.cast<String>(),
      question: data?['question'] == null ? null : Question.fromMap(data?['question'] as Map<String, dynamic>, data?['lang'] as String?),
      answer: data?['answer'] == null ? null : Answer.fromMap(data?['answer'] as Map<String, dynamic>, data?['lang'] as String?),
      mcqOptions: (data?['isRandom'] ?? false)
          ? listShuffle((data?['mcqOptions'] as List<dynamic>?)
                      ?.map((e) => McqOption.fromMap(e as Map<String, dynamic>, data?['lang'] as String?))
                      .toList() ??
                  [])
              .cast<McqOption>()
          : (data?['mcqOptions'] as List<dynamic>?)?.map((e) => McqOption.fromMap(e as Map<String, dynamic>, data?['lang'] as String?)).toList() ??
              [],
      comprehension:
          data?['comprehension'] == null ? null : Comprehension.fromMap(data?['comprehension'] as Map<String, dynamic>, data?['lang'] as String?),
      hint: data?["hint"] == null ? null : Solution.fromJson(data?["hint"], langCode),
      solution: data?["solution"] == null ? null : Solution.fromJson(data?["solution"], langCode),
      difficulty: data?['difficulty'] as String?,
      createdBy: data?['createdBy'] as String?,
      updatedBy: data?['updatedBy'] as String?,
      status: data?['status'] as String?,
      createdAt: data?['createdAt'] as String?,
      updatedAt: data?['updatedAt'] as String?,
      isPublisher: data?['isPublisher'] as bool?,
      publisher: data?['publisher'] as String?,
      book: data?['book'] as String?,
      trueFalseAns: data?['trueFalseAns'] as bool?,
      concept: data?['concept'] as String?,
      keyLearning: data?['keyLearning'] as String?,
      startedAt: data?['startedAt'] as String?,
      previousConceptCleared: data?['previousConceptCleared'] as bool?,
      previouskeyLearningCleared: data?['previouskeyLearningCleared'] as bool?,
      isRandom: data?['isRandom'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'lang': lang,
        'type': type,
        'orId': orId,
        'keyLearnings': keyLearnings,
        'concepts': concepts,
        'tags': tags,
        "topics": topics,
        'askedInExams': askedInExams,
        'question': question?.toMap(),
        'answer': answer?.toMap(),
        'mcqOptions': mcqOptions?.map((e) => e.toMap()).toList(),
        'comprehension': comprehension?.toMap(),
        'difficulty': difficulty,
        'blooms': blooms,
        'skills': skills,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'isPublisher': isPublisher,
        'publisher': publisher,
        'book': book,
        'trueFalseAns': trueFalseAns,
        'concept': concept,
        'keyLearning': keyLearning,
        'startedAt': startedAt,
        'previousConceptCleared': previousConceptCleared,
        'previouskeyLearningCleared': previouskeyLearningCleared,
        'isRandom': isRandom,
        "hint": hint?.toJson(),
        "solution": solution?.toJson(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory PreCapExamData.fromJson(String data) {
    return PreCapExamData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
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
