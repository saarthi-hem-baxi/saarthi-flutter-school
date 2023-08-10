import 'dart:convert';

import 'data.dart';

class SystemGeneratedTestModel {
  String? status;
  SystemGeneratedTestData? data;

  SystemGeneratedTestModel({this.status, this.data});

  @override
  String toString() {
    return 'SystemGeneratedTestModel(status: $status, data: $data)';
  }

  factory SystemGeneratedTestModel.fromMap(Map<String, dynamic> data) {
    return SystemGeneratedTestModel(
      status: data['status'] as String?,
      data: data['data'] == null
          ? null
          : SystemGeneratedTestData.fromMap(
              data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SystemGeneratedTestModel].
  factory SystemGeneratedTestModel.fromJson(String data) {
    return SystemGeneratedTestModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SystemGeneratedTestModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
