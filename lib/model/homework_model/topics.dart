import 'package:saarthi_pedagogy_studentapp/model/homework_model/topic.dart';

class Topics {
  // String? topicInList;
  dynamic topic; //may be of Type Topic or String
  String? type;
  String? id;
  int? questionCount;

  Topics({this.topic, this.type, this.id, this.questionCount});

  @override
  String toString() => 'Topic(topic: $topic, type: $type, id: $id)';

  factory Topics.fromMap(Map<String, dynamic> data, String? langCode) => Topics(
      // topicInList: data['topic'] == null ? null : data['topic'] as String?,
      topic: data['type'] == "concept"
          ? data['concept'] == null
              ? null
              : data['concept'].runtimeType == String
                  ? data['concept'] as String
                  : Topic.fromMap(data['concept'], langCode)
          : data['topic'].runtimeType == String
              ? data['topic'] as String
              : Topic.fromMap(data['topic'], langCode),
      type: data['type'] as String?,
      id: data['id'] as String?,
      questionCount: data['questionCount'] == null ? null : data['questionCount'] as int?);

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'type': type,
        'id': id,
        'questionCount': questionCount,
      };
}
