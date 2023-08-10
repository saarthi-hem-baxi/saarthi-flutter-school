import 'name.dart';

class Concept {
  String? id;
  Name? name;

  Concept({this.id, this.name});

  @override
  String toString() => 'Concept(id: $id, name: $name)';

  factory Concept.fromMap(Map<String, dynamic> data, String? langCode) =>
      Concept(
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
