import 'dart:convert';

class Submission {
  List<dynamic>? submission;
  DateTime? date;
  String? id;

  Submission({this.submission, this.date, this.id});

  @override
  String toString() {
    return 'Submission(submission: $submission, date: $date, id: $id)';
  }

  factory Submission.fromMap(Map<String, dynamic> data) => Submission(
        submission: (data['submissions'] as List<dynamic>?),
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'submission': submission,
        'date': date?.toUtc().toIso8601String(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Submission].
  factory Submission.fromJson(String data) {
    return Submission.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Submission] to a JSON string.
  String toJson() => json.encode(toMap());
}
