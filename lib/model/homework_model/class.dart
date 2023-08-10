class Class {
  Class({
    this.id,
    this.name,
    this.orderNumber,
    this.classId,
  });

  String? id;
  String? name;
  int? orderNumber;
  String? classId;

  factory Class.fromJson(Map<String, dynamic>? json) => Class(
        id: json?["_id"],
        name: json?["name"],
        orderNumber: json?["orderNumber"],
        classId: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "orderNumber": orderNumber,
        "id": classId,
      };
}
