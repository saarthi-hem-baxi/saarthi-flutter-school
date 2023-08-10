import 'dart:convert';

import 'retest_detail.dart';

class RetestDetailModel {
  String? status;
  RetestDetail? data;

  RetestDetailModel({this.status, this.data});

  @override
  String toString() => 'HomeworkDetailModel(status: $status, data: $data)';

  factory RetestDetailModel.fromMap(Map<String, dynamic> data) {
    return RetestDetailModel(
      status: data['status'] as String?,
      data: data['data'] == null ? null : RetestDetail.fromMap(data['data'] as Map<String, dynamic>, data['data']['lang']),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HomeworkModel].
  factory RetestDetailModel.fromJson(String data) {
    return RetestDetailModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HomeworkModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
