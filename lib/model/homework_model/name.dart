class Name {
  String? enUs;

  Name({this.enUs});

  @override
  String toString() => 'Name(enUs: $enUs)';

  factory Name.fromMap(Map<String, dynamic> data, String? langCode) => Name(
        enUs: (data[langCode ?? 'en_US'] == null || data[langCode].isEmpty) ? data['en_US'] : data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
