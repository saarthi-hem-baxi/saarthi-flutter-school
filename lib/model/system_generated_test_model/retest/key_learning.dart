import 'dart:convert';

class KeyLearning {
  String? keyLearning;
  bool? cleared;
  String? id;
  DateTime? clearedAt;

  KeyLearning({this.keyLearning, this.cleared, this.id, this.clearedAt});

  @override
  String toString() {
    return 'KeyLearning(keyLearning: $keyLearning, cleared: $cleared, id: $id, clearedAt: $clearedAt)';
  }

  factory KeyLearning.fromMap(Map<String, dynamic> data) => KeyLearning(
        keyLearning: data['keyLearning'] as String?,
        cleared: data['cleared'] as bool?,
        id: data['_id'] as String?,
        clearedAt: data['clearedAt'] == null
            ? null
            : DateTime.parse(data['clearedAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning,
        'cleared': cleared,
        '_id': id,
        'clearedAt': clearedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [KeyLearning].
  factory KeyLearning.fromJson(String data) {
    return KeyLearning.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [KeyLearning] to a JSON string.
  String toJson() => json.encode(toMap());
}
