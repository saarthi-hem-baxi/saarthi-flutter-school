import 'dart:convert';

class Verify {
  bool? verified;
  String? verifiedAt;
  String? verifiedBy;

  Verify({this.verified, this.verifiedAt, this.verifiedBy});

  @override
  String toString() {
    return 'Verify(verified: $verified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy)';
  }

  factory Verify.fromMap(Map<String, dynamic> data) => Verify(
        verified: data['verified'] as bool?,
        verifiedAt: data['verifiedAt'] as String?,
        verifiedBy: data['verifiedBy'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'verified': verified,
        'verifiedAt': verifiedAt,
        'verifiedBy': verifiedBy,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Verify].
  factory Verify.fromJson(String data) {
    return Verify.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Verify] to a JSON string.
  String toJson() => json.encode(toMap());
}
