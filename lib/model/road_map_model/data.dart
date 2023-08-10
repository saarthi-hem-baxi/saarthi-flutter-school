import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/road_map_model/chapters_configuration.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/unclear_pre_concept.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/work.dart';

import 'precap_details.dart';
import 'topics.dart';

class RoadMapData {
  PrecapDetails? precapDetails;
  String? id;
  String? school;
  String? dataClass;
  String? section;
  String? subject;
  ChaptersConfiguration? chapter;
  String? student;
  List<Topics>? topics;
  bool? completed;
  double? completion;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<UnclearPreConcept>? unclearPreConcepts;
  String? createdAt;
  String? updatedAt;
  bool? isPrecap;
  Work? homework;
  int? v;
  String? id_;
  String? lang;

  RoadMapData({
    this.precapDetails,
    this.id,
    this.school,
    this.dataClass,
    this.section,
    this.subject,
    this.chapter,
    this.student,
    this.topics,
    this.completed,
    this.completion,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.unclearPreConcepts,
    this.createdAt,
    this.updatedAt,
    this.isPrecap,
    this.homework,
    this.v,
    this.id_,
    this.lang,
  });

  @override
  String toString() {
    return 'Data(precapDetails: $precapDetails, id: $id, school: $school, dataClass: $dataClass, section: $section, subject: $subject,  student: $student, topics: $topics, completion: $completion, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, unclearPreConcepts: $unclearPreConcepts, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, id: $id_)';
  }

  factory RoadMapData.fromMap(Map<String, dynamic> data) {
    double? completion;
    if (data['completion'] != null) {
      if (data['completion'] is int) {
        completion = data['completion'].toDouble();
      } else if (data['completion'] is double) {
        completion = data['completion'];
      }
    }
    return RoadMapData(
        precapDetails: data['precapDetails'] == null ? null : PrecapDetails.fromMap(data['precapDetails'] as Map<String, dynamic>),
        id: data['id'] as String?,
        school: data['school'] as String?,
        dataClass: data['class'] as String?,
        section: data['section'] as String?,
        subject: data['subject'] as String?,
        // chapter: data['chapter'] as String?,
        chapter: data['chapter'] == null ? null : ChaptersConfiguration.fromMap(data['chapter']),
        student: data['student'] as String?,
        topics: (data['topics'] as List<dynamic>?)?.map((e) => Topics.fromMap(e as Map<String, dynamic>, data['lang'] as String?)).toList(),
        completed: data["completed"],
        completion: completion,
        createdBy: data['createdBy'] as String?,
        updatedBy: data['updatedBy'] as String?,
        status: data['status'] as String?,
        unclearPreConcepts: (data['unclearPreConcepts'] as List<dynamic>?)
            ?.map((e) => UnclearPreConcept.fromMap(e as Map<String, dynamic>, data['lang'] as String?))
            .toList(),
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        isPrecap: data["isPrecap"],
        homework: Work.fromJson(data["homework"]),
        v: data['__v'] as int?,
        id_: data['_id'] as String?,
        lang: data['lang'] as String? ?? "en_US");
  }

  Map<String, dynamic> toMap() => {
        'precapDetails': precapDetails?.toMap(),
        'id': id,
        'school': school,
        'class': dataClass,
        'section': section,
        'subject': subject,
        'chapter': chapter?.toMap(),
        'student': student,
        'topics': topics?.map((e) => e.toMap()).toList(),
        "completed": completed,
        "completion": completion,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'unclearPreConcepts': unclearPreConcepts,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        "isPrecap": isPrecap,
        "homework": homework?.toJson(),
        '__v': v,
        '_id': id_,
        'lang': lang,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory RoadMapData.fromJson(String data) {
    return RoadMapData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
