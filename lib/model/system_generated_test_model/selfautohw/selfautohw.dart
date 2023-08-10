import 'dart:convert';

import 'data.dart';

class SelfAutoHWDetailModel {
  String? status;
  Data? data;

  SelfAutoHWDetailModel({this.status, this.data});

  @override
  String toString() => 'Selfautohw(status: $status, data: $data)';

  factory SelfAutoHWDetailModel.fromMap(
    Map<String, dynamic> data,
  ) =>
      SelfAutoHWDetailModel(
        status: data['status'] as String?,
        data: data['data'] == null ? null : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SelfAutoHWDetailModel].
  factory SelfAutoHWDetailModel.fromJson(String data) {
    return SelfAutoHWDetailModel.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [SelfAutoHWDetailModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
