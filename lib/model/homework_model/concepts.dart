import 'package:saarthi_pedagogy_studentapp/model/homework_model/concept.dart';
import 'key_learning.dart';

class Concepts {
  int? clarity;
  dynamic concept;
  int? clearity;
  dynamic cleared;
  List<KeyLearnings>? keyLearnings;
  String? id;

  Concepts({
    this.clarity,
    this.concept,
    this.clearity,
    this.cleared,
    this.keyLearnings,
    this.id,
  });

  @override
  String toString() {
    return 'Concepts(clarity: $clarity, concept: $concept, clearity: $clearity, cleared: $cleared, keyLearnings: $keyLearnings, id: $id)';
  }

  factory Concepts.fromMap(Map<String, dynamic> data, String? langCode) =>
      Concepts(
        clarity: data['clarity'] as int?,
        concept: data['concept'] == null
            ? null
            : data['concept'].runtimeType == String
                ? data['concept'] as String
                : Concept.fromMap(data['concept'], langCode),
        clearity: data['clearity'] as int?,
        cleared: data['cleared'] as dynamic,
        keyLearnings: (data['keyLearnings'] as List<dynamic>?)
            ?.map((e) =>
                KeyLearnings.fromMap(e as Map<String, dynamic>, langCode))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'clarity': clarity,
        'concept': concept,
        'clearity': clearity,
        'cleared': cleared,
        'keyLearnings': keyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
      };
}
