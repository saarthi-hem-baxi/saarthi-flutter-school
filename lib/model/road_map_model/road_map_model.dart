import 'dart:convert';

import 'data.dart';

class RoadMapModel {
  String? status;
  RoadMapData? data;

  RoadMapModel({this.status, this.data});

  @override
  String toString() => 'RoadMapModel(status: $status, data: $data)';

  factory RoadMapModel.fromMap(Map<String, dynamic> data) => RoadMapModel(
        status: data['status'] as String?,
        data: data['data'] == null
            ? null
            : RoadMapData.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RoadMapModel].
  factory RoadMapModel.fromJson(String data) {
    return RoadMapModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RoadMapModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
