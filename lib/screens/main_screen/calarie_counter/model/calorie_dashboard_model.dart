// To parse this JSON data, do
//
//     final calorieDashboardModel = calorieDashboardModelFromJson(jsonString);

import 'dart:convert';

CalorieDashboardModel calorieDashboardModelFromJson(String str) =>
    CalorieDashboardModel.fromJson(json.decode(str));

String calorieDashboardModelToJson(CalorieDashboardModel data) =>
    json.encode(data.toJson());

class CalorieDashboardModel {
  CalorieDashboardModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  CalorieDashboardData? data;

  factory CalorieDashboardModel.fromJson(Map<String, dynamic> json) =>
      CalorieDashboardModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : CalorieDashboardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class CalorieDashboardData {
  CalorieDashboardData({
    this.caloriesEaten,
    this.list,
  });

  String? caloriesEaten;
  List<ListElement>? list;

  factory CalorieDashboardData.fromJson(Map<String?, dynamic> json) =>
      CalorieDashboardData(
        caloriesEaten:
            json["calories_eaten"] == null ? null : json["calories_eaten"],
        list: json["list"] == null
            ? null
            : List<ListElement>.from(
                json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "calories_eaten": caloriesEaten == null ? null : caloriesEaten,
        "list": list == null
            ? null
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.slug,
    this.title,
    this.value,
  });

  String? slug;
  String? title;
  String? value;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        slug: json["slug"] == null ? null : json["slug"],
        title: json["title"] == null ? null : json["title"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug == null ? null : slug,
        "title": title == null ? null : title,
        "value": value == null ? null : value,
      };
}
