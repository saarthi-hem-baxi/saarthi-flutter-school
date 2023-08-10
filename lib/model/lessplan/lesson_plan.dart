import 'dart:convert';

LessonPlanListModal lessonPlanListModalFromJson(String str) => LessonPlanListModal.fromJson(json.decode(str));

String lessonPlanListModalToJson(LessonPlanListModal data) => json.encode(data.toJson());

class LessonPlanListModal {
  LessonPlanListModal({
    this.lessonPlans,
    this.lang,
    this.concepts,
  });

  List<LessonPlan>? lessonPlans;
  String? lang;
  List<String>? concepts;

  factory LessonPlanListModal.fromJson(Map<String, dynamic>? json) => LessonPlanListModal(
        lessonPlans: List<LessonPlan>.from(json?["lessonPlans"]?.map((x) => LessonPlan.fromJson(x)) ?? []),
        lang: json?["lang"] ?? "en_US",
        concepts: List<String>.from(json?["concepts"]?.map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "lessonPlans": List<dynamic>.from(lessonPlans?.map((x) => x.toJson()) ?? []),
        "lang": lang,
        "concepts": List<dynamic>.from(concepts?.map((x) => x) ?? []),
      };
}

class LessonPlan {
  LessonPlan({
    this.id,
    this.lang,
    this.concepts,
    this.forStudent,
    this.studentInstruction,
    this.forTeacher,
    this.teacherInstruction,
    this.contentTypes,
    this.tags,
    this.topics,
    this.book,
    this.publisher,
    this.descriptions,
    this.videos,
    this.images,
    this.pdfs,
    this.documents,
    this.audio,
    this.examples,
    this.simulations,
    this.links,
    this.words,
    this.isPublisher,
    this.verify,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  List<String>? lang;
  List<Concept>? concepts;
  bool? forStudent;
  Map<String, String>? studentInstruction;
  bool? forTeacher;
  Map<String, String>? teacherInstruction;
  List<String>? contentTypes;
  List<String>? tags;
  List<LessonPlanTopic>? topics;
  String? book;
  String? publisher;
  List<LessonPlanItem>? descriptions;
  List<LessonPlanItem>? videos;
  List<LessonPlanItem>? images;
  List<LessonPlanItem>? pdfs;
  List<LessonPlanItem>? documents;
  List<LessonPlanItem>? audio;
  List<LessonPlanItem>? examples;
  List<LessonPlanItem>? simulations;
  List<LessonPlanItem>? links;
  List<Word>? words;
  bool? isPublisher;
  Verify? verify;
  String? createdBy;
  String? updatedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory LessonPlan.fromJson(Map<String, dynamic>? json) => LessonPlan(
        id: json?["_id"],
        lang: List<String>.from(json?["lang"]?.map((x) => x) ?? []),
        concepts: List<Concept>.from(json?["concepts"]?.map((x) => Concept.fromJson(x)) ?? []),
        forStudent: json?["forStudent"] ?? false,
        forTeacher: json?["forTeacher"] ?? false,
        studentInstruction: Map<String, String>.from(json?["studentInstruction"] ?? {}),
        teacherInstruction: Map<String, String>.from(json?["teacherInstruction"] ?? {}),
        contentTypes: List<String>.from(json?["contentTypes"]?.map((x) => x) ?? []),
        tags: List<String>.from(json?["tags"]?.map((x) => x) ?? []),
        topics: List<LessonPlanTopic>.from(json?["topics"]?.map((x) => LessonPlanTopic.fromJson(x)) ?? []),
        book: json?["book"],
        publisher: json?["publisher"],
        descriptions: List<LessonPlanItem>.from(json?["descriptions"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        videos: List<LessonPlanItem>.from(json?["videos"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        images: List<LessonPlanItem>.from(json?["images"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        pdfs: List<LessonPlanItem>.from(json?["pdfs"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        documents: List<LessonPlanItem>.from(json?["documents"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        audio: List<LessonPlanItem>.from(json?["audio"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        examples: List<LessonPlanItem>.from(json?["examples"].map((x) => LessonPlanItem.fromJson(x)) ?? []),
        simulations: List<LessonPlanItem>.from(json?["simulations"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        links: List<LessonPlanItem>.from(json?["links"]?.map((x) => LessonPlanItem.fromJson(x)) ?? []),
        words: List<Word>.from(json?["words"]?.map((x) => Word.fromJson(x)) ?? []),
        isPublisher: json?["isPublisher"] ?? false,
        verify: Verify.fromJson(json?["verify"]),
        createdBy: json?["createdBy"],
        updatedBy: json?["updatedBy"],
        status: json?["status"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? "")?.toLocal(),
        updatedAt: DateTime.tryParse(json?["updatedAt"] ?? "")?.toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lang": lang?.map((x) => x.toString()).toList() ?? [],
        "concepts": concepts?.map((x) => x.toString()).toList() ?? [],
        "forStudent": forStudent,
        "studentInstruction": studentInstruction,
        "forTeacher": forTeacher,
        "teacherInstruction": teacherInstruction,
        "contentTypes": contentTypes,
        "tags": tags,
        "topics": topics?.map((x) => x.toJson()).toList() ?? [],
        "book": book,
        "publisher": publisher,
        "descriptions": descriptions?.map((x) => x.toJson()).toList() ?? [],
        "videos": videos?.map((x) => x.toJson()).toList() ?? [],
        "images": images?.map((x) => x.toJson()).toList() ?? [],
        "pdfs": pdfs?.map((x) => x.toJson()).toList() ?? [],
        "documents": documents?.map((x) => x.toJson()).toList() ?? [],
        "audio": audio?.map((x) => x.toJson()).toList() ?? [],
        "simulations": simulations?.map((x) => x.toJson()).toList() ?? [],
        "links": links?.map((x) => x.toJson()).toList() ?? [],
        "words": words?.map((x) => x.toJson()).toList() ?? [],
        "isPublisher": isPublisher,
        "verify": verify?.toJson(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "status": status,
        "examples": examples?.map((x) => x.toJson()).toList() ?? [],
        "createdAt": createdAt?.toUtc().toIso8601String(),
        "updatedAt": updatedAt?.toUtc().toIso8601String(),
      };
}

class LessonPlanItem {
  LessonPlanItem({
    this.id,
    this.lang,
    this.type,
    this.name,
    this.description,
    this.url,
    this.thumb,
    this.contentCategory,
    this.topics,
    this.concepts,
    this.keyLearnings,
    this.startTime,
    this.endTime,
  });

  String? id;
  List<String>? lang;
  Map<String, String>? type;
  Map<String, String>? name;
  Map<String, String>? description;
  Map<String, String>? url;
  Map<String, String>? thumb;
  List<String>? contentCategory;
  List<LessonPlanItemTopic>? topics;
  List<String>? concepts;
  List<String>? keyLearnings;
  Map<String, String>? startTime;
  Map<String, String>? endTime;

  factory LessonPlanItem.fromJson(Map<String, dynamic>? json) => LessonPlanItem(
        id: json?["_id"],
        lang: List<String>.from(json?["lang"]?.map((x) => x) ?? []),
        name: Map<String, String>.from(json?["name"] ?? {}),
        description: Map<String, String>.from(json?["description"] ?? {}),
        url: Map<String, String>.from(json?["url"] ?? {}),
        type: Map<String, String>.from(json?["type"] ?? {}),
        contentCategory: List<String>.from(json?["contentCategory"]?.map((x) => x) ?? []),
        topics: List<LessonPlanItemTopic>.from(json?["topics"]?.map((x) => LessonPlanItemTopic.fromJson(x)) ?? []),
        concepts: List<String>.from(json?["concepts"]?.map((x) => x) ?? []),
        keyLearnings: List<String>.from(json?["keyLearnings"]?.map((x) => x) ?? []),
        thumb: Map<String, String>.from(json?["thumb"] ?? {}),
        startTime: Map<String, String>.from(json?["startTime"] ?? {}),
        endTime: Map<String, String>.from(json?["endTime"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lang": lang?.map((x) => x.toString()).toList() ?? [],
        "name": name,
        "description": description,
        "url": url,
        "type": type,
        "contentCategory": contentCategory?.map((x) => x.toString()).toList() ?? [],
        "topics": topics?.map((x) => x.toJson()).toList() ?? [],
        "concepts": concepts?.map((x) => x.toString()).toList() ?? [],
        "keyLearnings": keyLearnings?.map((x) => x.toString()).toList() ?? [],
        "thumb": thumb,
        "startTime": startTime,
        "endTime": endTime,
      };
}

class LessonPlanItemTopic {
  LessonPlanItemTopic({
    this.topic,
    this.chapter,
    this.id,
  });

  String? topic;
  String? chapter;
  String? id;

  factory LessonPlanItemTopic.fromJson(Map<String, dynamic>? json) => LessonPlanItemTopic(
        topic: json?["topic"],
        chapter: json?["chapter"],
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "chapter": chapter,
        "_id": id,
      };
}

class Concept {
  Concept({
    this.id,
    this.name,
  });

  String? id;
  Map<String, String>? name;

  factory Concept.fromJson(Map<String, dynamic>? json) => Concept(
        name: Map<String, String>.from(json?["name"] ?? {}),
        id: json?["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class LessonPlanTopic {
  LessonPlanTopic({
    this.id,
    this.topic,
    this.chapter,
  });

  String? id;
  Topic? topic;
  String? chapter;

  factory LessonPlanTopic.fromJson(Map<String, dynamic>? json) => LessonPlanTopic(
        id: json?["_id"],
        topic: Topic.fromJson(json?["topic"]),
        chapter: json?["chapter"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topic": topic?.toJson(),
        "chapter": chapter,
      };
}

class Topic {
  Topic({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Topic.fromJson(Map<String, dynamic>? json) => Topic(
        id: json?["_id"],
        name: json?["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Verify {
  Verify({
    this.verified,
    this.verifiedBy,
    this.verifiedAt,
  });

  bool? verified;
  String? verifiedBy;
  DateTime? verifiedAt;

  factory Verify.fromJson(Map<String, dynamic>? json) => Verify(
        verified: json?["verified"] ?? false,
        verifiedBy: json?["verifiedBy"],
        verifiedAt: DateTime.tryParse(json?["verifiedAt"] ?? "")?.toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "verifiedBy": verifiedBy,
        "verifiedAt": verifiedAt?.toUtc().toIso8601String(),
      };
}

class Word {
  Word({
    this.id,
    this.lang,
    this.word,
    this.meaning,
    this.contentCategory,
    this.topics,
    this.concepts,
    this.keyLearnings,
    this.media,
  });

  String? id;
  List<String>? lang;
  Map<String, String>? word;
  Map<String, String>? meaning;
  List<String>? contentCategory;
  List<LessonPlanItemTopic>? topics;
  List<String>? concepts;
  List<String>? keyLearnings;
  List<Media>? media;

  factory Word.fromJson(Map<String, dynamic>? json) => Word(
        id: json?["_id"],
        lang: List<String>.from(json?["lang"]?.map((x) => x) ?? []),
        word: Map<String, String>.from(json?["word"] ?? {}),
        meaning: Map<String, String>.from(json?["meaning"] ?? {}),
        contentCategory: List<String>.from(json?["contentCategory"]?.map((x) => x) ?? []),
        topics: List<LessonPlanItemTopic>.from(json?["topics"]?.map((x) => LessonPlanItemTopic.fromJson(x)) ?? []),
        concepts: List<String>.from(json?["concepts"]?.map((x) => x) ?? []),
        keyLearnings: List<String>.from(json?["keyLearnings"]?.map((x) => x) ?? []),
        media: List<Media>.from(json?["media"]?.map((x) => Media.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lang": lang?.map((x) => x.toString()).toList() ?? [],
        "word": word,
        "meaning": meaning,
        "contentCategory": contentCategory?.map((x) => x.toString()).toList() ?? [],
        "topics": topics?.map((x) => x.toJson()).toList() ?? [],
        "concepts": concepts?.map((x) => x.toString()).toList() ?? [],
        "keyLearnings": keyLearnings?.map((x) => x.toString()).toList() ?? [],
        "media": media?.map((x) => x.toJson()).toList() ?? [],
      };
}

class Media {
  Media({
    this.id,
    this.type,
    this.name,
    this.url,
    this.thumb,
    this.uniqueId,
  });

  String? id;
  Map<String, String>? type;
  Map<String, String>? name;
  Map<String, String>? url;
  Map<String, String>? thumb;
  String? uniqueId;

  factory Media.fromJson(Map<String, dynamic>? json) => Media(
        id: json?["_id"],
        type: Map<String, String>.from(json?["type"] ?? {}),
        name: Map<String, String>.from(json?["name"] ?? {}),
        url: Map<String, String>.from(json?["url"] ?? {}),
        thumb: Map<String, String>.from(json?["thumb"] ?? {}),
        uniqueId: json?["uniqueId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "name": name,
        "url": url,
        "thumb": thumb,
        "uniqueId": uniqueId,
      };
}
