import 'dart:convert';

import 'name.dart';

class UnclearKeyLearning {
  Name? name;
  String? id;

  UnclearKeyLearning({this.name, this.id});

  @override
  String toString() => 'UnclearKeyLearning(name: $name, id: $id, id: $id)';

  factory UnclearKeyLearning.fromMap(Map<String, dynamic> data, String langCode) {
    return UnclearKeyLearning(
      name: data['name'] == null ? null : Name.fromMap(data['name'] as Map<String, dynamic>, langCode),
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        '_id': id,
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UnclearKeyLearning].
  factory UnclearKeyLearning.fromJson(String data, String langCode) {
    return UnclearKeyLearning.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [UnclearKeyLearning] to a JSON string.
  String toJson() => json.encode(toMap());
}
