import 'dart:convert';

class Completed {
  bool? status;
  DateTime? date;
  Completed({this.status, this.date});

  @override
  String toString() => 'Completed(status: $status)';

  factory Completed.fromMap(Map<String, dynamic> data) => Completed(
        status: data['status'] as bool?,
        date: data['date'] != null
            ? DateTime.parse(data['date']).toLocal()
            : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'date': date?.toUtc().toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Completed].
  factory Completed.fromJson(String data) {
    return Completed.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Completed] to a JSON string.
  String toJson() => json.encode(toMap());
}
