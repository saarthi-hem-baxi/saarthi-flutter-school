import 'key_learning.dart';

class UnclearKeyLearning {
  KeyLearning? keyLearning;
  bool? cleared;
  String? clearedAt;
  String? id;

  UnclearKeyLearning({
    this.keyLearning,
    this.cleared,
    this.clearedAt,
    this.id,
  });

  @override
  String toString() {
    return 'UnclearKeyLearning(keyLearning: $keyLearning, cleared: $cleared, clearedAt: $clearedAt, id: $id)';
  }

  factory UnclearKeyLearning.fromMap(
      Map<String, dynamic> data, String? langCode) {
    return UnclearKeyLearning(
      keyLearning: data['keyLearning'] == null
          ? null
          : KeyLearning.fromMap(
              data['keyLearning'] as Map<String, dynamic>, langCode),
      cleared: data['cleared'] as bool?,
      clearedAt: data['clearedAt'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'keyLearning': keyLearning?.toMap(),
        'cleared': cleared,
        'clearedAt': clearedAt,
        '_id': id,
      };
}
