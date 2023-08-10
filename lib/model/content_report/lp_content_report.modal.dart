// To parse this JSON data, do
//
//     final lpContentReportModal = lpContentReportModalFromJson(jsonString);

import 'dart:convert';

String lpContentReportModalToJson(LpContentReportModal data) => json.encode(data.toJson());

class LpContentReportModal {
  LpContentReportModal({
    this.lang,
    this.subject,
    this.book,
    this.publisher,
    this.chapter,
    // this.topics,
    // this.concepts,
    this.isPublisher,
    this.content,
  });

  String? lang;
  String? subject;
  String? book;
  String? publisher;
  String? chapter;
  // List<String>? topics;
  // List<String>? concepts;
  bool? isPublisher;
  LPReportContent? content;

  Map<String, dynamic> toJson() => {
        "lang": lang,
        "subject": subject,
        "book": book,
        "publisher": publisher,
        "chapter": chapter,
        // "topics": List<dynamic>.from(topics?.map((x) => x) ?? []),
        // "concepts": List<dynamic>.from(concepts?.map((x) => x) ?? []),
        "isPublisher": isPublisher,
        "content": content?.toJson(),
      };
}

class LPReportContent {
  LPReportContent({
    this.lessonPlan,
    this.forStudent,
    this.forTeacher,
    this.description,
    this.video,
    this.image,
    this.pdf,
    this.document,
    this.audio,
    this.example,
    this.simulation,
    this.link,
    this.word,
  });

  String? lessonPlan;
  LPReportForStudent? forStudent;
  LPReportForTeacher? forTeacher;
  LPReportItem? description;
  LPReportItem? video;
  LPReportItem? image;
  LPReportItem? pdf;
  LPReportItem? document;
  LPReportItem? audio;
  LPReportItem? example;
  LPReportItem? simulation;
  LPReportItem? link;
  LPReportWord? word;

  Map<String, dynamic> toJson() => {
        "lessonPlan": lessonPlan,
        "forStudent": forStudent?.toJson(),
        "forTeacher": forTeacher?.toJson(),
        "description": description?.toJson(),
        "video": video?.toJson(),
        "image": image?.toJson(),
        "pdf": pdf?.toJson(),
        "document": document?.toJson(),
        "audio": audio?.toJson(),
        "example": example?.toJson(),
        "simulation": simulation?.toJson(),
        "link": link?.toJson(),
        "word": word?.toJson(),
      };
}

class LPReportItem {
  LPReportItem({
    this.contentId,
  });

  String? contentId;

  Map<String, dynamic> toJson() => {
        "contentId": contentId,
      };
}

class LPReportForStudent {
  LPReportForStudent({
    this.forStudent,
  });

  bool? forStudent;

  Map<String, dynamic> toJson() => {
        "forStudent": forStudent,
      };
}

class LPReportForTeacher {
  LPReportForTeacher({
    this.forTeacher,
  });

  bool? forTeacher;

  Map<String, dynamic> toJson() => {
        "forTeacher": forTeacher,
      };
}

class LPReportWord {
  LPReportWord({
    this.contentId,
    this.media,
  });

  String? contentId;
  LPReportItem? media;

  Map<String, dynamic> toJson() => {
        "contentId": contentId,
        "media": media?.toJson(),
      };
}
