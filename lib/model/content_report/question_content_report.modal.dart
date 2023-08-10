// To parse this JSON data, do
//
//     final questionContentReportModal = questionContentReportModalFromJson(jsonString);

import 'dart:convert';

String questionContentReportModalToJson(QuestionContentReportModal data) => json.encode(data.toJson());

class QuestionContentReportModal {
  QuestionContentReportModal({
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
  QuestionReportContent? content;

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

class QuestionReportContent {
  QuestionReportContent({
    this.question,
  });

  String? question;

  Map<String, dynamic> toJson() => {
        "question": question,
      };
}
