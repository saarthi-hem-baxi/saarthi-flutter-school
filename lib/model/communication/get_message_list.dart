import 'dart:convert';

MessageListModel getMessageListFromJson(String str) => MessageListModel.fromJson(json.decode(str));
String getMessageListToJson(MessageListModel data) => json.encode(data.toJson());

class MessageListModel {
  MessageListModel({
    this.status,
    this.data,
    this.total,
    this.page,
    this.limit,
  });

  MessageListModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MessageData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }
  String? status;
  List<MessageData>? data;
  int? total;
  int? page;
  int? limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    return map;
  }
}

MessageData dataFromJson(String str) => MessageData.fromJson(json.decode(str));
String dataToJson(MessageData data) => json.encode(data.toJson());

class MessageData {
  MessageData({
    this.id,
    this.school,
    this.media,
    this.message,
    this.date,
    this.schoolUser,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MessageData.fromJson(dynamic json) {
    id = json['_id'];
    school = json['school'];
    media = json?['media'] != null ? List<MediaData>.from(json?["media"].map((x) => MediaData.fromJson(x))) : [];
    message = json['message'];
    date = json['date'];
    schoolUser = json['schoolUser'] != null ? SchoolUser.fromJson(json['schoolUser']) : null;
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? school;
  List<MediaData>? media;
  String? message;
  String? date;
  SchoolUser? schoolUser;
  String? createdBy;
  String? updatedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['school'] = school;
    map['media'] = media;
    map['message'] = message;
    map['date'] = date;
    if (schoolUser != null) {
      map['schoolUser'] = schoolUser?.toJson();
    }
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

SchoolUser schoolUserFromJson(String str) => SchoolUser.fromJson(json.decode(str));
String schoolUserToJson(SchoolUser data) => json.encode(data.toJson());

class SchoolUser {
  SchoolUser({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
  });

  SchoolUser.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['name'] = name;
    return map;
  }
}

class MediaData {
  MediaData({
    this.url,
    this.thumb,
  });

  String? url;
  String? thumb;

  factory MediaData.fromJson(Map<String, dynamic>? json) => MediaData(
        url: json?["url"],
        thumb: json?["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "thumb": thumb,
      };
}
