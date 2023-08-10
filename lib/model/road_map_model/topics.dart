import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/road_map_model/unclear_pre_concept.dart';

import 'concept.dart';
import 'topic.dart';

class Topics {
  int? order;
  bool? started;
  Topic? topic;
  bool? cleared;
  List<Concept>? concepts;
  List<UnclearPreConcept>? unclearPreConcepts;
  String? id;

  Topics({
    this.order,
    this.started,
    this.topic,
    this.cleared,
    this.concepts,
    this.unclearPreConcepts,
    this.id,
  });

  @override
  String toString() {
    return 'Topic(order: $order, started: $started, topic: $topic, cleared: $cleared, concepts: $concepts, id: $id)';
  }

  factory Topics.fromMap(Map<String, dynamic> data, String? langCode) => Topics(
        order: data['order'] as int?,
        started: data['started'] as bool?,
        topic: data['topic'] == null
            ? null
            : Topic.fromMap(data['topic'] as Map<String, dynamic>, langCode),
        cleared: data['cleared'] as bool?,
        concepts: (data['concepts'] as List<dynamic>?)
            ?.map((e) => Concept.fromMap(e as Map<String, dynamic>, langCode))
            .toList(),
        unclearPreConcepts: (data['unclearPreConcepts'] as List<dynamic>?)
            ?.map((e) =>
                UnclearPreConcept.fromMap(e as Map<String, dynamic>, langCode))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'order': order,
        'started': started,
        'topic': topic?.toMap(),
        'cleared': cleared,
        'concepts': concepts?.map((e) => e.toMap()).toList(),
        'unclearPreConcepts': unclearPreConcepts,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Topic].
  factory Topics.fromJson(String data, String? langCode) {
    return Topics.fromMap(json.decode(data) as Map<String, dynamic>, langCode);
  }

  /// `dart:convert`
  ///
  /// Converts [Topic] to a JSON string.
  String toJson() => json.encode(toMap());
}
