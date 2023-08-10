import 'dart:convert';

class Submitted {
  dynamic status;
  DateTime? date;
  Submitted({this.status, this.date});

  @override
  String toString() => 'Submitted(status: $status, date: $date)';

  factory Submitted.fromMap(Map<String, dynamic> data) => Submitted(
        status: data['status'] as dynamic,
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
  /// Parses the string and returns the resulting Json object as [Submitted].
  factory Submitted.fromJson(String data) {
    return Submitted.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Submitted] to a JSON string.
  String toJson() => json.encode(toMap());
}
