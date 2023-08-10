import 'dart:convert';

class Description {
  String? enUs;

  Description({this.enUs});

  @override
  String toString() => 'Description(enUs: $enUs)';

  factory Description.fromMap(Map<String, dynamic> data) => Description(
        enUs: data['en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Description].
  factory Description.fromJson(String data) {
    return Description.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Description] to a JSON string.
  String toJson() => json.encode(toMap());
}
