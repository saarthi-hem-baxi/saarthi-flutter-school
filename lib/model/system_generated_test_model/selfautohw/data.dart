import 'dart:convert';

import 'unclear_pre_concepts.dart';

String _langCode = 'en_US';

class Data {
  UnclearPreConcepts? unclearPreConcepts;
  String? lang;

  Data({this.unclearPreConcepts, this.lang});

  @override
  String toString() {
    return 'Data(unclearPreConcepts: $unclearPreConcepts, lang: $lang)';
  }

  factory Data.fromMap(Map<String, dynamic> data) {
    _langCode = data['lang'] ?? "en_us";
    return Data(
      unclearPreConcepts:
          data['unclearPreConcepts'] == null ? null : UnclearPreConcepts.fromMap(data['unclearPreConcepts'] as Map<String, dynamic>, _langCode),
      lang: data['lang'] as String?,
    );
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
}
