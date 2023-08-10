import 'dart:convert';
import 'question.dart';

class SystemGeneratedAnswerKeyData {
  String? id;
  List<Questions>? questions;
  String? lang;

  SystemGeneratedAnswerKeyData({this.id, this.questions, this.lang});

  @override
  String toString() => 'Data(id: $id, questions: $questions)';

  factory SystemGeneratedAnswerKeyData.fromMap(Map<String, dynamic> data) =>
      SystemGeneratedAnswerKeyData(
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
  /// Parses the string and returns the resulting Json object as [SystemGeneratedAnswerKeyData].
  factory SystemGeneratedAnswerKeyData.fromJson(String data) {
    return SystemGeneratedAnswerKeyData.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SystemGeneratedAnswerKeyData] to a JSON string.
  String toJson() => json.encode(toMap());
}
