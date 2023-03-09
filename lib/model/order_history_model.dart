// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  List<Datum> data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.isReviewSubmited,
    required this.customOrderId,
    required this.status,
    required this.statusLabel,
    required this.itemTotal,
    required this.grandTotal,
    required this.createdAt,
    required this.ownerId,
    required this.items,
  });

  String id;
  bool isReviewSubmited;
  String customOrderId;
  String status;
  String statusLabel;
  String itemTotal;
  String grandTotal;
  String ownerId;
  DateTime createdAt;
  List<Item> items;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isReviewSubmited: json["is_review_submited"] == null
            ? false
            : json["is_review_submited"] == "1"
                ? true
                : false,
        customOrderId: json["custom_order_id"],
        ownerId: json["owner_id"],
        status: json["status"],
        statusLabel: json["status_lable"],
        itemTotal: json["item_total"],
        grandTotal: json["grand_total"],
        createdAt: DateTime.parse(json["created_at"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_review_submited": isReviewSubmited,
        "custom_order_id": customOrderId,
        "status": status,
        "owner_id": ownerId,
        "status_lable": statusLabel,
        "item_total": itemTotal,
        "grand_total": grandTotal,
        "created_at": createdAt.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.id,
    required this.productId,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
  });

  String id;
  String productId;
  String title;
  String image;
  String quantity;
  String price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        image: json["image"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "title": title,
        "image": image,
        "quantity": quantity,
        "price": price,
      };
}
