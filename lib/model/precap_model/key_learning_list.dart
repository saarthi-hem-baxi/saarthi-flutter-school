import 'package:saarthi_pedagogy_studentapp/model/precap_model/key_learning.dart';

class KeyLearningList {
  KeyLearning? keyLearning;
  bool? cleared;
  String? id;
  String? clearedAt;

  KeyLearningList({this.keyLearning, this.cleared, this.id, this.clearedAt});

  @override
  String toString() {
    return 'KeyLearning(keyLearning: $keyLearning, cleared: $cleared, id: $id, clearedAt: $clearedAt)';
  }

  factory KeyLearningList.fromMap(
          Map<String, dynamic> data, String? langCode) =>
      KeyLearningList(
        keyLearning: data['keyLearning'] == null
            ? null
            : KeyLearning.fromMap(
                data['keyLearning'] as Map<String, dynamic>, langCode),
        cleared: data['cleared'] as bool?,
        id: data['_id'] as String?,
        clearedAt: data['clearedAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning?.toMap(),
        'cleared': cleared,
        '_id': id,
        'clearedAt': clearedAt,
      };
}
