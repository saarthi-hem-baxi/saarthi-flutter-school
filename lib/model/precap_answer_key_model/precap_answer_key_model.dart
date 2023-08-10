import 'dart:convert';

import 'data.dart';

class PrecapAnswerKeyModel {
  String? status;
  Data? data;

  PrecapAnswerKeyModel({this.status, this.data});

  @override
  String toString() => 'PrecapAnswerKeyModel(status: $status, data: $data)';

  factory PrecapAnswerKeyModel.fromMap(Map<String, dynamic> data) {
    return PrecapAnswerKeyModel(
      status: data['status'] as String?,
      data: data['data'] == null ? null : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PrecapAnswerKeyModel].
  factory PrecapAnswerKeyModel.fromJson(String data) {
    return PrecapAnswerKeyModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrecapAnswerKeyModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
