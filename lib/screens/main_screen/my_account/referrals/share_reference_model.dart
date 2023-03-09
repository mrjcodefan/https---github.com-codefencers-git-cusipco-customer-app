// To parse this JSON data, do
//
//     final shareReferenceModel = shareReferenceModelFromJson(jsonString);

import 'dart:convert';

ShareReferenceModel shareReferenceModelFromJson(String str) =>
    ShareReferenceModel.fromJson(json.decode(str));

String shareReferenceModelToJson(ShareReferenceModel data) =>
    json.encode(data.toJson());

class ShareReferenceModel {
  ShareReferenceModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  ShareAndReferralsData? data;

  factory ShareReferenceModel.fromJson(Map<String, dynamic> json) =>
      ShareReferenceModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : ShareAndReferralsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class ShareAndReferralsData {
  ShareAndReferralsData({
    this.code,
    this.title,
  });

  String? code;
  String? title;

  factory ShareAndReferralsData.fromJson(Map<String, dynamic> json) =>
      ShareAndReferralsData(
        code: json["code"] == null ? null : json["code"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "title": title == null ? null : title,
      };
}
