// To parse this JSON data, do
//
//     final doctorListModel = doctorListModelFromJson(jsonString);

import 'dart:convert';

DoctorListModel doctorListModelFromJson(String str) =>
    DoctorListModel.fromJson(json.decode(str));

String doctorListModelToJson(DoctorListModel data) =>
    json.encode(data.toJson());

class DoctorListModel {
  DoctorListModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  List<DoctorData> data;

  factory DoctorListModel.fromJson(Map<String, dynamic> json) =>
      DoctorListModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<DoctorData>.from(
            json["data"].map((x) => DoctorData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DoctorData {
  DoctorData({
    required this.id,
    required this.image,
    required this.title,
    required this.qualification,
    required this.rating,
  });

  String id;
  String image;
  String title;
  String qualification;
  String rating;

  factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        qualification: json["qualification"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "qualification": qualification,
        "rating": rating,
      };
}
