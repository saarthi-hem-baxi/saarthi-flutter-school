import 'paragraph.dart';

class Comprehension {
  List<dynamic>? lang;
  Paragraph? paragraph;
  List<dynamic>? queAns;

  Comprehension({this.lang, this.paragraph, this.queAns});

  @override
  String toString() {
    return 'Comprehension(lang: $lang, paragraph: $paragraph, queAns: $queAns)';
  }

  factory Comprehension.fromMap(Map<String, dynamic> data, String? langCode) =>
      Comprehension(
        lang: data['lang'] as List<dynamic>?,
        paragraph: data['paragraph'] == null
            ? null
            : Paragraph.fromMap(
                data['paragraph'] as Map<String, dynamic>, langCode),
        queAns: data['queAns'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'lang': lang,
        'paragraph': paragraph?.toMap(),
        'queAns': queAns,
      };
}
