

import 'package:saarthi_pedagogy_studentapp/model/auth/IntroVideo/introvideo.dart';

class IntroVideoList {
  String? status;
  List<VideoData>? data;

  IntroVideoList({this.status, this.data});

  IntroVideoList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <VideoData>[];
      json['data'].forEach((v) {
        data!.add(VideoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}