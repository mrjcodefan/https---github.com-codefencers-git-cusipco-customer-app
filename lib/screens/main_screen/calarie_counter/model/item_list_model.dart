// To parse this JSON data, do
//
//     final calorieItemListModel = calorieItemListModelFromJson(jsonString);

import 'dart:convert';

CalorieItemListModel calorieItemListModelFromJson(String str) =>
    CalorieItemListModel.fromJson(json.decode(str));

String calorieItemListModelToJson(CalorieItemListModel data) =>
    json.encode(data.toJson());

class CalorieItemListModel {
  CalorieItemListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<CalorieItem>? data;

  factory CalorieItemListModel.fromJson(Map<String, dynamic> json) =>
      CalorieItemListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CalorieItem>.from(
                json["data"].map((x) => CalorieItem.fromJson(x))),
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

class CalorieItem {
  CalorieItem({
    this.id,
    this.calorieCategory,
    this.title,
    this.subTitle,
    this.count,
  });

  String? id;
  String? calorieCategory;
  String? title;
  String? subTitle;
  String? count;

  factory CalorieItem.fromJson(Map<String, dynamic> json) => CalorieItem(
        id: json["id"] == null ? null : json["id"],
        calorieCategory:
            json["calorie_category"] == null ? null : json["calorie_category"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "calorie_category": calorieCategory == null ? null : calorieCategory,
        "title": title == null ? null : title,
        "sub_title": subTitle == null ? null : subTitle,
        "count": count == null ? null : count,
      };
}
