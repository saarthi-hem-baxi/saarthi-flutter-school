import 'unclear_topics_concept.dart';

class RetestConceptTopicData {
  String? studentHomeworkId;
  List<UnclearTopicsConcept>? unclearTopicsConcepts;
  String? lang;

  RetestConceptTopicData({
    this.studentHomeworkId,
    this.unclearTopicsConcepts,
    this.lang,
  });

  @override
  String toString() {
    return 'RetestConceptTopicData(studentHomeworkId: $studentHomeworkId, unclearTopicsConcepts: $unclearTopicsConcepts, lang: $lang)';
  }

  factory RetestConceptTopicData.fromJson(Map<String, dynamic> data) {
    return RetestConceptTopicData(
      studentHomeworkId: data['studentHomeworkId'] as String?,
      unclearTopicsConcepts: (data['unclearTopicsConcepts'] as List<dynamic>)
          .map((e) => UnclearTopicsConcept.fromMap(
              e as Map<String, dynamic>, data['lang'] as String?))
          .toList(),
      lang: data['lang'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'studentHomeworkId': studentHomeworkId,
        'unclearTopicsConcepts':
            unclearTopicsConcepts?.map((e) => e.toMap()).toList(),
        'lang': lang,
      };
}
