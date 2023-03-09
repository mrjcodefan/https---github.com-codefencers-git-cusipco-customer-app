// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<ProductData>? data;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ProductData>.from(
                json["data"].map((x) => ProductData.fromJson(x))),
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

class ProductData {
  ProductData({
    this.id,
    this.title,
    this.subTitle,
    this.price,
    this.rating,
    this.image,
  });

  String? id;
  String? title;
  String? subTitle;
  String? price;
  String? rating;
  String? image;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        price: json["price"] == null ? null : json["price"],
        rating: json["rating"] == null ? null : json["rating"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "sub_title": subTitle == null ? null : subTitle,
        "price": price == null ? null : price,
        "rating": rating == null ? null : rating,
        "image": image == null ? null : image,
      };
}
