import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/homework_model/completed.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/started.dart';

import '../../helpers/list_operation.dart';
import '../tests_model/hint_solution_model.dart';
import 'answer.dart';
import 'comprehension.dart';
import 'mcq_option.dart';
import 'question.dart';
import 'topic.dart';
import 'verify.dart';

String langCode = 'en_US';

class SystemGeneratedTestData {
  String? id;
  String? lang;
  String? type;
  String? orId;
  List<String>? keyLearnings;
  List<String>? concepts;
  List<dynamic>? tags;
  List<Topic>? topics;
  String? book;
  String? publisher;
  List<dynamic>? askedInExams;
  Question? question;
  Answer? answer;
  List<McqOption>? mcqOptions;
  Comprehension? comprehension;
  Solution? hint;
  Solution? solution;
  String? difficulty;
  bool? isPublisher;
  bool? trueFalseAns;
  Verify? verify;
  String? createdBy;
  String? updatedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? concept;
  String? keyLearning;
  String? topic;
  String? startedAt;
  Completed? completed;
  Started? started;
  bool? isRandom;

  SystemGeneratedTestData({
    this.id,
    this.lang,
    this.type,
    this.orId,
    this.keyLearnings,
    this.concepts,
    this.tags,
    this.topics,
    this.book,
    this.publisher,
    this.trueFalseAns,
    this.askedInExams,
    this.question,
    this.answer,
    this.mcqOptions,
    this.comprehension,
    // this.hint,
    this.hint,
    this.solution,
    this.difficulty,
    this.isPublisher,
    this.verify,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.concept,
    this.keyLearning,
    this.topic,
    this.startedAt,
    this.completed,
    this.started,
    this.isRandom,
  });

  @override
  String toString() {
    return 'Data(id: $id, lang: $lang, type: $type, orId: $orId, keyLearnings: $keyLearnings, concepts: $concepts, tags: $tags, topics: $topics, book: $book, publisher: $publisher,  trueFalseAns: $trueFalseAns,askedInExams: $askedInExams, question: $question, answer: $answer, mcqOptions: $mcqOptions, comprehension: $comprehension, solution: $solution, hint: $hint, difficulty: $difficulty, isPublisher: $isPublisher, verify: $verify, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, concept: $concept, keyLearning: $keyLearning, startedAt: $startedAt,isRandom: $isRandom)';
  }

  factory SystemGeneratedTestData.fromMap(Map<String, dynamic> data) {
    langCode = data['lang'] ?? "en_US";
    return SystemGeneratedTestData(
      id: data['_id'] as String?,
      lang: data['lang'] as String?,
      type: data['type'] as String?,
      orId: data['orId'] as String?,
      keyLearnings: data['keyLearnings']?.cast<String>(),
      concepts: data['concepts']?.cast<String>(),
      tags: data['tags'] as List<dynamic>?,
      topics: (data['topics'] as List<dynamic>?)?.map((e) => Topic.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
      book: data['book'] as String?,
      publisher: data['publisher'] as String?,
      askedInExams: data['askedInExams'] as List<dynamic>?,
      question: data['question'] == null ? null : Question.fromMap(data['question'] as Map<String, dynamic>, data['lang'] as String?),
      answer: data['answer'] == null ? null : Answer.fromMap(data['answer'] as Map<String, dynamic>, data['lang'] as String?),
      mcqOptions: (data['isRandom'] ?? false)
          ? listShuffle((data['mcqOptions'] as List<dynamic>?)
                      ?.map((e) => McqOption.fromMap(e as Map<String, dynamic>, data['lang'] as String?))
                      .toList() ??
                  [])
              .cast<McqOption>()
          : (data['mcqOptions'] as List<dynamic>?)?.map((e) => McqOption.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList() ?? [],
      comprehension:
          data['comprehension'] == null ? null : Comprehension.fromMap(data['comprehension'] as Map<String, dynamic>, data['lang'] as String?),
      hint: data["hint"] == null ? null : Solution.fromJson(data["hint"], langCode),
      solution: data["solution"] == null ? null : Solution.fromJson(data["solution"], langCode),
      difficulty: data['difficulty'] as String?,
      isPublisher: data['isPublisher'] as bool?,
      trueFalseAns: data['trueFalseAns'] as bool?,
      verify: data['verify'] == null ? null : Verify.fromMap(data['verify'] as Map<String, dynamic>),
      createdBy: data['createdBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
      status: data['status'] as String?,
      createdAt: data['createdAt'] as String?,
      updatedAt: data['updatedAt'] as String?,
      v: data['__v'] as int?,
      concept: data['concept'] as String?,
      keyLearning: data['keyLearning'] as String?,
      topic: data['topic'] as String?,
      startedAt: data['startedAt'] as String?,
      completed: data['completed'] == null ? null : Completed.fromMap(data['completed'] as Map<String, dynamic>),
      started: data['started'] == null ? null : Started.fromMap(data['started'] as Map<String, dynamic>),
      isRandom: data['isRandom'] as bool?,
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
        'topics': topics?.map((e) => e.toMap()).toList(),
        'book': book,
        'publisher': publisher,
        'askedInExams': askedInExams,
        'question': question?.toMap(),
        'answer': answer?.toMap(),
        'mcqOptions': mcqOptions?.map((e) => e.toMap()).toList(),
        'comprehension': comprehension?.toMap(),
        "hint": hint?.toJson(),
        "solution": solution?.toJson(),
        'difficulty': difficulty,
        'isPublisher': isPublisher,
        'trueFalseAns': trueFalseAns,
        'verify': verify?.toMap(),
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'concept': concept,
        'keyLearning': keyLearning,
        'topic': topic,
        'startedAt': startedAt,
        'completed': completed?.toMap(),
        'started': started?.toMap(),
        'isRandom': isRandom,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SystemGeneratedTestData].
  factory SystemGeneratedTestData.fromJson(String data) {
    return SystemGeneratedTestData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SystemGeneratedTestData] to a JSON string.
  String toJson() => json.encode(toMap());
}
