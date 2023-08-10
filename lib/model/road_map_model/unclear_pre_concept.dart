import 'dart:convert';

import 'pre_concept.dart';
import 'unclear_key_learning.dart';

class UnclearPreConcept {
  PreConcept? preConcept;
  List<dynamic>? topics;
  bool? cleared;
  String? clearedAt;
  int? clarity;
  List<UnclearKeyLearning>? unclearKeyLearnings;
  String? id;
  bool? isSelfAutoHomework;
  bool? createSelfAutoHomework;
  String? selfAutoHomeworkId;
  bool? selfAutoHomeworkCompleted;

  UnclearPreConcept({
    this.preConcept,
    this.topics,
    this.cleared,
    this.clearedAt,
    this.clarity,
    this.unclearKeyLearnings,
    this.id,
    this.isSelfAutoHomework,
    this.createSelfAutoHomework,
    this.selfAutoHomeworkId,
    this.selfAutoHomeworkCompleted,
  });

  @override
  String toString() {
    return 'UnclearPreConcept(preConcept: $preConcept, topics: $topics, cleared: $cleared, clearedAt: $clearedAt,clarity: $clarity, unclearKeyLearnings: $unclearKeyLearnings, id: $id)';
  }

  factory UnclearPreConcept.fromMap(Map<String, dynamic> data, String? langCode) {
    return UnclearPreConcept(
      preConcept: data['preConcept'] == null ? null : PreConcept.fromMap(data['preConcept'] as Map<String, dynamic>, langCode),
      topics: data['topics'] as List<dynamic>?,
      cleared: data['cleared'] as bool?,
      clearedAt: data['clearedAt'] as String?,
      clarity: data['clarity'] as int?,
      unclearKeyLearnings:
          (data['unclearKeyLearnings'] as List<dynamic>?)?.map((e) => UnclearKeyLearning.fromMap(e as Map<String, dynamic>, langCode)).toList(),
      id: data['_id'] as String?,
      isSelfAutoHomework: data['isSelfAutoHomework'] as bool?,
      createSelfAutoHomework: data['createSelfAutoHomework'] as bool?,
      selfAutoHomeworkId: data['selfAutoHomeworkId'] as String?,
      selfAutoHomeworkCompleted: data['selfAutoHomeworkCompleted'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'preConcept': preConcept?.toMap(),
        'topics': topics,
        'cleared': cleared,
        'clearedAt': clearedAt,
        'clarity': clarity,
        'unclearKeyLearnings': unclearKeyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
        'isSelfAutoHomework': isSelfAutoHomework,
        'createSelfAutoHomework': createSelfAutoHomework,
        'selfAutoHomeworkId': selfAutoHomeworkId,
        'selfAutoHomeworkCompleted': selfAutoHomeworkCompleted
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UnclearPreConcept].
  factory UnclearPreConcept.fromJson(String data, String? langCode) {
    return UnclearPreConcept.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [UnclearPreConcept] to a JSON string.
  String toJson() => json.encode(toMap());
}
