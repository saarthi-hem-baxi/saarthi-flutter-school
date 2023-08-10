import 'dart:convert';

import 'pre_concept.dart';
import 'unclear_key_learning.dart';

class UnclearPreConcepts {
  PreConcept? preConcept;
  List<UnclearKeyLearning>? unclearKeyLearnings;

  UnclearPreConcepts({this.preConcept, this.unclearKeyLearnings});

  @override
  String toString() {
    return 'UnclearPreConcepts(preConcept: $preConcept, unclearKeyLearnings: $unclearKeyLearnings)';
  }

  factory UnclearPreConcepts.fromMap(Map<String, dynamic> data, String langCode) {
    return UnclearPreConcepts(
      preConcept: data['preConcept'] == null ? null : PreConcept.fromMap(data['preConcept'] as Map<String, dynamic>, langCode),
      unclearKeyLearnings:
          (data['unclearKeyLearnings'] as List<dynamic>?)?.map((e) => UnclearKeyLearning.fromMap(e as Map<String, dynamic>, langCode)).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'preConcept': preConcept?.toMap(),
        'unclearKeyLearnings': unclearKeyLearnings?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UnclearPreConcepts].
  factory UnclearPreConcepts.fromJson(String data, String langCode) {
    return UnclearPreConcepts.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [UnclearPreConcepts] to a JSON string.
  String toJson() => json.encode(toMap());
}
