import 'dart:convert';

class ExamCompleted {
  bool? status;

  ExamCompleted({this.status});

  @override
  String toString() => 'ExamCompleted(status: $status)';

  factory ExamCompleted.fromMap(Map<String, dynamic> data) => ExamCompleted(
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExamCompleted].
  factory ExamCompleted.fromJson(String data) {
    return ExamCompleted.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExamCompleted] to a JSON string.
  String toJson() => json.encode(toMap());
}
