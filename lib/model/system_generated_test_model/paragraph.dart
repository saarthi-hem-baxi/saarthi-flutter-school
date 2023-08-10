class Paragraph {
  String? enUs;

  Paragraph({this.enUs});

  @override
  String toString() => 'Paragraph(enUs: $enUs)';

  factory Paragraph.fromMap(Map<String, dynamic> data, String? langCode) =>
      Paragraph(
        enUs: data[langCode ?? 'en_US'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'en_US': enUs,
      };
}
