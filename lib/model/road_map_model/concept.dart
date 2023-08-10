import 'dart:convert';

class Concept {
  Concept? concept;
  bool? cleared;
  List<dynamic>? keyLearnings;
  String? id;

  Concept({this.concept, this.cleared, this.keyLearnings, this.id});

  @override
  String toString() {
    return 'Concept(concept: $concept, cleared: $cleared, keyLearnings: $keyLearnings, id: $id)';
  }

  factory Concept.fromMap(Map<String, dynamic> data, String? langCode) =>
      Concept(
        concept: data['concept'] == null
            ? null
            : Concept.fromMap(
                data['concept'] as Map<String, dynamic>, langCode),
        cleared: data['cleared'] as bool?,
        keyLearnings: data['keyLearnings'] as List<dynamic>?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'concept': concept?.toMap(),
        'cleared': cleared,
        'keyLearnings': keyLearnings,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Concept].
  factory Concept.fromJson(String data, String langCode) {
    return Concept.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [Concept] to a JSON string.
  String toJson() => json.encode(toMap());
}
