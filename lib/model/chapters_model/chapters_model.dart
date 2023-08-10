import 'dart:convert';

import 'datum.dart';

class ChaptersModel {
  String? status;
  List<ChaptersDatum>? data;

  ChaptersModel({this.status, this.data});

  @override
  String toString() => 'ChaptersModel(status: $status, data: $data)';

  factory ChaptersModel.fromMap(Map<String, dynamic> data) => ChaptersModel(
        status: data['status'] as String?,
        data: (data['data'] as List<dynamic>?)?.map((e) => ChaptersDatum.fromMap(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChaptersModel].
  factory ChaptersModel.fromJson(String data) {
    return ChaptersModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChaptersModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
