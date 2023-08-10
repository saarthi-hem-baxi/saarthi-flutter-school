class ViewContentReportModel {
  final String? status;
  final Data? data;

  ViewContentReportModel({
    this.status,
    this.data,
  });

  ViewContentReportModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}

class Data {
  final List<Reports>? reports;
  final int? total;
  final int? page;
  final int? limit;

  Data({
    this.reports,
    this.total,
    this.page,
    this.limit,
  });

  Data.fromJson(Map<String, dynamic> json)
      : reports = (json['reports'] as List?)?.map((dynamic e) => Reports.fromJson(e as Map<String, dynamic>)).toList(),
        total = json['total'] as int?,
        page = json['page'] as int?,
        limit = json['limit'] as int?;

  Map<String, dynamic> toJson() => {'reports': reports?.map((e) => e.toJson()).toList(), 'total': total, 'page': page, 'limit': limit};
}

class Reports {
  final String? id;
  final Subject? subject;
  final Content? content;
  final String? currentStatus;
  final String? reportId;
  final DateTime? createdAt;

  Reports({
    this.id,
    this.subject,
    this.content,
    this.currentStatus,
    this.reportId,
    this.createdAt,
  });

  Reports.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        subject = (json['subject'] as Map<String, dynamic>?) != null ? Subject.fromJson(json['subject'] as Map<String, dynamic>) : null,
        content = (json['content'] as Map<String, dynamic>?) != null ? Content.fromJson(json['content'] as Map<String, dynamic>) : null,
        currentStatus = json['currentStatus'] as String?,
        reportId = json['reportId'] as String?,
        createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal();

  Map<String, dynamic> toJson() => {
        '_id': id,
        'subject': subject?.toJson(),
        'content': content?.toJson(),
        'currentStatus': currentStatus,
        'reportId': reportId,
        'createdAt': createdAt
      };
}

class Subject {
  String? id;
  String? name;
  SubjectIcon? subjectIconData;

  Subject({
    required this.id,
    required this.name,
    this.subjectIconData,
  });

  factory Subject.fromJson(Map<String, dynamic>? json) => Subject(
        id: json?["_id"],
        name: json?["name"],
        subjectIconData: SubjectIcon.fromJson(json?["subject"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "subject": subjectIconData?.toJson(),
      };
}

class SubjectIcon {
  SubjectIcon({
    required this.id,
    required this.subjectIcon,
  });

  String? id;
  String? subjectIcon;

  factory SubjectIcon.fromJson(Map<String, dynamic>? json) => SubjectIcon(
        id: json?["_id"],
        subjectIcon: json?["subjectIcon"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subjectIcon": subjectIcon,
      };
}

class Content {
  final String? type;

  Content({
    this.type,
  });

  Content.fromJson(Map<String, dynamic> json) : type = json['type'] as String?;

  Map<String, dynamic> toJson() => {'type': type};
}
