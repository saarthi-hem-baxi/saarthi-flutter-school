import 'dart:convert';

import 'retest_exam_data.dart';

class RetestExamModel {
  String? status;
  RetestExamData? data;

  RetestExamModel({this.status, this.data});

  @override
  String toString() {
    return 'SystemGeneratedTestModel(status: $status, data: $data)';
  }

  factory RetestExamModel.fromMap(Map<String, dynamic> data) {
    return RetestExamModel(
      status: data['status'] as String?,
      data: data['data'] == null
          ? null
          : RetestExamData.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RetestExamModel].
  factory RetestExamModel.fromJson(String data) {
    return RetestExamModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RetestExamModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
