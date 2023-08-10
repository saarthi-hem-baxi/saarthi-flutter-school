import 'dart:convert';

import 'data.dart';

class SystemGeneratedAnswerKeyModel {
  String? status;
  SystemGeneratedAnswerKeyData? data;

  SystemGeneratedAnswerKeyModel({
    this.status,
    this.data,
  });

  @override
  String toString() => 'SystemGeneratedAnswerKeyModel(status: $status, data: $data,)';

  factory SystemGeneratedAnswerKeyModel.fromMap(Map<String, dynamic> data) {
    return SystemGeneratedAnswerKeyModel(
      status: data['status'] as String?,
      data: data['data'] == null ? null : SystemGeneratedAnswerKeyData.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SystemGeneratedAnswerKeyModel].
  factory SystemGeneratedAnswerKeyModel.fromJson(String data) {
    return SystemGeneratedAnswerKeyModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SystemGeneratedAnswerKeyModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
