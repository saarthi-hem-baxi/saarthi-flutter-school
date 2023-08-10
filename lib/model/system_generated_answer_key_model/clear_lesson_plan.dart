class ClearLessonPlan {
  final String? status;
  final Data? data;

  ClearLessonPlan({
    this.status,
    this.data,
  });

  ClearLessonPlan.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}

class Data {
  final List<LessonPlans>? lessonPlans;
  final String? lang;

  Data({
    this.lessonPlans,
    this.lang,
  });

  Data.fromJson(Map<String, dynamic> json)
      : lessonPlans = (json['lessonPlans'] as List?)?.map((dynamic e) => LessonPlans.fromJson(e as Map<String, dynamic>)).toList(),
        lang = json['lang'] as String?;

  Map<String, dynamic> toJson() => {'lessonPlans': lessonPlans?.map((e) => e.toJson()).toList(), 'lang': lang};
}

class LessonPlans {
  final StudentInstruction? studentInstruction;
  final TeacherInstruction? teacherInstruction;
  final Verify? verify;
  final GrammarVerify? grammarVerify;
  final ContentVerify? contentVerify;
  final TagsVerify? tagsVerify;
  final String? id;
  final List<String>? lang;
  final List<String>? concepts;
  final bool? forStudent;
  final bool? forTeacher;
  final List<String>? contentTypes;
  final List<String>? tags;
  final List<Descriptions>? descriptions;
  final List<Videos>? videos;
  final List<Images>? images;
  final List<Pdfs>? pdfs;
  final List<Documents>? documents;
  final List<Audio>? audio;
  final List<Examples>? examples;
  final List<Simulations>? simulations;
  final List<Links>? links;
  final List<Words>? words;
  final bool? isPublisher;
  final List<String>? tagsSlug;
  final String? createdBy;
  final String? updatedBy;
  final String? status;
  final List<dynamic>? topics;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? id_;

  LessonPlans({
    this.studentInstruction,
    this.teacherInstruction,
    this.verify,
    this.grammarVerify,
    this.contentVerify,
    this.tagsVerify,
    this.id,
    this.lang,
    this.concepts,
    this.forStudent,
    this.forTeacher,
    this.contentTypes,
    this.tags,
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
    this.tagsSlug,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.topics,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.id_,
  });

  LessonPlans.fromJson(Map<String, dynamic> json)
      : studentInstruction = (json['studentInstruction'] as Map<String, dynamic>?) != null
            ? StudentInstruction.fromJson(json['studentInstruction'] as Map<String, dynamic>)
            : null,
        teacherInstruction = (json['teacherInstruction'] as Map<String, dynamic>?) != null
            ? TeacherInstruction.fromJson(json['teacherInstruction'] as Map<String, dynamic>)
            : null,
        verify = (json['verify'] as Map<String, dynamic>?) != null ? Verify.fromJson(json['verify'] as Map<String, dynamic>) : null,
        grammarVerify =
            (json['grammarVerify'] as Map<String, dynamic>?) != null ? GrammarVerify.fromJson(json['grammarVerify'] as Map<String, dynamic>) : null,
        contentVerify =
            (json['contentVerify'] as Map<String, dynamic>?) != null ? ContentVerify.fromJson(json['contentVerify'] as Map<String, dynamic>) : null,
        tagsVerify = (json['tagsVerify'] as Map<String, dynamic>?) != null ? TagsVerify.fromJson(json['tagsVerify'] as Map<String, dynamic>) : null,
        id = json['_id'] as String?,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        forStudent = json['forStudent'] as bool?,
        forTeacher = json['forTeacher'] as bool?,
        contentTypes = (json['contentTypes'] as List?)?.map((dynamic e) => e as String).toList(),
        tags = (json['tags'] as List?)?.map((dynamic e) => e as String).toList(),
        descriptions = (json['descriptions'] as List?)?.map((dynamic e) => Descriptions.fromJson(e as Map<String, dynamic>)).toList(),
        videos = (json['videos'] as List?)?.map((dynamic e) => Videos.fromJson(e as Map<String, dynamic>)).toList(),
        images = (json['images'] as List?)?.map((dynamic e) => Images.fromJson(e as Map<String, dynamic>)).toList(),
        pdfs = (json['pdfs'] as List?)?.map((dynamic e) => Pdfs.fromJson(e as Map<String, dynamic>)).toList(),
        documents = (json['documents'] as List?)?.map((dynamic e) => Documents.fromJson(e as Map<String, dynamic>)).toList(),
        audio = (json['audio'] as List?)?.map((dynamic e) => Audio.fromJson(e as Map<String, dynamic>)).toList(),
        examples = (json['examples'] as List?)?.map((dynamic e) => Examples.fromJson(e as Map<String, dynamic>)).toList(),
        simulations = (json['simulations'] as List?)?.map((dynamic e) => Simulations.fromJson(e as Map<String, dynamic>)).toList(),
        links = (json['links'] as List?)?.map((dynamic e) => Links.fromJson(e as Map<String, dynamic>)).toList(),
        words = (json['words'] as List?)?.map((dynamic e) => Words.fromJson(e as Map<String, dynamic>)).toList(),
        isPublisher = json['isPublisher'] as bool?,
        tagsSlug = (json['tagsSlug'] as List?)?.map((dynamic e) => e as String).toList(),
        createdBy = json['createdBy'] as String?,
        updatedBy = json['updatedBy'] as String?,
        status = json['status'] as String?,
        topics = json['topics'] as List?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?,
        id_ = json['id'] as String?;

  Map<String, dynamic> toJson() => {
        'studentInstruction': studentInstruction?.toJson(),
        'teacherInstruction': teacherInstruction?.toJson(),
        'verify': verify?.toJson(),
        'grammarVerify': grammarVerify?.toJson(),
        'contentVerify': contentVerify?.toJson(),
        'tagsVerify': tagsVerify?.toJson(),
        '_id': id,
        'lang': lang,
        'concepts': concepts,
        'forStudent': forStudent,
        'forTeacher': forTeacher,
        'contentTypes': contentTypes,
        'tags': tags,
        'descriptions': descriptions?.map((e) => e.toJson()).toList(),
        'videos': videos?.map((e) => e.toJson()).toList(),
        'images': images?.map((e) => e.toJson()).toList(),
        'pdfs': pdfs?.map((e) => e.toJson()).toList(),
        'documents': documents?.map((e) => e.toJson()).toList(),
        'audio': audio?.map((e) => e.toJson()).toList(),
        'examples': examples?.map((e) => e.toJson()).toList(),
        'simulations': simulations?.map((e) => e.toJson()).toList(),
        'links': links?.map((e) => e.toJson()).toList(),
        'words': words?.map((e) => e.toJson()).toList(),
        'isPublisher': isPublisher,
        'tagsSlug': tagsSlug,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'status': status,
        'topics': topics,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'id': id_
      };
}

class StudentInstruction {
  final String? enUS;

  StudentInstruction({
    this.enUS,
  });

  StudentInstruction.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TeacherInstruction {
  final String? enUS;

  TeacherInstruction({
    this.enUS,
  });

  TeacherInstruction.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Verify {
  final bool? verified;
  final String? verifiedBy;
  final String? verifiedAt;

  Verify({
    this.verified,
    this.verifiedBy,
    this.verifiedAt,
  });

  Verify.fromJson(Map<String, dynamic> json)
      : verified = json['verified'] as bool?,
        verifiedBy = json['verifiedBy'] as String?,
        verifiedAt = json['verifiedAt'] as String?;

  Map<String, dynamic> toJson() => {'verified': verified, 'verifiedBy': verifiedBy, 'verifiedAt': verifiedAt};
}

class GrammarVerify {
  final bool? verified;
  final String? verifiedBy;
  final String? verifiedAt;

  GrammarVerify({
    this.verified,
    this.verifiedBy,
    this.verifiedAt,
  });

  GrammarVerify.fromJson(Map<String, dynamic> json)
      : verified = json['verified'] as bool?,
        verifiedBy = json['verifiedBy'] as String?,
        verifiedAt = json['verifiedAt'] as String?;

  Map<String, dynamic> toJson() => {'verified': verified, 'verifiedBy': verifiedBy, 'verifiedAt': verifiedAt};
}

class ContentVerify {
  final bool? verified;
  final String? verifiedBy;
  final String? verifiedAt;

  ContentVerify({
    this.verified,
    this.verifiedBy,
    this.verifiedAt,
  });

  ContentVerify.fromJson(Map<String, dynamic> json)
      : verified = json['verified'] as bool?,
        verifiedBy = json['verifiedBy'] as String?,
        verifiedAt = json['verifiedAt'] as String?;

  Map<String, dynamic> toJson() => {'verified': verified, 'verifiedBy': verifiedBy, 'verifiedAt': verifiedAt};
}

class TagsVerify {
  final bool? verified;
  final String? verifiedBy;
  final String? verifiedAt;

  TagsVerify({
    this.verified,
    this.verifiedBy,
    this.verifiedAt,
  });

  TagsVerify.fromJson(Map<String, dynamic> json)
      : verified = json['verified'] as bool?,
        verifiedBy = json['verifiedBy'] as String?,
        verifiedAt = json['verifiedAt'] as String?;

  Map<String, dynamic> toJson() => {'verified': verified, 'verifiedBy': verifiedBy, 'verifiedAt': verifiedAt};
}

class Descriptions {
  final Description? description;
  final List<String>? lang;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Descriptions({
    this.description,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Descriptions.fromJson(Map<String, dynamic> json)
      : description =
            (json['description'] as Map<String, dynamic>?) != null ? Description.fromJson(json['description'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'description': description?.toJson(),
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class Description {
  final String? enUS;

  Description({
    this.enUS,
  });

  Description.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Videos {
  final Name? name;
  final Url? url;
  final Thumb? thumb;
  final StartTime? startTime;
  final EndTime? endTime;
  final List<String>? lang;
  final Type? type;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Videos({
    this.name,
    this.url,
    this.thumb,
    this.startTime,
    this.endTime,
    this.lang,
    this.type,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Videos.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? Name.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? Url.fromJson(json['url'] as Map<String, dynamic>) : null,
        thumb = (json['thumb'] as Map<String, dynamic>?) != null ? Thumb.fromJson(json['thumb'] as Map<String, dynamic>) : null,
        startTime = (json['startTime'] as Map<String, dynamic>?) != null ? StartTime.fromJson(json['startTime'] as Map<String, dynamic>) : null,
        endTime = (json['endTime'] as Map<String, dynamic>?) != null ? EndTime.fromJson(json['endTime'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        type = (json['type'] as Map<String, dynamic>?) != null ? Type.fromJson(json['type'] as Map<String, dynamic>) : null,
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'thumb': thumb?.toJson(),
        'startTime': startTime?.toJson(),
        'endTime': endTime?.toJson(),
        'lang': lang,
        'type': type?.toJson(),
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class Name {
  final String? enUS;

  Name({
    this.enUS,
  });

  Name.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Url {
  final String? enUS;

  Url({
    this.enUS,
  });

  Url.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Thumb {
  final String? enUS;

  Thumb({
    this.enUS,
  });

  Thumb.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class StartTime {
  final String? enUS;
  final String? hiIN;
  final String? guIN;

  StartTime({
    this.enUS,
    this.hiIN,
    this.guIN,
  });

  StartTime.fromJson(Map<String, dynamic> json)
      : enUS = json['en_US'] as String?,
        hiIN = json['hi_IN'] as String?,
        guIN = json['gu_IN'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS, 'hi_IN': hiIN, 'gu_IN': guIN};
}

class EndTime {
  final String? enUS;
  final String? hiIN;
  final String? guIN;

  EndTime({
    this.enUS,
    this.hiIN,
    this.guIN,
  });

  EndTime.fromJson(Map<String, dynamic> json)
      : enUS = json['en_US'] as String?,
        hiIN = json['hi_IN'] as String?,
        guIN = json['gu_IN'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS, 'hi_IN': hiIN, 'gu_IN': guIN};
}

class Type {
  final String? enUS;

  Type({
    this.enUS,
  });

  Type.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Images {
  final NameImages? name;
  final UrlImages? url;
  final ThumbImages? thumb;
  final List<String>? lang;
  final TypeImages? type;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Images({
    this.name,
    this.url,
    this.thumb,
    this.lang,
    this.type,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Images.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameImages.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlImages.fromJson(json['url'] as Map<String, dynamic>) : null,
        thumb = (json['thumb'] as Map<String, dynamic>?) != null ? ThumbImages.fromJson(json['thumb'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        type = (json['type'] as Map<String, dynamic>?) != null ? TypeImages.fromJson(json['type'] as Map<String, dynamic>) : null,
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'thumb': thumb?.toJson(),
        'lang': lang,
        'type': type?.toJson(),
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NameImages {
  final String? enUS;

  NameImages({
    this.enUS,
  });

  NameImages.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlImages {
  final String? enUS;

  UrlImages({
    this.enUS,
  });

  UrlImages.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class ThumbImages {
  final String? enUS;

  ThumbImages({
    this.enUS,
  });

  ThumbImages.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TypeImages {
  final String? enUS;

  TypeImages({
    this.enUS,
  });

  TypeImages.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Pdfs {
  final NamePdfs? name;
  final UrlPdfs? url;
  final List<String>? lang;
  final TypePdfs? type;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Pdfs({
    this.name,
    this.url,
    this.lang,
    this.type,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Pdfs.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NamePdfs.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlPdfs.fromJson(json['url'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        type = (json['type'] as Map<String, dynamic>?) != null ? TypePdfs.fromJson(json['type'] as Map<String, dynamic>) : null,
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'lang': lang,
        'type': type?.toJson(),
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NamePdfs {
  final String? enUS;

  NamePdfs({
    this.enUS,
  });

  NamePdfs.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlPdfs {
  final String? enUS;

  UrlPdfs({
    this.enUS,
  });

  UrlPdfs.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TypePdfs {
  final String? enUS;

  TypePdfs({
    this.enUS,
  });

  TypePdfs.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Documents {
  final NameDocuments? name;
  final UrlDocuments? url;
  final List<String>? lang;
  final TypeDocuments? type;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Documents({
    this.name,
    this.url,
    this.lang,
    this.type,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Documents.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameDocuments.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlDocuments.fromJson(json['url'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        type = (json['type'] as Map<String, dynamic>?) != null ? TypeDocuments.fromJson(json['type'] as Map<String, dynamic>) : null,
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'lang': lang,
        'type': type?.toJson(),
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NameDocuments {
  final String? enUS;

  NameDocuments({
    this.enUS,
  });

  NameDocuments.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlDocuments {
  final String? enUS;

  UrlDocuments({
    this.enUS,
  });

  UrlDocuments.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TypeDocuments {
  final String? enUS;

  TypeDocuments({
    this.enUS,
  });

  TypeDocuments.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Audio {
  final NameAudio? name;
  final UrlAudio? url;
  final List<String>? lang;
  final TypeAudio? type;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Audio({
    this.name,
    this.url,
    this.lang,
    this.type,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Audio.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameAudio.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlAudio.fromJson(json['url'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        type = (json['type'] as Map<String, dynamic>?) != null ? TypeAudio.fromJson(json['type'] as Map<String, dynamic>) : null,
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'lang': lang,
        'type': type?.toJson(),
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NameAudio {
  final String? enUS;

  NameAudio({
    this.enUS,
  });

  NameAudio.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlAudio {
  final String? enUS;

  UrlAudio({
    this.enUS,
  });

  UrlAudio.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TypeAudio {
  final String? enUS;

  TypeAudio({
    this.enUS,
  });

  TypeAudio.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Examples {
  final DescriptionExamples? description;
  final List<String>? lang;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Examples({
    this.description,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Examples.fromJson(Map<String, dynamic> json)
      : description =
            (json['description'] as Map<String, dynamic>?) != null ? DescriptionExamples.fromJson(json['description'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'description': description?.toJson(),
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class DescriptionExamples {
  final String? enUS;

  DescriptionExamples({
    this.enUS,
  });

  DescriptionExamples.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Simulations {
  final NameSimulations? name;
  final UrlSimulations? url;
  final List<String>? lang;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Simulations({
    this.name,
    this.url,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Simulations.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameSimulations.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlSimulations.fromJson(json['url'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NameSimulations {
  final String? enUS;

  NameSimulations({
    this.enUS,
  });

  NameSimulations.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlSimulations {
  final String? enUS;

  UrlSimulations({
    this.enUS,
  });

  UrlSimulations.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Links {
  final NameLinks? name;
  final UrlLinks? url;
  final List<String>? lang;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final String? id;
  final List<dynamic>? topics;

  Links({
    this.name,
    this.url,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.id,
    this.topics,
  });

  Links.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameLinks.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlLinks.fromJson(json['url'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'name': name?.toJson(),
        'url': url?.toJson(),
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        '_id': id,
        'topics': topics
      };
}

class NameLinks {
  final String? enUS;

  NameLinks({
    this.enUS,
  });

  NameLinks.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlLinks {
  final String? enUS;

  UrlLinks({
    this.enUS,
  });

  UrlLinks.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Words {
  final Word? word;
  final Meaning? meaning;
  final List<String>? lang;
  final List<String>? contentCategory;
  final List<String>? concepts;
  final List<String>? keyLearnings;
  final List<Media>? media;
  final String? id;
  final List<dynamic>? topics;

  Words({
    this.word,
    this.meaning,
    this.lang,
    this.contentCategory,
    this.concepts,
    this.keyLearnings,
    this.media,
    this.id,
    this.topics,
  });

  Words.fromJson(Map<String, dynamic> json)
      : word = (json['word'] as Map<String, dynamic>?) != null ? Word.fromJson(json['word'] as Map<String, dynamic>) : null,
        meaning = (json['meaning'] as Map<String, dynamic>?) != null ? Meaning.fromJson(json['meaning'] as Map<String, dynamic>) : null,
        lang = (json['lang'] as List?)?.map((dynamic e) => e as String).toList(),
        contentCategory = (json['contentCategory'] as List?)?.map((dynamic e) => e as String).toList(),
        concepts = (json['concepts'] as List?)?.map((dynamic e) => e as String).toList(),
        keyLearnings = (json['keyLearnings'] as List?)?.map((dynamic e) => e as String).toList(),
        media = (json['media'] as List?)?.map((dynamic e) => Media.fromJson(e as Map<String, dynamic>)).toList(),
        id = json['_id'] as String?,
        topics = json['topics'] as List?;

  Map<String, dynamic> toJson() => {
        'word': word?.toJson(),
        'meaning': meaning?.toJson(),
        'lang': lang,
        'contentCategory': contentCategory,
        'concepts': concepts,
        'keyLearnings': keyLearnings,
        'media': media?.map((e) => e.toJson()).toList(),
        '_id': id,
        'topics': topics
      };
}

class Word {
  final String? enUS;

  Word({
    this.enUS,
  });

  Word.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Meaning {
  final String? enUS;

  Meaning({
    this.enUS,
  });

  Meaning.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class Media {
  final NameMedia? name;
  final UrlMedia? url;
  final ThumbMedia? thumb;
  final TypeMedia? type;
  final String? uniqueId;
  final String? id;

  Media({
    this.name,
    this.url,
    this.thumb,
    this.type,
    this.uniqueId,
    this.id,
  });

  Media.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as Map<String, dynamic>?) != null ? NameMedia.fromJson(json['name'] as Map<String, dynamic>) : null,
        url = (json['url'] as Map<String, dynamic>?) != null ? UrlMedia.fromJson(json['url'] as Map<String, dynamic>) : null,
        thumb = (json['thumb'] as Map<String, dynamic>?) != null ? ThumbMedia.fromJson(json['thumb'] as Map<String, dynamic>) : null,
        type = (json['type'] as Map<String, dynamic>?) != null ? TypeMedia.fromJson(json['type'] as Map<String, dynamic>) : null,
        uniqueId = json['uniqueId'] as String?,
        id = json['_id'] as String?;

  Map<String, dynamic> toJson() =>
      {'name': name?.toJson(), 'url': url?.toJson(), 'thumb': thumb?.toJson(), 'type': type?.toJson(), 'uniqueId': uniqueId, '_id': id};
}

class NameMedia {
  final String? enUS;

  NameMedia({
    this.enUS,
  });

  NameMedia.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class UrlMedia {
  final String? enUS;

  UrlMedia({
    this.enUS,
  });

  UrlMedia.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class ThumbMedia {
  final String? enUS;

  ThumbMedia({
    this.enUS,
  });

  ThumbMedia.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}

class TypeMedia {
  final String? enUS;

  TypeMedia({
    this.enUS,
  });

  TypeMedia.fromJson(Map<String, dynamic> json) : enUS = json['en_US'] as String?;

  Map<String, dynamic> toJson() => {'en_US': enUS};
}
