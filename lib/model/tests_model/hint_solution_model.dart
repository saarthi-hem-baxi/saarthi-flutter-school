import '../system_generated_test_model/answer.dart';

class Solution {
  Solution({
    this.description,
    this.media,
  });

  Answer? description;
  List<SolutionMedia>? media;

  factory Solution.fromJson(Map<String, dynamic> json, String langCode) {
    return Solution(
      description: json["description"] == null ? null : Answer.fromMap(json["description"], langCode),
      media: json["media"] == null ? [] : List<SolutionMedia>.from(json["media"]!.map((x) => SolutionMedia.fromJson(x, langCode))),
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description?.toMap(),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class SolutionMedia {
  SolutionMedia({
    this.type,
    this.name,
    this.url,
    this.thumb,
    this.uniqueId,
    this.id,
  });

  Answer? type;
  Answer? name;
  SolutionUrl? url;
  Answer? thumb;
  String? uniqueId;
  String? id;

  factory SolutionMedia.fromJson(Map<String, dynamic> json, String langCode) => SolutionMedia(
        type: json["type"] == null ? null : Answer.fromMap(json["type"], langCode),
        name: json["name"] == null ? null : Answer.fromMap(json["name"], langCode),
        url: json["url"] == null ? null : SolutionUrl.fromJson(json["url"], langCode),
        thumb: json["thumb"] == null ? null : Answer.fromMap(json["thumb"], langCode),
        uniqueId: json["uniqueId"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type?.toMap(),
        "name": name?.toMap(),
        "url": url?.toJson(),
        "thumb": thumb?.toMap(),
        "uniqueId": uniqueId,
        "_id": id,
      };
}

class SolutionUrl {
  SolutionUrl({
    this.enUs,
  });

  String? enUs;

  factory SolutionUrl.fromJson(Map<String, dynamic> json, String langCode) => SolutionUrl(
        enUs: json[langCode],
      );

  Map<String, dynamic> toJson() => {
        '$enUs': enUs,
      };
}
