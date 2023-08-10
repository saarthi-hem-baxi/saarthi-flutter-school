class QusSubsubsub {
  String? enUs;

  QusSubsubsub({this.enUs});

  @override
  String toString() => 'QusSubsubsub(enUs: $enUs)';

  factory QusSubsubsub.fromMap(Map<String, dynamic> data, String? langCode) =>
      QusSubsubsub(
        enUs: data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
