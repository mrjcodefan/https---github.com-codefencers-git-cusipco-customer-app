// To parse this JSON data, do
//
//     final healthRecordModel = healthRecordModelFromJson(jsonString);

import 'dart:convert';

HealthRecordModel healthRecordModelFromJson(String str) =>
    HealthRecordModel.fromJson(json.decode(str));

String healthRecordModelToJson(HealthRecordModel data) =>
    json.encode(data.toJson());

class HealthRecordModel {
  HealthRecordModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<HealthRecordData>? data;

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) =>
      HealthRecordModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<HealthRecordData>.from(
                json["data"].map((x) => HealthRecordData.fromJson(x))),
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

class HealthRecordData {
  HealthRecordData({
    this.id,
    this.userId,
    this.ownerId,
    this.title,
    this.files,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.date,
    this.time,
  });

  String? id;
  String? userId;
  String? ownerId;
  String? title;
  String? files;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? date;
  String? time;

  factory HealthRecordData.fromJson(Map<String, dynamic> json) =>
      HealthRecordData(
        id: json["id"] == null ? null : json["id"].toString(),
        userId: json["user_id"] == null ? null : json["user_id"].toString(),
        ownerId: json["owner_id"] == null ? null : json["owner_id"].toString(),
        title: json["title"] == null ? null : json["title"].toString(),
        files: json["files"] == null ? null : json["files"].toString(),
        status: json["status"] == null ? null : json["status"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
        date: json["date"] == null ? null : json["date"].toString(),
        time: json["time"] == null ? null : json["time"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "owner_id": ownerId == null ? null : ownerId,
        "title": title == null ? null : title,
        "files": files == null ? null : files,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
      };
}
