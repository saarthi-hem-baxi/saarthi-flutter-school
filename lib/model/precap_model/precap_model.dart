import 'dart:convert';

import 'precapdata.dart';

class PrecapModel {
  String? status;
  PrecapData? precapData;

  PrecapModel({this.status, this.precapData});

  @override
  String toString() => 'PrecapModel(status: $status, data: $precapData)';

  factory PrecapModel.fromMap(Map<String, dynamic> data) => PrecapModel(
        status: data['status'] as String?,
        precapData: data['data'] == null
            ? null
            : PrecapData.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': precapData?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PrecapModel].
  factory PrecapModel.fromJson(String data) {
    return PrecapModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrecapModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
