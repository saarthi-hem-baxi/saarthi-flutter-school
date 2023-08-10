import 'dart:convert';

class PrecapDetails {
  bool? skipped;
  bool? assingned;
  bool? started;
  bool? completed;

  PrecapDetails({
    this.skipped,
    this.assingned,
    this.started,
    this.completed,
  });

  @override
  String toString() {
    return 'PrecapDetails(skipped: $skipped, assingned: $assingned, started: $started, completed: $completed)';
  }

  factory PrecapDetails.fromMap(Map<String, dynamic> data) => PrecapDetails(
        skipped: data['skipped'] as bool?,
        assingned: data['assingned'] as bool?,
        started: data['started'] as bool?,
        completed: data['completed'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'skipped': skipped,
        'assingned': assingned,
        'started': started,
        'completed': completed,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PrecapDetails].
  factory PrecapDetails.fromJson(String data) {
    return PrecapDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrecapDetails] to a JSON string.
  String toJson() => json.encode(toMap());
}
