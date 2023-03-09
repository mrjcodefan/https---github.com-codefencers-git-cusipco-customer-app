// To parse this JSON data, do
//
//     final therapyProductModel = therapyProductModelFromJson(jsonString);

import 'dart:convert';

TherapyProductModel therapyProductModelFromJson(String str) =>
    TherapyProductModel.fromJson(json.decode(str));

String therapyProductModelToJson(TherapyProductModel data) =>
    json.encode(data.toJson());

class TherapyProductModel {
  TherapyProductModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<TherapyProduct>? data;

  factory TherapyProductModel.fromJson(Map<String, dynamic> json) =>
      TherapyProductModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TherapyProduct>.from(
                json["data"].map((x) => TherapyProduct.fromJson(x))),
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

class TherapyProduct {
  TherapyProduct({
    this.id,
    this.image,
    this.title,
    this.owner,
    this.price,
    this.salePrice,
    this.rating,
  });

  String? id;
  String? image;
  String? title;
  String? owner;
  String? price;
  String? salePrice;

  String? rating;

  factory TherapyProduct.fromJson(Map<String, dynamic> json) => TherapyProduct(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        owner: json["owner"] == null ? null : json["owner"],
        price: json["price"] == null ? null : json["price"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        rating: json["rating"] == null ? null : json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "owner": owner == null ? null : owner,
        "price": price == null ? null : price,
        "sale_price": salePrice == null ? null : salePrice,
        "rating": rating == null ? null : rating,
      };
}
