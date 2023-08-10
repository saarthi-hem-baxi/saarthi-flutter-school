import 'dart:convert';

class Skills {
  int? problemSolving;
  int? criticalThinking;
  int? creativity;
  int? decisionMaking;

  Skills({
    this.problemSolving,
    this.criticalThinking,
    this.creativity,
    this.decisionMaking,
  });

  @override
  String toString() {
    return 'Skills(problemSolving: $problemSolving, criticalThinking: $criticalThinking, creativity: $creativity, decisionMaking: $decisionMaking)';
  }

  factory Skills.fromMap(Map<String, dynamic> data) => Skills(
        problemSolving: data['problemSolving'] as int?,
        criticalThinking: data['criticalThinking'] as int?,
        creativity: data['creativity'] as int?,
        decisionMaking: data['decisionMaking'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'problemSolving': problemSolving,
        'criticalThinking': criticalThinking,
        'creativity': creativity,
        'decisionMaking': decisionMaking,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Skills].
  factory Skills.fromJson(String data) {
    return Skills.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Skills] to a JSON string.
  String toJson() => json.encode(toMap());
}
