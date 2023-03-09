// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  Data? data;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.ownerId,
    this.isReviewSubmited,
    this.orderStatus,
    this.statusLabel,
    this.customOrderId,
    this.deliveryFee,
    this.itemTotal,
    this.discount,
    this.grandTotal,
    this.createdAt,
    this.contactPerson,
    this.contactPhoneNumber,
    this.contactEmail,
    this.shippingAddress,
    this.rider,
    this.items,
    this.isItemDiscount,
    this.isDeliveryCharge,
    this.textLabel,
    this.tax,
  });

  String? id;
  String? tax;
  String? ownerId;
  String? isItemDiscount;
  String? textLabel;
  String? isDeliveryCharge;
  String? isReviewSubmited;
  String? orderStatus;
  String? statusLabel;
  String? customOrderId;
  String? deliveryFee;
  String? itemTotal;
  String? discount;
  String? grandTotal;
  String? createdAt;
  String? contactPerson;
  String? contactPhoneNumber;
  String? contactEmail;
  String? shippingAddress;
  Rider? rider;
  List<Item>? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        tax: json["tax"] == null ? null : json["tax"],
        textLabel: json["tax_label"] == null ? null : json["tax_label"],
        isItemDiscount:
            json["is_item_discount"] == null ? null : json["is_item_discount"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        isReviewSubmited: json["is_review_submited"] == null
            ? null
            : json["is_review_submited"],
        orderStatus: json["order_status"] == null ? null : json["order_status"],
        statusLabel: json["status_label"] == null ? null : json["status_label"],
        customOrderId:
            json["custom_order_id"] == null ? null : json["custom_order_id"],
        deliveryFee: json["delivery_fee"] == null ? null : json["delivery_fee"],
        itemTotal: json["item_total"] == null ? null : json["item_total"],
        discount: json["discount"] == null ? null : json["discount"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        contactPerson:
            json["contact_person"] == null ? null : json["contact_person"],
        contactPhoneNumber: json["contact_phone_number"] == null
            ? null
            : json["contact_phone_number"],
        isDeliveryCharge: json["is_delivery_charge"] == null
            ? null
            : json["is_delivery_charge"],
        contactEmail:
            json["contact_email"] == null ? null : json["contact_email"],
        shippingAddress:
            json["shipping_address"] == null ? null : json["shipping_address"],
        rider: json["rider"] == null ? null : Rider.fromJson(json["rider"]),
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "tax": tax == null ? null : tax,
        "tax_label": textLabel == null ? null : textLabel,
        "is_delivery_charge":
            isDeliveryCharge == null ? null : isDeliveryCharge,
        "owner_id": ownerId == null ? null : ownerId,
        "is_item_discount": isItemDiscount == null ? null : isItemDiscount,
        "is_review_submited":
            isReviewSubmited == null ? null : isReviewSubmited,
        "order_status": orderStatus == null ? null : orderStatus,
        "status_label": statusLabel == null ? null : statusLabel,
        "custom_order_id": customOrderId == null ? null : customOrderId,
        "delivery_fee": deliveryFee == null ? null : deliveryFee,
        "item_total": itemTotal == null ? null : itemTotal,
        "discount": discount == null ? null : discount,
        "grand_total": grandTotal == null ? null : grandTotal,
        "created_at": createdAt == null ? null : createdAt,
        "contact_person": contactPerson == null ? null : contactPerson,
        "contact_phone_number":
            contactPhoneNumber == null ? null : contactPhoneNumber,
        "contact_email": contactEmail == null ? null : contactEmail,
        "shipping_address": shippingAddress == null ? null : shippingAddress,
        "rider": rider == null ? null : rider!.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.productId,
    this.title,
    this.image,
    this.quantity,
    this.price,
    this.total,
  });

  String? id;
  String? productId;
  String? title;
  String? image;
  String? quantity;
  String? price;
  String? total;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"] == null ? null : json["id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
      };
}

class Rider {
  Rider({
    this.name,
    this.phoneNumber,
  });

  String? name;
  String? phoneNumber;

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        name: json["name"] == null ? null : json["name"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "phone_number": phoneNumber == null ? null : phoneNumber,
      };
}
