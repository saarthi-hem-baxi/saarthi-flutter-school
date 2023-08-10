class Chapter {
  Chapter({
    this.id,
    this.name,
    this.orderNumber,
    this.chapterId,
  });

  String? id;
  String? name;
  int? orderNumber;
  String? chapterId;

  factory Chapter.fromJson(Map<String, dynamic>? json) => Chapter(
        id: json?["_id"],
        name: json?["name"],
        orderNumber: json?["orderNumber"],
        chapterId: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "orderNumber": orderNumber,
        "id": chapterId,
      };
}
