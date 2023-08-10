import 'name.dart';

class KeyLearning {
  String? id;
  Name? name;

  KeyLearning({this.id, this.name});

  @override
  String toString() => 'Concept(id: $id, name: $name)';

  factory KeyLearning.fromMap(Map<String, dynamic> data, String? langCode) =>
      KeyLearning(
        id: data['_id'] as String?,
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>, langCode),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name?.toMap(),
      };
}
