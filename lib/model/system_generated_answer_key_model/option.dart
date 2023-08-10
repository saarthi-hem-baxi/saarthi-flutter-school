class Option {
  String? enUs;

  Option({this.enUs});

  @override
  String toString() => 'Option(enUs: $enUs)';

  factory Option.fromMap(Map<String, dynamic> data, String? langCode) => Option(
        enUs: data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
