import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/precap_model/chapter_modal.dart';

import 'blooms.dart';
import 'exam_assigned.dart';
import 'exam_completed.dart';
import 'exam_skipped.dart';
import 'exam_started.dart';
import 'exam_status_history.dart';
import 'pre_concept.dart';
import 'question.dart';
import 'skills.dart';
import 'topic.dart';

String _langCode = 'en_US';

class PrecapData {
  String? id;
  String? school;
  String? dataClass;
  String? section;
  String? subject;
  Chapter? chapter;
  String? student;
  List<PreConcept>? preConcepts;
  List<Topic>? topics;
  Skills? skills;
  Blooms? blooms;
  int? attempts;
  int? correct;
  int? wrong;
  ExamCompleted? examCompleted;
  ExamStarted? examStarted;
  ExamSkipped? examSkipped;
  ExamAssigned? examAssigned;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<Question>? questions;
  List<ExamStatusHistory>? examStatusHistory;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? lang;

  PrecapData({
    this.id,
    this.school,
    this.dataClass,
    this.section,
    this.subject,
    this.chapter,
    this.student,
    this.preConcepts,
    this.topics,
    this.skills,
    this.blooms,
    this.attempts,
    this.correct,
    this.wrong,
    this.examCompleted,
    this.examStarted,
    this.examSkipped,
    this.examAssigned,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.questions,
    this.examStatusHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lang,
  });

  @override
  String toString() {
    return 'Data(id: $id, school: $school, dataClass: $dataClass, section: $section, subject: $subject, chapter: $chapter, student: $student, preConcepts: $preConcepts, topics: $topics, skills: $skills, blooms: $blooms, attempts: $attempts, correct: $correct, wrong: $wrong, examCompleted: $examCompleted, examStarted: $examStarted, examSkipped: $examSkipped, examAssigned: $examAssigned, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, questions: $questions, examStatusHistory: $examStatusHistory, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, lang: $lang)';
  }

  factory PrecapData.fromMap(Map<String, dynamic> data) {
    _langCode = data['lang'] ?? "en_US";
    return PrecapData(
      id: data['_id'] as String?,
      school: data['school'] as String?,
      dataClass: data['class'] as String?,
      section: data['section'] as String?,
      subject: data['subject'] as String?,
      chapter: Chapter.fromJson(data["chapter"]),
      student: data['student'] as String?,
      preConcepts: (data['preConcepts'] as List<dynamic>?)?.map((e) => PreConcept.fromMap(e as Map<String, dynamic>, _langCode)).toList(),
      topics: (data['topics'] as List<dynamic>?)?.map((e) => Topic.fromMap(e as Map<String, dynamic>, _langCode)).toList(),
      skills: data['skills'] == null ? null : Skills.fromMap(data['skills'] as Map<String, dynamic>),
      blooms: data['blooms'] == null ? null : Blooms.fromMap(data['blooms'] as Map<String, dynamic>),
      attempts: data['attempts'] as int?,
      correct: data['correct'] as int?,
      wrong: data['wrong'] as int?,
      examCompleted: data['examCompleted'] == null ? null : ExamCompleted.fromMap(data['examCompleted'] as Map<String, dynamic>),
      examStarted: data['examStarted'] == null ? null : ExamStarted.fromMap(data['examStarted'] as Map<String, dynamic>),
      examSkipped: data['examSkipped'] == null ? null : ExamSkipped.fromMap(data['examSkipped'] as Map<String, dynamic>),
      examAssigned: data['examAssigned'] == null ? null : ExamAssigned.fromMap(data['examAssigned'] as Map<String, dynamic>),
      createdBy: data['createdBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
      status: data['status'] as String?,
      questions: (data['questions'] as List<dynamic>?)?.map((e) => Question.fromMap(e as Map<String, dynamic>)).toList(),
      examStatusHistory: (data['examStatusHistory'] as List<dynamic>?)?.map((e) => ExamStatusHistory.fromMap(e as Map<String, dynamic>)).toList(),
      createdAt: data['createdAt'] as String?,
      updatedAt: data['updatedAt'] as String?,
      v: data['__v'] as int?,
      lang: data['lang'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'school': school,
        'class': dataClass,
        'section': section,
        'subject': subject,
        "chapter": chapter?.toJson(),
        'student': student,
        'preConcepts': preConcepts?.map((e) => e.toMap()).toList(),
        'topics': topics?.map((e) => e.toMap()).toList(),
        'skills': skills?.toMap(),
        'blooms': blooms?.toMap(),
        'attempts': attempts,
        'correct': correct,
        'wrong': wrong,
        'examCompleted': examCompleted?.toMap(),
        'examStarted': examStarted?.toMap(),
        'examSkipped': examSkipped?.toMap(),
        'examAssigned': examAssigned?.toMap(),
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'questions': questions?.map((e) => e.toMap()).toList(),
        'examStatusHistory': examStatusHistory?.map((e) => e.toMap()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'lang': lang,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory PrecapData.fromJson(String data) {
    return PrecapData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
