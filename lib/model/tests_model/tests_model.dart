import 'dart:convert';

import '../chapters_model/datum.dart';
import '../subject_model/datum.dart';

class TestsModel {
  List<TestData>? tests;
  int? total;
  int? page;
  int? limit;

  TestsModel({this.tests, this.total, this.page, this.limit});

  @override
  String toString() {
    return 'Generatetestmodel(tests: $tests, total: $total, page: $page, limit: $limit)';
  }

  factory TestsModel.fromMap(Map<String, dynamic> data) {
    return TestsModel(
      tests: (data['data']['tests'] as List<dynamic>?)?.map((e) => TestData.fromMap(e as Map<String, dynamic>)).toList(),
      total: data['data']['total'] as int?,
      page: data['data']['page'] as int?,
      limit: data['data']['limit'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'tests': tests?.map((e) => e.toMap()).toList(),
        'total': total,
        'page': page,
        'limit': limit,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TestsModel].
  factory TestsModel.fromJson(String data) {
    return TestsModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TestsModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

class TestData {
  Completed? completed;
  Started? started;
  Assigned? assigned;
  Submitted? submitted;
  Skipped? skipped;
  HasOpened? hasOpened;
  Skills? skills;
  Blooms? blooms;
  String? id;
  String? school;
  String? testClass;
  String? section;
  String? student;
  Datum? subject;
  ChaptersDatum? chapter;
  String? homework;
  String? type;
  String? name;
  String? worksheet;
  bool? shareAnswerKey;
  bool? automaticShareAnswerKey;
  List<Topics>? topics;
  bool? hasDuedate;
  List<HomeworkHistory>? homeworkHistory;
  int? attempts;
  int? correct;
  int? wrong;
  List<dynamic>? concepts;
  bool? isSystemGenerated;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<dynamic>? questionTypes;
  List<dynamic>? submissions;
  List<Question>? questions;
  String? createdAt;
  String? updatedAt;
  int? v;

  ExamCompleted? examCompleted;
  ExamStarted? examStarted;
  ExamSkipped? examSkipped;
  ExamAssigned? examAssigned;
  String? precap;
  List<PreConcept>? preConcepts;
  DateTime? dueDate;
  List<ExamStatusHistory>? examStatusHistory;
  String? description;
  bool? hasSubmission;
  bool? hasMarking;
  List<ClassworkHistory>? classworkHistory;

  TestData({
    this.completed,
    this.started,
    this.assigned,
    this.submitted,
    this.skipped,
    this.hasOpened,
    this.skills,
    this.blooms,
    this.id,
    this.school,
    this.testClass,
    this.section,
    this.student,
    this.subject,
    this.chapter,
    this.homework,
    this.type,
    this.name,
    this.worksheet,
    this.shareAnswerKey,
    this.automaticShareAnswerKey,
    this.topics,
    this.hasDuedate,
    this.homeworkHistory,
    this.attempts,
    this.correct,
    this.wrong,
    this.concepts,
    this.isSystemGenerated,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.questionTypes,
    this.submissions,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.examCompleted,
    this.examStarted,
    this.examSkipped,
    this.examAssigned,
    this.precap,
    this.preConcepts,
    this.dueDate,
    this.examStatusHistory,
    this.description,
    this.hasSubmission,
    this.hasMarking,
    this.classworkHistory,
  });

  @override
  String toString() {
    return 'Test(completed: $completed, started: $started, assigned: $assigned, submitted: $submitted, skipped: $skipped, hasOpened: $hasOpened, skills: $skills, blooms: $blooms, id: $id, school: $school, testClass: $testClass, section: $section, student: $student, subject: $subject, chapter: $chapter, homework: $homework, type: $type, name: $name, worksheet: $worksheet, shareAnswerKey: $shareAnswerKey, automaticShareAnswerKey: $automaticShareAnswerKey, topics: $topics, hasDuedate: $hasDuedate, homeworkHistory: $homeworkHistory, attempts: $attempts, correct: $correct, wrong: $wrong, concepts: $concepts, isSystemGenerated: $isSystemGenerated, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, questionTypes: $questionTypes, submissions: $submissions, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, id: $id, examCompleted: $examCompleted, examStarted: $examStarted, examSkipped: $examSkipped, examAssigned: $examAssigned, precap: $precap, preConcepts: $preConcepts, dueDate: $dueDate, examStatusHistory: $examStatusHistory,  description: $description, hasSubmission: $hasSubmission, hasMarking: $hasMarking, classworkHistory: $classworkHistory)';
  }

  factory TestData.fromMap(Map<String, dynamic> data) => TestData(
        completed: data['completed'] == null ? null : Completed.fromMap(data['completed'] as Map<String, dynamic>),
        started: data['started'] == null ? null : Started.fromMap(data['started'] as Map<String, dynamic>),
        assigned: data['assigned'] == null ? null : Assigned.fromMap(data['assigned'] as Map<String, dynamic>),
        submitted: data['submitted'] == null ? null : Submitted.fromMap(data['submitted'] as Map<String, dynamic>),
        skipped: data['skipped'] == null ? null : Skipped.fromMap(data['skipped'] as Map<String, dynamic>),
        hasOpened: data['hasOpened'] == null ? null : HasOpened.fromMap(data['hasOpened'] as Map<String, dynamic>),
        skills: data['skills'] == null ? null : Skills.fromMap(data['skills'] as Map<String, dynamic>),
        blooms: data['blooms'] == null ? null : Blooms.fromMap(data['blooms'] as Map<String, dynamic>),
        id: data['_id'] as String?,
        school: data['school'] as String?,
        testClass: data['class'] as String?,
        section: data['section'] as String?,
        student: data['student'] as String?,
        subject: data['subject'] == null ? null : Datum.fromMap(data['subject'] as Map<String, dynamic>),
        chapter: data['chapter'] == null ? null : ChaptersDatum.fromMap(data['chapter'] as Map<String, dynamic>),
        homework: data['homework'] as String?,
        type: data['type'] as String?,
        name: data['name'] as String?,
        worksheet: data['worksheet'] as String?,
        shareAnswerKey: data['shareAnswerKey'] as bool?,
        automaticShareAnswerKey: data['automaticShareAnswerKey'] as bool?,
        topics: (data['topics'] as List<dynamic>?)?.map((e) => Topics.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
        hasDuedate: data['hasDuedate'] as bool?,
        homeworkHistory: (data['homeworkHistory'] as List<dynamic>?)?.map((e) => HomeworkHistory.fromMap(e as Map<String, dynamic>)).toList(),
        attempts: data['attempts'] as int?,
        correct: data['correct'] as int?,
        wrong: data['wrong'] as int?,
        concepts: data['concepts'] as List<dynamic>?,
        isSystemGenerated: data['isSystemGenerated'] as bool?,
        createdBy: data['createdBy'] as String?,
        updatedBy: data['updatedBy'] as String?,
        status: data['status'] as String?,
        questionTypes: data['questionTypes'] as List<dynamic>?,
        submissions: data['submissions'] as List<dynamic>?,
        questions: (data['questions'] as List<dynamic>?)?.map((e) => Question.fromMap(e as Map<String, dynamic>)).toList(),
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        v: data['__v'] as int?,
        examCompleted: data['examCompleted'] == null ? null : ExamCompleted.fromMap(data['examCompleted'] as Map<String, dynamic>),
        examStarted: data['examStarted'] == null ? null : ExamStarted.fromMap(data['examStarted'] as Map<String, dynamic>),
        examSkipped: data['examSkipped'] == null ? null : ExamSkipped.fromMap(data['examSkipped'] as Map<String, dynamic>),
        examAssigned: data['examAssigned'] == null ? null : ExamAssigned.fromMap(data['examAssigned'] as Map<String, dynamic>),
        precap: data['precap'] as String?,
        preConcepts: (data['preConcepts'] as List<dynamic>?)?.map((e) => PreConcept.fromMap(e as Map<String, dynamic>)).toList(),
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']).toLocal() : null,
        examStatusHistory: (data['examStatusHistory'] as List<dynamic>?)?.map((e) => ExamStatusHistory.fromMap(e as Map<String, dynamic>)).toList(),
        description: data['description'] as String?,
        hasSubmission: data['hasSubmission'] as bool?,
        hasMarking: data['hasMarking'] as bool?,
        classworkHistory: (data['classworkHistory'] as List<dynamic>?)?.map((e) => ClassworkHistory.fromMap(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toMap() => {
        'completed': completed?.toMap(),
        'started': started?.toMap(),
        'assigned': assigned?.toMap(),
        'submitted': submitted?.toMap(),
        'skipped': skipped?.toMap(),
        'hasOpened': hasOpened?.toMap(),
        'skills': skills?.toMap(),
        'blooms': blooms?.toMap(),
        '_id': id,
        'school': school,
        'class': testClass,
        'section': section,
        'student': student,
        'subject': subject?.toMap(),
        'chapter': chapter?.toMap(),
        'homework': homework,
        'type': type,
        'name': name,
        'worksheet': worksheet,
        'shareAnswerKey': shareAnswerKey,
        'automaticShareAnswerKey': automaticShareAnswerKey,
        'topics': topics?.map((e) => e.toMap()).toList(),
        'hasDuedate': hasDuedate,
        'homeworkHistory': homeworkHistory?.map((e) => e.toMap()).toList(),
        'attempts': attempts,
        'correct': correct,
        'wrong': wrong,
        'concepts': concepts,
        'isSystemGenerated': isSystemGenerated,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'questionTypes': questionTypes,
        'submissions': submissions,
        'questions': questions?.map((e) => e.toMap()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'id': id,
        'examCompleted': examCompleted?.toMap(),
        'examStarted': examStarted?.toMap(),
        'examSkipped': examSkipped?.toMap(),
        'examAssigned': examAssigned?.toMap(),
        'precap': precap,
        'preConcepts': preConcepts?.map((e) => e.toMap()).toList(),
        'dueDate': dueDate?.toUtc().toIso8601String(),
        'examStatusHistory': examStatusHistory?.map((e) => e.toMap()).toList(),
        'description': description,
        'hasSubmission': hasSubmission,
        'hasMarking': hasMarking,
        'classworkHistory': classworkHistory?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TestData].
  factory TestData.fromJson(String data) {
    return TestData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TestData] to a JSON string.
  String toJson() => json.encode(toMap());
}

class Completed {
  bool? status;
  DateTime? date;

  Completed({this.status, this.date});

  @override
  String toString() => 'Completed(status: $status, date: $date)';

  factory Completed.fromMap(Map<String, dynamic> data) => Completed(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Completed.fromJson(String data) => Completed.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Assigned {
  bool? status;
  DateTime? date;

  Assigned({this.status, this.date});

  @override
  String toString() => 'Assigned(status: $status, date: $date)';

  factory Assigned.fromMap(Map<String, dynamic> data) => Assigned(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Assigned.fromJson(String data) => Assigned.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Started {
  bool? status;
  DateTime? date;

  Started({this.status, this.date});

  @override
  String toString() => 'Completed(status: $status, date: $date)';

  factory Started.fromMap(Map<String, dynamic> data) => Started(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Started.fromJson(String data) => Started.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Submitted {
  dynamic status;

  Submitted({this.status});

  @override
  String toString() => 'Submitted(status: $status)';

  factory Submitted.fromMap(Map<String, dynamic> data) => Submitted(
        status: data['status'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  factory Submitted.fromJson(String data) => Submitted.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Skipped {
  dynamic status;

  Skipped({this.status});

  @override
  String toString() => 'Skipped(status: $status)';

  factory Skipped.fromMap(Map<String, dynamic> data) => Skipped(
        status: data['status'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  factory Skipped.fromJson(String data) => Skipped.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class HasOpened {
  bool? status;
  String? date;

  HasOpened({this.status, this.date});

  @override
  String toString() => 'HasOpened(status: $status, date: $date)';

  factory HasOpened.fromMap(Map<String, dynamic> data) => HasOpened(
        status: data['status'] as bool?,
        date: data['date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
      };

  factory HasOpened.fromJson(String data) => HasOpened.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Skills {
  dynamic problemSolving;
  dynamic criticalThinking;
  dynamic creativity;
  dynamic decisionMaking;

  Skills({
    this.problemSolving,
    this.criticalThinking,
    this.creativity,
    this.decisionMaking,
  });

  @override
  String toString() {
    return 'Skills(problemSolving: $problemSolving, criticalThinking: $criticalThinking, creativity: $creativity, decisionMaking: $decisionMaking)';
  }

  factory Skills.fromMap(Map<String, dynamic> data) => Skills(
        problemSolving: data['problemSolving'] as dynamic,
        criticalThinking: data['criticalThinking'] as dynamic,
        creativity: data['creativity'] as dynamic,
        decisionMaking: data['decisionMaking'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'problemSolving': problemSolving,
        'criticalThinking': criticalThinking,
        'creativity': creativity,
        'decisionMaking': decisionMaking,
      };

  factory Skills.fromJson(String data) => Skills.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Blooms {
  dynamic knowledge;
  dynamic application;
  dynamic analysis;
  dynamic understanding;
  dynamic evaluation;
  dynamic creations;

  Blooms({
    this.knowledge,
    this.application,
    this.analysis,
    this.understanding,
    this.evaluation,
    this.creations,
  });

  @override
  String toString() {
    return 'Blooms(knowledge: $knowledge, application: $application, analysis: $analysis, understanding: $understanding, evaluation: $evaluation, creations: $creations)';
  }

  factory Blooms.fromMap(Map<String, dynamic> data) => Blooms(
        knowledge: data['knowledge'] as dynamic,
        application: data['application'] as dynamic,
        analysis: data['analysis'] as dynamic,
        understanding: data['understanding'] as dynamic,
        evaluation: data['evaluation'] as dynamic,
        creations: data['creations'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'knowledge': knowledge,
        'application': application,
        'analysis': analysis,
        'understanding': understanding,
        'evaluation': evaluation,
        'creations': creations,
      };

  factory Blooms.fromJson(String data) => Blooms.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Completion {
  String? id;
  int? completion;

  Completion({this.id, this.completion});

  @override
  String toString() => 'Completion(id: $id, completion: $completion)';

  factory Completion.fromMap(Map<String, dynamic> data) => Completion(
        id: data['_id'] as String?,
        completion: data['completion'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'completion': completion,
      };

  factory Completion.fromJson(String data) => Completion.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Topics {
  // String? topicInList;
  dynamic topic; //may be of Type Topic or String
  String? type;
  String? id;
  int? questionCount;

  Topics({this.topic, this.type, this.id, this.questionCount});

  @override
  String toString() => 'Topic(topic: $topic, type: $type, id: $id)';

  factory Topics.fromMap(Map<String, dynamic> data, String? langCode) => Topics(
      // topicInList: data['topic'] == null ? null : data['topic'] as String?,
      topic: data['topic'] == null
          ? data['concept'] == null
              ? null
              : data['concept'].runtimeType == String
                  ? data['concept'] as String
                  : Topic.fromMap(data['concept'], langCode)
          : data['topic'].runtimeType == String
              ? data['topic'] as String
              : Topic.fromMap(data['topic'], langCode),
      type: data['type'] as String?,
      id: data['id'] as String?,
      questionCount: data['questionCount'] == null ? null : data['questionCount'] as int?);

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'type': type,
        'id': id,
        'questionCount': questionCount,
      };
}

class Topic {
  String? name;
  String? id;

  Topic({this.name, this.id});

  @override
  String toString() => 'Topic(name: $name,id: $id)';

  factory Topic.fromMap(Map<String, dynamic> data, String? langCode) => Topic(
        name: data['name'].runtimeType == String ? data['name'] as String? : data['name'][langCode ?? "en_US"] as String?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}

class HomeworkHistory {
  String? status;
  String? date;
  String? id;

  HomeworkHistory({this.status, this.date, this.id});

  @override
  String toString() {
    return 'HomeworkHistory(status: $status, date: $date, id: $id)';
  }

  factory HomeworkHistory.fromMap(Map<String, dynamic> data) {
    return HomeworkHistory(
      status: data['status'] as String?,
      date: data['date'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
        '_id': id,
      };

  factory HomeworkHistory.fromJson(String data) => HomeworkHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Question {
  String? question;
  String? topic;
  String? answer;
  String? orId;
  bool? correct;
  List<dynamic>? concepts;
  List<dynamic>? keyLearnings;
  List<dynamic>? topics;
  int? timeTaken;
  String? startedAt;
  String? endAt;
  String? id;

  Question({
    this.question,
    this.topic,
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
  });

  @override
  String toString() {
    return 'Question(question: $question, topic: $topic, answer: $answer, orId: $orId, correct: $correct, concepts: $concepts, keyLearnings: $keyLearnings, topics: $topics, timeTaken: $timeTaken, startedAt: $startedAt, endAt: $endAt, id: $id)';
  }

  factory Question.fromMap(Map<String, dynamic> data) => Question(
        question: data['question'] as String?,
        topic: data['topic'] as String?,
        answer: data['answer'] as String?,
        orId: data['orId'] as String?,
        correct: data['correct'] as bool?,
        concepts: data['concepts'] as List<dynamic>?,
        keyLearnings: data['keyLearnings'] as List<dynamic>?,
        topics: data['topics'] as List<dynamic>?,
        timeTaken: data['timeTaken'] as int?,
        startedAt: data['startedAt'] as String?,
        endAt: data['endAt'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'question': question,
        'topic': topic,
        'answer': answer,
        'orId': orId,
        'correct': correct,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        'topics': topics,
        'timeTaken': timeTaken,
        'startedAt': startedAt,
        'endAt': endAt,
        '_id': id,
      };

  factory Question.fromJson(String data) => Question.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class ExamCompleted {
  bool? status;
  DateTime? date;

  ExamCompleted({
    this.status,
    this.date,
  });

  @override
  String toString() => 'ExamCompleted(status: $status, date: $date)';

  factory ExamCompleted.fromMap(Map<String, dynamic> data) => ExamCompleted(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory ExamCompleted.fromJson(String data) => ExamCompleted.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class ExamStarted {
  bool? status;
  DateTime? date;

  ExamStarted({this.status, this.date});

  @override
  String toString() => 'ExamStarted(status: $status, date: $date)';

  factory ExamStarted.fromMap(Map<String, dynamic> data) => ExamStarted(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory ExamStarted.fromJson(String data) {
    return ExamStarted.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

class ExamSkipped {
  bool? status;

  ExamSkipped({this.status});

  @override
  String toString() => 'ExamSkipped(status: $status)';

  factory ExamSkipped.fromMap(Map<String, dynamic> data) => ExamSkipped(
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  factory ExamSkipped.fromJson(String data) => ExamSkipped.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class ExamAssigned {
  bool? status;
  DateTime? date;

  ExamAssigned({this.status, this.date});

  @override
  String toString() => 'ExamAssigned(status: $status, date: $date)';

  factory ExamAssigned.fromMap(Map<String, dynamic> data) => ExamAssigned(
        status: data['status'] as bool?,
        date: data['date'] != null ? DateTime.parse(data['date']).toLocal() : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory ExamAssigned.fromJson(String data) => ExamAssigned.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class PreConcept {
  String? concept;
  int? clarity;
  bool? cleared;
  List<KeyLearning>? keyLearnings;
  String? id;
  String? clearedAt;

  PreConcept({
    this.concept,
    this.clarity,
    this.cleared,
    this.keyLearnings,
    this.id,
    this.clearedAt,
  });

  @override
  String toString() {
    return 'PreConcept(concept: $concept, clarity: $clarity, cleared: $cleared, keyLearnings: $keyLearnings, id: $id, clearedAt: $clearedAt)';
  }

  factory PreConcept.fromMap(Map<String, dynamic> data) => PreConcept(
        concept: data['concept'] as String?,
        clarity: data['clarity'] as int?,
        cleared: data['cleared'] as bool?,
        keyLearnings: (data['keyLearnings'] as List<dynamic>?)?.map((e) => KeyLearning.fromMap(e as Map<String, dynamic>)).toList(),
        id: data['_id'] as String?,
        clearedAt: data['clearedAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'concept': concept,
        'clarity': clarity,
        'cleared': cleared,
        'keyLearnings': keyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
        'clearedAt': clearedAt,
      };

  factory PreConcept.fromJson(String data) => PreConcept.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class KeyLearning {
  String? keyLearning;
  bool? cleared;
  String? id;
  String? clearedAt;

  KeyLearning({this.keyLearning, this.cleared, this.id, this.clearedAt});

  @override
  String toString() {
    return 'KeyLearning(keyLearning: $keyLearning, cleared: $cleared, id: $id, clearedAt: $clearedAt)';
  }

  factory KeyLearning.fromMap(Map<String, dynamic> data) => KeyLearning(
        keyLearning: data['keyLearning'] as String?,
        cleared: data['cleared'] as bool?,
        id: data['_id'] as String?,
        clearedAt: data['clearedAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning,
        'cleared': cleared,
        '_id': id,
        'clearedAt': clearedAt,
      };

  factory KeyLearning.fromJson(String data) => KeyLearning.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class ExamStatusHistory {
  String? status;
  String? date;
  String? id;

  ExamStatusHistory({this.status, this.date, this.id});

  @override
  String toString() {
    return 'ExamStatusHistory(status: $status, date: $date, id: $id)';
  }

  factory ExamStatusHistory.fromMap(Map<String, dynamic> data) {
    return ExamStatusHistory(
      status: data['status'] as String?,
      date: data['date'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
        '_id': id,
      };

  factory ExamStatusHistory.fromJson(String data) => ExamStatusHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class ClassworkHistory {
  String? status;
  String? date;
  String? id;

  ClassworkHistory({this.status, this.date, this.id});

  @override
  String toString() {
    return 'ClassworkHistory(status: $status, date: $date, id: $id)';
  }

  factory ClassworkHistory.fromMap(Map<String, dynamic> data) {
    return ClassworkHistory(
      status: data['status'] as String?,
      date: data['date'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
        '_id': id,
      };

  factory ClassworkHistory.fromJson(String data) => ClassworkHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}
