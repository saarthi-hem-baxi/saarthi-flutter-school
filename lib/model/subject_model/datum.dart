import 'dart:convert';

class Datum {
  String? id;
  String? name;
  int? orderNumber;
  String? chapterId;
  List<ChapterElement>? chapters;

  Datum({
    this.id,
    this.name,
    this.orderNumber,
    this.chapterId,
    this.chapters,
  });

  @override
  String toString() => 'Datum(id: $id, name: $name)';

  factory Datum.fromMap(Map<String, dynamic>? data) => Datum(
        id: data?['_id'] as String?,
        name: data?['name'] as String?,
        orderNumber: data?["orderNumber"],
        chapterId: data?["id"],
        chapters: data?["chapters"] == null
            ? null
            : List<ChapterElement>.from(
                data?["chapters"].map((x) => ChapterElement.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        "orderNumber": orderNumber,
        "id": chapterId,
        "chapters": chapters == null
            ? null
            : List<dynamic>.from(chapters?.map((x) => x.toJson()) ?? []),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());
}

class ChapterElement {
  ChapterElement({
    this.book,
    this.chapter,
    this.order,
    this.id,
  });

  String? book;
  String? chapter;
  int? order;
  String? id;

  factory ChapterElement.fromJson(Map<String, dynamic>? json) => ChapterElement(
        book: json?["book"],
        chapter: json?["chapter"],
        order: json?["order"],
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "book": book,
        "chapter": chapter,
        "order": order,
        "_id": id,
      };
}
