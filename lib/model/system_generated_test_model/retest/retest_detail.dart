import 'package:saarthi_pedagogy_studentapp/model/homework_model/chapters.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/class.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/concepts.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/section.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/started.dart';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/subject.dart';
import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';

import '../../homework_model/assigned.dart';
import '../../homework_model/blooms.dart';
import '../../homework_model/completed.dart';
import '../../homework_model/skills.dart';
import '../../homework_model/topics.dart';

class RetestDetail {
  Completed? completed;
  Started? started;
  Assigned? assigned;
  Skills? skills;
  Blooms? blooms;
  String? id;
  String? homework;
  String? student;
  String? school;
  dynamic classData;
  dynamic section;
  dynamic subject;
  dynamic chapter;
  String? type;
  String? studentHomework;
  int? totalTopicConceptCount;
  int? clearedTopicConceptCount;
  String? name;
  List<Topics>? topics;
  int? attempts;
  int? correct;
  int? wrong;
  List<Concepts>? concepts;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<dynamic>? questions;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? topicStatus;
  String? lang;
  List<RetestResult>? retestResultList;

  RetestDetail(
      {this.completed,
      this.started,
      this.assigned,
      this.skills,
      this.blooms,
      this.id,
      this.homework,
      this.student,
      this.school,
      this.classData,
      this.section,
      this.subject,
      this.chapter,
      this.type,
      this.studentHomework,
      this.totalTopicConceptCount,
      this.clearedTopicConceptCount,
      this.name,
      this.topics,
      this.attempts,
      this.correct,
      this.wrong,
      this.concepts,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.questions,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.topicStatus,
      this.lang,
      this.retestResultList});

  @override
  String toString() {
    return 'Datum(completed: $completed,started: $started, skills: $skills, blooms: $blooms, id: $id, homework: $homework, student: $student, school: $school, datumClass: $classData, section: $section, subject: $subject, chapter: $chapter, type: $type, name: $name,totalTopicConceptCount: $totalTopicConceptCount, topics: $topics, , attempts: $attempts, correct: $correct, wrong: $wrong, createdBy: $createdBy, updatedBy: $updatedBy, status: $status,  questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, id: $id, finalResult: $retestResultList)';
  }

  factory RetestDetail.fromMap(Map<String, dynamic> data, String? languageCode) {
    return RetestDetail(
      completed: data['completed'] == null ? null : Completed.fromMap(data['completed'] as Map<String, dynamic>),
      assigned: data['assigned'] == null ? null : Assigned.fromMap(data['assigned'] as Map<String, dynamic>),
      started: data['started'] == null ? null : Started.fromMap(data['started'] as Map<String, dynamic>),
      skills: data['skills'] == null ? null : Skills.fromMap(data['skills'] as Map<String, dynamic>),
      blooms: data['blooms'] == null ? null : Blooms.fromMap(data['blooms'] as Map<String, dynamic>),
      id: data['_id'] as String?,
      homework: data['homework'] as String?,
      student: data['student'] as String?,
      school: data['school'] as String?,
      classData: data["class"] == null
          ? null
          : data["class"].runtimeType == String
              ? data["class"]
              : Class.fromJson(data["class"]),
      section: data["section"] == null
          ? null
          : data["section"].runtimeType == String
              ? data["section"]
              : Section.fromJson(data["section"]),
      subject: data["subject"] == null
          ? null
          : data["subject"].runtimeType == String
              ? data["subject"]
              : Subject.fromJson(data["subject"]),
      chapter: data["subject"] == null
          ? null
          : data["chapter"].runtimeType == String
              ? data["chapter"]
              : Chapter.fromJson(data["chapter"]),
      type: data['type'] as String?,
      totalTopicConceptCount: data["totalTopicConceptCount"] as int?,
      clearedTopicConceptCount: data["clearedTopicConceptCount"] as int?,
      name: data['name'] as String?,
      topics: (data['topics'] as List<dynamic>?)?.map((e) => Topics.fromMap(e as Map<String, dynamic>, (languageCode ?? "en_US"))).toList(),
      attempts: data['attempts'] as int?,
      correct: data['correct'] as int?,
      wrong: data['wrong'] as int?,
      concepts: (data['concepts'] as List<dynamic>?)?.map((e) => Concepts.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
      createdBy: data['createdBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
      status: data['status'] as String?,
      questions: data['questions'] as List<dynamic>?,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']).toLocal() : null,
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']).toLocal() : null,
      v: data['__v'] as int?,
      topicStatus: data['topicStatus'] as String?,
      lang: data['lang'] as String?,
      retestResultList:
          (data['finalResult'] as List<dynamic>?)?.map((e) => RetestResult.fromMap(e as Map<String, dynamic>, (languageCode ?? "en_US"))).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'completed': completed?.toMap(),
        'assigned': assigned?.toMap(),
        'started': started?.toMap(),
        'skills': skills?.toMap(),
        'blooms': blooms?.toMap(),
        '_id': id,
        'homework': homework,
        'student': student,
        'school': school,
        'class': classData,
        'section': section,
        'subject': subject,
        'chapter': chapter,
        'type': type,
        'name': name,
        'totalTopicConceptCount': totalTopicConceptCount,
        'clearedTopicConceptCount': clearedTopicConceptCount,
        'topics': topics?.map((e) => e.toMap()).toList(),
        'concepts': concepts?.map((e) => e.toMap()).toList(),
        'attempts': attempts,
        'correct': correct,
        'wrong': wrong,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'questions': questions,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
        '__v': v,
        'topicStatus': topicStatus,
        'lang': lang,
        'finalResult': retestResultList
      };
}
