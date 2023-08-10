class FilterSubjectModel {
  final String? status;
  final List<SubjectData>? subjectData;

  FilterSubjectModel({
    this.status,
    this.subjectData,
  });

  FilterSubjectModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        subjectData = (json['data'] as List?)?.map((dynamic e) => SubjectData.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'status': status, 'data': subjectData?.map((e) => e.toJson()).toList()};
}

class SubjectData {
  final String? subjectId;
  final String? name;
  final List<String>? subjects;
  final String? id;

  SubjectData({
    this.subjectId,
    this.name,
    this.subjects,
    this.id,
  });

  SubjectData.fromJson(Map<String, dynamic> json)
      : subjectId = json['_id'] as String?,
        name = json['name'] as String?,
        subjects = (json['subjects'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['id'] as String?;

  Map<String, dynamic> toJson() => {'_id': subjectId, 'name': name, 'subjects': subjects, 'id': id};
}
