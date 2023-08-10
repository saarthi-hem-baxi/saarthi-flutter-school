class Topic {
  String? id;
  String? name;
  String? status;
  num? startPageNumber;
  num? endPageNumber;
  num? startLineNumber;
  num? endLineNumber;
  bool? hasGrammar;

  Topic({
    this.id,
    this.name,
    this.status,
    this.startPageNumber,
    this.endPageNumber,
    this.startLineNumber,
    this.endLineNumber,
    this.hasGrammar,
  });

  @override
  String toString() => 'Datum(id: $id, name: $name,status: $status, hasGrammar: $hasGrammar)';

  factory Topic.fromMap(Map<String, dynamic> data, String? langCode) => Topic(
        id: data['id'] as String?,
        name: data['name'] as String?,
        status: data['status'] as String?,
        startPageNumber: data['startPageNumber'] as num?,
        endPageNumber: data['endPageNumber'] as num?,
        startLineNumber: data['startLineNumber'] as num?,
        endLineNumber: data['endLineNumber'] as num?,
        hasGrammar: data['hasGrammar'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'status': status,
        'startPageNumber': startPageNumber,
        'endPageNumber': endPageNumber,
        'startLineNumber': startLineNumber,
        'endLineNumber': endLineNumber,
        'hasGrammar': hasGrammar
      };
}
