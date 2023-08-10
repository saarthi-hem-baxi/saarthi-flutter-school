import 'dart:convert';

import 'concept.dart';
import 'key_learning.dart';

class RetestResult {
  Concept? concept;
  bool? cleared;
  DateTime? clearedAt;
  int? clarity;
  List<KeyLearning>? keyLearnings;
  String? id;

  RetestResult({
    this.concept,
    this.cleared,
    this.clearedAt,
    this.clarity,
    this.keyLearnings,
    this.id,
  });

  @override
  String toString() {
    return 'RetestResult(concept: $concept, cleared: $cleared, clearedAt: $clearedAt, clarity: $clarity, keyLearnings: $keyLearnings, id: $id)';
  }

  factory RetestResult.fromMap(Map<String, dynamic> data, String langCode) => RetestResult(
        concept: data['concept'] == null ? null : Concept.fromMap(data['concept'] as Map<String, dynamic>, langCode),
        cleared: data['cleared'] as bool?,
        clearedAt: data['clearedAt'] == null ? null : DateTime.parse(data['clearedAt'] as String),
        clarity: data['clarity'] as int?,
        keyLearnings: (data['keyLearnings'] as List<dynamic>?)?.map((e) => KeyLearning.fromMap(e as Map<String, dynamic>, langCode)).toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'concept': concept?.toMap(),
        'cleared': cleared,
        'clearedAt': clearedAt?.toIso8601String(),
        'clarity': clarity,
        'keyLearnings': keyLearnings?.map((e) => e.toMap()).toList(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RetestResult].
  factory RetestResult.fromJson(String data, String langCode) {
    return RetestResult.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [RetestResult] to a JSON string.
  String toJson() => json.encode(toMap());
}
