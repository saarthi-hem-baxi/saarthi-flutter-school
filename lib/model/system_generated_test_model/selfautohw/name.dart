import 'dart:convert';

class Name {
  String? enUs;

  Name({this.enUs});

  @override
  String toString() => 'Name(enUs: $enUs)';

  factory Name.fromMap(Map<String, dynamic> data, String langCode) => Name(
        enUs: (data[langCode] == null || (data[langCode].isEmpty)) ? data['en_US'] : data[langCode] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Name].
  factory Name.fromJson(String data, String langCode) {
    return Name.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [Name] to a JSON string.
  String toJson() => json.encode(toMap());
}
