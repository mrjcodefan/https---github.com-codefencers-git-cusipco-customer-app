// To parse this JSON data, do
//
//     final myRecommandationModel = myRecommandationModelFromJson(jsonString);

import 'dart:convert';

MyRecommandationModel myRecommandationModelFromJson(String str) =>
    MyRecommandationModel.fromJson(json.decode(str));

String myRecommandationModelToJson(MyRecommandationModel data) =>
    json.encode(data.toJson());

class MyRecommandationModel {
  MyRecommandationModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<RecommandationData>? data;

  factory MyRecommandationModel.fromJson(Map<String, dynamic> json) =>
      MyRecommandationModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<RecommandationData>.from(
                json["data"].map((x) => RecommandationData.fromJson(x))),
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

class RecommandationData {
  RecommandationData(
      {this.id,
      this.title,
      this.description,
      this.userId,
      this.type,
      this.typeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.date,
      this.time,
      this.productTitle});

  String? id;
  String? title;
  String? description;
  String? userId;
  String? type;
  String? typeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? date;
  String? time;
  String? productTitle;

  factory RecommandationData.fromJson(Map<String, dynamic> json) =>
      RecommandationData(
        id: json["id"] == null ? null : json["id"].toString(),
        title: json["title"] == null ? null : json["title"].toString(),
        description:
            json["description"] == null ? null : json["description"].toString(),
        userId: json["user_id"] == null ? null : json["user_id"].toString(),
        type: json["type"] == null ? null : json["type"].toString(),
        typeId: json["type_id"] == null ? null : json["type_id"].toString(),
        status: json["status"] == null ? null : json["status"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
        date: json["date"] == null ? null : json["date"].toString(),
        time: json["time"] == null ? null : json["time"].toString(),
        productTitle: json["product_title"] == null
            ? null
            : json["product_title"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "user_id": userId == null ? null : userId,
        "type": type == null ? null : type,
        "type_id": typeId == null ? null : typeId,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
        "product_title": productTitle == null ? null : productTitle,
      };
}
