class Topic {
  String? name;
  String? id;

  Topic({this.name, this.id});

  @override
  String toString() => 'Topic(name: $name,id: $id)';

  factory Topic.fromMap(Map<String, dynamic> data, String? langCode) => Topic(
        name: data['name'].runtimeType == String ? data['name'] as String? : data['name'][langCode ?? "en_US"] as String?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}
