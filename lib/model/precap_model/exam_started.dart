import 'dart:convert';

class ExamStarted {
  bool? status;
  String? date;

  ExamStarted({this.status, this.date});

  @override
  String toString() => 'ExamStarted(status: $status, date: $date)';

  factory ExamStarted.fromMap(Map<String, dynamic> data) => ExamStarted(
        status: data['status'] as bool?,
        date: data['date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExamStarted].
  factory ExamStarted.fromJson(String data) {
    return ExamStarted.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExamStarted] to a JSON string.
  String toJson() => json.encode(toMap());
}
