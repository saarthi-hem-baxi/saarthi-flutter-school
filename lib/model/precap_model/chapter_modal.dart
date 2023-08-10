class Chapter {
  Chapter({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Chapter.fromJson(Map<String, dynamic>? json) => Chapter(
        id: json?["_id"],
        name: json?["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
