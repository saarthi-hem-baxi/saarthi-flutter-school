import 'dart:convert';

import 'datum.dart';

class SubjectModel {
  List<Datum>? data;

  SubjectModel({this.data});

  @override
  String toString() => 'SubjectModel(data: $data)';

  factory SubjectModel.fromMap(Map<String, dynamic> data) => SubjectModel(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SubjectModel].
  factory SubjectModel.fromJson(String data) {
    return SubjectModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SubjectModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
