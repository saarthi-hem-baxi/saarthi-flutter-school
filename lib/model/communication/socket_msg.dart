// To parse this JSON data, do
//
//     final socketMsgData = socketMsgDataFromJson(jsonString);

import 'dart:convert';

import 'package:saarthi_pedagogy_studentapp/model/communication/get_message_list.dart';

SocketMsgData socketMsgDataFromJson(String str) =>
    SocketMsgData.fromJson(json.decode(str));

String socketMsgDataToJson(SocketMsgData data) => json.encode(data.toJson());

class SocketMsgData {
  SocketMsgData({
    this.message,
    this.media,
    this.date,
    this.name,
    this.room,
  });

  String? message;
  List<MediaData>? media;
  DateTime? date;
  String? name;
  String? room;

  factory SocketMsgData.fromJson(Map<String, dynamic>? json) => SocketMsgData(
        message: json?["message"],
        media: List<MediaData>.from(
            json?["media"]?.map((x) => MediaData.fromJson(x)) ?? []),
        date: json?["date"] == null
            ? null
            : DateTime.parse(json?["date"]).toLocal(),
        name: json?["name"],
        room: json?["room"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "media": List<dynamic>.from(media?.map((x) => x.toJson()) ?? []),
        "date": date?.toLocal().toIso8601String(),
        "name": name,
        "room": room,
      };
}
