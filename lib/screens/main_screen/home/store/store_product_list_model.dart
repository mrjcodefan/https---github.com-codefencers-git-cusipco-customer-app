// To parse this JSON data, do
//
//     final storeProductListModel = storeProductListModelFromJson(jsonString);

import 'dart:convert';

StoreProductListModel storeProductListModelFromJson(String str) =>
    StoreProductListModel.fromJson(json.decode(str));

String storeProductListModelToJson(StoreProductListModel data) =>
    json.encode(data.toJson());

class StoreProductListModel {
  StoreProductListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<StoreProductListData>? data;

  factory StoreProductListModel.fromJson(Map<String, dynamic> json) =>
      StoreProductListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<StoreProductListData>.from(
                json["data"].map((x) => StoreProductListData.fromJson(x))),
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

class StoreProductListData {
  StoreProductListData({
    this.id,
    this.title,
    this.image,
    this.ownerId,
    this.countInCart,
    this.quantity,
    this.price,
    this.priceTxt,
    this.description,
    this.status,
    this.rating,
    this.variation,
    this.salePrice,
  });

  String? id;
  String? title;
  String? image;
  String? ownerId;
  String? countInCart;
  String? quantity;
  String? price;
  String? priceTxt;
  String? description;
  String? rating;
  String? status;
  String? variation;
  String? salePrice;
  factory StoreProductListData.fromJson(Map<String, dynamic> json) =>
      StoreProductListData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        countInCart:
            json["count_in_cart"] == null ? null : json["count_in_cart"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        priceTxt: json["price_txt"] == null ? null : json["price_txt"],
        description: json["description"] == null ? null : json["description"],
        status: json["status"] == null ? null : json["status"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        rating: json["rating"] == null ? null : json["rating"],
        variation: json["variation"] == null ? null : json["variation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "owner_id": ownerId == null ? null : ownerId,
        "count_in_cart": countInCart == null ? null : countInCart,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "price_txt": priceTxt == null ? null : priceTxt,
        "description": description == null ? null : description,
        "status": status == null ? null : status,
        "rating": rating == null ? null : rating,
        "variation": variation == null ? null : variation,
        "sale_price": salePrice == null ? null : salePrice,
      };
}
