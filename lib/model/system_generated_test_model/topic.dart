class Topic {
  dynamic topic;
  String? chapter;
  String? id;

  Topic({this.topic, this.chapter, this.id});

  @override
  String toString() => 'Topic(topic: $topic, chapter: $chapter, id: $id)';

  factory Topic.fromMap(Map<String, dynamic> data, String? langCode) => Topic(
        topic: data['topic'] == null
            ? null
            : data['topic'].runtimeType == String
                ? data['topic'] as String
                : Topic.fromMap(data['topic'], langCode),
        chapter: data['chapter'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'chapter': chapter,
        '_id': id,
      };
}
