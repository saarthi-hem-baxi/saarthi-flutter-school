import 'qus.dart';

String? langCode = 'en_US';

class Questions {
  Qus? qus;
  Concept? concept;
  String? keyLearning;
  String? answer;
  String? orId;
  bool? correct;
  List<dynamic>? concepts;
  List<dynamic>? keyLearnings;
  List<dynamic>? topics;
  int? timeTaken;
  String? startedAt;
  String? endAt;
  String? id;

  Questions({
    this.qus,
    this.concept,
    this.keyLearning,
    this.answer,
    this.orId,
    this.correct,
    this.concepts,
    this.keyLearnings,
    this.topics,
    this.timeTaken,
    this.startedAt,
    this.endAt,
    this.id,
  });

  @override
  String toString() {
    return 'Question(question: $qus, concept: $concept, keyLearning: $keyLearning, answer: $answer, orId: $orId, correct: $correct, concepts: $concepts, keyLearnings: $keyLearnings, topics: $topics, timeTaken: $timeTaken, startedAt: $startedAt, endAt: $endAt, id: $id)';
  }

  factory Questions.fromMap(Map<String, dynamic> data, String? lang) {
    langCode = lang;
    return Questions(
      qus: data['question'] == null ? null : Qus.fromMap(data['question'] as Map<String, dynamic>, langCode),
      concept: data["concept"] == null ? null : Concept.fromJson(data["concept"], langCode),
      keyLearning: data['keyLearning'] as String?,
      answer: data['answer'] as String?,
      orId: data['orId'] as String?,
      correct: data['correct'] as bool?,
      concepts: data['concepts'] as List<dynamic>?,
      keyLearnings: data['keyLearnings'] as List<dynamic>?,
      topics: data['topics'] as List<dynamic>?,
      timeTaken: data['timeTaken'] as int?,
      startedAt: data['startedAt'] as String?,
      endAt: data['endAt'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'question': qus?.toMap(),
        "concept": concept?.toJson(),
        'keyLearning': keyLearning,
        'answer': answer,
        'orId': orId,
        'correct': correct,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        'topics': topics,
        'timeTaken': timeTaken,
        'startedAt': startedAt,
        'endAt': endAt,
        '_id': id,
      };
}

class Concept {
  Concept({
    this.id,
    this.name,
  });

  String? id;
  Name? name;

  factory Concept.fromJson(Map<String, dynamic> json, String? langCode) => Concept(
        id: json["_id"],
        name: json["name"] == null ? null : Name.fromJson(json["name"], langCode),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name?.toJson(),
      };
}

class Name {
  Name({
    this.enUs,
  });

  String? enUs;

  factory Name.fromJson(Map<String, dynamic> json, String? langCode) => Name(
        enUs: json[langCode],
      );

  Map<String, dynamic> toJson() => {
        "$enUs": enUs,
      };
}
