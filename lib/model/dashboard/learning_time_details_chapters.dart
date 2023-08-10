// To parse this JSON data, do
//
//     final learningTimeDetailsChapters = learningTimeDetailsChaptersFromJson(jsonString);

import 'dart:convert';

LearningTimeDetailsChaptersModal learningTimeDetailsChaptersFromJson(str) => LearningTimeDetailsChaptersModal.fromJson(str);

String learningTimeDetailsChaptersToJson(LearningTimeDetailsChaptersModal data) => json.encode(data.toJson());

class LearningTimeDetailsChaptersModal {
  LearningTimeDetailsChaptersModal({
    this.chartData,
    this.subjectName,
  });

  List<LearningTimeChapterData>? chartData;
  String? subjectName;

  factory LearningTimeDetailsChaptersModal.fromJson(Map<String, dynamic>? json) => LearningTimeDetailsChaptersModal(
        chartData: List<LearningTimeChapterData>.from(json?["chartData"].map((x) => LearningTimeChapterData.fromJson(x)) ?? []),
        subjectName: json?["subjectName"],
      );

  Map<String, dynamic> toJson() => {
        "chartData": List<LearningTimeChapterData>.from(chartData?.map((x) => x.toJson()) ?? []),
        "subjectName": subjectName,
      };
}

class LearningTimeChapterData {
  LearningTimeChapterData({
    this.name,
    this.chapterNumber,
    this.chapterId,
    this.subjectId,
    this.duration,
  });

  String? name;
  int? chapterNumber;
  String? chapterId;
  String? subjectId;
  num? duration;

  factory LearningTimeChapterData.fromJson(Map<String, dynamic>? json) => LearningTimeChapterData(
        name: json?["name"],
        chapterNumber: json?["chapterNumber"],
        chapterId: json?["chapterId"],
        subjectId: json?["subjectId"],
        duration: json?["duration"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "chapterNumber": chapterNumber,
        "chapterId": chapterId,
        "subjectId": subjectId,
        "duration": duration,
      };
}
