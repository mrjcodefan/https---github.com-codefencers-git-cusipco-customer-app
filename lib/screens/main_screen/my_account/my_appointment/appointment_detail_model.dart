// To parse this JSON data, do
//
//     final appointmentDetailsModel = appointmentDetailsModelFromJson(jsonString);

import 'dart:convert';

AppointmentDetailsModel appointmentDetailsModelFromJson(String str) =>
    AppointmentDetailsModel.fromJson(json.decode(str));

String appointmentDetailsModelToJson(AppointmentDetailsModel data) =>
    json.encode(data.toJson());

class AppointmentDetailsModel {
  AppointmentDetailsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  AppointmentDetailData? data;

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailsModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : AppointmentDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class AppointmentDetailData {
  AppointmentDetailData({
    this.id,
    this.image,
    this.title,
    this.subTitle,
    this.date,
    this.time,
    this.status,
    this.modeOfBooking,
    this.meetingUrl,
    this.address,
    this.otp,
    this.ownerId,
    this.itemId,
    this.module,
    this.note,
    this.tax,
    this.prescription,
    this.totalAmount,
    this.isReviewSubmitted,
  });

  String? id;
  String? image;
  String? title;
  String? subTitle;
  String? date;
  String? time;
  String? status;
  String? modeOfBooking;
  String? meetingUrl;
  String? address;
  String? otp;
  String? ownerId;
  String? itemId;
  String? module;
  String? note;
  String? tax;
  String? prescription;
  String? isReviewSubmitted;
  String? totalAmount;

  factory AppointmentDetailData.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailData(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        status: json["status"] == null ? null : json["status"],
        modeOfBooking:
            json["mode_of_booking"] == null ? null : json["mode_of_booking"],
        meetingUrl: json["meeting_url"] == null ? null : json["meeting_url"],
        address: json["address"] == null ? null : json["address"],
        otp: json["otp"] == null ? null : json["otp"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        module: json["module"] == null ? null : json["module"],
        note: json["note"] == null ? null : json["note"],
        tax: json["tax"] == null ? null : json["tax"],
        isReviewSubmitted: json["is_review_submited"] == null
            ? null
            : json["is_review_submited"],
        prescription:
            json["prescription"] == null ? null : json["prescription"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "sub_title": subTitle == null ? null : subTitle,
        "date": date == null ? null : date,
        "total_amount": totalAmount == null ? null : totalAmount,
        "time": time == null ? null : time,
        "status": status == null ? null : status,
        "mode_of_booking": modeOfBooking == null ? null : modeOfBooking,
        "meeting_url": meetingUrl == null ? null : meetingUrl,
        "address": address == null ? null : address,
        "otp": otp == null ? null : otp,
        "owner_id": ownerId == null ? null : ownerId,
        "item_id": itemId == null ? null : itemId,
        "module": module == null ? null : module,
        "note": note == null ? null : note,
        "tax": tax == null ? null : tax,
        "is_review_submited":
            isReviewSubmitted == null ? null : isReviewSubmitted,
        "prescription": prescription == null ? null : prescription,
      };
}
