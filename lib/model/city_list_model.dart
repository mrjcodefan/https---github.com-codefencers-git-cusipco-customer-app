// To parse this JSON data, do
//
//     final cityList = cityListFromJson(jsonString);

import 'dart:convert';

CityList cityListFromJson(String str) => CityList.fromJson(json.decode(str));

String cityListToJson(CityList data) => json.encode(data.toJson());

class CityListModel {
  CityListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<CityList>? data;

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<CityList>.from(
                json["data"].map((x) => CityList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CityList {
  CityList({
    this.id,
    this.name,
    this.stateId,
  });

  String? id;
  String? name;
  String? stateId;

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        stateId: json["state_id"] == null ? null : json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "state_id": stateId == null ? null : stateId,
      };
}
