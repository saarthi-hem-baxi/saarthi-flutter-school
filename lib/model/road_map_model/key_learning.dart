class KeyLearning {
  Map<String, String>? name;
  String? id;
  String? id_;

  KeyLearning({this.name, this.id, this.id_});

  @override
  String toString() => 'KeyLearning(name: $name, id: $id, id: $id_)';

  factory KeyLearning.fromMap(Map<String, dynamic> data, String? langCode) => KeyLearning(
        name: data['name'] == null ? null : Map<String, String>.from(data['name'] ?? ""),
        id: data['id'] as String?,
        id_: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        '_id': id_,
      };
}
