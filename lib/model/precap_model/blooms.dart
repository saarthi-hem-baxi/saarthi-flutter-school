import 'dart:convert';

class Blooms {
  int? knowledge;
  int? application;
  int? analysis;
  int? understanding;
  int? evaluation;
  int? creations;

  Blooms({
    this.knowledge,
    this.application,
    this.analysis,
    this.understanding,
    this.evaluation,
    this.creations,
  });

  @override
  String toString() {
    return 'Blooms(knowledge: $knowledge, application: $application, analysis: $analysis, understanding: $understanding, evaluation: $evaluation, creations: $creations)';
  }

  factory Blooms.fromMap(Map<String, dynamic> data) => Blooms(
        knowledge: data['knowledge'] as int?,
        application: data['application'] as int?,
        analysis: data['analysis'] as int?,
        understanding: data['understanding'] as int?,
        evaluation: data['evaluation'] as int?,
        creations: data['creations'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'knowledge': knowledge,
        'application': application,
        'analysis': analysis,
        'understanding': understanding,
        'evaluation': evaluation,
        'creations': creations,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Blooms].
  factory Blooms.fromJson(String data) {
    return Blooms.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Blooms] to a JSON string.
  String toJson() => json.encode(toMap());
}
