import 'dart:convert';

class Question {
  String? question;
  String? concept;
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

  Question({
    this.question,
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
    return 'Question(question: $question, concept: $concept, keyLearning: $keyLearning, answer: $answer, orId: $orId, correct: $correct, concepts: $concepts, keyLearnings: $keyLearnings, topics: $topics, timeTaken: $timeTaken, startedAt: $startedAt, endAt: $endAt, id: $id)';
  }

  factory Question.fromMap(Map<String, dynamic> data) => Question(
        question: data['question'] as String?,
        concept: data['concept'] as String?,
        keyLearning: data['keyLearning'] as String?,
        answer: data['answer'] as String?,
        orId: data['orId'] as String?,
        correct: data['correct'] as bool?,
        concepts: data['concepts'] as List<dynamic>,
        keyLearnings: data['keyLearnings'] as List<dynamic>,
        topics: data['topics'] as List<dynamic>?,
        timeTaken: data['timeTaken'] as int?,
        startedAt: data['startedAt'] as String?,
        endAt: data['endAt'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'question': question,
        'concept': concept,
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

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Question].
  factory Question.fromJson(String data) {
    return Question.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Question] to a JSON string.
  String toJson() => json.encode(toMap());
}
