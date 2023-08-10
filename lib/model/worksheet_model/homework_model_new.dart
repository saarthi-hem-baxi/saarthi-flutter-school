import 'dart:convert';

import '../chapters_model/datum.dart';
import '../subject_model/datum.dart';

class HomeworkListModal {
  HomeworkListModal({
    this.worksheets,
    this.total,
    this.page,
    this.limit,
  });

  List<Worksheet>? worksheets;
  int? total;
  int? page;
  int? limit;

  factory HomeworkListModal.fromMap(Map<String, dynamic>? json) => HomeworkListModal(
        // worksheets: List<Worksheet>.from(json?["worksheets"].map((x) => Worksheet.fromJson(x))),
        worksheets: (json?['data']["worksheets"] as List<dynamic>?)?.map((e) => Worksheet.fromMap(e as Map<String, dynamic>)).toList(),
        total: json?["total"],
        page: json?["page"],
        limit: json?["limit"],
      );

  Map<String, dynamic> toMap() => {
        "worksheets": List<dynamic>.from(worksheets?.map((x) => x.toJson()) ?? []),
        "total": total,
        "page": page,
        "limit": limit,
      };

  factory HomeworkListModal.fromJson(String data) => HomeworkListModal.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Worksheet {
  Worksheet({
    this.completed,
    this.started,
    this.examStarted,
    this.assigned,
    this.submitted,
    this.id,
    this.subject,
    this.chapter,
    this.homework,
    this.type,
    this.name,
    this.worksheet,
    this.shareAnswerKey,
    this.topics,
    this.attempts,
    this.correct,
    this.wrong,
    this.concepts,
    this.isSystemGenerated,
    this.submissions,
    this.createdAt,
    this.worksheetId,
    this.examCompleted,
    this.examAssigned,
    this.precap,
    this.preConcepts,
    this.dueDate,
    this.questionPdf,
    this.hasSubmission,
    this.answerPdf,
    this.submissionDate,
    this.obtainedMarks,
    this.totalMarks,
    this.hasMarking,
    this.hasRetest,
    this.cleared,
    this.clearedRetest,
  });

  Assigned? completed;
  Started? started;
  Started? examStarted;
  Assigned? assigned;
  Submitted? submitted;
  String? id;
  Datum? subject;
  ChaptersDatum? chapter;
  String? homework;
  String? type;
  String? name;
  String? worksheet;
  bool? shareAnswerKey;
  bool? hasMarking;
  List<Topics>? topics;
  int? attempts;
  int? correct;
  int? wrong;
  List<dynamic>? concepts;
  bool? isSystemGenerated;
  List<dynamic>? submissions;
  DateTime? createdAt;
  String? worksheetId;
  ExamCompleted? examCompleted;
  Assigned? examAssigned;
  String? precap;
  List<dynamic>? preConcepts;
  DateTime? dueDate;
  String? questionPdf;
  bool? hasSubmission;
  String? answerPdf;
  DateTime? submissionDate;
  int? obtainedMarks;
  int? totalMarks;
  bool? hasRetest;
  bool? cleared;
  bool? clearedRetest;

  factory Worksheet.fromMap(Map<String, dynamic>? json) => Worksheet(
        completed: Assigned.fromJson(json?["completed"]),
        started: json?['started'] == null ? null : Started.fromMap(json?['started'] as Map<String, dynamic>),
        examStarted: json?['examStarted'] == null ? null : Started.fromMap(json?['examStarted'] as Map<String, dynamic>),
        assigned: Assigned.fromJson(json?["assigned"]),
        submitted: json?["submitted"] == null ? null : Submitted.fromJson(json?["submitted"] ?? ''),
        id: json?["_id"],
        subject: Datum.fromMap(json?["subject"]),
        chapter: ChaptersDatum.fromMap(json?["chapter"]),
        homework: json?["homework"],
        type: json?["type"],
        hasMarking: json?['hasMarking'] as bool?,
        questionPdf: json?['questionPdf'] as String?,
        hasSubmission: json?['hasSubmission'] as bool?,
        answerPdf: json?['answerPdf'] as String?,
        submissionDate: json?['submissionDate'] != null ? DateTime.parse(json?['submissionDate']).toLocal() : null,
        obtainedMarks: json?['obtainedMarks'] as int?,
        totalMarks: json?['totalMarks'] as int?,
        name: json?["name"],
        worksheet: json?["worksheet"],
        shareAnswerKey: json?["shareAnswerKey"],
        topics: (json?['topics'] as List<dynamic>?)?.map((e) => Topics.fromMap(e as Map<String, dynamic>)).toList(),
        attempts: json?["attempts"],
        correct: json?["correct"],
        wrong: json?["wrong"],
        concepts: json?["concepts"] == null ? [] : List<dynamic>.from(json?["concepts"].map((x) => x)),
        isSystemGenerated: json?["isSystemGenerated"],
        submissions: json?["submissions"] == null ? [] : List<dynamic>.from(json?["submissions"].map((x) => x)),
        createdAt: DateTime.parse(json?["createdAt"]),
        worksheetId: json?["id"],
        examCompleted: json?["examCompleted"] == null ? null : ExamCompleted.fromJson(json?["examCompleted"]),
        examAssigned: json?["examAssigned"] == null ? null : Assigned.fromJson(json?["examAssigned"]),
        precap: json?["precap"],
        preConcepts: json?["preConcepts"] == null ? null : List<dynamic>.from(json?["preConcepts"].map((x) => x)),
        dueDate: json?["dueDate"] == null ? null : DateTime.parse(json?["dueDate"]),
        hasRetest: json?['hasRetest'] as bool?,
        cleared: json?['cleared'] as bool?,
        clearedRetest: json?['clearedRetest'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "completed": completed?.toJson(),
        "examStarted": examStarted?.toJson(),
        "assigned": assigned?.toJson(),
        "submitted": submitted?.toJson(),
        "_id": id,
        "subject": subject?.toJson(),
        "chapter": chapter?.toJson(),
        "homework": homework,
        "type": type,
        "name": name,
        "worksheet": worksheet,
        "shareAnswerKey": shareAnswerKey,
        'topics': topics?.map((e) => e.toMap()).toList(),
        "attempts": attempts,
        "correct": correct,
        "wrong": wrong,
        'hasMarking': hasMarking,
        "concepts": List<dynamic>.from(concepts?.map((x) => x) ?? []),
        "isSystemGenerated": isSystemGenerated,
        "submissions": List<dynamic>.from(submissions?.map((x) => x) ?? []),
        "createdAt": createdAt?.toIso8601String(),
        "id": worksheetId,
        "examCompleted": examCompleted?.toJson(),
        "examAssigned": examAssigned?.toJson(),
        "precap": precap,
        "preConcepts": preConcepts == null ? null : List<dynamic>.from(preConcepts?.map((x) => x) ?? []),
        "dueDate": dueDate?.toIso8601String(),
        'answerPdf': answerPdf,
        'questionPdf': questionPdf,
        'hasSubmission': hasSubmission,
        'submissionDate': submissionDate?.toUtc().toIso8601String(),
        'obtainedMarks': obtainedMarks,
        'totalMarks': totalMarks,
        'hasRetest': hasRetest,
        'cleared': cleared,
        'clearedRetest': clearedRetest,
      };
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

class Assigned {
  Assigned({
    this.status,
    this.date,
  });

  bool? status;
  DateTime? date;

  factory Assigned.fromJson(Map<String, dynamic>? json) => Assigned(
        status: json?["status"],
        date: json?['date'] != null ? DateTime.parse(json?['date']).toLocal() : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "date": date?.toIso8601String(),
      };
}

// class ChapterData {
//   ChapterData({
//     this.id,
//     this.name,
//     this.orderNumber,
//     this.chapterId,
//   });

//   String? id;
//   String? name;
//   int? orderNumber;
//   String? chapterId;

//   factory ChapterData.fromJson(Map<String, dynamic>? json) => ChapterData(
//         id: json?["_id"],
//         name: json?["name"],
//         orderNumber: json?["orderNumber"],
//         chapterId: json?["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "orderNumber": orderNumber,
//         "id": chapterId,
//       };
// }

// class SubjectData {
//   SubjectData({
//     this.id,
//     this.name,
//     this.orderNumber,
//     this.chapterId,
//     this.chapters,
//   });

//   String? id;
//   String? name;
//   int? orderNumber;
//   String? chapterId;
//   List<ChapterElement>? chapters;

//   factory SubjectData.fromJson(Map<String, dynamic>? json) => SubjectData(
//         id: json?["_id"],
//         name: json?["name"],
//         orderNumber: json?["orderNumber"],
//         chapterId: json?["id"],
//         chapters: json?["chapters"] == null ? null : List<ChapterElement>.from(json?["chapters"].map((x) => ChapterElement.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "orderNumber": orderNumber,
//         "id": chapterId,
//         "chapters": chapters == null ? null : List<dynamic>.from(chapters?.map((x) => x.toJson()) ?? []),
//       };
// }

// class ChapterElement {
//   ChapterElement({
//     this.book,
//     this.chapter,
//     this.order,
//     this.id,
//   });

//   String? book;
//   String? chapter;
//   int? order;
//   String? id;

//   factory ChapterElement.fromJson(Map<String, dynamic>? json) => ChapterElement(
//         book: json?["book"],
//         chapter: json?["chapter"],
//         order: json?["order"],
//         id: json?["_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "book": book,
//         "chapter": chapter,
//         "order": order,
//         "_id": id,
//       };
// }

class ExamCompleted {
  ExamCompleted({
    this.status,
    this.date,
  });

  bool? status;
  DateTime? date;

  factory ExamCompleted.fromJson(Map<String, dynamic>? json) => ExamCompleted(
        status: json?["status"],
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "date": date?.toIso8601String(),
      };
}

class Concept {
  Concept({
    this.concept,
    this.clarity,
    this.cleared,
    this.keyLearnings,
    this.id,
    this.clearedAt,
  });

  String? concept;
  int? clarity;
  bool? cleared;
  List<KeyLearning>? keyLearnings;
  String? id;
  DateTime? clearedAt;

  factory Concept.fromJson(Map<String, dynamic>? json) => Concept(
        concept: json?["concept"],
        clarity: json?["clarity"],
        cleared: json?["cleared"],
        keyLearnings: List<KeyLearning>.from(json?["keyLearnings"].map((x) => KeyLearning.fromJson(x))),
        id: json?["_id"],
        clearedAt: json?["clearedAt"] == null ? null : DateTime.parse(json?["clearedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "concept": concept,
        "clarity": clarity,
        "cleared": cleared,
        "keyLearnings": List<dynamic>.from(keyLearnings?.map((x) => x.toJson()) ?? []),
        "_id": id,
        "clearedAt": clearedAt?.toIso8601String(),
      };
}

class KeyLearning {
  KeyLearning({
    this.keyLearning,
    this.cleared,
    this.id,
    this.clearedAt,
  });

  String? keyLearning;
  bool? cleared;
  String? id;
  DateTime? clearedAt;

  factory KeyLearning.fromJson(Map<String, dynamic>? json) => KeyLearning(
        keyLearning: json?["keyLearning"],
        cleared: json?["cleared"],
        id: json?["_id"],
        clearedAt: json?["clearedAt"] == null ? null : DateTime.parse(json?["clearedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "keyLearning": keyLearning,
        "cleared": cleared,
        "_id": id,
        "clearedAt": clearedAt?.toIso8601String(),
      };
}

class Submitted {
  Submitted({
    this.status,
  });

  dynamic status;

  factory Submitted.fromJson(Map<String, dynamic> json) => Submitted(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
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

  factory Topics.fromMap(
    Map<String, dynamic> data,
  ) =>
      Topics(
          // topicInList: data['topic'] == null ? null : data['topic'] as String?,
          topic: data['topic'] == null
              ? data['concept'] == null
                  ? null
                  : data['concept'].runtimeType == String
                      ? data['concept'] as String
                      : Topic.fromMap(
                          data['concept'],
                        )
              : data['topic'].runtimeType == String
                  ? data['topic'] as String
                  : Topic.fromMap(
                      data['topic'],
                    ),
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

  factory Topic.fromMap(
    Map<String, dynamic> data,
  ) =>
      Topic(
        name: data['name'].runtimeType == String ? data['name'] as String? : data['name'],
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}
