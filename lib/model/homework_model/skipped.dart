import 'dart:convert';

class Skipped {
  dynamic status;

  Skipped({this.status});

  @override
  String toString() => 'Skipped(status: $status)';

  factory Skipped.fromMap(Map<String, dynamic> data) => Skipped(
        status: data['status'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Skipped].
  factory Skipped.fromJson(String data) {
    return Skipped.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Skipped] to a JSON string.
  String toJson() => json.encode(toMap());
}
