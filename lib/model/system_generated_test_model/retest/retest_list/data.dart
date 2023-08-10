import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/system_generated_test_model/retest/retest_result/retest_result.dart';

import '../retest_detail.dart';

String langCode = 'en_US';

class Data {
  List<RetestResult>? retestResult;
  List<RetestDetail>? retestDetail;
  int? unclearTopicConcepts;
  String? lang;

  Data({
    this.retestResult,
    this.retestDetail,
    this.unclearTopicConcepts,
    this.lang,
  });

  @override
  String toString() {
    return 'Data(homeworks: $retestDetail, unclearTopicConcepts: $unclearTopicConcepts)';
  }

  factory Data.fromMap(Map<String, dynamic> data) {
    langCode = data['lang'] ?? "en_US";
    return Data(
      retestResult: (data['finalResult'] as List<dynamic>?)?.map((e) => RetestResult.fromMap(e as Map<String, dynamic>, langCode)).toList(),
      retestDetail: (data['homeworks'] as List<dynamic>?)?.map((e) => RetestDetail.fromMap(e as Map<String, dynamic>, langCode)).toList(),
      unclearTopicConcepts: data['unclearTopicConcepts'] as int?,
      lang: data['lang'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'retestResult': retestResult?.map((e) => e.toMap()).toList(),
        'homeworks': retestDetail?.map((e) => e.toMap()).toList(),
        'unclearTopicConcepts': unclearTopicConcepts,
        'lang': lang,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
