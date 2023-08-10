class ViewContentReportDetailModel {
  final String? status;
  final Data? data;

  ViewContentReportDetailModel({
    this.status,
    this.data,
  });

  ViewContentReportDetailModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}

class Data {
  final String? id;
  final ClassData? classData;
  final Chapter? chapter;
  final Subject? subject;
  final String? lang;
  final Content? content;
  final Message? message;
  final String? currentStatus;
  final String? reportId;
  final List<Solution>? solution;
  final DateTime? createdAt;
  final dynamic contentData;

  Data(
      {this.id,
      this.classData,
      this.chapter,
      this.subject,
      this.lang,
      this.content,
      this.message,
      this.currentStatus,
      this.reportId,
      this.solution,
      this.createdAt,
      this.contentData});

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        classData = (json['class'] as Map<String, dynamic>?) != null ? ClassData.fromJson(json['class'] as Map<String, dynamic>) : null,
        chapter = (json['chapter'] as Map<String, dynamic>?) != null ? Chapter.fromJson(json['chapter'] as Map<String, dynamic>) : null,
        subject = (json['subject'] as Map<String, dynamic>?) != null ? Subject.fromJson(json['subject'] as Map<String, dynamic>) : null,
        lang = json['lang'] as String?,
        content = (json['content'] as Map<String, dynamic>?) != null
            ? Content.fromJson(json['content'] as Map<String, dynamic>, (json['lang'] ?? ''))
            : null,
        message = (json['message'] as Map<String, dynamic>?) != null ? Message.fromJson(json['message'] as Map<String, dynamic>) : null,
        currentStatus = json['currentStatus'] as String?,
        reportId = json['reportId'] as String?,
        solution = (json['solution'] as List?)?.map((dynamic e) => Solution.fromJson(e as Map<String, dynamic>)).toList(),
        contentData = (json['content'] as Map<String, dynamic>?) != null ? json['content'] as Map<String, dynamic> : null,
        createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal();

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chapter': chapter?.toJson(),
        'subject': subject?.toJson(),
        'lang': lang,
        'content': content?.toJson(),
        'message': message?.toJson(),
        'currentStatus': currentStatus,
        'reportId': reportId,
        'solution': solution,
        'createdAt': createdAt
      };
}

class ClassData {
  final String? id;
  final String? name;

  ClassData({
    this.id,
    this.name,
  });

  ClassData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class Chapter {
  final String? id;
  final String? name;

  Chapter({
    this.id,
    this.name,
  });

  Chapter.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class Subject {
  final String? id;
  final String? name;

  Subject({
    this.id,
    this.name,
  });

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class Content {
  final String? type;
  final String? lessonPlan;
  final String? contentDataType;
  final ForStudent? forStudent;
  final ForTeacher? forTeacher;
  final Description? description;
  final Example? example;
  final Word? word;
  final Video? video;
  final Image? image;
  final Pdf? pdf;
  final Document? document;
  final Audio? audio;
  final Simulation? simulation;
  final Link? link;
  final Question? question;
  final List<Solution>? solution;
  Content({
    this.type,
    this.lessonPlan,
    this.contentDataType,
    this.forStudent,
    this.forTeacher,
    this.description,
    this.example,
    this.word,
    this.video,
    this.image,
    this.pdf,
    this.document,
    this.audio,
    this.simulation,
    this.link,
    this.question,
    this.solution,
  });

  Content.fromJson(Map<String, dynamic> json, String langCode)
      : type = json['type'] as String?,
        lessonPlan = json['lessonPlan'] as String?,
        contentDataType = json.containsKey('forStudent') == true
            ? 'forStudent'
            : false || json.containsKey('forTeacher') == true
                ? 'forTeacher'
                : false || json.containsKey('description') == true
                    ? 'description'
                    : false || json.containsKey('example') == true
                        ? 'example'
                        : false || json.containsKey('word') == true
                            ? 'word'
                            : false || json.containsKey('video') == true
                                ? 'video'
                                : false || json.containsKey('image') == true
                                    ? 'image'
                                    : false || json.containsKey('pdf') == true
                                        ? 'pdf'
                                        : false || json.containsKey('document') == true
                                            ? 'document'
                                            : false || json.containsKey('audio') == true
                                                ? 'audio'
                                                : false || json.containsKey('simulation') == true
                                                    ? 'simulation'
                                                    : false || json.containsKey('link') == true
                                                        ? 'link'
                                                        : false || json.containsKey('question') == true
                                                            ? 'question'
                                                            : '',
        forStudent = (json['forStudent'] as Map<String, dynamic>?) != null ? ForStudent.fromJson(json['forStudent'] as Map<String, dynamic>) : null,
        forTeacher = (json['forTeacher'] as Map<String, dynamic>?) != null ? ForTeacher.fromJson(json['forTeacher'] as Map<String, dynamic>) : null,
        description =
            (json['description'] as Map<String, dynamic>?) != null ? Description.fromJson(json['description'] as Map<String, dynamic>) : null,
        example = (json['example'] as Map<String, dynamic>?) != null ? Example.fromJson(json['example'] as Map<String, dynamic>) : null,
        word = (json['word'] as Map<String, dynamic>?) != null ? Word.fromJson(json['word'] as Map<String, dynamic>) : null,
        video = (json['video'] as Map<String, dynamic>?) != null ? Video.fromJson(json['video'] as Map<String, dynamic>) : null,
        image = (json['image'] as Map<String, dynamic>?) != null ? Image.fromJson(json['image'] as Map<String, dynamic>) : null,
        pdf = (json['pdf'] as Map<String, dynamic>?) != null ? Pdf.fromJson(json['pdf'] as Map<String, dynamic>) : null,
        document = (json['document'] as Map<String, dynamic>?) != null ? Document.fromJson(json['document'] as Map<String, dynamic>) : null,
        audio = (json['audio'] as Map<String, dynamic>?) != null ? Audio.fromJson(json['audio'] as Map<String, dynamic>) : null,
        simulation = (json['simulation'] as Map<String, dynamic>?) != null ? Simulation.fromJson(json['simulation'] as Map<String, dynamic>) : null,
        link = (json['link'] as Map<String, dynamic>?) != null ? Link.fromJson(json['link'] as Map<String, dynamic>) : null,
        question = (json['question'] as Map<String, dynamic>?) != null ? Question.fromJson(json['question'] as Map<String, dynamic>, langCode) : null,
        solution = (json['solution'] as List?)?.map((dynamic e) => Solution.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'type': type, 'lessonPlan': lessonPlan, 'forStudent': forStudent?.toJson()};
}

class ForStudent {
  final bool? forStudent;
  final String? studentInstruction;

  ForStudent({
    this.forStudent,
    this.studentInstruction,
  });

  ForStudent.fromJson(Map<String, dynamic> json)
      : forStudent = json['forStudent'] as bool?,
        studentInstruction = json['studentInstruction'] as String?;

  Map<String, dynamic> toJson() => {'forStudent': forStudent, 'studentInstruction': studentInstruction};
}

class ForTeacher {
  final bool? forTeacher;
  final String? teacherInstruction;

  ForTeacher({
    this.forTeacher,
    this.teacherInstruction,
  });

  ForTeacher.fromJson(Map<String, dynamic> json)
      : forTeacher = json['forTeacher'] as bool?,
        teacherInstruction = json['teacherInstruction'] as String?;

  Map<String, dynamic> toJson() => {'forTeacher': forTeacher, 'teacherInstruction': teacherInstruction};
}

class Description {
  final String? contentId;
  final String? description;

  Description({
    this.contentId,
    this.description,
  });

  Description.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        description = json['description'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'description': description};
}

class Example {
  final String? contentId;
  final String? description;

  Example({
    this.contentId,
    this.description,
  });

  Example.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        description = json['description'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'description': description};
}

class Word {
  final String? contentId;
  final String? meaning;
  final WordMedia? wordMedia;

  Word({
    this.contentId,
    this.meaning,
    this.wordMedia,
  });

  Word.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        meaning = json['meaning'] as String?,
        wordMedia = (json['media'] as Map<String, dynamic>?) != null ? WordMedia.fromJson(json['media'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'meaning': meaning, 'media': wordMedia};
}

class WordMedia {
  final String? contentId;
  final String? url;
  final String? thumb;

  WordMedia({this.contentId, this.url, this.thumb});

  WordMedia.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?,
        thumb = json['thumb'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url, 'thumb': thumb};
}

class Video {
  final String? contentId;
  final String? url;
  final String? thumb;

  Video({
    this.contentId,
    this.url,
    this.thumb,
  });

  Video.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?,
        thumb = json['thumb'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url, 'thumb': thumb};
}

class Image {
  final String? contentId;
  final String? url;
  final String? thumb;

  Image({
    this.contentId,
    this.url,
    this.thumb,
  });

  Image.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?,
        thumb = json['thumb'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url, 'thumb': thumb};
}

class Pdf {
  final String? contentId;
  final String? url;

  Pdf({
    this.contentId,
    this.url,
  });

  Pdf.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url};
}

class Document {
  final String? contentId;
  final String? url;

  Document({
    this.contentId,
    this.url,
  });

  Document.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url};
}

class Audio {
  final String? contentId;
  final String? url;

  Audio({
    this.contentId,
    this.url,
  });

  Audio.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url};
}

class Simulation {
  final String? contentId;
  final String? url;

  Simulation({
    this.contentId,
    this.url,
  });

  Simulation.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url};
}

class Link {
  final String? contentId;
  final String? url;

  Link({
    this.contentId,
    this.url,
  });

  Link.fromJson(Map<String, dynamic> json)
      : contentId = json['contentId'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {'contentId': contentId, 'url': url};
}

class Question {
  final String? id;
  final QuestionData? questionData;

  Question({
    this.id,
    this.questionData,
  });

  Question.fromJson(Map<String, dynamic> json, String langCode)
      : id = json['_id'] as String?,
        questionData =
            (json['question'] as Map<String, dynamic>?) != null ? QuestionData.fromJson(json['question'] as Map<String, dynamic>, langCode) : null;

  Map<String, dynamic> toJson() => {'_id': id, 'question': questionData};
}

class QuestionData {
  final String? question;

  QuestionData({
    this.question,
  });

  QuestionData.fromJson(Map<String, dynamic> json, String langCode) : question = json[langCode] as String?;

  Map<String, dynamic> toJson() => {'question': question};
}

class Message {
  final String? description;
  final List<Media>? media;

  Message({
    this.description,
    this.media,
  });

  Message.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String?,
        media = (json['media'] as List?)?.map((dynamic e) => Media.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'description': description, 'media': media};
}

class Media {
  final String? url;
  final String? thumbUrl;
  final String? id;

  Media({
    this.url,
    this.thumbUrl,
    this.id,
  });

  Media.fromJson(Map<String, dynamic> json)
      : url = json['url'] as String?,
        thumbUrl = json['thumbUrl'] as String?,
        id = json['_id'] as String?;

  Map<String, dynamic> toJson() => {'url': url, 'thumbUrl': thumbUrl, 'id': id};
}

class Solution {
  final String? solvedBy;
  final String? description;
  final DateTime? date;
  final String? id;

  Solution({
    this.solvedBy,
    this.description,
    this.date,
    this.id,
  });

  Solution.fromJson(Map<String, dynamic> json)
      : solvedBy = json['solvedBy'] as String?,
        description = json['description'] as String?,
        date = json["date"] == null ? null : DateTime.parse(json["date"]).toLocal(),
        id = json['_id'] as String?;

  Map<String, dynamic> toJson() => {'solvedBy': solvedBy, 'description': description, 'date': date, '_id': id};
}
