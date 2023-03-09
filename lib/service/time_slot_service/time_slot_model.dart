// To parse this JSON data, do
//
//     final timingSlotModel = timingSlotModelFromJson(jsonString);

import 'dart:convert';

TimingSlotModel timingSlotModelFromJson(String str) =>
    TimingSlotModel.fromJson(json.decode(str));

String timingSlotModelToJson(TimingSlotModel data) =>
    json.encode(data.toJson());

class TimingSlotModel {
  TimingSlotModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<TimeSlot>? data;

  factory TimingSlotModel.fromJson(Map<String, dynamic> json) =>
      TimingSlotModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TimeSlot>.from(
                json["data"].map((x) => TimeSlot.fromJson(x))),
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

class TimeSlot {
  TimeSlot({
    this.slug,
    this.title,
  });

  String? slug;
  String? title;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        slug: json["slug"] == null ? null : json["slug"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug == null ? null : slug,
        "title": title == null ? null : title,
      };
}
