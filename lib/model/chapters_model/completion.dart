import 'dart:convert';

class Completion {
  String? id;
  num? completion;

  Completion({this.id, this.completion});

  @override
  String toString() => 'Completion(id: $id, completion: $completion)';

  factory Completion.fromMap(Map<String, dynamic> data) => Completion(
        id: data['_id'] as String?,
        completion: data['completion'] as num?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'completion': completion,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Completion].
  factory Completion.fromJson(String data) {
    return Completion.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Completion] to a JSON string.
  String toJson() => json.encode(toMap());
}
