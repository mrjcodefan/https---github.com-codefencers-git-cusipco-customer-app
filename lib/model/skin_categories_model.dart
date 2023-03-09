// To parse this JSON data, do
//
//     final skinCategoriesModel = skinCategoriesModelFromJson(jsonString);

import 'dart:convert';

SkinCategoriesModel skinCategoriesModelFromJson(String str) => SkinCategoriesModel.fromJson(json.decode(str));

String skinCategoriesModelToJson(SkinCategoriesModel data) => json.encode(data.toJson());

class SkinCategoriesModel {
    SkinCategoriesModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    String? success;
    String? status;
    String? message;
    List<Datum>? data;

    factory SkinCategoriesModel.fromJson(Map<String, dynamic> json) => SkinCategoriesModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.title,
        this.image,
        this.status,
    });

    String? id;
    String? title;
    String? image;
    String? status;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "status": status,
    };
}
