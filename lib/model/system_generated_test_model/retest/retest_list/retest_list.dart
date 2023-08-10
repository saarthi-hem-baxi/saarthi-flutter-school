import 'dart:convert';

import 'data.dart';

class RetestListModel {
  String? status;
  Data? data;

  RetestListModel({this.status, this.data});

  @override
  String toString() => 'RetestList(status: $status, data: $data)';

  factory RetestListModel.fromMap(Map<String, dynamic> data) => RetestListModel(
        status: data['status'] as String?,
        data: data['data'] == null
            ? null
            : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RetestListModel].
  factory RetestListModel.fromJson(String data) {
    return RetestListModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RetestListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
