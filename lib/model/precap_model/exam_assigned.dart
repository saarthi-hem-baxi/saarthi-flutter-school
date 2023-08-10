import 'dart:convert';

class ExamAssigned {
  bool? status;

  ExamAssigned({this.status});

  @override
  String toString() => 'ExamAssigned(status: $status)';

  factory ExamAssigned.fromMap(Map<String, dynamic> data) => ExamAssigned(
        status: data['status'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExamAssigned].
  factory ExamAssigned.fromJson(String data) {
    return ExamAssigned.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExamAssigned] to a JSON string.
  String toJson() => json.encode(toMap());
}
