import 'dart:convert';

import 'precapexamdata.dart';

class PrecapExamModel {
  String? status;
  PreCapExamData? preCapExamData;

  PrecapExamModel({this.status, this.preCapExamData});

  @override
  String toString() =>
      'PrecapExamModel(status: $status, data: $preCapExamData)';

  factory PrecapExamModel.fromMap(Map<String, dynamic> data) {
    return PrecapExamModel(
      status: data['status'] as String?,
      preCapExamData: data['data'] == null
          ? null
          : PreCapExamData.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': preCapExamData?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PrecapExamModel].
  factory PrecapExamModel.fromJson(String data) {
    return PrecapExamModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrecapExamModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
