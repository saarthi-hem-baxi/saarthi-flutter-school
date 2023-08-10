import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/topic.dart';

import 'concept.dart';
import 'key_learning.dart';

class UnclearTopicsConcept {
  Concept? concept;
  Topic? topic;
  int? clarity;
  bool? cleared;
  List<KeyLearning>? keyLearnings;
  String? id;
  String? type;
  DateTime? clearedAt;

  UnclearTopicsConcept({
    this.concept,
    this.topic,
    this.clarity,
    this.cleared,
    this.keyLearnings,
    this.id,
    this.type,
    this.clearedAt,
  });

  @override
  String toString() {
    return 'UnclearTopicsConcept(concept: $concept, clarity: $clarity, cleared: $cleared, keyLearnings: $keyLearnings, id: $id, clearedAt: $clearedAt)';
  }

  factory UnclearTopicsConcept.fromMap(
      Map<String, dynamic> data, String? langCode) {
    return UnclearTopicsConcept(
      concept: data['concept'] == null
          ? null
          : Concept.fromMap(data['concept'] as Map<String, dynamic>, langCode),
      topic: data['topic'] == null
          ? null
          : Topic.fromMap(data['topic'] as Map<String, dynamic>),
      clarity: data['clarity'] as int?,
      cleared: data['cleared'] as bool?,
      keyLearnings: (data['keyLearnings'] as List<dynamic>?)
          ?.map((e) => KeyLearning.fromMap(e as Map<String, dynamic>))
          .toList(),
      id: data['_id'] as String?,
      type: data["type"] as String?,
      clearedAt: data['clearedAt'] == null
          ? null
          : DateTime.parse(data['clearedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'concept': concept?.toMap(),
        'clarity': clarity,
        'cleared': cleared,
        'keyLearnings': keyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
        'type': type,
        'clearedAt': clearedAt?.toIso8601String(),
      };

  map(Function(dynamic e) param0) {}
}
