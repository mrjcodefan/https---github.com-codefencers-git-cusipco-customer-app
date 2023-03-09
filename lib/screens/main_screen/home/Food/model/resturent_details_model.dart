// To parse this JSON data, do
//
//     final resturentDetailModel = resturentDetailModelFromJson(jsonString);

import 'dart:convert';

ResturentDetailModel resturentDetailModelFromJson(String str) =>
    ResturentDetailModel.fromJson(json.decode(str));

String resturentDetailModelToJson(ResturentDetailModel data) =>
    json.encode(data.toJson());

class ResturentDetailModel {
  ResturentDetailModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  ResturentDetails? data;

  factory ResturentDetailModel.fromJson(Map<String, dynamic> json) =>
      ResturentDetailModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : ResturentDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class ResturentDetails {
  ResturentDetails({
    this.id,
    this.image,
    this.status,
    this.title,
    this.location,
    this.rating,
    this.categories,
    this.isSubscribed,
  });

  String? id;
  String? image;
  String? status;
  String? title;
  String? location;
  String? rating;

  String? isSubscribed;

  List<ResturentCategory>? categories;

  factory ResturentDetails.fromJson(Map<String, dynamic> json) =>
      ResturentDetails(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        status: json["status"] == null ? null : json["status"],
        title: json["title"] == null ? null : json["title"],
        location: json["location"] == null ? null : json["location"],
        isSubscribed:
            json["is_subsbcribed"] == null ? null : json["is_subsbcribed"],
        rating: json["rating"] == null ? null : json["rating"],
        categories: json["categories"] == null
            ? null
            : List<ResturentCategory>.from(
                json["categories"].map((x) => ResturentCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "status": status == null ? null : status,
        "title": title == null ? null : title,
        "location": location == null ? null : location,
        "rating": rating == null ? null : rating,
        "is_subsbcribed": isSubscribed == null ? null : isSubscribed,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class ResturentCategory {
  ResturentCategory({
    this.id,
    this.title,
    this.items,
  });

  String? id;
  String? title;
  List<ResturentItem>? items;

  factory ResturentCategory.fromJson(Map<String, dynamic> json) =>
      ResturentCategory(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        items: json["items"] == null
            ? null
            : List<ResturentItem>.from(
                json["items"].map((x) => ResturentItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class ResturentItem {
  ResturentItem({
    this.id,
    this.restaurantId,
    this.restaurantName,
    this.image,
    this.title,
    this.description,
    this.price,
    this.rating,
    this.quantityInCart,
  });

  String? id;
  String? restaurantId;
  String? restaurantName;
  String? image;
  String? title;
  String? description;
  String? price;
  String? rating;
  String? quantityInCart;

  factory ResturentItem.fromJson(Map<String, dynamic> json) => ResturentItem(
        id: json["id"] == null ? null : json["id"],
        quantityInCart:
            json["quantity_in_cart"] == null ? null : json["quantity_in_cart"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        restaurantName:
            json["restaurant_name"] == null ? null : json["restaurant_name"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"],
        rating: json["rating"] == null ? null : json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "quantity_in_cart": quantityInCart == null ? null : quantityInCart,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "restaurant_name": restaurantName == null ? null : restaurantName,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "price": price == null ? null : price,
        "rating": rating == null ? null : rating,
      };
}
