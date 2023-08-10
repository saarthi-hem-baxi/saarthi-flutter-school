import 'package:saarthi_pedagogy_studentapp/model/homework_model/name.dart';

class Keylearning {
  Name? name;
  String? id;

  Keylearning({this.name, this.id});

  @override
  String toString() => 'Topic(name: $name,id: $id)';

  factory Keylearning.fromMap(Map<String, dynamic> data, String? langCode) =>
      Keylearning(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>, langCode),
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}
