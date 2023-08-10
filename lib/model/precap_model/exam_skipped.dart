import 'dart:convert';

class ExamSkipped {
  bool? status;

  ExamSkipped({this.status});

  @override
  String toString() => 'ExamSkipped(status: $status)';

  factory ExamSkipped.fromMap(Map<String, dynamic> data) => ExamSkipped(
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExamSkipped].
  factory ExamSkipped.fromJson(String data) {
    return ExamSkipped.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExamSkipped] to a JSON string.
  String toJson() => json.encode(toMap());
}
