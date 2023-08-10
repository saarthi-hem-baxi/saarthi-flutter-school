import 'package:saarthi_pedagogy_studentapp/model/homework_model/keylearning.dart';

class KeyLearnings {
  dynamic keyLearning;
  dynamic cleared;
  String? id;

  KeyLearnings({this.keyLearning, this.cleared, this.id});

  @override
  String toString() {
    return 'KeyLearning(keyLearning: $keyLearning, cleared: $cleared, id: $id)';
  }

  factory KeyLearnings.fromMap(Map<String, dynamic> data, String? langCode) =>
      KeyLearnings(
        keyLearning: data['keyLearning'] == null
            ? null
            : data['keyLearning'].runtimeType == String
                ? data['keyLearning'] as String
                : Keylearning.fromMap(
                    data['keyLearning'] as Map<String, dynamic>, langCode),
        cleared: data['cleared'] as dynamic,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning?.toMap(),
        'cleared': cleared,
        '_id': id,
      };
}
