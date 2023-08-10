import 'dart:convert';

import 'completion.dart';

class ChaptersDatum {
  String? id;
  String? name;
  int? orderNumber;
  Completion? completion;

  String? book;
  String? chapter;

  ChaptersDatum(
      {this.id,
      this.name,
      this.orderNumber,
      this.completion,
      this.book,
      this.chapter});

  @override
  String toString() {
    return 'Datum(id: $id, name: $name,orderNumber: $orderNumber, completion: $completion, book: $book, chapter: $chapter)';
  }

  factory ChaptersDatum.fromMap(Map<String, dynamic>? data) => ChaptersDatum(
        id: data?['_id'] as String?,
        name: data?['name'] as String?,
        book: data?["book"],
        chapter: data?["chapter"],
        orderNumber: data?['orderNumber'] as int?,
        completion: data?['completion'] == null
            ? null
            : Completion.fromMap(data?['completion'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        "book": book,
        "chapter": chapter,
        'orderNumber': orderNumber,
        'completion': completion?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory ChaptersDatum.fromJson(String data) {
    return ChaptersDatum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());
}
