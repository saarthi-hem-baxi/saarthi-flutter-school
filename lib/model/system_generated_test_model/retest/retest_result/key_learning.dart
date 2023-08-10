import 'dart:convert';

class KeyLearning {
  Keylearning? keyLearning;
  bool? cleared;
  DateTime? clearedAt;
  String? id;

  KeyLearning({this.keyLearning, this.cleared, this.clearedAt, this.id});

  @override
  String toString() {
    return 'KeyLearning(keyLearning: $keyLearning, cleared: $cleared, clearedAt: $clearedAt, id: $id)';
  }

  factory KeyLearning.fromMap(Map<String, dynamic> data, String? langCode) => KeyLearning(
        keyLearning: data['keyLearning'] == null ? null : Keylearning.fromMap(data['keyLearning'] as Map<String, dynamic>, (langCode ?? "en_US")),
        cleared: data['cleared'] as bool?,
        clearedAt: data['clearedAt'] == null ? null : DateTime.parse(data['clearedAt'] as String),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning?.toMap(),
        'cleared': cleared,
        'clearedAt': clearedAt?.toIso8601String(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [KeyLearning].
  factory KeyLearning.fromJson(String data, String? langCode) {
    return KeyLearning.fromMap(json.decode(data) as Map<String, dynamic>, (langCode ?? "en_US"));
  }

  /// `dart:convert`
  ///
  /// Converts [KeyLearning] to a JSON string.
  String toJson() => json.encode(toMap());
}

class Keylearning {
  Name? name;
  String? id;

  Keylearning({this.name, this.id});

  @override
  String toString() => 'Topic(name: $name,id: $id)';

  factory Keylearning.fromMap(Map<String, dynamic> data, String? langCode) => Keylearning(
        name: data['name'] == null ? null : Name.fromMap(data['name'] as Map<String, dynamic>, (langCode ?? "en_US")),
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}

class Name {
  String? enUs;

  Name({this.enUs});

  @override
  String toString() => 'Name(enUs: $enUs)';

  factory Name.fromMap(Map<String, dynamic> data, String langCode) => Name(
        enUs: (data[langCode] == null || (data[langCode]?.isEmpty)) ? data['en_US'] : data[langCode] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
