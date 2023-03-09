// To parse this JSON data, do
//
//     final cartsModel = cartsModelFromJson(jsonString);

import 'dart:convert';

CartsModel cartsModelFromJson(String str) =>
    CartsModel.fromJson(json.decode(str));

String cartsModelToJson(CartsModel data) => json.encode(data.toJson());

class CartsModel {
  CartsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  CartData? data;

  factory CartsModel.fromJson(Map<String, dynamic> json) => CartsModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : CartData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class CartData {
  CartData({
    this.totalItem,
    this.tax,
    this.totalAmount,
    this.items,
    this.discount,
    this.payableAmount,
    this.isItemDiscount,
  });

  String? totalItem;
  String? tax;
  String? totalAmount;
  String? discount;
  String? payableAmount;
  String? isItemDiscount;
  List<CartItem>? items;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        totalItem: json["total_item"] == null ? null : json["total_item"],
        tax: json["tax"] == null ? null : json["tax"],
        isItemDiscount:
            json["is_item_discount"] == null ? null : json["is_item_discount"],
        totalAmount: json["item_total"] == null ? null : json["item_total"],
        discount: json["item_discount"] == null ? null : json["item_discount"],
        payableAmount:
            json["payable_amount"] == null ? null : json["payable_amount"],
        items: json["items"] == null
            ? null
            : List<CartItem>.from(
                json["items"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_item": totalItem == null ? null : totalItem,
        "tax": tax == null ? null : tax,
        "item_total": totalAmount == null ? null : totalAmount,
        "item_discount": discount == null ? null : discount,
        "payable_amount": payableAmount == null ? null : payableAmount,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class CartItem {
  CartItem({
    this.id,
    this.productId,
    this.title,
    this.image,
    this.ownerId,
    this.quantity,
    this.price,
    this.priceTxt,
    this.salePrice,
    this.description,
    this.variation,
  });

  String? id;
  String? productId;
  String? title;
  String? image;
  String? ownerId;
  String? quantity;
  String? price;
  String? priceTxt;
  String? description;
  String? salePrice;

  String? variation;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"] == null ? null : json["id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        priceTxt: json["price_txt"] == null ? null : json["price_txt"],
        description: json["description"] == null ? null : json["description"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        variation: json["variation"] == null ? null : json["variation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "owner_id": ownerId == null ? null : ownerId,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "price_txt": priceTxt == null ? null : priceTxt,
        "variation": variation == null ? null : variation,
        "sale_price": salePrice == null ? null : salePrice,
        "description": description == null ? null : description,
      };
}
