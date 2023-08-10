import 'concept.dart';
import 'key_learning_list.dart';

class PreConcept {
  Concept? concept;
  int? clarity;
  bool? cleared;
  List<KeyLearningList>? keyLearnings;
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

  factory PreConcept.fromMap(Map<String, dynamic> data, String? langCode) =>
      PreConcept(
        concept: data['concept'] == null
            ? null
            : Concept.fromMap(
                data['concept'] as Map<String, dynamic>, langCode),
        clarity: data['clarity'] as int?,
        cleared: data['cleared'] as bool?,
        keyLearnings: (data['keyLearnings'] as List<dynamic>?)
            ?.map((e) =>
                KeyLearningList.fromMap(e as Map<String, dynamic>, langCode))
            .toList(),
        id: data['_id'] as String?,
        clearedAt: data['clearedAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'concept': concept?.toMap(),
        'clarity': clarity,
        'cleared': cleared,
        'keyLearnings': keyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
        'clearedAt': clearedAt,
      };
}
