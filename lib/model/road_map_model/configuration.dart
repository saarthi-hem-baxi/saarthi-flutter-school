import 'dart:convert';

class Configuration {
  bool? precap;
  bool? homework;
  bool? autoHomework;

  Configuration({
    this.precap,
    this.homework,
    this.autoHomework,
  });

  @override
  String toString() {
    return 'Configuration(precap: $precap, homework: $homework, autoHomework: $autoHomework)';
  }

  factory Configuration.fromMap(Map<String, dynamic> data) => Configuration(
        precap: data['precap'] as bool?,
        homework: data['homework'] as bool?,
        autoHomework: data['autoHomework'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'precap': precap,
        'homework': homework,
        'autoHomework': autoHomework,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Configuration].
  factory Configuration.fromJson(String data) {
    return Configuration.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Configuration] to a JSON string.
  String toJson() => json.encode(toMap());
}
