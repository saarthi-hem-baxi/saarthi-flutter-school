import 'dart:convert';

class ExamStatusHistory {
  String? status;
  String? date;
  String? id;

  ExamStatusHistory({this.status, this.date, this.id});

  @override
  String toString() {
    return 'ExamStatusHistory(status: $status, date: $date, id: $id)';
  }

  factory ExamStatusHistory.fromMap(Map<String, dynamic> data) {
    return ExamStatusHistory(
      status: data['status'] as String?,
      date: data['date'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExamStatusHistory].
  factory ExamStatusHistory.fromJson(String data) {
    return ExamStatusHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExamStatusHistory] to a JSON string.
  String toJson() => json.encode(toMap());
}
