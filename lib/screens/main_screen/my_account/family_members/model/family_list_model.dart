// To parse this JSON data, do
//
//     final familyListModel = familyListModelFromJson(jsonString);

import 'dart:convert';

FamilyListModel familyListModelFromJson(String str) =>
    FamilyListModel.fromJson(json.decode(str));

String familyListModelToJson(FamilyListModel data) =>
    json.encode(data.toJson());

class FamilyListModel {
  FamilyListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<FamilyData>? data;

  factory FamilyListModel.fromJson(Map<String, dynamic> json) =>
      FamilyListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<FamilyData>.from(
                json["data"].map((x) => FamilyData.fromJson(x))),
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

class FamilyData {
  FamilyData(
      {this.id,
      this.profileImage,
      this.name,
      this.relation,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.dob,
      this.activity,
      this.height,
      this.weight,
      this.age});

  String? id;
  String? profileImage;
  String? name;
  String? relation;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? dob;
  String? age;
  String? height;
  String? weight;
  String? activity;
  factory FamilyData.fromJson(Map<String, dynamic> json) => FamilyData(
        id: json["id"] == null ? null : json["id"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        name: json["name"] == null ? null : json["name"],
        relation: json["relation"] == null ? null : json["relation"],
        email: json["email"] == null ? null : json["email"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        dob: json["dob"] == null ? null : json["dob"],
        age: json["age"] == null ? null : json["age"],
        height: json["height"] == null ? null : json["height"],
        weight: json["weight"] == null ? null : json["weight"],
        activity: json["activity"] == null ? null : json["activity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "profile_image": profileImage == null ? null : profileImage,
        "name": name == null ? null : name,
        "relation": relation == null ? null : relation,
        "email": email == null ? null : email,
        "country_code": countryCode == null ? null : countryCode,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "activity": activity == null ? null : activity,
        "dob": dob == null ? null : dob,
        "age": age == null ? null : age,
        "height": height == null ? null : height,
        "weight": weight == null ? null : weight,
      };
}
