import 'dart:convert';

import 'description.dart';

class SubDescription {
  Description? description;
  List<dynamic>? topics;
  List<String>? lang;
  List<dynamic>? contentCategory;
  List<dynamic>? concepts;
  List<dynamic>? keyLearnings;
  String? id;

  SubDescription({
    this.description,
    this.topics,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
  });

  @override
  String toString() {
    return 'SubDescription(description: $description, topics: $topics, lang: $lang, contentCategory: $contentCategory, concepts: $concepts, keyLearnings: $keyLearnings, id: $id)';
  }

  factory SubDescription.fromMap(Map<String, dynamic> data) {
    return SubDescription(
      description: data['description'] == null
          ? null
          : Description.fromMap(data['description'] as Map<String, dynamic>),
      topics: data['topics'] as List<dynamic>?,
      lang: data['lang'] as List<String>?,
      contentCategory: data['contentCategory'] as List<dynamic>?,
      concepts: data['concepts'] as List<dynamic>?,
      keyLearnings: data['keyLearnings'] as List<dynamic>?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'description': description?.toMap(),
        'topics': topics,
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SubDescription].
  factory SubDescription.fromJson(String data) {
    return SubDescription.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SubDescription] to a JSON string.
  String toJson() => json.encode(toMap());
}
