import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_detail.dart';

class HomeworkDetailModel {
  String? status;
  HomeworkDetail? data;

  HomeworkDetailModel({this.status, this.data});

  @override
  String toString() => 'HomeworkDetailModel(status: $status, data: $data)';

  factory HomeworkDetailModel.fromMap(Map<String, dynamic> data) {
    return HomeworkDetailModel(
      status: data['status'] as String?,
      data: data['data'] == null
          ? null
          : HomeworkDetail.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HomeworkModel].
  factory HomeworkDetailModel.fromJson(String data) {
    return HomeworkDetailModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HomeworkModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
