import 'concept.dart';

class Topic {
  String? topic;
  List<Concept>? concepts;
  String? id;

  Topic({this.topic, this.concepts, this.id});

  @override
  String toString() => 'Topic(topic: $topic, concepts: $concepts, id: $id)';

  factory Topic.fromMap(Map<String, dynamic> data, String? langCode) => Topic(
        topic: data['topic'] as String?,
        concepts: (data['concepts'] as List<dynamic>?)
            ?.map((e) => Concept.fromMap(e as Map<String, dynamic>, langCode))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'concepts': concepts?.map((e) => e.toMap()).toList(),
        '_id': id,
      };
}
