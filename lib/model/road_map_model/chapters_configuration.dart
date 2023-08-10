import 'dart:convert';

import 'configuration.dart';

class ChaptersConfiguration {
  Configuration? configuration;
  String? id;
  String? name;

  ChaptersConfiguration({this.configuration, this.id, this.name});

  @override
  String toString() {
    return 'ChaptersConfiguration(configuration: $configuration, id: $id, name: $name, id: $id)';
  }

  factory ChaptersConfiguration.fromMap(Map<String, dynamic> data) {
    return ChaptersConfiguration(
      configuration: data['configuration'] == null
          ? null
          : Configuration.fromMap(
              data['configuration'] as Map<String, dynamic>),
      id: data['_id'] as String?,
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'configuration': configuration?.toMap(),
        '_id': id,
        'name': name,
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChaptersConfiguration].
  factory ChaptersConfiguration.fromJson(String data) {
    return ChaptersConfiguration.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChaptersConfiguration] to a JSON string.
  String toJson() => json.encode(toMap());
}
