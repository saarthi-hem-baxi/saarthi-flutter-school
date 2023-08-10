import 'dart:convert';
import 'package:saarthi_pedagogy_studentapp/model/homework_model/homework_datum.dart';

class HomeworkModel {
  String? status;
  List<HomeworkDatum>? data;

  HomeworkModel({this.status, this.data});

  @override
  String toString() => 'HomeworkModel(status: $status, data: $data)';

  factory HomeworkModel.fromMap(Map<String, dynamic> data) {
    return HomeworkModel(
      status: data['status'] as String?,
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => HomeworkDatum.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HomeworkModel].
  factory HomeworkModel.fromJson(String data) {
    return HomeworkModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HomeworkModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
