import 'dart:convert';

import 'name.dart';

class Concept {
  Name? name;
  String? id;

  Concept({
    this.name,
    this.id,
  });

  @override
  String toString() => 'Concept(name: $name, id: $id, id: $id)';

  factory Concept.fromMap(Map<String, dynamic> data, String? langCode) {
    return Concept(
      name: data['name'] == null ? null : Name.fromMap(data['name'] as Map<String, dynamic>, (langCode ?? "en_US")),
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Concept].
  factory Concept.fromJson(String data, String? languageCode) {
    return Concept.fromMap(json.decode(data) as Map<String, dynamic>, (languageCode ?? "en_US"));
  }

  /// `dart:convert`
  ///
  /// Converts [Concept] to a JSON string.
  String toJson() => json.encode(toMap());
}
