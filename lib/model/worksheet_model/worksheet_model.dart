import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';

class WorksheetModel {
  List<Worksheet>? tests;
  int? total;
  int? page;
  int? limit;

  WorksheetModel({this.tests, this.total, this.page, this.limit});

  @override
  String toString() {
    return 'Generatetestmodel(tests: $tests, total: $total, page: $page, limit: $limit)';
  }

  factory WorksheetModel.fromMap(Map<String, dynamic> data) {
    return WorksheetModel(
      tests: (data['data']['worksheets'] as List<dynamic>?)
          ?.map((e) => Worksheet.fromMap(e as Map<String, dynamic>))
          .toList(),
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

  factory WorksheetModel.fromJson(String data) =>
      WorksheetModel.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Worksheet {
  Assigned? assigned;
  Submitted? submitted;
  Completed? completed;
  String? id;
  Datum? subject;
  ChaptersDatum? chapter;
  String? type;
  String? worksheet;
  String? name;
  String? questionPdf;
  String? answerPdf;
  bool? shareAnswerKey;
  bool? hasSubmission;
  DateTime? submissionDate;
  bool? hasMarking;
  int? totalMarks;
  int? obtainedMarks;
  List<Submission>? submissions;
  String? createdAt;

  Worksheet({
    this.assigned,
    this.submitted,
    this.completed,
    this.id,
    this.subject,
    this.chapter,
    this.type,
    this.worksheet,
    this.name,
    this.questionPdf,
    this.answerPdf,
    this.shareAnswerKey,
    this.hasSubmission,
    this.submissionDate,
    this.hasMarking,
    this.totalMarks,
    this.obtainedMarks,
    this.submissions,
    this.createdAt,
  });

  @override
  String toString() {
    return 'Worksheet(assigned: $assigned, submitted: $submitted, id: $id, subject: $subject, chapter: $chapter, type: $type, worksheet: $worksheet, name: $name, questionPdf: $questionPdf, answerPdf: $answerPdf, shareAnswerKey: $shareAnswerKey,answerPdf: $answerPdf, hasSubmission: $hasSubmission, submissionDate: $submissionDate, hasMarking: $hasMarking, totalMarks: $totalMarks, submissions: $submissions, createdAt: $createdAt, id: $id)';
  }

  factory Worksheet.fromMap(Map<String, dynamic> data) => Worksheet(
        assigned: data['assigned'] == null
            ? null
            : Assigned.fromMap(data['assigned'] as Map<String, dynamic>),
        submitted: data['submitted'] == null
            ? null
            : Submitted.fromMap(data['submitted'] as Map<String, dynamic>),
        completed: data['completed'] == null
            ? null
            : Completed.fromMap(data['completed'] as Map<String, dynamic>),
        id: data['_id'] as String?,
        subject: data['subject'] == null
            ? null
            : Datum.fromMap(data['subject'] as Map<String, dynamic>),
        chapter: data['chapter'] == null
            ? null
            : ChaptersDatum.fromMap(data['chapter'] as Map<String, dynamic>),
        type: data['type'] as String?,
        worksheet: data['worksheet'] as String?,
        name: data['name'] as String?,
        questionPdf: data['questionPdf'] as String?,
        answerPdf: data['answerPdf'] as String?,
        hasSubmission: data['hasSubmission'] as bool?,
        shareAnswerKey: data['shareAnswerKey'] as bool?,
        submissionDate: data['submissionDate'] != null
            ? DateTime.parse(data['submissionDate']).toLocal()
            : null,
        hasMarking: data['hasMarking'] as bool?,
        totalMarks: data['totalMarks'] as int?,
        obtainedMarks: data['obtainedMarks'] as int?,
        submissions: (data['submissions'] as List<dynamic>?)
            ?.map((e) => Submission.fromMap(e as Map<String, dynamic>))
            .toList(),
        createdAt: data['createdAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'assigned': assigned?.toMap(),
        'submitted': submitted?.toMap(),
        'completed': completed?.toMap(),
        '_id': id,
        'subject': subject?.toMap(),
        'chapter': chapter?.toMap(),
        'type': type,
        'worksheet': worksheet,
        'name': name,
        'questionPdf': questionPdf,
        'answerPdf': answerPdf,
        'hasSubmission': hasSubmission,
        'shareAnswerKey': shareAnswerKey,
        'submissionDate': submissionDate?.toUtc().toIso8601String(),
        'hasMarking': hasMarking,
        'totalMarks': totalMarks,
        'obtainedMarks': obtainedMarks,
        'submissions': submissions?.map((e) => e.toMap()).toList(),
        'createdAt': createdAt,
        'id': id,
      };

  factory Worksheet.fromJson(String data) =>
      Worksheet.fromMap(json.decode(data) as Map<String, dynamic>);
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
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Assigned.fromJson(String data) =>
      Assigned.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Submitted {
  bool? status;
  DateTime? date;

  Submitted({this.status, this.date});

  @override
  String toString() => 'Submitted(status: $status, date: $date)';

  factory Submitted.fromMap(Map<String, dynamic> data) => Submitted(
        status: data['status'] as bool?,
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Submitted.fromJson(String data) =>
      Submitted.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Completed {
  bool? status;
  DateTime? date;

  Completed({this.status, this.date});

  @override
  String toString() => 'Submitted(status: $status, date: $date)';

  factory Completed.fromMap(Map<String, dynamic> data) => Completed(
        status: data['status'] as bool?,
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  factory Completed.fromJson(String data) =>
      Completed.fromMap(json.decode(data) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());
}

class Submission {
  List<dynamic>? submissions;
  DateTime? date;
  String? id;

  Submission({this.submissions, this.date, this.id});

  @override
  String toString() {
    return 'Submission(submissions: $submissions, date: $date, id: $id)';
  }

  factory Submission.fromMap(Map<String, dynamic> data) => Submission(
        submissions: data['submissions'] as List<dynamic>?,
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'submissions': submissions,
        'date': date?.toUtc().toIso8601String(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Submission].
  factory Submission.fromJson(String data) {
    return Submission.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Submission] to a JSON string.
  String toJson() => json.encode(toMap());
}
