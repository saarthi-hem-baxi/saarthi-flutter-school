import 'name.dart';

class Concept {
  Name? name;
  String? id;

  Concept({this.name, this.id});

  @override
  String toString() => 'Concept(name: $name, id: $id, )';

  factory Concept.fromMap(Map<String, dynamic> data, String? langCode) =>
      Concept(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>, langCode),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        '_id': id,
        'id': id,
      };
}
