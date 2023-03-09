// To parse this JSON data, do
//
//     final getAppoModel = getAppoModelFromJson(jsonString);

import 'dart:convert';

GetAppoModel getAppoModelFromJson(String str) =>
    GetAppoModel.fromJson(json.decode(str));

String getAppoModelToJson(GetAppoModel data) => json.encode(data.toJson());

class GetAppoModel {
  GetAppoModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  List<AppoData> data;

  factory GetAppoModel.fromJson(Map<String, dynamic> json) => GetAppoModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data:
            List<AppoData>.from(json["data"].map((x) => AppoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AppoData {
  AppoData({
    required this.id,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.time,
    required this.isReviewSubmited,
    required this.status,
  });

  String id;
  String image;
  bool isReviewSubmited;
  String title;
  String subTitle;
  String date;
  String time;
  String status;

  factory AppoData.fromJson(Map<String, dynamic> json) => AppoData(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        subTitle: json["sub_title"],
        isReviewSubmited: json["is_review_submited"] == null
            ? false
            : json["is_review_submited"] == "1"
                ? true
                : false,
        date: json["date"],
        time: json["time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "is_review_submited": isReviewSubmited,
        "title": title,
        "sub_title": subTitle,
        "date": date,
        "time": time,
        "status": status,
      };
}
