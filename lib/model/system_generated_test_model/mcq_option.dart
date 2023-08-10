import 'option.dart';

class McqOption {
  Option? option;
  bool? correct;
  String? id;

  McqOption({this.option, this.correct, this.id});

  @override
  String toString() {
    return 'McqOption(option: $option, correct: $correct, id: $id)';
  }

  factory McqOption.fromMap(Map<String, dynamic> data, String? langCode) =>
      McqOption(
        option: data['option'] == null
            ? null
            : Option.fromMap(data['option'] as Map<String, dynamic>, langCode),
        correct: data['correct'] as bool?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'option': option?.toMap(),
        'correct': correct,
        '_id': id,
      };
}
