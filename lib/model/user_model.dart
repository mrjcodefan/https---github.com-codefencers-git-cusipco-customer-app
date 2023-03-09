// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  UserData? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"].toString(),
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class UserData {
  UserData({
    this.token,
    this.id,
    this.name,
    this.profileImage,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.age,
    this.height,
    this.activity,
    this.weight,
    this.status,
    this.userType,
  });

  String? token;
  String? id;
  String? name;
  String? profileImage;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? gender;
  String? dob;
  String? height;
  String? weight;
  String? activity;
  String? age;
  String? status;
  String? userType;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        token: json["token"] == null ? null : json["token"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        email: json["email"] == null ? null : json["email"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        gender: json["gender"] == null ? null : json["gender"],
        dob: json["dob"] == null ? null : json["dob"],
        age: json["age"] == null ? null : json["age"],
        height: json["height"] == null ? null : json["height"],
        activity: json["activity"] == null ? null : json["activity"],
        weight: json["weight"] == null ? null : json["weight"],
        status: json["status"] == null ? null : json["status"],
        userType: json["user_type"] == null ? null : json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "profile_image": profileImage == null ? null : profileImage,
        "email": email == null ? null : email,
        "country_code": countryCode == null ? null : countryCode,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "gender": gender == null ? null : gender,
        "dob": dob == null ? null : dob,
        "age": age == null ? null : age,
        "weight": weight == null ? null : weight,
        "height": height == null ? null : height,
        "activity": activity == null ? null : activity,
        "status": status == null ? null : status,
        "user_type": userType == null ? null : userType,
      }..removeWhere((key, value) => value == null);
}
