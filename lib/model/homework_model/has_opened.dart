import 'dart:convert';

class HasOpened {
  dynamic status;

  HasOpened({this.status});

  @override
  String toString() => 'HasOpened(status: $status)';

  factory HasOpened.fromMap(Map<String, dynamic> data) => HasOpened(
        status: data['status'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HasOpened].
  factory HasOpened.fromJson(String data) {
    return HasOpened.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HasOpened] to a JSON string.
  String toJson() => json.encode(toMap());
}
