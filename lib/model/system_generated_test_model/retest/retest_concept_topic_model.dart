import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_concept_topic_data.dart';

class RetestConceptTopicModel {
  String? status;
  RetestConceptTopicData? data;

  RetestConceptTopicModel({this.status, this.data});

  @override
  String toString() {
    return 'SystemGeneratedTestModel(status: $status, data: $data)';
  }

  factory RetestConceptTopicModel.fromMap(Map<String, dynamic> data) {
    return RetestConceptTopicModel(
      status: data['status'] as String?,
      data: data['data'] == null
          ? null
          : RetestConceptTopicData.fromJson(
              data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toJson(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SystemGeneratedTestModel].
  factory RetestConceptTopicModel.fromJson(String data) {
    return RetestConceptTopicModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SystemGeneratedTestModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
