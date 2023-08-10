import 'dart:convert';

class Started {
  bool? status;
  DateTime? date;

  Started({this.status, this.date});

  @override
  String toString() => 'Started(status: $status, date: $date)';

  factory Started.fromMap(Map<String, dynamic> data) => Started(
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
  /// Parses the string and returns the resulting Json object as [Started].
  factory Started.fromJson(String data) {
    return Started.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Started] to a JSON string.
  String toJson() => json.encode(toMap());
}
