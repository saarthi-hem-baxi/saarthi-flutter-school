import '../tests_model/hint_solution_model.dart';
import 'mcq_option.dart';
import 'qus_subsubsub.dart';

String langCode = 'en_US';

class Qus {
  String? id;
  String? type;
  bool? trueFalseAns;
  QusSubsubsub? qusSubsubsub;
  List<McqOption>? mcqOptions;
  Solution? solution;

  Qus({
    this.id,
    this.type,
    this.trueFalseAns,
    this.qusSubsubsub,
    this.mcqOptions,
    this.solution,
  });

  @override
  String toString() {
    return 'Qus(id: $id,type: $type,trueFalseAns: $trueFalseAns, qusSubsubsub: $qusSubsubsub, mcqOptions: $mcqOptions,  solution: $solution)';
  }

  factory Qus.fromMap(Map<String, dynamic> data, String? langCode) {
    // langCode = data['lang'] ?? "en_US";
    return Qus(
      id: data['_id'] as String?,
      type: data['type'] as String?,
      trueFalseAns: data['trueFalseAns'] as bool?,
      qusSubsubsub: data['question'] == null ? null : QusSubsubsub.fromMap(data['question'] as Map<String, dynamic>, langCode),
      mcqOptions: (data['mcqOptions'] as List<dynamic>?)?.map((e) => McqOption.fromMap(e as Map<String, dynamic>, langCode)).toList(),
      solution: data["solution"] == null ? null : Solution.fromJson(data["solution"], langCode ?? 'en_US'),
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'type': type,
        'trueFalseAns': trueFalseAns,
        'question': qusSubsubsub?.toMap(),
        'mcqOptions': mcqOptions?.map((e) => e.toMap()).toList(),
        "solution": solution?.toJson(),
      };
}
