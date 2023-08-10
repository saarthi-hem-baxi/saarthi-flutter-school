class Answer {
  String? enUs;

  Answer({this.enUs});

  @override
  String toString() => 'Answer(enUs: $enUs)';

  factory Answer.fromMap(Map<String, dynamic> data, String? langCode) => Answer(
        enUs: data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
