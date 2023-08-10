import 'package:saarthi_pedagogy_studentapp/model/homework_model/concepts.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/started.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/submission.dart';

import 'assigned.dart';
import 'blooms.dart';
import 'homework_history.dart';
import 'completed.dart';
import 'has_opened.dart';
import 'skills.dart';
import 'skipped.dart';
import 'submitted.dart';
import 'topics.dart';

class HomeworkDatum {
  Completed? completed;
  Assigned? assigned;
  Started? started;
  Submitted? submitted;
  Skipped? skipped;
  HasOpened? hasOpened;
  Skills? skills;
  Blooms? blooms;
  String? id;
  String? classwork;
  String? homework;
  String? student;
  String? school;
  String? datumClass;
  String? section;
  String? subject;
  String? chapter;
  String? type;
  String? name;
  String? description;
  String? questionPdf;
  String? answerPdf;
  bool? hasSubmission;
  DateTime? submissionDate;
  bool? hasMarking;
  bool? shareAnswerKey;
  int? totalMarks;
  int? obtainedMarks;
  List<Topics>? topics;
  bool? hasDuedate;
  DateTime? dueDate;
  List<HomeworkHistory>? classworkHistory;
  List<HomeworkHistory>? homeworkHistory;
  int? attempts;
  int? correct;
  int? wrong;
  List<Concepts>? concepts;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<dynamic>? questionTypes;
  List<Submission>? submissions;
  List<dynamic>? questions;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? hasRetest;
  bool? cleared;
  bool? clearedRetest;
  bool? isSelfSystemGenerated;
  String? lang;

  HomeworkDatum({
    this.completed,
    this.assigned,
    this.started,
    this.submitted,
    this.skipped,
    this.hasOpened,
    this.skills,
    this.blooms,
    this.id,
    this.classwork,
    this.homework,
    this.student,
    this.school,
    this.datumClass,
    this.section,
    this.subject,
    this.chapter,
    this.type,
    this.name,
    this.description,
    this.questionPdf,
    this.answerPdf,
    this.hasSubmission,
    this.submissionDate,
    this.hasMarking,
    this.shareAnswerKey,
    this.totalMarks,
    this.obtainedMarks,
    this.topics,
    this.hasDuedate,
    this.dueDate,
    this.classworkHistory,
    this.homeworkHistory,
    this.attempts,
    this.correct,
    this.wrong,
    this.concepts,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.questionTypes,
    this.submissions,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.hasRetest,
    this.cleared,
    this.clearedRetest,
    this.isSelfSystemGenerated,
    this.lang,
  });

  @override
  String toString() {
    return 'Datum(completed: $completed, assigned: $assigned,started: $started, submitted: $submitted, skipped: $skipped, hasOpened: $hasOpened, skills: $skills, blooms: $blooms, id: $id, classwork: $classwork,homework: $homework, student: $student, school: $school, datumClass: $datumClass, section: $section, subject: $subject, chapter: $chapter, type: $type, name: $name, description: $description, questionPdf: $questionPdf, answerPdf: $answerPdf, hasSubmission: $hasSubmission, submissionDate: $submissionDate, hasMarking: $hasMarking, automaticShareKey: $shareAnswerKey, totalMarks: $totalMarks,obtainedMarks: $obtainedMarks, topics: $topics, hasDuedate: $hasDuedate, dueDate: $dueDate, classworkHistory: $classworkHistory,homeworkHistory: $homeworkHistory, attempts: $attempts, correct: $correct, wrong: $wrong, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, questionTypes: $questionTypes, submissions: $submissions, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, id: $id)';
  }

  factory HomeworkDatum.fromMap(Map<String, dynamic> data) => HomeworkDatum(
        completed: data['completed'] == null ? null : Completed.fromMap(data['completed'] as Map<String, dynamic>),
        assigned: data['assigned'] == null ? null : Assigned.fromMap(data['assigned'] as Map<String, dynamic>),
        started: data['started'] == null ? null : Started.fromMap(data['started'] as Map<String, dynamic>),
        submitted: data['submitted'] == null ? null : Submitted.fromMap(data['submitted'] as Map<String, dynamic>),
        skipped: data['skipped'] == null ? null : Skipped.fromMap(data['skipped'] as Map<String, dynamic>),
        hasOpened: data['hasOpened'] == null ? null : HasOpened.fromMap(data['hasOpened'] as Map<String, dynamic>),
        skills: data['skills'] == null ? null : Skills.fromMap(data['skills'] as Map<String, dynamic>),
        blooms: data['blooms'] == null ? null : Blooms.fromMap(data['blooms'] as Map<String, dynamic>),
        id: data['_id'] as String?,
        classwork: data['classwork'] as String?,
        homework: data['homework'] as String?,
        student: data['student'] as String?,
        school: data['school'] as String?,
        datumClass: data['class'] as String?,
        section: data['section'] as String?,
        subject: data['subject'] as String?,
        chapter: data['chapter'] as String?,
        type: data['type'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        questionPdf: data['questionPdf'] as String?,
        answerPdf: data['answerPdf'] as String?,
        hasSubmission: data['hasSubmission'] as bool?,
        submissionDate: data['submissionDate'] != null ? DateTime.parse(data['submissionDate']).toLocal() : null,
        hasMarking: data['hasMarking'] as bool?,
        shareAnswerKey: data['shareAnswerKey'] as bool?,
        totalMarks: data['totalMarks'] as int?,
        obtainedMarks: data['obtainedMarks'] as int?,
        topics: (data['topics'] as List<dynamic>?)?.map((e) => Topics.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
        hasDuedate: data['hasDuedate'] as bool?,
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']).toLocal() : null,
        classworkHistory: (data['classworkHistory'] as List<dynamic>?)?.map((e) => HomeworkHistory.fromMap(e as Map<String, dynamic>)).toList(),
        homeworkHistory: (data['homeworkHistory'] as List<dynamic>?)?.map((e) => HomeworkHistory.fromMap(e as Map<String, dynamic>)).toList(),
        attempts: data['attempts'] as int?,
        correct: data['correct'] as int?,
        wrong: data['wrong'] as int?,
        concepts: (data['concepts'] as List<dynamic>?)?.map((e) => Concepts.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
        createdBy: data['createdBy'] as String?,
        updatedBy: data['updatedBy'] as String?,
        status: data['status'] as String?,
        questionTypes: data['questionTypes'] as List<dynamic>?,
        submissions: (data['submissions'] as List<dynamic>?)?.map((e) => Submission.fromMap(e as Map<String, dynamic>)).toList(),
        questions: data['questions'] as List<dynamic>?,
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']).toLocal() : null,
        updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']).toLocal() : null,
        v: data['__v'] as int?,
        hasRetest: data['hasRetest'] as bool?,
        cleared: data['cleared'] as bool?,
        clearedRetest: data['clearedRetest'] as bool?,
        isSelfSystemGenerated: data['isSelfSystemGenerated'] != null ? data['isSelfSystemGenerated'] as bool : null,
        lang: data['lang'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'completed': completed?.toMap(),
        'assigned': assigned?.toMap(),
        'started': started?.toMap(),
        'submitted': submitted?.toMap(),
        'skipped': skipped?.toMap(),
        'hasOpened': hasOpened?.toMap(),
        'skills': skills?.toMap(),
        'blooms': blooms?.toMap(),
        '_id': id,
        'classwork': classwork,
        'homework': homework,
        'student': student,
        'school': school,
        'class': datumClass,
        'section': section,
        'subject': subject,
        'chapter': chapter,
        'type': type,
        'name': name,
        'description': description,
        'questionPdf': questionPdf,
        'answerPdf': answerPdf,
        'hasSubmission': hasSubmission,
        'submissionDate': submissionDate?.toUtc().toIso8601String(),
        'hasMarking': hasMarking,
        'automaticShareKey': shareAnswerKey,
        'totalMarks': totalMarks,
        'obtainedMarks': obtainedMarks,
        'topics': topics?.map((e) => e.toMap()).toList(),
        'concepts': concepts?.map((e) => e.toMap()).toList(),
        'hasDuedate': hasDuedate,
        'dueDate': dueDate,
        'classworkHistory': classworkHistory?.map((e) => e.toMap()).toList(),
        'homeworkHistory': classworkHistory?.map((e) => e.toMap()).toList(),
        'attempts': attempts,
        'correct': correct,
        'wrong': wrong,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'questionTypes': questionTypes,
        'submissions': submissions,
        'questions': questions,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
        '__v': v,
        'hasRetest': hasRetest,
        'cleared': cleared,
        'clearedRetest': clearedRetest,
        'isSelfSystemGenerated': isSelfSystemGenerated,
        'lang': lang
      };
}
