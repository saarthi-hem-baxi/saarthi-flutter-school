class Question {
  String? enUs;

  Question({this.enUs});

  @override
  String toString() => 'Question(enUs: $enUs)';

  factory Question.fromMap(Map<String, dynamic> data, String? langCode) =>
      Question(
        enUs: data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
