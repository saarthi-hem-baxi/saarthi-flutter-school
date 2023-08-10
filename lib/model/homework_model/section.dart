class Section {
  Section({
    this.id,
    this.name,
    this.orderNumber,
    this.sectionId,
  });

  String? id;
  String? name;
  int? orderNumber;
  String? sectionId;

  factory Section.fromJson(Map<String, dynamic>? json) => Section(
        id: json?["_id"],
        name: json?["name"],
        orderNumber: json?["orderNumber"],
        sectionId: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "orderNumber": orderNumber,
        "id": sectionId,
      };
}
