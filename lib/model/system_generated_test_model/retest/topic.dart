class Topic {
  String? name;
  String? id;

  Topic({this.name, this.id});

  @override
  String toString() => 'Concept(name: $name, id: $id, )';

  factory Topic.fromMap(Map<String, dynamic> data) => Topic(
        name: data['name'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
        'id': id,
      };
}
