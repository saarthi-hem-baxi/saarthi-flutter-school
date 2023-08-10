import 'dart:convert';

class Assigned {
  bool? status;
  DateTime? date;

  Assigned({this.status, this.date});

  @override
  String toString() => 'Assigned(status: $status, date: $date)';

  factory Assigned.fromMap(Map<String, dynamic> data) => Assigned(
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
  /// Parses the string and returns the resulting Json object as [Assigned].
  factory Assigned.fromJson(String data) {
    return Assigned.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Assigned] to a JSON string.
  String toJson() => json.encode(toMap());
}
