// To parse this JSON data, do
//
//     final menuItemsModel = menuItemsModelFromJson(jsonString);

import 'dart:convert';

MenuItemsModel menuItemsModelFromJson(String str) =>
    MenuItemsModel.fromJson(json.decode(str));

String menuItemsModelToJson(MenuItemsModel data) => json.encode(data.toJson());

class MenuItemsModel {
  MenuItemsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<ManuItemData>? data;

  factory MenuItemsModel.fromJson(Map<String, dynamic> json) => MenuItemsModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ManuItemData>.from(
                json["data"].map((x) => ManuItemData.fromJson(x))),
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

class ManuItemData {
  ManuItemData({
    this.id,
    this.restaurantId,
    this.image,
    this.restaurantName,
    this.title,
    this.description,
    this.price,
    this.rating,
  });

  String? id;
  String? restaurantId;
  String? image;
  String? restaurantName;
  String? title;
  String? description;
  String? price;
  String? rating;

  factory ManuItemData.fromJson(Map<String, dynamic> json) => ManuItemData(
        id: json["id"] == null ? null : json["id"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        image: json["image"] == null ? null : json["image"],
        restaurantName:
            json["restaurant_name"] == null ? null : json["restaurant_name"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"],
        rating: json["rating"] == null ? null : json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "restaurant_name": restaurantName == null ? null : restaurantName,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "price": price == null ? null : price,
        "rating": rating == null ? null : rating,
      };
}
