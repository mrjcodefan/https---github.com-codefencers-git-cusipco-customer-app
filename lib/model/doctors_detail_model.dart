// To parse this JSON data, do
//
//     final doctorDetailsModel = doctorDetailsModelFromJson(jsonString);

import 'dart:convert';

DoctorDetailsModel doctorDetailsModelFromJson(String str) =>
    DoctorDetailsModel.fromJson(json.decode(str));

String doctorDetailsModelToJson(DoctorDetailsModel data) =>
    json.encode(data.toJson());

class DoctorDetailsModel {
  DoctorDetailsModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  Data data;

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) =>
      DoctorDetailsModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.image,
    required this.title,
    required this.speciality,
    required this.licenseId,
    required this.qualification,
    required this.bio,
    required this.rating,
    required this.language,
    required this.charges,
    required this.timing,
    required this.tax,
    required this.payableAmount,
  });

  String id;
  String image;
  String title;
  String speciality;
  String licenseId;
  String qualification;
  String bio;
  String charges;
  String tax;
  String payableAmount;
  String language;
  String rating;
  List<Timing> timing;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        image: json["image"],
        tax: json["tax"],
        payableAmount: json["payable_amount"],
        title: json["title"],
        speciality: json["speciality"],
        licenseId: json["license_id"],
        qualification: json["qualification"],
        bio: json["bio"],
        charges: json["charges"] != null ? json["charges"] : null,
        language: json["language"],
        rating: json["rating"],
        timing:
            List<Timing>.from(json["timing"].map((x) => Timing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "tax": tax,
        "payable_amount": payableAmount,
        "title": title,
        "speciality": speciality,
        "license_id": licenseId,
        "qualification": qualification,
        "charges": charges,
        "bio": bio,
        "language": language,
        "rating": rating,
        "timing": List<dynamic>.from(timing.map((x) => x.toJson())),
      };
}

class Timing {
  Timing({
    required this.slug,
    required this.title,
  });

  String slug;
  String title;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        slug: json["slug"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
      };
}
