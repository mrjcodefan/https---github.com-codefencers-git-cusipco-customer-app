// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<SliderData>? data;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<SliderData>.from(
                json["data"].map((x) => SliderData.fromJson(x))),
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

class SliderData {
  SliderData({
    this.id,
    this.title,
    this.tagline,
    this.image,
    this.isClickable,
    this.redirectTo,
    this.buttonText,
    this.description,
  });

  String? id;
  String? title;
  String? tagline;
  String? image;
  String? isClickable;
  String? redirectTo;
  String? buttonText;
  String? description;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        tagline: json["tagline"] == null ? null : json["tagline"],
        image: json["image"] == null ? null : json["image"],
        isClickable: json["is_clickable"] == null ? null : json["is_clickable"],
        redirectTo: json["redirect_to"] == null ? null : json["redirect_to"],
        buttonText: json["button_text"] == null ? null : json["button_text"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "tagline": tagline == null ? null : tagline,
        "image": image == null ? null : image,
        "is_clickable": isClickable == null ? null : isClickable,
        "redirect_to": redirectTo == null ? null : redirectTo,
        "button_text": buttonText == null ? null : buttonText,
        "description": description == null ? null : description,
      };
}
