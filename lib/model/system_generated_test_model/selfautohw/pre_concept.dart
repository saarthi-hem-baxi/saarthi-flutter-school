import 'dart:convert';

import 'name.dart';

class PreConcept {
  Name? name;
  String? id;

  PreConcept({this.name, this.id});

  @override
  String toString() => 'PreConcept(name: $name, id: $id, id: $id)';

  factory PreConcept.fromMap(Map<String, dynamic> data, String langCode) => PreConcept(
        name: data['name'] == null ? null : Name.fromMap(data['name'] as Map<String, dynamic>, langCode),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        '_id': id,
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PreConcept].
  factory PreConcept.fromJson(String data, String langCode) {
    return PreConcept.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [PreConcept] to a JSON string.
  String toJson() => json.encode(toMap());
}
