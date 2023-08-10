class TotalTimeSpent {
  String? status;
  Data? data;

  TotalTimeSpent({this.status, this.data});

  TotalTimeSpent.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? totalDuration;
  bool? minutesReached;
  ScreenData? screenData;

  Data({this.totalDuration, this.minutesReached, this.screenData});

  Data.fromJson(Map<String, dynamic> json) {
    totalDuration = json['totalDuration'];
    minutesReached = json['minutesReached'];
    screenData = json['screenData'] != null
        ? ScreenData.fromJson(json['screenData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalDuration'] = totalDuration;
    data['minutesReached'] = minutesReached;
    if (screenData != null) {
      data['screenData'] = screenData!.toJson();
    }
    return data;
  }
}

class ScreenData {
  bool? lEARN;
  bool? sUBJECT;
  bool? cHAPTERLIST;
  bool? rOADMAPLEARN;
  bool? rOADMAPHOMEWORK;

  ScreenData(
      {this.lEARN,
        this.sUBJECT,
        this.cHAPTERLIST,
        this.rOADMAPLEARN,
        this.rOADMAPHOMEWORK});

  ScreenData.fromJson(Map<String, dynamic> json) {
    lEARN = json['LEARN'];
    sUBJECT = json['SUBJECT'];
    cHAPTERLIST = json['CHAPTER LIST'];
    rOADMAPLEARN = json['ROADMAP_LEARN'];
    rOADMAPHOMEWORK = json['ROADMAP_HOMEWORK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LEARN'] = lEARN;
    data['SUBJECT'] = sUBJECT;
    data['CHAPTER LIST'] = cHAPTERLIST;
    data['ROADMAP_LEARN'] = rOADMAPLEARN;
    data['ROADMAP_HOMEWORK'] = rOADMAPHOMEWORK;
    return data;
  }
}