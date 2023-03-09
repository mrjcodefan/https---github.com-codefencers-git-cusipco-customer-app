// To parse this JSON data, do
//
//     final couponListModel = couponListModelFromJson(jsonString);

import 'dart:convert';

CouponListModel couponListModelFromJson(String str) =>
    CouponListModel.fromJson(json.decode(str));

String couponListModelToJson(CouponListModel data) =>
    json.encode(data.toJson());

class CouponListModel {
  CouponListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<CouponData>? data;

  factory CouponListModel.fromJson(Map<String, dynamic> json) =>
      CouponListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CouponData>.from(
                json["data"].map((x) => CouponData.fromJson(x))),
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

class CouponData {
  CouponData({
    this.id,
    this.image,
    this.title,
    this.code,
    this.description,
    this.discount,
    this.discountType,
    this.startDate,
    this.endDate,
    this.status,
  });

  String? id;
  String? image;
  String? title;
  String? code;
  String? description;
  String? discount;
  String? discountType;
  String? startDate;
  String? endDate;
  String? status;

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        code: json["code"] == null ? null : json["code"],
        description: json["description"] == null ? null : json["description"],
        discount: json["discount"] == null ? null : json["discount"],
        discountType:
            json["discount_type"] == null ? null : json["discount_type"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        endDate: json["end_date"] == null ? null : json["end_date"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "code": code == null ? null : code,
        "description": description == null ? null : description,
        "discount": discount == null ? null : discount,
        "discount_type": discountType == null ? null : discountType,
        "start_date": startDate == null ? null : startDate,
        "end_date": endDate == null ? null : endDate,
        "status": status == null ? null : status,
      };
}
