class PreConcept {
  Map<String, String>? name;
  String? id;
  String? id_;
  String? status;
  bool? hasGrammar;

  PreConcept({
    this.name,
    this.id,
    this.id_,
    this.status,
    this.hasGrammar,
  });

  @override
  String toString() => 'PreConcept(name: $name, id: $id, id: $id_,status: $status, hasGrammar: $hasGrammar)';

  factory PreConcept.fromMap(Map<String, dynamic> data, String? langCode) => PreConcept(
        name: data['name'] == null ? null : Map<String, String>.from(data['name']),
        id: data['id'] as String?,
        id_: data['_id'] as String?,
        status: data['status'] as String?,
        hasGrammar: data['hasGrammar'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        '_id': id_,
        'status': status,
        'hasGrammar': hasGrammar,
      };
}
