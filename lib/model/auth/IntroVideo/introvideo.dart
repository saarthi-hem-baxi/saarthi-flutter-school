
class IntroVideo {
  String? status;
  VideoData? data;

  IntroVideo({this.status, this.data});

  IntroVideo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? VideoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VideoData {
  String? sId;
  String? feature;
  List<String>? screen;
  String? tourCode;
  String? createdBy;
  String? updatedBy;
  String? status;
  List<Videos>? videos;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  VideoData(
      {this.sId,
        this.feature,
        this.screen,
        this.tourCode,
        this.createdBy,
        this.updatedBy,
        this.status,
        this.videos,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  VideoData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    feature = json['feature'];
    screen = json['screen'].cast<String>();
    tourCode = json['tourCode'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['feature'] = feature;
    data['screen'] = screen;
    data['tourCode'] = tourCode;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['status'] = status;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['id'] = id;
    return data;
  }
}

class Videos {
  Url? url;
  Url? thumb;
  List<String>? lang;
  Url? type;
  String? sId;

  Videos({this.url, this.thumb, this.lang, this.type, this.sId});

  Videos.fromJson(Map<String, dynamic> json) {
    url = json['url'] != null ? Url.fromJson(json['url']) : null;
    thumb = json['thumb'] != null ? Url.fromJson(json['thumb']) : null;
    lang = json['lang'].cast<String>();
    type = json['type'] != null ? Url.fromJson(json['type']) : null;
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (url != null) {
      data['url'] = url!.toJson();
    }
    if (thumb != null) {
      data['thumb'] = thumb!.toJson();
    }
    data['lang'] = lang;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    data['_id'] = sId;
    return data;
  }
}

class Url {
  String? enUS;
  String? hiIN;

  Url({this.enUS, this.hiIN});

  Url.fromJson(Map<String, dynamic> json) {
    enUS = json['en_US'];
    hiIN = json['hi_IN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en_US'] = enUS;
    data['hi_IN'] = hiIN;
    return data;
  }
}
// class IntroVideo {
//   String? status;
//   IntroVideodata? data;
//
//   IntroVideo({this.status, this.data});
//
//   // @override
//   // String toString() => 'IntroVideo(status: $status, data: $data)';
//
//   factory IntroVideo.fromMap(Map<String, dynamic> data) => IntroVideo(
//         status: data['status'] as String?,
//         data: data['data'] == null
//             ? null
//             : IntroVideodata.fromMap(data['data'] as Map<String, dynamic>),
//       );
//
//   Map<String, dynamic> toMap() => {
//         'status': status,
//         'data': data?.toMap(),
//       };
//
//   /// `dart:convert`
//   ///
//   /// Parses the string and returns the resulting Json object as [Lessplan].
//   factory IntroVideo.fromJson(String data) {
//     return IntroVideo.fromMap(json.decode(data) as Map<String, dynamic>);
//   }
//
//   /// `dart:convert`
//   ///
//   /// Converts [Lessplan] to a JSON string.
//   String toJson() => json.encode(toMap());
// }
