class Subject {
  Subject({
    this.id,
    this.name,
    this.orderNumber,
    this.subjectId,
  });

  String? id;
  String? name;
  int? orderNumber;
  String? subjectId;

  factory Subject.fromJson(Map<String, dynamic>? json) => Subject(
        id: json?["_id"],
        name: json?["name"],
        orderNumber: json?["orderNumber"],
        subjectId: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "orderNumber": orderNumber,
        "id": subjectId,
      };
}
