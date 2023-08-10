import 'dart:convert';

class HomeworkHistory {
  String? status;
  String? date;
  String? id;

  HomeworkHistory({this.status, this.date, this.id});

  @override
  String toString() {
    return 'HomeworkHistory(status: $status, date: $date, id: $id)';
  }

  factory HomeworkHistory.fromMap(Map<String, dynamic> data) {
    return HomeworkHistory(
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
  /// Parses the string and returns the resulting Json object as [ClassworkHistory].
  factory HomeworkHistory.fromJson(String data) {
    return HomeworkHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ClassworkHistory] to a JSON string.
  String toJson() => json.encode(toMap());
}
