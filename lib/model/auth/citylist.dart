// To parse this JSON data, do
//
//     final cityListModel = cityListModelFromJson(jsonString);

import 'dart:convert';

List<CityListModel> cityListModelFromJson(str) => List<CityListModel>.from(str.map((x) => CityListModel.fromJson(x)));

String cityListModelToJson(List<CityListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityListModel {
  CityListModel({
    this.id,
    this.state,
    this.name,
  });

  String? id;
  StateData? state;
  String? name;

  factory CityListModel.fromJson(Map<String, dynamic>? json) => CityListModel(
        id: json?["_id"],
        state: json?["state"] == null ? null : StateData.fromJson(json?["state"]),
        name: json?["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "state": state?.toJson(),
        "name": name,
      };
}

class StateData {
  StateData({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory StateData.fromJson(Map<String, dynamic>? json) => StateData(
        id: json?["_id"],
        name: json?["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
