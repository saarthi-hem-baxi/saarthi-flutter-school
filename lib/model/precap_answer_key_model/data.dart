import 'dart:convert';

import 'question.dart';

class Data {
  String? id;
  List<Questions>? questions;
  String? lang;

  Data({this.id, this.questions, this.lang});

  @override
  String toString() => 'Data(id: $id, questions: $questions)';

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        id: data['_id'] as String?,
        questions: (data['questions'] as List<dynamic>?)
            ?.map((e) => Questions.fromMap(
                e as Map<String, dynamic>, data['lang'] as String?))
            .toList(),
        lang: data['lang'] as String?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'questions': questions?.map((e) => e.toMap()).toList(),
        'lang': lang
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
